//
// 还有 'inline while'。和 'inline for' 一样，它在编译时循环，
// 让你能做出各种运行时无法完成的有趣操作。试试看能否弄清楚
// 这个相当古怪的例子会打印什么：
//
//     const foo = [3]*const [5]u8{ "~{s}~", "<{s}>", "d{s}b" };
//     comptime var i = 0;
//
//     inline while ( i < foo.len ) : (i += 1) {
//         print(foo[i] ++ "\n", .{foo[i]});
//     }
//
// 你还没摘下那顶巫师帽吧？
//
const print = @import("std").debug.print;

pub fn main() void {
    // 这里有一个字符串，包含一系列算术运算和一位十进制数值。
    // 我们把每一组运算和数字称为一条“指令”。
    const instructions = "+3 *5 -2 *2";

    // 这个 u32 变量会在运行时记录程序当前的值。它从 0 开始，
    // 我们将通过执行上面的一系列指令得到最终值。
    var value: u32 = 0;

    // 这个 "index" 变量只会在循环的编译时阶段使用。
    comptime var i = 0;

    // 我们希望在编译时遍历字符串中的每条“指令”。
    //
    // 请修正这里，使循环对每条“指令”执行一次：
    ??? (i < instructions.len) : (???) {

        // 这里从“指令”中取出数字。你能想明白为什么要减去 '0' 吗？
        const digit = instructions[i + 1] - '0';

        // 这个 'switch' 语句包含运行时实际执行的工作。乍一看没什么特别……
        switch (instructions[i]) {
            '+' => value += digit,
            '-' => value -= digit,
            '*' => value *= digit,
            else => unreachable,
        }
        // ……但实际情况比表面看起来有意思得多。
        // 'inline while' 在运行时已经不存在了，任何没有被运行时代码直接
        // 使用的内容也都不会保留。例如，'instructions' 字符串不会出现在
        // 编译后的程序中，因为程序运行时并未使用它！
        //
        // 所以从某种意义上说，这个循环确实在编译时把字符串中的指令
        // 转换成了运行时代码。看来我们现在算是编译器作者了。瞧，
        // 这顶巫师帽戴得很有道理吧。
    }

    print("{}\n", .{value});
}
