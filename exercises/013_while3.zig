//
// 前两个练习在功能上相同。继续表达式与 'continue' 语句搭配时，
// 才真正体现出它的用处！
//
// 示例：
//
//     while (condition) : (continue expression) {
//
//         if (other condition) continue;
//
//     }
//
// 每次循环重新开始时都会执行“继续表达式”，即使 `continue` 语句
// 跳过了循环体剩余部分也一样。
//
const std = @import("std");

pub fn main() void {
    var n: u32 = 1;

    // 我想打印 1 到 20 之间不能被 3 或 5 整除的所有数字。
    while (n <= 20) : (n += 1) {
        // '%' 符号是“取模”运算符，会返回除法的余数。
        if (n % 3 == 0) ???;
        if (n % 5 == 0) ???;
        std.debug.print("{} ", .{n});
    }

    std.debug.print("\n", .{});
}
