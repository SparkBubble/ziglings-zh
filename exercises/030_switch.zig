//
// "switch" 语句可以匹配表达式可能的值，并针对每个值执行不同操作。
//
// 下面的 switch：
//
//     switch (players) {
//         1 => startOnePlayerGame(),
//         2 => startTwoPlayerGame(),
//         else => {
//             alert();
//             return GameError.TooManyPlayers;
//         }
//     }
//
// 等价于下面的 if/else：
//
//     if (players == 1) startOnePlayerGame();
//     else if (players == 2) startTwoPlayerGame();
//     else {
//         alert();
//         return GameError.TooManyPlayers;
//     }
//
const std = @import("std");

pub fn main() void {
    const lang_chars = [_]u8{ 26, 9, 7, 42 };

    for (lang_chars) |c| {
        switch (c) {
            1 => std.debug.print("A", .{}),
            2 => std.debug.print("B", .{}),
            3 => std.debug.print("C", .{}),
            4 => std.debug.print("D", .{}),
            5 => std.debug.print("E", .{}),
            6 => std.debug.print("F", .{}),
            7 => std.debug.print("G", .{}),
            8 => std.debug.print("H", .{}),
            9 => std.debug.print("I", .{}),
            10 => std.debug.print("J", .{}),
            // ……中间的内容不必全部列出……
            25 => std.debug.print("Y", .{}),
            26 => std.debug.print("Z", .{}),
            // switch 语句必须“穷尽”（每个可能的值都必须有匹配项）。
            // 请在这个 switch 中添加 "else"，当 c 不匹配现有分支时
            // 打印问号 "?"。
        }
    }

    std.debug.print("\n", .{});
}
