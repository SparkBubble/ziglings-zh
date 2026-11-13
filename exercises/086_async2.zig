//
// 现在我们已经知道如何获取 Io 值，来用它执行异步任务吧！
//
// io.async() 会启动一个函数并返回 Future。调用其 .await() 之前，
// 结果不一定已经准备好：
//
//     var future = io.async(someFunction, .{ arg1, arg2 });
//     const result = future.await(io);
//
// 函数*可能*立即运行，也可能在另一个线程上运行，代码无需关心！
// 这正是 Io 抽象的优点。
//
// 重要：每个 Future 都必须调用 .await() 或 .cancel()。
// 否则会泄漏资源！一种稳妥的写法是：
//
//     var future = io.async(myFn, .{});
//     defer _ = future.cancel(io);  // safety net
//     // ……稍后，如果需要结果：
//     const result = future.await(io);
//     //（cancel 后再 await 也没问题，只会返回结果）
//
// .await() 和 .cancel() 都会阻塞到任务结束并返回结果。
// 区别在于 .cancel() 还会请求任务在下一个取消点停止。
// 重复调用任一个方法都是安全的，后续调用只会返回结果副本。
//
// 请修复此程序，让 computeAnswer 异步运行并正确等待其结果。
//
const std = @import("std");
const print = std.debug.print;

pub fn main(init: std.process.Init) !void {
    const io = init.io;

    // 异步启动 computeAnswer。
    var future = io.async(computeAnswer, .{ 6, 7 });
    defer _ = future.cancel(io); // always clean up!

    print("Computing... ", .{});

    // 现在获取结果。Future 的哪个方法会等待结果就绪并返回它？
    const answer = future.???(io);

    print("The answer is: {}\n", .{answer});
}

fn computeAnswer(a: u32, b: u32) u32 {
    return a * b;
}
