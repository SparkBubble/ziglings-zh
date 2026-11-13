//
// 还记得像这样把 if/else 语句当作表达式吗？
//
//     var foo: u8 = if (true) 5 else 0;
//
// Zig 也允许把 for 和 while 循环当作表达式。
//
// 类似函数中的 'return'，可以用 break 从循环代码块返回一个值：
//
//     break true; // 从代码块返回布尔值
//
// 如果循环从未执行到 break，会返回什么值？我们需要一个默认表达式。
// 幸好 Zig 循环也有 'else' 分支！你可能已经猜到，以下情况会执行 'else'：
// 1) 'while' 条件变为假；2) 'for' 循环遍历完所有项目。
//
//     const two: u8 = while (true) break 2 else 0;         // 2
//     const three: u8 = for ([1]u8{1}) |f| break 3 else 0; // 3
//
// 如果没有提供 else 分支，编译器会补上一个空分支，其结果是 void 类型，
// 这可能不是你想要的。因此，将循环用作表达式时，else 分支不可或缺。
//
//     const four: u8 = while (true) {
//         break 4;
//     };               // <-- 错误！这里隐式使用了 'else void'！
//
// 记住这一点，看看能否修复这个程序的问题。
//
const print = @import("std").debug.print;

pub fn main() void {
    const langs: [6][]const u8 = .{
        "Erlang",
        "Algol",
        "C",
        "OCaml",
        "Zig",
        "Prolog",
    };

    // 找到第一个名称由三个字母组成的语言，并从 for 循环中返回它。
    const current_lang: ?[]const u8 = for (langs) |lang| {
        if (lang.len == 3) break lang;
    };

    if (current_lang) |cl| {
        print("Current language: {s}\n", .{cl});
    } else {
        print("Did not find a three-letter language name. :-(\n", .{});
    }
}
