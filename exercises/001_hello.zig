//
// 糟了，这段程序本应打印 "Hello world!"，但还需要
// 你的帮助。
//
// Zig 函数默认是私有的，但 main() 函数
// 必须是公开的。
//
// 使用 "pub" 关键字可以将函数声明为公开，示例如下：
//
//     pub fn foo() void {
//         ...
//     }
//
// 了解这一点，也许就能帮你解决这个小程序
// 中遇到的错误？
//
const std = @import("std");

fn main() void {
    std.debug.print("Hello world!\n", .{});
}
