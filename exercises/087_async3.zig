//
// 启动多个任务时，异步的真正威力才会显现！
//
// 使用 io.async()，可以启动多个操作，然后逐个等待它们。
// Io 后端可能会让它们并发运行：
//
//     var f1 = io.async(taskA, .{});
//     defer _ = f1.cancel(io);
//     var f2 = io.async(taskB, .{});
//     defer _ = f2.cancel(io);
//     const a = f1.await(io);
//     const b = f2.await(io);
//
// 注意 defer 的写法：每次 async 调用后立即安排 defer cancel。
// 即使提前返回，或在 await 前遇到错误，也能确保清理资源。
// await/cancel 都是幂等的，所以即使已经 await，defer 也无害。
//
// 请修复此程序，启动两个任务并获取它们的结果。
//
const std = @import("std");
const print = std.debug.print;

pub fn main(init: std.process.Init) !void {
    const io = init.io;

    // 异步启动两个任务。
    var future_a = io.async(slowAdd, .{ 1, 2 });
    defer _ = future_a.cancel(io);
    var future_b = ???(slowMul, .{ 6, 7 });
    defer _ = future_b.cancel(io);

    // 等待两个结果。
    const sum = future_a.await(io);
    const product = future_b.await(io);

    print("{} + {} = {}\n", .{ 1, 2, sum });
    print("{} * {} = {}\n", .{ 6, 7, product });
    print("Total: {}\n", .{sum + product});
}

fn slowAdd(a: u32, b: u32) u32 {
    return a + b;
}

fn slowMul(a: u32, b: u32) u32 {
    return a * b;
}
