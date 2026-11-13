//
// Zig 的 'while' 语句会在条件为真时重复执行循环体。
// 下面这个循环最多只运行一次：
//
//     while (condition) {
//         condition = false;
//     }
//
// 记住，条件必须是布尔值。我们可以通过以下比较运算符
// 得到布尔值：
//
//     a == b   表示“a 等于 b”
//     a < b    表示“a 小于 b”
//     a > b    表示“a 大于 b”
//     a != b   表示“a 不等于 b”
//
const std = @import("std");

pub fn main() void {
    var n: u32 = 2;

    // 请设置一个条件，让循环一直运行，直到 "n" 达到 1024：
    while (???) {
        // 打印当前数字
        std.debug.print("{} ", .{n});

        // 将 n 设为其当前值的两倍
        n *= 2;
    }

    // 上面的代码正确后，这里会打印 "n=1024"
    std.debug.print("n={}\n", .{n});
}
