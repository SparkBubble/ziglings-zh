//
// 来学习一些数组基础知识。数组这样声明：
//
//   var foo: [3]u32 = [3]u32{ 42, 108, 5423 };
//
// 如果 Zig 能推断数组长度，可以用 '_' 代替长度。
// 也可以让 Zig 推断值的类型，这样声明就简洁得多。
//
//   var foo = [_]u32{ 42, 108, 5423 };
//
// 使用 array[index] 语法获取数组中的值：
//
//     const bar = foo[2]; // 5423
//
// 使用 array[index] 语法设置数组中的值：
//
//     foo[2] = 16;
//
// 使用 len 属性获取数组长度：
//
//     const length = foo.len;
//
const std = @import("std");

pub fn main() void {
    //（问题 1）
    // 这个 "const" 稍后会导致问题，你看得出是什么吗？
    // 应该如何修正？
    const some_primes = [_]u8{ 1, 3, 5, 7, 11, 13, 17, 19 };

    // 可以用 '[]' 语法单独设置某个值。
    // 例如：这一行将第一个质数改为 2（这是正确的）：
    some_primes[0] = 2;

    // 也可以用 '[]' 语法单独访问某个值。
    // 例如：这一行将第一个质数存入 "first"：
    const first = some_primes[0];

    //（问题 2）
    // 看来需要补全这个表达式。参照上面的例子，将 some_primes
    // 数组的第四个元素赋给 "fourth"：
    const fourth = some_primes[???];

    //（问题 3）
    // 使用 len 属性获取数组长度：
    const length = some_primes.???;

    std.debug.print("First: {}, Fourth: {}, Length: {}\n", .{
        first, fourth, length,
    });
}
