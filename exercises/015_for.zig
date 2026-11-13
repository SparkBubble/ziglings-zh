//
// 看看 'for' 循环！它可以对数组中的每个元素执行代码：
//
//     for (items) |item| {
//
//         // 对 item 做些处理
//
//     }
//
const std = @import("std");

pub fn main() void {
    const story = [_]u8{ 'h', 'h', 's', 'n', 'h' };

    std.debug.print("A Dramatic Story: ", .{});

    for (???) |???| {
        if (scene == 'h') std.debug.print(":-)  ", .{});
        if (scene == 's') std.debug.print(":-(  ", .{});
        if (scene == 'n') std.debug.print(":-|  ", .{});
    }

    std.debug.print("The End.\n", .{});
}
// 注意，'for' 循环也适用于称为“切片”的类型，
// 我们稍后会介绍它。
//
// 另外，'for' 循环最近变得更灵活、更强大了
//（这是本练习编写两年之后的变化）。稍后会详细介绍。
