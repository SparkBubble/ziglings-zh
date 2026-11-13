//
// 有时需要让多个任务竞速，并处理最先完成的任务。此时可以使用 Select！
//
// Select 类似 Group，但可以在任务完成时逐个接收各自的结果：
//
//     const Race = std.Io.Select(union(enum) {
//         fast: u32,
//         slow: u32,
//     });
//
//     var buffer: [2]Race.Union = undefined;
//     var sel = Race.init(io, &buffer);
//
//     sel.async(.fast, fastFn, .{io});
//     sel.async(.slow, slowFn, .{io});
//
//     const winner = try sel.await();  // 返回最先完成的结果
//     switch (winner) {
//         .fast => |val| ...,
//         .slow => |val| ...,
//     }
//     sel.cancelDiscard();  // 取消其余任务并丢弃结果
//
// 和所有异步原语一样，Select 启动的任务必须清理。可以使用 sel.cancel()
// 逐个获取剩余结果（以便清理资源）；如果不需要结果，则使用 sel.cancelDiscard()。
//
// 缓冲区必须足够大，能容纳调用 cancelDiscard() 前可能完成的所有任务。
//
// 请修复此程序，接收竞速中最先完成的任务。
//
const std = @import("std");
const print = std.debug.print;

const RaceResult = std.Io.Select(union(enum) {
    hare: []const u8,
    tortoise: []const u8,
});

pub fn main(init: std.process.Init) !void {
    const io = init.io;

    var buffer: [2]RaceResult.Union = undefined;
    var sel = RaceResult.init(io, &buffer);

    sel.async(.hare, runHare, .{io});
    sel.async(.tortoise, runTortoise, .{io});

    // 等待最先完成的任务。
    // Select 的哪个方法会返回第一个完成的结果？
    const winner = try sel.???();

    switch (winner) {
        .hare => |msg| print("Hare: {s}\n", .{msg}),
        .tortoise => |msg| print("Tortoise: {s}\n", .{msg}),
    }

    // 清理落败任务，我们不需要它的结果。
    sel.cancelDiscard();
}

fn runHare(io: std.Io) []const u8 {
    // 兔子很快，只需要 1 秒！
    io.sleep(std.Io.Duration.fromSeconds(1), .awake) catch return "I got canceled!";
    return "I'm fast!";
}

fn runTortoise(io: std.Io) []const u8 {
    // 乌龟很慢，需要 10 秒。
    io.sleep(std.Io.Duration.fromSeconds(10), .awake) catch return "I got canceled!";
    return "Slow and steady...";
}
