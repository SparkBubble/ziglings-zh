//
// Zig 有一个 "unreachable" 语句。当你想告诉编译器某个代码分支绝不应执行，
// 而一旦执行到那里就意味着出错时，可以使用它。
//
//     if (true) {
//         ...
//     } else {
//         unreachable;
//     }
//
// 这里我们做了一个小型虚拟机，对单个数值执行数学运算。
// 看起来不错，但有个小问题：switch 语句没有涵盖 u8 数值的所有可能值！
//
// 我们知道只有三种操作，但 Zig 并不知道。请用 unreachable 补全 switch。
// 或者使用 ELSE。:-)
//
const std = @import("std");

pub fn main() void {
    const operations = [_]u8{ 1, 1, 1, 3, 2, 2 };

    var current_value: u32 = 0;

    for (operations) |op| {
        switch (op) {
            1 => {
                current_value += 1;
            },
            2 => {
                current_value -= 1;
            },
            3 => {
                current_value *= current_value;
            },
        }

        std.debug.print("{} ", .{current_value});
    }

    std.debug.print("\n", .{});
}
