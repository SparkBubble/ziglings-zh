//
// 现在进入有趣的部分，先从 'if' 语句开始！
//
//     if (true) {
//         ...
//     } else {
//         ...
//     }
//
// Zig 有一些常见的比较运算符，例如：
//
//     a == b   表示“a 等于 b”
//     a < b    表示“a 小于 b”
//     a > b    表示“a 大于 b”
//     a != b   表示“a 不等于 b”
//
// Zig 的 "if" 有个重要特点：它*只*接受布尔值。
// 它不会将数字或其他类型的数据转换成 true 或 false。
//
const std = @import("std");

pub fn main() void {
    const foo = 42;

    // 请修正这个条件：
    if (foo) {
        // 我们希望程序打印这条消息！
        std.debug.print("Foo is 42!\n", .{});
    } else {
        std.debug.print("Foo is not 42!\n", .{});
    }
}
