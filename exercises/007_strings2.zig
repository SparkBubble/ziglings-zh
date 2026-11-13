//
// 来看个有趣的特性：Zig 支持多行字符串！
//
// 要创建多行字符串，只需在每一行开头放置 '\\'，
// 就像代码注释一样，只不过这里用的是反斜杠：
//
//     const two_lines =
//         \\Line One
//         \\Line Two
//     ;
//
// 试试看能否让这个程序打印几句歌词。
//
const std = @import("std");

pub fn main() void {
    const lyrics =
        Ziggy played guitar
        Jamming good with Andrew Kelley
        And the Spiders from Mars
    ;

    std.debug.print("{s}\n", .{lyrics});
}
