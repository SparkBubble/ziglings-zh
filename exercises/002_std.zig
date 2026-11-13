//
// 哎呀！这个程序本应像 Hello World 示例那样打印一行内容，
// 但我们忘了如何导入 Zig 标准库。
//
// @import() 是 Zig 内置函数。它会返回一个表示所导入代码的值。
// 最好用一个与导入项同名的常量来保存它：
//
//     const foo = @import("foo");
//
// 请补全下面的导入语句：
//

??? = @import("std");

pub fn main() void {
    std.debug.print("Standard Library.\n", .{});
}

// 补充说明：导入项必须声明为常量，因为它们只能在编译时使用，
// 不能在运行时使用。Zig 会在编译时求出常量的值。别担心，
// 后面我们会详细讲解导入。
// 另请参阅这个解答：https://stackoverflow.com/a/62567550/695615
