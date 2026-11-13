//
// if 语句也可以作为表达式：
//
//     const foo: u8 = if (a) 2 else 3;
//
const std = @import("std");

pub fn main() void {
    const discount = true;

    // 请使用 if...else 表达式设置 "price"。
    // 如果 discount 为 true，价格应为 $17，否则为 $20：
    const price: u8 = if ???;

    std.debug.print("With the discount, the price is ${}.\n", .{price});
}
