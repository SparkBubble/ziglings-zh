//
// Zig 有一个数组运算符。
//
// 可以使用 '++' 拼接两个数组：
//
//   const a = [_]u8{ 1,2 };
//   const b = [_]u8{ 3,4 };
//   const c = a ++ b ++ [_]u8{ 5 }; // 结果为 1 2 3 4 5
//
// 注意，'++' 只会在程序_编译期间_对数组进行操作。
// 在 Zig 中，这个特殊阶段称为 "comptime"，之后我们会
// 进一步学习相关内容。
//
const std = @import("std");

pub fn main() void {
    const le = [_]u8{ 1, 3 };
    const et = [_]u8{ 3, 7 };

    //（问题 1）请拼接上面的两个数组来设置此数组，结果应为：1 3 3 7。
    const leet = ???;

    //（问题 2）请使用重复操作设置此数组。
    // 结果应为：1 0 0 1 1 0 0 1 1 0 0 1。请继续阅读以了解解法。
    const bit_pattern_unit = ???;

    // 位模式应该有多长？
    const len = ???;

    // 现在先不用担心 SIMD 的用法。
    // 不过，正好可以试试 Zig 很棒的自带文档。
    // 请在命令行运行 `zig std`，然后在浏览器中搜索 repeat 函数。
    const bit_pattern: [len]u8 = std.simd.repeat(len, bit_pattern_unit);

    // 好，问题都做完了。来看看结果。
    //
    // 我们可以用 leet[0]、leet[1]……来打印数组，但不如先
    // 预览一下 Zig 的 'for' 循环：
    //
    //    for (<item array>) |item| { <对 item 做些处理> }
    //
    // 别担心，后续课程会详细讲解循环。
    //
    std.debug.print("LEET: ", .{});

    for (leet) |n| {
        std.debug.print("{}", .{n});
    }

    std.debug.print(", Bits: ", .{});

    for (bit_pattern) |n| {
        std.debug.print("{}", .{n});
    }

    std.debug.print("\n", .{});
}

// 补充说明：
//
// `std.simd.repeat` 函数接受目标长度和一个模式，
// 并返回按该模式重复填充到目标长度的向量。
//
// 例如，`repeat(5, [_]u8{1, 2})` 会返回等价于 `.{1, 2, 1, 2, 1}` 的向量。
