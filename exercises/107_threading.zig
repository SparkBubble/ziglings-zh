//
// 在练习 85-94 和测验 95 中，我们学习了 Zig 用于并发执行的 Io 接口：
// io.async()、Group、Select 和 Future。Threaded 后端会在底层为你管理
// 一组真正的操作系统线程，包括调度、取消和资源清理。
//
// 但有时你需要直接控制线程：
//   * 长期运行的专用工作线程
//   * 指定栈大小或线程数量
//   * 无法使用 Io 接口的代码
//   * 更细粒度的同步模式
//
// 这时就要用到 std.Thread。它提供原生操作系统线程，由你自行启动、管理并等待。
// 没有线程池、Future 或自动取消，但可以完全掌控。
//
// 下图大致说明了不同进程执行方式之间的区别：
//
//
// 同步处理     异步处理
//                              多线程
// ┌──────────┐ ┌──────────┐  ┌──────────┐ ┌──────────┐
// │ Thread 1 │ │ Thread 1 │  │ Thread 1 │ │ Thread 2 │
// ├──────────┤ ├──────────┤  ├──────────┤ ├──────────┤    总耗时
// └──┼┼┼┼┼───┴─┴──┼┼┼┼┼───┴──┴──┼┼┼┼┼───┴─┴──┼┼┼┼┼───┴──┬───────┬───────┬──
//    ├───┤        ├───┤         ├───┤        ├───┤      │       │       │
//    │ T │        │ T │         │ T │        │ T │      │       │       │
//    │ a │        │ a │         │ a │        │ a │      │       │       │
//    │ s │        │ s │         │ s │        │ s │      │       │       │
//    │ k │        │ k │         │ k │        │ k │      │       │       │
//    │   │        │   │         │   │        │   │      │       │       │
//    │ 1 │        │ 1 │         │ 1 │        │ 3 │      │       │       │
//    └─┬─┘        └─┬─┘         └─┬─┘        └─┬─┘      │       │       │
//      │            │             │            │      5 Sec     │       │
// ┌────┴───┐      ┌─┴─┐         ┌─┴─┐        ┌─┴─┐      │       │       │
// │阻塞等待│      │ T │         │ T │        │ T │      │       │       │
// └────┬───┘      │ a │         │ a │        │ a │      │       │       │
//      │          │ s │         │ s │        │ s │      │     8 Sec     │
//    ┌─┴─┐        │ k │         │ k │        │ k │      │       │       │
//    │ T │        │   │         │   │        │   │      │       │       │
//    │ a │        │ 2 │         │ 2 │        │ 4 │      │       │       │
//    │ s │        └─┬─┘         ├───┤        ├───┤      │       │       │
//    │ k │          │           │┼┼┼│        │┼┼┼│      ▼       │    10 Sec
//    │   │        ┌─┴─┐         └───┴────────┴───┴─────────     │       │
//    │ 1 │        │ T │                                         │       │
//    └─┬─┘        │ a │                                         │       │
//      │          │ s │                                         │       │
//    ┌─┴─┐        │ k │                                         │       │
//    │ T │        │   │                                         │       │
//    │ a │        │ 1 │                                         │       │
//    │ s │        ├───┤                                         │       │
//    │ k │        │┼┼┼│                                         ▼       │
//    │   │        └───┴────────────────────────────────────────────     │
//    │ 2 │                                                              │
//    ├───┤                                                              │
//    │┼┼┼│                                                              ▼
//    └───┴────────────────────────────────────────────────────────────────
//
//
// 该图参考了一篇详细解释异步处理与多线程区别的博客：
// https://blog.devgenius.io/multi-threading-vs-asynchronous-programming-what-is-the-difference-3ebfe1179a5
//
// 本练习主要是说明 Zig 中的处理方式，因此尽量保持简单。
// 多线程本身已经够复杂了。;-)
//
const std = @import("std");

pub fn main() !void {
    // 并行处理开始前，在这里进行准备工作。
    std.debug.print("Starting work...\n", .{});

    // 这些花括号非常重要，它们包住了启动并等待线程的代码区域。
    // 程序会在这个代码块的右花括号处阻塞，等待所有线程结束，
    // 从而确保 "Zig is cool!" 总是最后打印。
    {
        // 现在启动第一个线程，并将数字作为参数传入
        const handle = try std.Thread.spawn(.{}, thread_function, .{1});

        // 等待线程完成，然后释放 `spawn()` 创建的资源。
        defer handle.join();

        // 第二个线程
        const handle2 = try std.Thread.spawn(.{}, thread_function, .{-4}); // 这不太对吧？
        defer handle2.join();

        // 第三个线程
        const handle3 = try std.Thread.spawn(.{}, thread_function, .{3});
        defer ??? // <-- 这里还缺了点东西

        // 线程启动后会并行运行，我们也可以在此期间继续做其他工作。
        var io_instance: std.Io.Threaded = .init_single_threaded;
        const io = io_instance.io();
        try io.sleep(std.Io.Duration.fromMilliseconds(400), .awake);
        std.debug.print("Some weird stuff, after starting the threads.\n", .{});
    }
    // 执行到这里时，可以保证所有线程都已结束。
    std.debug.print("Zig is cool!\n", .{});
}

// 每个已创建的线程都会运行这个函数。
// 本例中，我们将线程编号作为参数传入。
fn thread_function(id: usize) !void {
    var io_instance: std.Io.Threaded = .init_single_threaded;
    const io = io_instance.io();
    try io.sleep(std.Io.Duration.fromMilliseconds(100 * @as(isize, @intCast(id))), .awake);
    std.debug.print("thread {d}: {s}\n", .{ id, "started." });

    // 这个计时器用于模拟线程的工作。
    const work_time = 300 * ((5 - id % 3) - 2);
    try io.sleep(std.Io.Duration.fromMilliseconds(@intCast(work_time)), .awake);

    std.debug.print("thread {d}: {s}\n", .{ id, "finished." });
}
// 这是并行运行线程最简单的方法。不过通常还需要更多管理工作，
// 例如建立线程池，并允许线程通过信号量相互通信。
//
// 这些内容留到其他练习再介绍。
