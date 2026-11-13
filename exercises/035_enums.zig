//
// 还记得我们用 "unreachable" 语句做的小型数学虚拟机吗？
// 当时使用操作码的方式有两个问题：
//
//   1. 需要记住操作码对应的数字，很不方便。
//   2. 我们不得不使用 "unreachable"，因为 Zig 无法知道有多少个有效操作码。
//
// "enum"（枚举）是一种 Zig 结构，可以为数值命名并将它们存入一个集合。
// 它看起来很像错误集合：
//
//     const Fruit = enum{ apple, pear, orange };
//
//     const my_fruit = Fruit.apple;
//
// 让我们用枚举替代上一版中使用的数字！
//
const std = @import("std");

// 请补全这个枚举！
const Ops = enum { ??? };

pub fn main() void {
    const operations = [_]Ops{
        Ops.inc,
        Ops.inc,
        Ops.inc,
        Ops.pow,
        Ops.dec,
        Ops.dec,
    };

    var current_value: u32 = 0;

    for (operations) |op| {
        switch (op) {
            Ops.inc => {
                current_value += 1;
            },
            Ops.dec => {
                current_value -= 1;
            },
            Ops.pow => {
                current_value *= current_value;
            },
            // 不需要 "else"！这是为什么？
        }

        std.debug.print("{} ", .{current_value});
    }

    std.debug.print("\n", .{});
}
