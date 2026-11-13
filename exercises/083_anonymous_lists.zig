//
// 匿名结构体字面量语法也可以配合数组类型目标，组成“匿名列表”：
//
//     const foo: [3]u32 = .{10, 20, 30};
//
// 否则它就是一个“元组”：
//
//     const bar = .{10, 20, 30};
//
// 两者唯一的区别是目标类型。
//
const print = @import("std").debug.print;

pub fn main() void {
    // 请将 'hello' 变成类似字符串的 u8 数组，但不要更改值字面量。
    //
    // 不要更改这一部分：
    //
    //     = .{ 'h', 'e', 'l', 'l', 'o' };
    //
    const hello = .{ 'h', 'e', 'l', 'l', 'o' };
    print("I say {s}!\n", .{hello});
}
