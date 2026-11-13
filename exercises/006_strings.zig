//
// 学过数组后，我们来聊聊字符串。
//
// 我们已经见过 Zig 字符串字面量："Hello world.\n"
//
// Zig 将字符串存储为字节数组。
//
//     const foo = "Hello";
//
// 几乎*等同于：
//
//     const foo = [_]u8{ 'H', 'e', 'l', 'l', 'o' };
//
//（* 我们会在练习 77 中了解 Zig 字符串的真正含义。）
//
// 注意，单个字符使用单引号 ('H')，字符串使用双引号 ("H")。
// 两者不能互换！
//
const std = @import("std");

pub fn main() void {
    const ziggy = "stardust";

    //（问题 1）使用数组方括号语法，从上面的 "stardust" 中取出字母 'd'。
    const d: u8 = ziggy[???];

    //（问题 2）使用数组拼接运算符 '++' 组成 "Major Tom"。（还需要加空格！）
    const major = "Major";
    const tom = "Tom";
    const major_tom = major ??? tom;

    // 问题就这些。来看看结果：
    std.debug.print("d={u} {s}\n", .{ d, major_tom });
    // 细心的你会发现，我们在格式字符串的 '{}' 占位符中放入了 'u' 和 's'。
    // 它们分别告诉 print() 将值格式化为 UTF-8 字符和 UTF-8 字符串。
    // 如果不这样做，我们会看到 '100'，这是 UTF-8 中字符 'd' 对应的十进制值。
    //（字符串则会报错。）
    //
    // 顺便一提，'c'（ASCII 编码字符）也可以替代 'u'，
    // 因为 UTF-8 的前 128 个字符与 ASCII 相同！
    //
}
