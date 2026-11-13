//
// 有时你知道一个变量可能有值，也可能没有值。Zig 用一种称为 Optional（可选类型）
// 的简洁方式表达这个概念。可选类型只需加上 '?'，例如：
//
//     var foo: ?u32 = 10;
//
// 现在 foo 可以存储 u32 整数，也可以是 null（表示值_不存在_这一宇宙恐怖的值！）
//
//     foo = null;
//
//     if (foo == null) beginScreaming();
//
// 将可选值当作非 null 类型（这里是 u32 整数）使用之前，必须确保它不是 null。
// 一种方法是用 "orelse" 语句来“威胁”它。
//
//     var bar = foo orelse 2;
//
// 这里，bar 要么等于 foo 中存储的 u32 整数值，要么在 foo 为 null 时等于 2。
//
const std = @import("std");

pub fn main() void {
    const result = deepThought();

    // 请“威胁”这个结果，让 answer 要么是 deepThought() 返回的整数值，
    // 要么是数字 42：
    const answer: u8 = result;

    std.debug.print("The Ultimate Answer: {}.\n", .{answer});
}

fn deepThought() ?u8 {
    // 看来 Deep Thought 的输出质量下降了。
    // 不过我们就先这样吧。抱歉，Deep Thought。
    return null;
}
// 回顾一下之前的内容：
//
// 可选类型很像错误联合类型，后者可以存储值或错误。同样，orelse 语句
// 类似于 catch 语句，可用于“解包”值或提供默认值：
//
//    var maybe_bad: Error!u32 = Error.Evil;
//    var number: u32 = maybe_bad catch 0;
//
