// ----------------------------------------------------------------------------
// 测验时间：翻转、设置和清除位
// ----------------------------------------------------------------------------
//
// Zig 的另一个令人兴奋之处是它适合嵌入式编程。你的 Zig 代码不必只运行在笔记本电脑上，
// 也可以部署到微控制器！这意味着你可以用 Zig 驱动机器人或温室气候控制系统。
// 准备好进入令人兴奋的嵌入式编程世界了吗？开始吧！
//
// ----------------------------------------------------------------------------
// 背景知识
// ----------------------------------------------------------------------------
//
// 微控制器编程中常见的操作是设置或清除输入输出引脚上的位，从而控制 LED、传感器、电机等。
// 在之前的练习（100_bit_manipulation.zig）中，你学习了如何使用 ^（XOR，异或）运算符交换两个字节。
// 本测验会检验你对 Zig 位操作的掌握情况，也让你体验控制真实微控制器寄存器的方式。
// 最后还附有一些辅助函数，展示如何让代码更易读。
//
// 下图是著名的 ATmega328 AVR 微控制器引脚示意图，它是 Arduino UNO 等常见开发板的主要芯片。
//
//  ============ ATMEGA328 微控制器引脚示意图 ============
//                                _____ _____
//                               |     U     |
//                 (RESET) PC6 --|  1     28 |-- PC5
//                         PD0 --|  2     27 |-- PC4
//                         PD1 --|  3     26 |-- PC3
//                         PD2 --|  4     25 |-- PC2
//                         PD3 --|  5     24 |-- PC1
//                         PD4 --|  6     23 |-- PC0
//                         VCC --|  7     22 |-- GND
//                         GND --|  8     21 |-- AREF
//                     |-- PB6 --|  9     20 |-- AVCC
//                     |-- PB7 --| 10     19 |-- PB5 --|
//                     |   PD5 --| 11     18 |-- PB4 --|
//                     |   PD6 --| 12     17 |-- PB3 --|
//                     |   PD7 --| 13     16 |-- PB2 --|
//                     |-- PB0 --| 14     15 |-- PB1 --|
//                     |         |___________|         |
//                     \_______________________________/
//                                    |
//                                  PORTB
//
// 受此图启发，我们将使用 PORTB 的引脚作为本测验位操作的思维模型。
// 请注意，下面的问题使用普通变量（其中一个命名为 PORTB）来模拟修改真实硬件寄存器中的位。
// 但在实际的微控制器代码中，PORTB 的定义会类似这样：
//          pub const PORTB = @as(*volatile u8, @ptrFromInt(0x25));
//
// 这样可以告诉编译器不要对 PORTB 做优化，从而确保 I/O 引脚正确映射到代码中。
//
// 注意：为简单起见，下面的问题使用 u4 类型，因此将结果应用到 PORTB 时只会影响低四个引脚 PB0..PB3。
// 当然，也可以将 u4 换成 u8，以控制 PORTB 的全部 8 个 I/O 引脚。

const std = @import("std");
const print = std.debug.print;
const testing = std.testing;

