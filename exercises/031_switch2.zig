//
// 很棒的一点是，switch 语句也可以作为表达式来返回值。
//
//     const a = switch (x) {
//         1 => 9,
//         2 => 16,
//         3 => 7,
//         ...
//     }
//
const std = @import("std");

pub fn main() void {
    const lang_chars = [_]u8{ 26, 9, 7, 42 };

    for (lang_chars) |c| {
        const real_char: u8 = switch (c) {
            1 => 'A',
            2 => 'B',
            3 => 'C',
            4 => 'D',
            5 => 'E',
            6 => 'F',
            7 => 'G',
            8 => 'H',
            9 => 'I',
            10 => 'J',
            // ...
            25 => 'Y',
            26 => 'Z',
            // 和上一个练习一样，请添加 'else' 分支，
            // 这次让它返回感叹号 '!'。
        };

        std.debug.print("{c}", .{real_char});
        // 注意："{c}" 会强制 print() 将值显示为字符。
        // 你能猜到去掉 "c" 会怎样吗？试试看！
    }

    std.debug.print("\n", .{});
}
