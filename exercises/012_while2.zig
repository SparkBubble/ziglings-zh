//
// Zig 的 'while' 语句可以带一个可选的“继续表达式”，每次循环继续时
// 都会执行它（无论是在循环体末尾，还是显式执行 'continue' 时；
// 我们接下来会试试）：
//
//     while (condition) : (continue expression) {
//         ...
//     }
//
// 示例：
//
//     var foo = 2;
//     while (foo < 10) : (foo += 2) {
//         // 对小于 10 的偶数做些处理……
//     }
//
// 试试看能否用继续表达式重写上一个练习：
//
const std = @import("std");

pub fn main() void {
    var n: u32 = 2;

    // 请设置继续表达式，让下面的打印语句得到预期结果。
    while (n < 1000) : ??? {
        // 打印当前数字
        std.debug.print("{} ", .{n});
    }

    // 和上一个练习一样，我们希望结果为 "n=1024"
    std.debug.print("n={}\n", .{n});
}
