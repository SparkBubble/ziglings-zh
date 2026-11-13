//
// 现在用指针来做一件之前做不到的事：将值以引用方式传给函数。
//
// 为什么要传递整数变量的指针，而不是整数值本身？
// 因为这样我们就可以*修改*这个变量的值！
//
//     +-----------------------------------------------+
//     | 想要修改指针所指的值时就传引用；        |
//     | 否则直接传值。                            |
//     +-----------------------------------------------+
//
const std = @import("std");

pub fn main() void {
    var num: u8 = 1;
    var more_nums = [_]u8{ 1, 1, 1, 1 };

    // 将 num 的引用传给函数并打印：
    makeFive(&num);
    std.debug.print("num: {}, ", .{num});

    // 接下来做点有趣的事。将某个特定数组元素的引用传进去：
    makeFive(&more_nums[2]);

    // 然后打印数组：
    std.debug.print("more_nums: ", .{});
    for (more_nums) |n| {
        std.debug.print("{} ", .{n});
    }

    std.debug.print("\n", .{});
}

// 这个函数应该接受一个 u8 值的引用并为其赋值。
// to 5.
fn makeFive(x: *u8) void {
    ??? = 5; // fix me!
}
