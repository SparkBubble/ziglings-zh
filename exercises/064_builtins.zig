//
// Zig 编译器提供“内置”函数。你已经习惯在每个 Ziglings 练习文件开头
// 看到 @import() 了。
//
// 我们还在 "016_for2.zig"、"058_quiz7.zig" 中见过 @intCast()，
// 并在 "036_enums2.zig" 中见过 @backingInt()。
//
// 内置函数很特别，因为它们属于 Zig 语言本身（而不是由标准库提供）。
// 它们还可以提供只有编译器协助才能实现的功能，例如类型内省
//（在程序中检查类型属性的能力）。
//
// Zig 有 100 多个内置函数。我们当然不会全部介绍，但可以看看其中一些有趣的函数。
//
// 开始之前要知道，许多内置函数的参数都标记为 "comptime"。这些参数需要在“编译时已知”，
// 含义应该很清楚。放心，我们很快会认真讲解 "comptime" 主题。
//
const print = @import("std").debug.print;

pub fn main() void {
    // 按字母顺序排列的第二个内置函数是：
    //   @addWithOverflow(a: anytype, b: anytype) struct { @TypeOf(a, b), u1 }
    //     * 'a' 和 'b' 是任意类型的数字。
    //     * 返回值是一个元组，包含计算结果和可能的溢出位。
    //
    // 用很小的 4 位整数试试看，这样更容易理解：
    const a: u4 = 0b1101;
    const b: u4 = 0b0101;
    const my_result = @addWithOverflow(a, b);

    // 看看这个巧妙的格式！b:0>4 表示“以二进制打印，宽度为 4，
    // 右对齐并在左侧补零”。下面的 print() 会输出："1101 + 0101 = 0010 (true)"。
    print("{b:0>4} + {b:0>4} = {b:0>4} ({s})", .{ a, b, my_result[0], if (my_result[1] == 1) "true" else "false" });

    // 来理解这个结果。'b' 的十进制值是 5。将 5 加到 'a' 上，
    // 一步一步看看在哪里发生溢出：
    //
//   a  |  b   | 结果   | 是否溢出？
    // ----------------------------------
    // 1101 + 0001 =  1110  | false
    // 1110 + 0001 =  1111  | false
// 1111 + 0001 =  0000  | true  （真实结果是 10000）
    // 0000 + 0001 =  0001  | false
    // 0001 + 0001 =  0010  | false
    //
    // 最后两行中，'a' 的值已被破坏，因为第三行发生了溢出，但第四、五行的运算本身并未溢出。
    // 以下两者有所不同：
    //  - 某个值曾经溢出，因此现在已经不正确
    //  - 某次运算发生溢出，并可能导致后续错误
    // 实际上，我们通常先发现溢出后的值，再反向追查导致溢出的运算。
    //
    // 如果给 a 加 5 的过程中完全没有溢出，'my_result[0]' 会是多少？
    // 请自行计算，并将答案作为字面量写入 'expected_result'。
    const expected_result: u8 = ???;
    print(". Without overflow: {b:0>8}. ", .{expected_result});

    print("Furthermore, ", .{});

    // 再看个有趣的函数：
    //
    //   @bitReverse(integer: anytype) T
    //     * 'integer' 是要反转的值。
    //     * 返回值与输入类型相同，但其中的位顺序已反转！
    //
    // 现在轮到你了。试试看能否修正这段代码，用此内置函数反转 u8 整数的位。
    const input: u8 = 0b11110000;
    const tupni: u8 = @bitReverse(input, tupni);
    print("{b:0>8} backwards is {b:0>8}.\n", .{ input, tupni });
}
