//
// 在练习 089 中，我们了解到取消会发生在“取消点”，也就是任何
// 可能返回 error.Canceled 的 Io 函数处。
//
// 但有时任务会有绝不能中断的临界区，例如将一致状态写入磁盘，
// 或完成一笔事务。
//
// Io 为此提供 CancelProtection：
//
//     const old = io.swapCancelProtection(.blocked);
//     defer _ = io.swapCancelProtection(old);

//     // 在这个代码块中，任何 Io 函数都不会返回 error.Canceled。
//     // 取消请求会一直暂存，直到恢复保护状态。
//
// 有两种状态：
//   .unblocked - 正常状态：取消点可以触发（默认）
//   .blocked   - 受保护状态：不会返回 error.Canceled
//
// 还有 io.checkCancel()，这是一个纯取消点；如果有待处理的取消请求，
// 它只会返回 error.Canceled。适用于耗时较长的 CPU 密集循环。
//
// io.recancel() 则会重新启用已消费的取消请求，让下一个取消点再次触发。
//
// 请修复此程序，使临界区即使在任务被取消时也能完成。
//
const std = @import("std");
const print = std.debug.print;

pub fn main(init: std.process.Init) !void {
    const io = init.io;

    var future = io.async(importantTask, .{io});
    defer _ = future.cancel(io);

    // 给任务时间启动并进入临界区。
    io.sleep(std.Io.Duration.fromMilliseconds(200), .awake) catch {};

    // 在任务处于受保护区段时取消它。
    const result = future.cancel(io);
    print("Task result: {s}\n", .{result});
}

fn importantTask(io: std.Io) []const u8 {
    print("Starting critical section...\n", .{});

    // 保护此区段，使其不受取消影响。
    // 哪个方法可以切换取消保护状态？
    const old = io.???(.blocked);
    defer _ = io.???(old);

    // 即使在休眠期间收到取消请求，这次休眠也不会返回 error.Canceled，
    // 因为保护仍然有效！
    io.sleep(std.Io.Duration.fromMilliseconds(300), .awake) catch |err| switch (err) {
        error.Canceled => {
            // 处于保护状态时绝不会发生这种情况！
            return "ERROR: canceled during critical section!";
        },
    };

    print("Critical section completed safely.\n", .{});
    return "All data saved.";
}
