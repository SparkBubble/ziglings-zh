//
// 到目前为止，大多数示例的输入在编译时已知，因此程序使用的内存量是固定的。
// 但如果要处理编译时无法确定大小的输入，例如：
//  - user input via command-line arguments
//  - 来自其他程序的输入
//
// 就需要在运行时向操作系统申请分配内存。
//
// Zig 提供了多种分配器。对于只分配一次内存然后退出的简单程序，
// Zig 文档推荐使用 Arena 分配器：
//
//     const std = @import("std");
//
//     // 内存分配可能失败，因此返回类型是 !void
//     pub fn main() !void {
//
//         var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
//         defer arena.deinit();
//
//         const allocator = arena.allocator();
//
//         const ptr = try allocator.create(i32);
//         std.debug.print("ptr={*}\n", .{ptr});
//
//         const slice_ptr = try allocator.alloc(f64, 5);
//         std.debug.print("slice_ptr={*}\n", .{slice_ptr});
//     }

// 此程序需要分配一个切片，其长度与输入数组相同，而非使用简单整数或固定长度切片。

// 给定一系列数字，计算逐步更新的平均值。换句话说，每个位置 N 都应保存
// 前 N 个元素的平均值。

const std = @import("std");

fn runningAverage(arr: []const f64, avg: []f64) void {
    var sum: f64 = 0;

    for (0.., arr) |index, val| {
        sum += val;
        const f_index: f64 = @floatFromInt(index + 1);
        avg[index] = sum / f_index;
    }
}

pub fn main() !void {
    // 假设这是通过读取用户输入得到的
    const arr: []const f64 = &[_]f64{ 0.3, 0.2, 0.1, 0.1, 0.4 };

    // 初始化分配器
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);

    // 退出时释放内存
    defer arena.deinit();

    // 初始化分配器
    const allocator = arena.allocator();

    // 为此数组分配内存
    const avg: []f64 = ???;

    runningAverage(arr, avg);
    std.debug.print("Running Average: ", .{});
    for (avg) |val| {
        std.debug.print("{d:.2} ", .{val});
    }
    std.debug.print("\n", .{});
}

// 关于内存分配和不同类型分配器的更多细节，请参阅：https://www.youtube.com/watch?v=vHWiDx_l4V0
