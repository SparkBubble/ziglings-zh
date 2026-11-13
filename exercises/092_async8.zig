//
// 任务经常需要相互通信！Io 为此提供 Queue，即用于任务间传递数据的
// 有界、线程安全通道：
//
//     var backing: [16]u32 = undefined;
//     var queue: std.Io.Queue(u32) = .init(&backing);
//
//     // 生产者任务：
//     try queue.putOne(io, value);    // 队列已满时阻塞
//
//     // 消费者任务：
//     const val = try queue.getOne(io);  // 队列为空时阻塞
//
// 生产者完成后，会调用 queue.close(io) 表示不会再有数据。
// 队列清空后，getOne() 会返回 error.Closed。
//
// 这是经典的生产者/消费者模式：一个任务生成工作，另一个任务处理，
// 队列会自动处理所有同步工作。
//
// 请修复此程序：生产者发送数字 1..10，消费者将它们求和。
// 预期总和为 55。
//
const std = @import("std");
const print = std.debug.print;

pub fn main(init: std.process.Init) !void {
    const io = init.io;

    var backing: [4]u32 = undefined;
    var queue: std.Io.Queue(u32) = .init(&backing);

    var group: std.Io.Group = .init;

    group.async(io, producer, .{ io, &queue });
    group.async(io, consumer, .{ io, &queue });

    try group.await(io);
}

fn producer(io: std.Io, queue: *std.Io.Queue(u32)) void {
    // 将数字 1 到 10 发送到队列。
    for (1..11) |i| {
        // Queue 的哪个方法会发送单个元素，并在队列已满时阻塞？
        queue.???(io, @intCast(i)) catch return;
    }
    // 发出发送完成的信号。
    queue.close(io);
}

fn consumer(io: std.Io, queue: *std.Io.Queue(u32)) void {
    var sum: u32 = 0;
    while (true) {
        const value = queue.getOne(io) catch |err| switch (err) {
            error.Closed => break,
            error.Canceled => return,
        };
        sum += value;
    }
    print("Sum of 1..10 = {}\n", .{sum});
}
