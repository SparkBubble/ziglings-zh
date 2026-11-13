//
// 看看这个：
//
//     var foo: u8 = 5;      // foo 的值为 5
//     var bar: *u8 = &foo;  // bar 是一个指针
//
// 什么是指针？它是对某个值的引用。在这个例子中，bar 引用了当前存放值 5 的内存位置。
//
// 上述声明的速查表：
//
//     u8         u8 值的类型
//     foo        值 5
//     *u8        指向 u8 值的指针类型
//     &foo       对 foo 的引用
//     bar        指向 foo 中值的指针
//     bar.*      值 5（对 bar 解引用得到的值）
//
// 稍后我们会了解指针的用途。现在先试试看能否让这个例子正常工作！
//
const std = @import("std");

pub fn main() void {
    var num1: u8 = 5;
    const num1_pointer: *u8 = &num1;

    var num2: u8 = undefined;

    // 请使用 num1_pointer 让 num2 等于 5！
    //（可以参考上面的“速查表”。）
    num2 = ???;

    std.debug.print("num1: {}, num2: {}\n", .{ num1, num2 });
}
