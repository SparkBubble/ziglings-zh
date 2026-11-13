//
// 我们一直使用 io.async() 启动任务。还有一个保证更强的变体：io.concurrent()。
//
// 区别如下：
//
//   io.async():
//     * 函数可能在独立的并发单元中运行，也可能立即在调用方中同步运行。
//     * 不会失败：如果没有可用并发资源，就立即运行函数。
//     * 可移植性更好，适用于所有 Io 后端。
//
//   io.concurrent():
//     * 保证使用独立的并发单元。
//     * 如果资源耗尽或后端不支持，可能失败并返回 error.ConcurrencyUnavailable。
//     * 需要任务独立于调用方运行时使用。
//
// 什么是“并发单元”？这取决于后端！Threaded 后端使用操作系统线程，
// 而 Evented 后端（Uring、Kqueue、Dispatch）使用 M:N 绿色线程/纤程，
// 即使只有一个操作系统线程也能实现并发。代码无需了解这些区别。
//
// 因为 concurrent() 可能失败，所以必须处理错误：
//
//     var future = try io.concurrent(myFn, .{args});
//     defer _ = future.cancel(io);
//     const result = future.await(io);
//
// 来看一个稍作简化的信号处理示例：假设我们要寻找信号中高于噪声阈值的起点。
// 为此，从头到尾将每个数据项与阈值比较。为了加快处理速度，我们把信号分成两半，
// 交给两个并行工作任务搜索。先找到起点的一方获胜，并结束另一个任务。
//
// 如前所述，这只是简化后的解释，实际做法大致如此。
//
const std = @import("std");
const Io = std.Io;
const print = std.debug.print;

const SearchResult = struct {
    found: bool,
    worker_id: u8 = 0,
    index: usize = 0,
};

pub fn main(init: std.process.Init) !void {
    const io = init.io;

    const data = [_]u32{ 10, 23, 45, 67, 12, 69, 3, 54, 69, 42, 68, 56, 71, 79, 79, 75, 70, 77 };
    const threshold = 70;
    const mid = data.len / 2;

    // 可容纳一个结果的队列。
    var buf: [1]SearchResult = undefined;
    var queue = Io.Queue(SearchResult).init(&buf);

    // 启动两个工作任务，各自搜索数组的一半。
    // 记住，我们要确保它们使用独立的并发单元。
    var f1 = ???(searchThreshold, .{ io, data[0..mid], threshold, 0, 0, &queue });
    defer _ = f1.cancel(io);

    var f2 = ???(searchThreshold, .{ io, data[mid..], threshold, mid, 1, &queue });
    defer _ = f2.cancel(io);

    // 等待第一个结果。
    const result = try queue.getOne(io);

    if (result.found)
        print("Worker {} found signal start over threshold at index {}!\n", .{ result.worker_id, result.index });
}

fn searchThreshold(
    io: Io,
    slice: []const u32,
    threshold: u32,
    base_offset: usize,
    worker_id: u8,
    queue: *Io.Queue(SearchResult),
) void {
    for (slice, 0..) |val, i| {
        // 这里必须暂停，这样其他任务已经完成时才能取消当前任务。
        // 如果不暂停，所有任务都会继续运行到最后。
        io.sleep(Io.Duration.fromMilliseconds(1), .awake) catch return;

        // 要测试这一点，可以取消下面代码的注释来查看工作任务的处理过程，
        // 然后注释掉暂停语句。
        // print("id: {} - val: {}\n", .{ worker_id, val });

        if (val >= threshold) {
            queue.putOne(io, .{
                .found = true,
                .worker_id = worker_id,
                .index = base_offset + i,
            }) catch return;
            return;
        }
    }

    // 没有找到
    queue.putOneUncancelable(io, .{ .found = false }) catch return;
}
