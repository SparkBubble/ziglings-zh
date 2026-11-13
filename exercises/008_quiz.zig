//
// 测验时间！看看你能否修好整个程序。
//
// 这题需要稍微动动脑筋。
//
// 让编译器告诉你哪里出了问题。
//
// 从最上面开始。
//
const std = @import("std");

pub fn main() void {
    // 这是什么乱七八糟的东西？:-)
    const letters = "YZhifg";

    // 注意：usize 是用于表示……大小的无符号整数类型。
    // usize 的确切大小取决于目标 CPU 架构。
    // 这里也可以用 u8，但数组索引通常使用 usize。
    //
    // 这一行确实有问题，但问题不在 'usize'。
    const x: usize = 1;

    // 注意：如果要声明一块尚未填入内容的内存（这里是数组），
    // 可以将它设为 'undefined'。这一行没有问题。
    var lang: [3]u8 = undefined;

    // 以下几行尝试通过变量 'x' 索引数组 'letters'，
    // 将 'Z'、'i' 和 'g' 放入刚创建的 'lang' 数组。
    // 如上所示，x 初始值为 1。
    lang[0] = letters[x];

    x = 3;
    lang[???] = letters[x];

    x = ???;
    lang[2] = letters[???];

    // 当然，我们想要打印 "Program in Zig!"：
    std.debug.print("Program in {s}!\n", .{lang});
}
