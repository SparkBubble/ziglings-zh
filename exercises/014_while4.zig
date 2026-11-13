//
// 可以用 "break" 语句强制立即退出循环：
//
//     while (condition) : (continue expression) {
//
//         if (other condition) break;
//
//     }
//
// while 循环因 break 而停止时，不会执行继续表达式！
//
const std = @import("std");

pub fn main() void {
    var n: u32 = 1;

    // 糟了！这个 while 循环会一直运行下去吗？！
    // 请修正它，让下面的打印语句输出预期结果。
    while (true) : (n += 1) {
        if (???) ???;
    }

    // 预期结果：n=4
    std.debug.print("n={}\n", .{n});
}
