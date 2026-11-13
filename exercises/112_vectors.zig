// 到目前为止，我们在 Ziglings 中见过如何用 for 循环以多种方式
// 对数组中的元素重复执行计算。
//
// for 循环通常很适合这类任务，但有时无法充分利用 CPU 的能力。
//
// 大多数现代 CPU 可以执行这样的指令：在寄存器中同时进行多项计算。
// 这称为“单指令多数据”（SIMD）指令，可以显著提升代码性能。
//
// 为了理解原因，假设有个程序需要对四个（不断变化的）f32 浮点数求平方根。
//
// 简单的编译器会生成依次计算每个平方根的机器码。现代 CPU 的大多数寄存器为 64 位，
// 因此可以想象每个浮点数都会进入一个 64 位寄存器，并重复以下过程四次：
//
//            32 bits   32 bits
//          +-------------------+
// register |    0    |    x    |
//          +-------------------+
//
//                    |
//           [SQRT instruction]
//                    V
//
//          +-------------------+
//          |    0    | sqrt(x) |
//          +-------------------+
//
// 注意，寄存器有一半空间是空的，没有参与计算。多浪费！如果能利用这部分空间呢？
// 这正是 SIMD 的核心思想。
//
// 大多数现代 CPU 都包含至少 128 位的专用寄存器来执行 SIMD 指令。
// 对于具有 128 位 SIMD 寄存器的机器，聪明的编译器可能不会像上面那样发出四条 sqrt 指令，
// 而是将浮点数打包进一个 128 位寄存器，再执行一条“打包”平方根指令，
// 一次完成所有平方根计算。
//
// 例如：
//
//
//             32 bits   32 bits   32 bits   32 bits
//           +---------------------------------------+
// register  |   4.0   |   9.0   |  25.0   |  49.0   |
//           +---------------------------------------+
//
//                              |
//                  [SIMD SQRT instruction]
//                              V
//
//           +---------------------------------------+
// register  |   2.0   |   3.0   |   5.0   |   7.0   |
//           +---------------------------------------+
//
// 很酷吧？
//
// 使用 SIMD 指令的代码通常比不使用的性能更好。Zig 非常重视性能，
// 因此内置支持 SIMD！它提供了一种直接支持 SIMD 指令的数据结构：
//
//                        +-----------+
//                        |  Vectors  |
//                        +-----------+
//
// 在 Zig 中对向量执行的运算会尽可能使用 SIMD 指令并行完成。
//
// 在 Zig 中定义向量很简单，无需导入任何库。
const v1 = @Vector(3, i32){ 1, 10, 100 };
const v2 = @Vector(3, f32){ 2.0, 3.0, 5.0 };

// 向量支持与其底层元素类型相同的内置运算符。
const v3 = v1 + v1; // {   2,  20,  200};
const v4 = v2 * v2; // { 4.0, 9.0, 25.0};

// 适用于基本类型的内置函数通常也适用于向量。
const v5: @Vector(3, f32) = @floatFromInt(v3); // { 2.0,  20.0,  200.0}
const v6 = v4 - v5; // { 2.0, -11.0, -175.0}
const v7 = @abs(v6); // { 2.0,  11.0,  175.0}

// 可以创建常量向量，也可以对向量进行归约。
const v8: @Vector(4, u8) = @splat(2); // { 2, 2, 2, 2}
const v8_sum = @reduce(.Add, v8); // 8
const v8_min = @reduce(.Min, v8); // 2

// 固定长度数组可以自动赋值给向量，反之亦然。
const single_digit_primes = [4]i8{ 2, 3, 5, 7 };
const prime_vector: @Vector(4, i8) = single_digit_primes;

// 现在用向量简化并优化一些代码吧！
//
// Ewa 正在编写一个程序，经常需要比较两个各含四个 f32 的列表。
// Ewa 认为两个列表应该比较相似，希望找出它们对应元素之间的最大差值。
//
// Ewa 写了下面这个函数来完成计算。

fn calcMaxPairwiseDiffOld(list1: [4]f32, list2: [4]f32) f32 {
    var max_diff: f32 = 0;
    for (list1, list2) |n1, n2| {
        const abs_diff = @abs(n1 - n2);
        if (abs_diff > max_diff) {
            max_diff = abs_diff;
        }
    }
    return max_diff;
}

// Ewa 听说了 Zig 中的向量，于是开始编写该函数的向量版本，但卡住了！
//
// 帮 Ewa 完成向量版本！上面的例子应该能提供帮助。

const Vec4 = @Vector(4, f32);
fn calcMaxPairwiseDiffNew(a: Vec4, b: Vec4) f32 {
    const abs_diff_vec = ???;
    const max_diff = @reduce(???, abs_diff_vec);
    return max_diff;
}

// 简化得真不少！甚至可以把函数写成一行，而且仍然易读。
//
// 现在整个函数都由向量运算构成，Zig 编译器可以轻松地将其编译为使用 SIMD 指令的机器码，
// 并行完成大量计算。

const std = @import("std");
const print = std.debug.print;

pub fn main() void {
    const l1 = [4]f32{ 3.141, 2.718, 0.577, 1.000 };
    const l2 = [4]f32{ 3.154, 2.707, 0.591, 0.993 };
    const mpd_old = calcMaxPairwiseDiffOld(l1, l2);
    const mpd_new = calcMaxPairwiseDiffNew(l1, l2);
    print("Max difference (old fn): {d: >5.3}\n", .{mpd_old});
    print("Max difference (new fn): {d: >5.3}\n", .{mpd_new});
}

// 向量的另一个有趣特性是重复模式。
// 还记得之前通过重复模式创建数组的练习吗？参见 `005_arrays2.zig`。
