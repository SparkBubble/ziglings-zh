//
// Zig 支持用几种方便的格式表示整数字面量。以下各项的值都相同：
//
//     const a1: u8 = 65;          // 十进制
//     const a2: u8 = 0x41;        // 十六进制
//     const a3: u8 = 0o101;       // 八进制
//     const a4: u8 = 0b1000001;   // 二进制
//     const a5: u8 = 'A';         // ASCII 码点字面量
//     const a6: u16 = '\u{0041}'; // Unicode 码点最多占 21 位
//
// 也可以在数字中插入下划线以便阅读：
//
//     const t1: u32 = 14_689_520 // 福特 T 型车 1909 至 1927 年的销量
//     const t2: u32 = 0xE0_24_F0 // 同一数字，以十六进制分组表示
//
// 请修正这条消息：

const print = @import("std").debug.print;

pub fn main() void {
    const zig = [_]u8{
        0o131, // octal
        0b1101000, // binary
        0x66, // hex
    };

    print("{s} is cool.\n", .{zig});
}