pub fn main() !void {
    var PORTB: u4 = 0b0000; // only 4 bits wide for simplicity

    // ------------------------------------------------------------------------
    // 测验
    // ------------------------------------------------------------------------

    // 试试看能否解决以下问题。最后两题会稍微出乎意料，先尝试独立完成。
    // 如果需要帮助，请滚动到 main 函数末尾，查看 Zig 中翻转、设置和清除位的详细说明。

    print("Toggle pins with XOR on PORTB\n", .{});
    print("-----------------------------\n", .{});
    PORTB = 0b1100;
    print("  {b:0>4} // (initial state of PORTB)\n", .{PORTB});
    print("^ {b:0>4} // (bitmask)\n", .{0b0101});
    PORTB ^= (1 << 1) | (1 << 0); // What's wrong here?
    checkAnswer(0b1001, PORTB);

    newline();

    PORTB = 0b1100;
    print("  {b:0>4} // (initial state of PORTB)\n", .{PORTB});
    print("^ {b:0>4} // (bitmask)\n", .{0b0011});
    PORTB ^= (1 << 1) & (1 << 0); // What's wrong here?
    checkAnswer(0b1111, PORTB);

    newline();

    print("Set pins with OR on PORTB\n", .{});
    print("-------------------------\n", .{});

    PORTB = 0b1001; // reset PORTB
    print("  {b:0>4} // (initial state of PORTB)\n", .{PORTB});
    print("| {b:0>4} // (bitmask)\n", .{0b0100});
    PORTB = PORTB ??? (1 << 2); // What's missing here?
    checkAnswer(0b1101, PORTB);

    newline();

    PORTB = 0b1001; // reset PORTB
    print("  {b:0>4} // (reset state)\n", .{PORTB});
    print("| {b:0>4} // (bitmask)\n", .{0b0100});
    PORTB ??? (1 << 2); // What's missing here?
    checkAnswer(0b1101, PORTB);

    newline();

    print("Clear pins with AND and NOT on PORTB\n", .{});
    print("------------------------------------\n", .{});

    PORTB = 0b1110; // reset PORTB
    print("  {b:0>4} // (initial state of PORTB)\n", .{PORTB});
    print("& {b:0>4} // (bitmask)\n", .{0b1011});
    PORTB = PORTB & ???@as(u4, 1 << 2); // What character is missing here?
    checkAnswer(0b1010, PORTB);

    newline();

    PORTB = 0b0111; // reset PORTB
    print("  {b:0>4} // (reset state)\n", .{PORTB});
    print("& {b:0>4} // (bitmask)\n", .{0b1110});
    PORTB &= ~(1 << 0); // What's missing here?
    checkAnswer(0b0110, PORTB);

    newline();
    newline();
}

// ************************************************************************
//                    详细说明见下方
// ************************************************************************
//
//
//
//
//
//
//
//
//
//
//
// ------------------------------------------------------------------------
// 使用 XOR 翻转位：
// ------------------------------------------------------------------------
// XOR 是“异或”的缩写。可以像下面这样使用 ^（XOR）位运算符翻转位：
//
//
// XOR 运算只有在两个输入位不同时才会输出 1。因此 0 ^ 1 和 1 ^ 0 都得到 1，
// 而 0 ^ 0 和 1 ^ 1 都得到 0。两个输入都是 1 时输出 0，这是 XOR 与 OR 的区别；
// 这一特性也让我们可以通过在位掩码中放入 1 来翻转对应位。
//
// - 位掩码操作数中的 1 会让另一个操作数对应的位翻转为相反值。
// - 0 不会造成变化。
//
//                            位掩码中的 0 会在输出中保留这些值
// -XOR 运算- ---展开---
//            _______________/
//           /       /
//   1100   1   1   0   0
// ^ 0101   0   1   0   1（位掩码）
// ------   -   -   -   -
// = 1001   1   0   0   1 <- 这一位原本已经清零。
//              \_______\
//                       \
//                         可以认为这些位因位掩码对应列中的 1 而发生翻转。
//
// 现在看看如何使用 | 运算符设置位。
//
//
//
//
//
// ------------------------------------------------------------------------
// 使用 OR 设置位：
// ------------------------------------------------------------------------
// 可以像这样使用 |（OR）运算符设置 PORTB 中的位：
//
// var PORTB: u4 = 0b1001;
// PORTB = PORTB | 0b0010;
// print("PORTB: {b:0>4}\n", .{PORTB}); // 输出：1011
//
// -OR 运算- ---展开---
//                    _ 只设置这一位。
//                   /
//   1001   1   0   0   1
// | 0010   0   0   1   0（位掩码）
// ------   -   -   -   -
// = 1011   1   0   1   1
//           \___\_______\
//                        \
//                          这些位保持不变，因为与 0 做 OR 不会改变结果。
//
// ------------------------------------------------------------------------
// 要创建上面使用的 0b0010 位掩码：
//
// 1. 首先，像下面这样使用 <<（左移）位运算符将数值 1 左移一位：
//           1 << 0 -> 0001
//           1 << 1 -> 0010  <-- 将 1 向左移动一位
//           1 << 2 -> 0100
//           1 << 3 -> 1000
//
// 这样就可以把上面的代码改写为：
//
// var PORTB: u4 = 0b1001;
// PORTB = PORTB | (1 << 1);
// print("PORTB: {b:0>4}\n", .{PORTB}); // 输出：1011
//
// 最后，和 C 语言一样，Zig 也支持 |= 运算符，因此可以将代码进一步简化为更符合习惯的形式：
// PORTB |= (1 << 1)

