//
// 'comptime' 函数参数最常见的用途之一，是将类型传给函数：
//
//     fn foo(comptime MyType: type) void { ... }
//
// 实际上，类型只能在编译时使用，因此这里必须使用 'comptime' 关键字。
//
// 请戴上为你准备的巫师帽。我们马上要用这个能力实现一个泛型函数。
//
const print = @import("std").debug.print;

pub fn main() void {
    // 这里我们通过函数调用，在编译时声明了三种不同类型和长度的数组。真棒！
    const s1 = makeSequence(u8, 3); // creates a [3]u8
    const s2 = makeSequence(u32, 5); // creates a [5]u32
    const s3 = makeSequence(i64, 7); // creates a [7]i64

    print("s1={any}, s2={any}, s3={any}\n", .{ s1, s2, s3 });
}

// 这个函数相当特别，因为它在运行时执行，并且属于最终编译出的程序。
// 函数编译时使用的数据大小和类型都是固定的。
//
// 然而它也允许不同大小和类型。这似乎自相矛盾，怎么可能两者都成立？
//
// 为此，Zig 编译器实际上会为每种大小和类型的组合分别生成一个函数副本！
// 因此本例会为你生成三个不同的函数，每个函数的机器码都处理特定的数据大小和类型。
//
// 请修正这个函数，使 'size' 参数：
//
//     1) 保证在编译时已知。
//     2) 设置 T 类型数组的长度（也就是我们要创建并返回的序列长度）。
//
fn makeSequence(comptime T: type, ??? size: usize) [???]T {
    var sequence: [???]T = undefined;
    var i: usize = 0;

    while (i < size) : (i += 1) {
        sequence[i] = @as(T, @intCast(i)) + 1;
    }

    return sequence;
}
