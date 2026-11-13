//
// 如果有许多不单独返回值的任务，可以使用 Group！Group 是一组无序任务，
// 只能整体等待或取消：
//
//     var group: std.Io.Group = .init;
//     group.async(io, myTask, .{arg1});
//     group.async(io, myTask, .{arg2});
//     try group.await(io);  // 阻塞，直到所有任务完成
//
// 重要规则：
//   * Group 中启动的函数，其返回类型必须可强制转换为 Cancelable!void
//    （即 void 或 error{Canceled}!void）。
//   * 调用 group.async() 后，最终必须调用 group.await() 或 group.cancel() 释放资源。
//   * group.cancel() 会请求取消所有成员，然后阻塞到它们全部结束。
//
// 与 Future 不同，Group 任务不会向调用方返回值。
// 它适合通过共享状态或副作用（例如打印）进行通信的并行工作。
//
// 请修复此程序，等待组中的所有任务。
//
const std = @import("std");
const print = std.debug.print;

pub fn main(init: std.process.Init) !void {
    const io = init.io;

    var group: std.Io.Group = .init;

    // 按任意顺序启动 3 个任务。每个任务会先休眠 id 秒再打印，
    // 因此输出顺序是确定的。
    group.async(io, doWork, .{ io, 1 });
    group.async(io, doWork, .{ io, 3 });
    group.async(io, doWork, .{ io, 2 });

    // 等待所有任务结束。
    // Group 的哪个方法会阻塞到所有任务完成？
    try group.???(io);

    print("All tasks finished!\n", .{});
}

fn doWork(io: std.Io, id: u32) void {
    // 休眠确保输出顺序确定。
    io.sleep(std.Io.Duration.fromSeconds(id), .awake) catch return;
    print("Task {} done.\n", .{id});
}