// 我们已经介绍了如何翻转和设置位。那怎样清除位呢？这里 Zig 会带来一点意外，
// 别担心，我们会一步步讲解。
//
//
//
//
//
// ------------------------------------------------------------------------
// 使用 AND 和 NOT 清除位：
// ------------------------------------------------------------------------
// 可以像这样使用 &（AND）位运算符清除位：

// PORTB = 0b1110; // 重置 PORTB
// PORTB = PORTB & 0b1011;
// print("PORTB: {b:0>4}\n", .{PORTB}); // 输出 -> 1010
//
// - 与位运算 AND 搭配时，0 会清除对应位。
// - 1 不产生影响，因此保留原来的位。
//
// -AND 运算- ---展开---
//                __________ 只清除此位。
//               /
//   1110   1   1   1   0
// & 1011   1   0   1   1（位掩码）
// ------   -   -   -   -
// = 1010   1   0   1   0 <- 这一位原本已经清零。
//           \_______\
//                    \
//                      这些位保持不变，因为与 1 做 AND 会保留原位值，无论它是 0 还是 1。
//
// ------------------------------------------------------------------------
// 可以使用 ~（NOT）运算符轻松创建类似 1011 的位掩码：
//
//  1. 首先，像下面这样使用 <<（左移）位运算符将数值 1 左移两位：
//          1 << 0 -> 0001
//          1 << 1 -> 0010
//          1 << 2 -> 0100 <- 1 已向左移动两位
//          1 << 3 -> 1000
//
//  2. 创建位掩码的第二步是反转这些位
//          ~0100 -> 1011
//     在 C 中会写成：
//          ~(1 << 2) -> 1011
//
//     但如果在 Zig 中编译 ~(1 << 2)，就会报错：
//          无法对类型 'comptime_int' 执行二进制 NOT 运算
//
//     在 Zig 反转位之前，需要知道要反转的位数。
//
//     可以像这样使用 @as（转换为）内置函数：
//          @as(u4, 1 << 2) -> 0100
//
//     最后，可以像这样在表达式前放置 NOT 运算符 ~，反转新掩码：
//          ~@as(u4, 1 << 2) -> 1011
//
//     如果你觉得 Zig 不像 C 那样允许直接反转位、而必须先转换为特定大小的整数很不方便，
//     你并不孤单。不过这也体现了 Zig 的帮助：它能避免难以调试、令人头疼的整数溢出错误。
//     为了让行为明确，Zig 要求你指定正在反转的数值有多少位。引用 Andrew Kelley 的话：
//     “如果要反转整数的位，zig 必须知道它有多少位。”
//
//     想更深入了解 Zig 团队为何采用这种 ~ 运算符设计，请查看 Andrew 在以下 GitHub issue 中的评论：
//     https://github.com/ziglang/zig/issues/1382#issuecomment-414459529
//
// 呼，经过这些步骤，最终得到：
//          PORTB = PORTB & ~@as(u4, 1 << 2);
//
// 可以用 &= 这个 AND 与赋值的组合运算符简化，它会对 PORTB 执行 AND 后再赋回 PORTB：
//          PORTB &= ~@as(u4, 1 << 2);
//

