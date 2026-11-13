//
//    "We live on a placid island of ignorance in the midst
//     of black seas of infinity, and it was not meant that
//     we should voyage far."
//
//     from The Call of Cthulhu
//       by H. P. Lovecraft
//
// Zig 至少有四种表示“无值”的方式：
//
// * undefined
//
//       var foo: u8 = undefined;
//
//       不要把 "undefined" 当作一个值，它是在告诉编译器你现在_还没有_赋值。
//       任何变量都可以设为 undefined，但在赋值前尝试读取它的值_总是_错误的。
//
// * null
//
//       var foo: ?u8 = null;
//
//       "null" 这个原始值_本身就是_表示“无值”的值。
//       它通常与可选类型一起使用，例如上面的 ?u8。foo 等于 null 时，
//       它就不是 u8 类型的值，而是表示你给 foo 赋了_无值_！
//
// * error
//
//       var foo: MyError!u8 = BadError;
//
//       错误和 null_非常_相似。它们_也是_值，但通常表示你要找的“实际值”不存在。
//       这时得到的不是“无值”，而是一个错误。示例错误联合类型 MyError!u8
//       表示 foo 存储的要么是 u8 值，要么是 MyError 错误。
//
// * void
//
//       var foo: void = {};
//
//       "void" 是一种_类型_，而不是值。它是零位类型中最常见的一种
//      （这类类型完全不占空间，只具有语义上的意义）。编译为可执行代码时，
//       零位类型不会生成任何代码。上例将空表达式的值赋给 void 类型变量 foo。
//       更常见的情况是用 void 作为不返回值的函数的返回类型。
//
// Zig 提供这些表示不同“无值”情况的方式，是因为它们各有用途。简而言之：
//
//   * undefined - 目前还没有值，所以目前还不能读取
//   * null      - 明确表示“无值”的值
//   * errors    - 因为出错而没有值
//   * void      - 这里永远不会有值
//
// 请为每个 ??? 选择正确的“无值”表示，让程序打印《死灵之书》中的诅咒引文。
// ……如果你敢的话。
//
const std = @import("std");

const Err = error{Cthulhu};

pub fn main() void {
    var first_line1: *const [16]u8 = ???;
    first_line1 = "That is not dead";

    var first_line2: Err!*const [21]u8 = ???;
    first_line2 = "which can eternal lie";

    // 注意，错误联合类型的字符串需要使用 "{!s}" 格式。
    std.debug.print("{s} {!s} / ", .{ first_line1, first_line2 });

    printSecondLine();
}

fn printSecondLine() ??? {
    var second_line2: ?*const [18]u8 = ???;
    second_line2 = "even death may die";

    std.debug.print("And with strange aeons {s}.\n", .{second_line2.?});
}
