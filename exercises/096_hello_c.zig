//
// 2016 年 2 月 8 日，Andrew Kelley 在博客中宣布了一门新编程语言——Zig，
// 并立即提出了雄心勃勃的目标：取代 C 语言！
//
// 要实现这个目标，Zig 必须尽可能兼容它的“前身”。
// 只有在无需复杂封装就能替换现有 C 程序中的独立模块时，
// 这项事业才有成功的可能。
//
// 因此，Zig 调用 C 函数以及反向调用都非常“顺畅”，这并不奇怪。
//
// 要在 Zig 中调用 C 函数，只需指定包含该函数的库。
// 为此，Zig 提供了一个与熟悉的 @import() 对应的内置函数：
//
//                           @cImport()
//
// 现在可以用常见的 Zig 语法引入所需库：
//
//                    const c = @cImport({
//                        @cInclude("stdio.h");
//                        @cInclude("...");
//                    });
//
// 现在可以通过常量 'c'（在本例中）调用函数：
//
//                    c.puts("Hello world!");
//
// 顺便一提，大多数 C 函数会返回整数值。可以据此判断错误（返回值 < 0），
// 或获取其他信息。例如，'puts' 会返回输出的字符数。
//
// 为了不让这些内容停留在枯燥的理论上，我们现在就从 Zig 调用一个 C 函数。

// 我们熟悉的 Zig "import"
const std = @import("std");

// 以及这里用于导入 C 的新方式
const c = @cImport({
    @cInclude("unistd.h");
});

pub fn main() void {

    // 为了输出可由 Zig Builder 检查的文本，需要写入标准错误。
    // 在 Zig 中使用 "std.debug.print"；在 C 中可以指定文件描述符，
    // 例如用 2 表示错误输出。
    //
    // 本练习中我们用 'write' 输出 17 个字符，但还缺了点什么……
    const c_res = write(2, "Hello C from Zig!", 17);

    // 来看看 C 函数的结果：
    std.debug.print(" - C result is {d} chars written.\n", .{c_res});
}
//
// 编译含 C 函数的程序时有一点需要注意：必须让 Zig 编译器知道要链接相应的库。
// 为此，调用编译器时需要给这类程序传入参数 "lc"，
// 例如："zig run -lc hello_c.zig"。
//
