//
// 我们已经看到，传递数组有时很麻烦。还记得 quiz3 中那个特别糟糕的函数定义吗？
// 它只能接受长度恰好为 4 的数组！
//
//     fn printPowersOfTwo(numbers: [4]u16) void { ... }
//
// 这就是数组的问题：长度是数据类型的一部分，每次使用这种类型都必须硬编码。
// 这个 digits 数组永远都是 [10]u8：
//
//     var digits = [10]u8{ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 };
//
// 幸好 Zig 有切片，可以动态指定起始元素和长度。下面是数字数组的一些切片：
//
//     const foo = digits[0..1];  // 0
//     const bar = digits[3..9];  // 3 4 5 6 7 8
//     const baz = digits[5..9];  // 5 6 7 8
//     const all = digits[0..];   // 0 1 2 3 4 5 6 7 8 9
//
// 如你所见，切片 [x..y] 从索引 x 的元素开始，最后一个元素的索引是 y-1。
// 省略 y 就可以取得“剩余所有元素”。
//
// u8 数组切片的类型是 []u8。
//
const std = @import("std");

pub fn main() void {
    var cards = [8]u8{ 'A', '4', 'K', '8', '5', '2', 'Q', 'J' };

    // 请将前 4 张牌放入 hand1，其余牌放入 hand2。
    const hand1: []u8 = cards[???];
    const hand2: []u8 = cards[???];

    std.debug.print("Hand1: ", .{});
    printHand(hand1);

    std.debug.print("Hand2: ", .{});
    printHand(hand2);
}

// 请帮这个函数一把。具体来说，是给它一个 u8 切片。
fn printHand(hand: ???) void {
    for (hand) |h| {
        std.debug.print("{u} ", .{h});
    }
    std.debug.print("\n", .{});
}
//
// 趣闻：切片底层由指向第一个元素的指针和一个长度组成。
