//
// for 循环还可以访问迭代“索引”，也就是每次迭代都会递增的数字。
// 要获取迭代索引，需要指定第二个序列和第二个捕获值。
//
//     for (items, 0..) |item, index| {
//
//         // 使用 item 和 index 做些处理
//
//     }
//
// "item" 和 "index" 可以使用任意名称。"i" 常用作 "index" 的缩写。
// item 通常使用所遍历元素类型的单数形式命名。
//
const std = @import("std");

pub fn main() void {
    // 我们按“小端”顺序（最低有效字节或位在前）
    // 存储二进制数 1101 的各个位：
    const bits = [_]u8{ 1, 0, 1, 1 };
    var value: u32 = 0;

    // 接下来，将每一位对应的位权（2 的幂）相加，
    // 把二进制位转换成数值。
    //
    // 试试看能否补全缺失的部分：
    for (bits, ???) |bit, ???| {
        // 注意，我们用 @intCast() 将 usize 类型的 i 转换为 u32。
        // 它和 @import() 一样是内置函数，之后会在练习中详细介绍。
        const i_u32: u32 = @intCast(i);
        const place_value = std.math.pow(u32, 2, i_u32);
        value += place_value * bit;
    }

    std.debug.print("The value of bits '1101': {}.\n", .{value});
}
//
// 如上一个练习所说，自早期练习编写以来，'for' 循环增加了更多灵活性。
// 后面的练习会介绍，以上捕获索引的语法只是更通用功能的一部分。
// 请继续学习！
