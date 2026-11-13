//
// 函数！我们已经创建过许多名为 'main()' 的函数。现在来做点不同的：
//
//     fn foo(n: u8) u8 {
//         return n + 1;
//     }
//
// 上面的 foo() 函数接受数字 'n'，并返回比它大 1 的数字。
//
// 注意，输入参数 'n' 和返回值类型都是 u8。
//
const std = @import("std");

pub fn main() void {
    // 新函数 deepThought() 应返回数字 42。请看下方。
    const answer: u8 = deepThought();

    std.debug.print("Answer to the Ultimate Question: {}\n", .{answer});
}

// 请在下方定义 deepThought() 函数。
//
// 这里只缺少几个东西。其中不缺的是 "pub" 关键字，因为这里不需要它。
// 你能猜到原因吗？
//
??? deepThought() ??? {
    return 42; // Number courtesy Douglas Adams
}