// ------------------------------------------------------------------------
// 总结
// ------------------------------------------------------------------------
//
// 虽然本测验示例只使用 4 位变量，但处理 8 位没有区别。
// 下面的例子从 2 的位开始，每隔一位设置一个位：

// var PORTD: u8 = 0b0000_0000;
// print("PORTD: {b:0>8}\n", .{PORTD});
// PORTD |= (1 << 1);
// PORTD = setBit(u8, PORTD, 3);
// PORTD |= (1 << 5) | (1 << 7);
// print("PORTD: {b:0>8} // 每隔一位设置一个位\n", .{PORTD});
// PORTD = ~PORTD;
// print("PORTD: {b:0>8} // 使用 NOT (~) 翻转位\n", .{PORTD});
// newline();
//
// // 这里从 2 的位开始，每隔一位清除一个位。
//
// PORTD = 0b1111_1111;
// print("PORTD: {b:0>8}\n", .{PORTD});
// PORTD &= ~@as(u8, 1 << 1);
// PORTD = clearBit(u8, PORTD, 3);
// PORTD &= ~@as(u8, (1 << 5) | (1 << 7));
// print("PORTD: {b:0>8} // 每隔一位清除一个位\n", .{PORTD});
// PORTD = ~PORTD;
// print("PORTD: {b:0>8} // 使用 NOT (~) 翻转位\n", .{PORTD});
// newline();

// ----------------------------------------------------------------------------
// 以下是一些用于位操作的辅助函数
// ----------------------------------------------------------------------------

// 设置、清除和翻转单个位的函数
fn setBit(comptime T: type, byte: T, comptime bit_pos: T) !T {
    return byte | (1 << bit_pos);
}

test "setBit" {
    try testing.expectEqual(setBit(u8, 0b0000_0000, 3), 0b0000_1000);
}

fn clearBit(comptime T: type, byte: T, comptime bit_pos: T) T {
    return byte & ~@as(T, (1 << bit_pos));
}

test "clearBit" {
    try testing.expectEqual(clearBit(u8, 0b1111_1111, 0), 0b1111_1110);
}

fn toggleBit(comptime T: type, byte: T, comptime bit_pos: T) T {
    return byte ^ (1 << bit_pos);
}

test "toggleBit" {
    var byte = toggleBit(u8, 0b0000_0000, 0);
    try testing.expectEqual(byte, 0b0000_0001);
    byte = toggleBit(u8, byte, 0);
    try testing.expectEqual(byte, 0b0000_0000);
}

// ----------------------------------------------------------------------------
// 还有一些函数可以通过元组一次设置、清除或翻转多个位，何乐而不为呢？
// ----------------------------------------------------------------------------
//

fn createBitmask(comptime T: type, comptime bits: anytype) !T {
    comptime var bitmask: T = 0;
    inline for (bits) |bit| {
        if (bit >= @bitSizeOf(T)) return error.BitPosTooLarge;
        if (bit < 0) return error.BitPosTooSmall;

        bitmask |= (1 << bit);
    }
    return bitmask;
}

test "creating bitmasks from a tuple" {
    try testing.expectEqual(createBitmask(u8, .{0}), 0b0000_0001);
    try testing.expectEqual(createBitmask(u8, .{1}), 0b0000_0010);
    try testing.expectEqual(createBitmask(u8, .{2}), 0b0000_0100);
    try testing.expectEqual(createBitmask(u8, .{3}), 0b0000_1000);
    //
    try testing.expectEqual(createBitmask(u8, .{ 0, 4 }), 0b0001_0001);
    try testing.expectEqual(createBitmask(u8, .{ 1, 5 }), 0b0010_0010);
    try testing.expectEqual(createBitmask(u8, .{ 2, 6 }), 0b0100_0100);
    try testing.expectEqual(createBitmask(u8, .{ 3, 7 }), 0b1000_1000);

    try testing.expectError(error.BitPosTooLarge, createBitmask(u4, .{4}));
}

