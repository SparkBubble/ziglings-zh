//
// 新 Io 系统最重要的特性之一是结构化取消！
//
// 每个 Future 都有 .cancel() 方法，它会：
//   1. 请求任务停止（在下一个“取消点”通过 error.Canceled 实现）
//   2. 阻塞到任务实际结束
//   3. 返回任务产生的结果
//
// “取消点”是指任何可能返回 error.Canceled 的 Io 函数，最常见的是 io.sleep()：
//
//     fn myTask(io: std.Io) u32 {
//         io.sleep(...) catch |err| switch (err) {
//             error.Canceled => return 0,  // error handle
//         };
//         return 42;
//     }
//
// 这与直接终止线程根本不同：任务有机会清理资源并返回值！
//
// 记住：.await() 和 .cancel() 都会阻塞并返回结果。唯一的区别是 .cancel()
// 还会发出取消请求。二者都是幂等的，重复调用只会返回相同结果。
//
// 请修复此程序：慢任务原本需要 10 秒，但我们在 1 秒后取消它。
// 任务应检测到取消并提前返回。
//
const std = @import("std");
const print = std.debug.print;

pub fn main(init: std.process.Init) !void {
    const io = init.io;

    var future = io.async(slowTask, .{io});
    defer _ = future.cancel(io); // safety net

    // 等待 1 秒后取消，不必等满 10 秒。
    io.sleep(std.Io.Duration.fromSeconds(1), .awake) catch {};

    print("Canceling slow task...\n", .{});

    // 我们不想等 10 秒！Future 的哪个方法会请求取消并返回结果？
    const result = future.???(io);

    print("Task returned: {}\n", .{result});
}

fn slowTask(io: std.Io) u32 {
    print("Starting long computation...\n", .{});

    // 尝试休眠 10 秒，不过任务可能会被取消！
    io.sleep(std.Io.Duration.fromSeconds(10), .awake) catch |err| switch (err) {
        error.Canceled => {
            print("Task was canceled, cleaning up.\n", .{});
            return 0;
        },
    };

    print("Task completed normally.\n", .{});
    return 42;
}
