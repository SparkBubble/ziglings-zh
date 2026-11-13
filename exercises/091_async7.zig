//
// 多个异步任务访问共享数据时，需要进行同步！Io 提供了 Mutex：
//
//     var mutex: std.Io.Mutex = .init;
//
//     // 在任务中：
//     try mutex.lock(io);       // 阻塞，直到成功获取锁
//     defer mutex.unlock(io);
//     // ... critical section: safe to modify shared data ...
//
// 没有互斥锁时，并发任务可能同时读写同一块内存，造成数据竞争，
// 结果将无法预测。
//
// mutex.lock() 是取消点，可能返回 error.Canceled。还有 tryLock()，
// 它会立即返回（获取成功为 true，否则为 false）。
//
// 请修复此程序，正确同步计数器。若不修复，最终计数无法预测。
// 修复后，四个任务各自递增 100 次，结果应为 400。
//
const std = @import("std");
const print = std.debug.print;

const SharedState = struct {
    counter: u32 = 0,
    mutex: std.Io.Mutex = .init,
};

pub fn main(init: std.process.Init) !void {
    const io = init.io;
    var state = SharedState{};

    var group: std.Io.Group = .init;

    group.async(io, increment, .{ io, &state, 100 });
    group.async(io, increment, .{ io, &state, 100 });
    group.async(io, increment, .{ io, &state, 100 });
    group.async(io, increment, .{ io, &state, 100 });

    try group.await(io);

    print("Counter: {}\n", .{state.counter});
}

fn increment(io: std.Io, state: *SharedState, times: u32) void {
    for (0..times) |_| {
        // 修改共享状态前先获取锁。
        // Mutex 的哪个方法会一直阻塞到成功获取锁？
        state.mutex.??? catch return;
        defer state.mutex.unlock(); // <-- what's missing here?

        // 休眠，让其他任务有机会运行。
        // 这里只是为了让不确定性更明显。
        io.sleep(std.Io.Duration.fromMilliseconds(1), .awake) catch {};

        // 如果忘了锁定互斥锁会怎样？

        state.counter += 1;
    }
}
