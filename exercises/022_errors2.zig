//
// 一种常见的错误场景是：我们期望得到一个值，或者发生了错误。看这个例子：
//
//     var text: Text = getText("foo.txt");
//
// 如果 getText() 找不到 "foo.txt" 会怎样？在 Zig 中该如何表示这种情况？
//
// Zig 提供了所谓的“错误联合类型”，其值可以是普通值，也可以是某个错误集合中的错误：
//
//     var text: MyErrorSet!Text = getText("foo.txt");
//
// 现在先来试着创建一个错误联合类型！
//
const std = @import("std");

const MyNumberError = error{TooSmall};

pub fn main() void {
    var my_number: ??? = 5;

    // 看来 my_number 需要存储一个数字或一个错误。
    // 你能在上面正确设置它的类型吗？
    my_number = MyNumberError.TooSmall;

    std.debug.print("I compiled!\n", .{});
}
