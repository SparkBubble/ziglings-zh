//
// 容易混淆的是，指针自身的可变性（var 与 const）决定能否改变指针所指向的_位置_，
// 而不是能否修改该位置存储的_值_！
//
//     const locked: u8 = 5;
//     var unlocked: u8 = 10;
//
//     const p1: *const u8 = &locked;
//     var   p2: *const u8 = &locked;
//
// p1 和 p2 都指向不可更改的常量值。不过，p2 可以改为指向其他内容，p1 则不行！
//
//     const p3: *u8 = &unlocked;
//     var   p4: *u8 = &unlocked;
//     const p5: *const u8 = &unlocked;
//     var   p6: *const u8 = &unlocked;
//
// 这里，p3 和 p4 都可以用来修改所指向的值，但 p3 不能改为指向其他内容。
// 有趣的是，p5 和 p6 的行为与 p1 和 p2 相同，但它们指向 "unlocked" 中的值。
// 这就是我们所说的：可以为任意值创建常量引用！
//
const std = @import("std");

pub fn main() void {
    var foo: u8 = 5;
    var bar: u8 = 10;

    // 请定义指针 "p"，让它既能指向 foo 或 bar，也能修改所指向的值！
    ??? p: ??? = undefined;

    p = &foo;
    p.* += 1;
    p = &bar;
    p.* += 1;
    std.debug.print("foo={}, bar={}\n", .{ foo, bar });
}
