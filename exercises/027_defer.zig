//
// 可以用 "defer" 语句延后执行一段代码，让它在代码块退出_之后_运行：
//
//     {
//         defer runLater();
//         runNow();
//     }
//
// 在上面的例子中，代码块 ({...}) 结束时会运行 runLater()。
// 因此代码会按以下顺序运行：
//
//     runNow();
//     runLater();
//
// 这个特性起初看起来有些奇怪，但我们会在下一个练习中看到它的用处。
const std = @import("std");

pub fn main() void {
    // 不要改动其他内容，请在此代码中添加 'defer' 语句，
    // 让程序打印 "One Two\n"：
    std.debug.print("Two\n", .{});
    std.debug.print("One ", .{});
}
