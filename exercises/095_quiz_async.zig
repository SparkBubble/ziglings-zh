//
// 测验时间：异步 I/O！
//
// Zoraptera 博士的昆虫模拟进展顺利，但她发现虚拟花园还需要天气数据！
// 昆虫的行为会随温度、湿度和风况而改变。
//
// 她在花园周围设置了三个天气传感器，并行测量环境状况，
// 再通过共享数据通道报告读数。收集任务汇总读数，等所有传感器报告后，
// 打印花园天气报告。
//
// 但 Z 博士（当时正被蚱蜢追赶）匆忙写完代码，留下了几个 bug。
// 你能修好它们吗？
//
// 程序应完成以下工作：
//   1. 三个传感器任务各通过 Queue 发送恰好 3 条读数
//   2. 收集任务并发接收读数，并使用 Mutex 保护共享状态
//   3. 所有传感器完成后关闭队列
//   4. 在取消保护区段中写出最终报告
//
// *************************************************************
// *                    本练习须知                            *
// *                                                           *
// * 本测验使用了练习 085-094 中的概念。                       *
// * 需要修复 6 个 bug，请找到所有 ???！                       *
// *                                                           *
// *************************************************************
//
const std = @import("std");
const print = std.debug.print;

const SensorType = enum { thermometer, hygrometer, anemometer };

const Reading = struct {
    sensor_type: SensorType,
    value: i32,
};

const GardenWeather = struct {
    temperature: i32 = 0,
    humidity: i32 = 0,
    wind: i32 = 0,
    readings_count: u32 = 0,
    mutex: std.Io.Mutex = .init,

    fn addReading(self: *GardenWeather, io: std.Io, reading: Reading) void {
        // Bug 1：收集任务修改共享状态前需要先加锁。
        // Mutex 的哪个方法可以获取锁？
        self.mutex.???(io) catch return;
        defer self.mutex.unlock(io);

        switch (reading.sensor_type) {
            .thermometer => self.temperature = reading.value,
            .hygrometer => self.humidity = reading.value,
            .anemometer => self.wind = reading.value,
        }
        self.readings_count += 1;
    }
};

pub fn main(init: std.process.Init) !void {
    const io = init.io;

    var weather = GardenWeather{};

    var reading_buf: [8]Reading = undefined;
    var queue: std.Io.Queue(Reading) = .init(&reading_buf);

    // 收集任务必须并发运行，以便在传感器仍在发送时处理读数。
    // 先启动它，确保为其预留并发单元。
    //
    // Bug 2：收集任务需要保证并发运行。
    // 哪个方法能确保使用独立的并发单元？（别忘了：它可能失败！）
    var collector_future = try io.???(collector, .{ io, &queue, &weather });
    defer _ = collector_future.cancel(io);

    // 传感器组：传感器只需要运行，因此可以使用可移植性更好的 async。
    var sensors: std.Io.Group = .init;

    sensors.async(io, sensor, .{ io, &queue, .thermometer, 20 });
    sensors.async(io, sensor, .{ io, &queue, .hygrometer, 60 });
    sensors.async(io, sensor, .{ io, &queue, .anemometer, 10 });

    // Bug 3：等待所有传感器完成读数发送。
    // Group 的哪个方法会阻塞到所有任务完成？
    try sensors.???(io);

    // 所有传感器都已完成，关闭队列以通知收集任务不会再有数据。
    queue.close(io);

    // Bug 4：如何等待收集任务读完队列中的剩余数据？
    _ = collector_future.???(io);

    // 现在写出花园报告。这是关键操作，即使有取消请求也绝不能中断！
    //
    // Bug 5：保护此区段，使其不受取消影响。
    // Io 的哪个方法可以切换取消保护状态？
    const old_protection = io.???(.blocked);
    defer _ = io.???(old_protection);

    printGardenReport(&weather);
}

fn sensor(
    io: std.Io,
    queue: *std.Io.Queue(Reading),
    sensor_type: SensorType,
    base_value: i32,
) void {
    // 每个传感器恰好测量 3 次。
    for (1..4) |i| {
        io.sleep(std.Io.Duration.fromMilliseconds(100), .awake) catch return;

        const reading = Reading{
            .sensor_type = sensor_type,
            .value = base_value + @as(i32, @intCast(i)),
        };

        // Bug 6：将读数发送到队列。
        // Queue 的哪个方法可以发送单个元素？
        queue.???(io, reading) catch return;
    }
}

fn collector(
    io: std.Io,
    queue: *std.Io.Queue(Reading),
    weather: *GardenWeather,
) void {
    while (true) {
        const reading = queue.getOne(io) catch |err| switch (err) {
            error.Closed => break,
            error.Canceled => return,
        };
        weather.addReading(io, reading);
    }
}

fn printGardenReport(weather: *GardenWeather) void {
    print("=== Doctor Zoraptera's Garden Report ===\n", .{});
    print("Temperature : {}C\n", .{weather.temperature});
    print("Humidity    : {}%\n", .{weather.humidity});
    print("Wind        : {} km/h\n", .{weather.wind});
    print("Readings    : {}\n", .{weather.readings_count});

    if (weather.temperature > 20 and weather.wind < 15) {
        print("Bee-friendly conditions! Expect high pollination.\n", .{});
    } else {
        print("Grasshoppers will be grumpy today.\n", .{});
    }
}

// 延伸阅读：
//
// 本测验涉及了主要的异步 I/O 原语：
//   io.async()               - 启动任务（可能内联运行）
//   io.concurrent()          - 保证使用独立并发单元
//   Future.await/cancel      - 获取或取消单个任务
//   Group.async/await/cancel - 管理无需等待结果的任务
//   Select.async/await       - 让任务竞速并处理最先完成者
//   Queue                    - 任务间的有界通道
//   Mutex                    - 保护共享状态
//   CancelProtection         - 保护临界区
//
// 还有一些我们没有介绍的同步原语：
//   Condition  - 等待条件变为真
//   RwLock     - 允许多个读取者或一个写入者
//   Semaphore  - 限制对资源的并发访问
//   Futex      - 在内存地址上进行底层等待/唤醒
//   Batch      - 一次提交多个 I/O 操作
//
// 关键在于：这些功能都通过 Io VTable 工作，因此代码可以跨后端移植，
// 无论后端是 Threaded（操作系统线程池），还是 Evented（M:N 绿色线程/纤程，
// 即使在单个操作系统线程上也能提供并发）。
//
// Zoraptera 博士表示认可。
