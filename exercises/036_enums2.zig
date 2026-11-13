//
// 枚举本质上只是一组数字。可以把编号交给编译器决定，
// 也可以显式指定。甚至还可以指定使用的数值类型。
//
//     const Stuff = enum(u8){ foo = 16 };
//
// 可以用内置函数 @backingInt() 获取对应整数。
// 后面的练习会详细介绍内置函数。
//
//     const my_stuff: u8 = @backingInt(Stuff.foo);
//
// 注意，这个内置函数和我们一直在用的 @import() 一样以 "@" 开头。
//
const std = @import("std");

// Zig 允许我们用十六进制格式书写整数：
//
//     0xf（十六进制中的值为 15）
//
// 网页浏览器允许我们用十六进制数指定颜色。每个字节表示红、绿、蓝（RGB）
// 分量的亮度；两个十六进制数字组成一个字节，取值范围为 0 到 255：
//
//     #RRGGBB
//
// 请定义并使用纯蓝色的 Color 值：
const Color = enum(u32) {
    red = 0xff0000,
    green = 0x00ff00,
    blue = ???,
};

pub fn main() void {
    // 还记得 Zig 的多行字符串吗？它们又出现了。
    // 另外，看看这个有趣的格式字符串：
    //
    //     {x:0>6}
    //      ^
    //      x       类型（'x' 表示小写十六进制）
    //       :      分隔符（格式语法所需）
    //        0     填充字符（默认为空格）
    //         >    对齐方式（'>' 表示右对齐）
    //          6   宽度（使用填充字符达到指定宽度）
    //
    // 请将此格式应用到蓝色值上。
    //（更好的做法是去掉它试试，或只尝试其中一部分，看看输出是什么！）
    std.debug.print(
        \\<p>
        \\  <span style="color: #{x:0>6}">Red</span>
        \\  <span style="color: #{x:0>6}">Green</span>
        \\  <span style="color: #{}">Blue</span>
        \\</p>
        \\
    , .{
        @backingInt(Color.red),
        @backingInt(Color.green),
        @backingInt(???), // Oops! We're missing something!
    });
}