fn setBits(byte: u8, bits: anytype) !u8 {
    const bitmask = try createBitmask(u8, bits);
    return byte | bitmask;
}

test "setBits" {
    try testing.expectEqual(setBits(0b0000_0000, .{0}), 0b0000_0001);
    try testing.expectEqual(setBits(0b0000_0000, .{7}), 0b1000_0000);

    try testing.expectEqual(setBits(0b0000_0000, .{ 0, 1, 2, 3, 4, 5, 6, 7 }), 0b1111_1111);
    try testing.expectEqual(setBits(0b1111_1111, .{ 0, 1, 2, 3, 4, 5, 6, 7 }), 0b1111_1111);

    try testing.expectEqual(setBits(0b0000_0000, .{ 2, 3, 4, 5 }), 0b0011_1100);

    try testing.expectError(error.BitPosTooLarge, setBits(0b1111_1111, .{8}));
    try testing.expectError(error.BitPosTooSmall, setBits(0b1111_1111, .{-1}));
}

fn clearBits(comptime byte: u8, comptime bits: anytype) !u8 {
    const bitmask: u8 = try createBitmask(u8, bits);
    return byte & ~@as(u8, bitmask);
}

test "clearBits" {
    try testing.expectEqual(clearBits(0b1111_1111, .{0}), 0b1111_1110);
    try testing.expectEqual(clearBits(0b1111_1111, .{7}), 0b0111_1111);

    try testing.expectEqual(clearBits(0b1111_1111, .{ 0, 1, 2, 3, 4, 5, 6, 7 }), 0b000_0000);
    try testing.expectEqual(clearBits(0b0000_0000, .{ 0, 1, 2, 3, 4, 5, 6, 7 }), 0b000_0000);

    try testing.expectEqual(clearBits(0b1111_1111, .{ 0, 1, 6, 7 }), 0b0011_1100);

    try testing.expectError(error.BitPosTooLarge, clearBits(0b1111_1111, .{8}));
    try testing.expectError(error.BitPosTooSmall, clearBits(0b1111_1111, .{-1}));
}

fn toggleBits(comptime byte: u8, comptime bits: anytype) !u8 {
    const bitmask = try createBitmask(u8, bits);
    return byte ^ bitmask;
}

test "toggleBits" {
    try testing.expectEqual(toggleBits(0b0000_0000, .{0}), 0b0000_0001);
    try testing.expectEqual(toggleBits(0b0000_0000, .{7}), 0b1000_0000);

    try testing.expectEqual(toggleBits(0b1111_1111, .{ 0, 1, 2, 3, 4, 5, 6, 7 }), 0b000_0000);
    try testing.expectEqual(toggleBits(0b0000_0000, .{ 0, 1, 2, 3, 4, 5, 6, 7 }), 0b1111_1111);

    try testing.expectEqual(toggleBits(0b0000_1111, .{ 0, 1, 2, 3, 4, 5, 6, 7 }), 0b1111_0000);
    try testing.expectEqual(toggleBits(0b0000_1111, .{ 0, 1, 2, 3 }), 0b0000_0000);

    try testing.expectEqual(toggleBits(0b0000_0000, .{ 0, 2, 4, 6 }), 0b0101_0101);

    try testing.expectError(error.BitPosTooLarge, toggleBits(0b1111_1111, .{8}));
    try testing.expectError(error.BitPosTooSmall, toggleBits(0b1111_1111, .{-1}));
}

// ----------------------------------------------------------------------------
// 工具函数
// ----------------------------------------------------------------------------

fn newline() void {
    print("\n", .{});
}

fn checkAnswer(expected: u4, answer: u4) void {
    if (expected != answer) {
        print("*************************************************************\n", .{});
        print("= {b:0>4} <- INCORRECT! THE EXPECTED OUTPUT IS {b:0>4}\n", .{ answer, expected });
        print("*************************************************************\n", .{});
    } else {
        print("= {b:0>4}", .{answer});
    }
    newline();
}
