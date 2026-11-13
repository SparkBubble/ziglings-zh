//
// 有时你需要创建不遵循命名规则的标识符，原因可能各不相同：
//
//     const 55_cows: i32 = 55; // 非法：不能以数字开头
//     const isn't true: bool = false; // 非法：这是什么写法？！
//
// 如果你在通常情况下尝试创建其中任何一个标识符，程序标识符语法安全
// 特别行动队（PISST）就会找上门把你带走。
//
// 幸运的是，Zig 提供了 @"" 标识符引用语法，能让这些古怪标识符躲过监管。
//
//     @"foo"
//
// 请帮我们把这些逃亡标识符安全地偷渡进程序：
//
const print = @import("std").debug.print;

pub fn main() void {
    const 55_cows: i32 = 55;
    const isn't true: bool = false;

    print("Sweet freedom: {}, {}.\n", .{
        55_cows,
        isn't true,
    });
}
