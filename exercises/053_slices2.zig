//
// 你可能想对字符串使用切片？毕竟它们是 u8 字符数组，对吧？字符串切片很好用。
// 但有一点要注意：Zig 字符串字面量是不可变（const）值。因此切片类型需要从：
//
//     var foo: []u8 = "foobar"[0..3];
//
// to:
//
//     var foo: []const u8 = "foobar"[0..3];
//
// 试试看能否修好这个受 Zero Wing 启发的短语解码器：
const std = @import("std");

pub fn main() void {
    const scrambled = "great base for all your justice are belong to us";

    const base1: []u8 = scrambled[15..23];
    const base2: []u8 = scrambled[6..10];
    const base3: []u8 = scrambled[32..];
    printPhrase(base1, base2, base3);

    const justice1: []u8 = scrambled[11..14];
    const justice2: []u8 = scrambled[0..5];
    const justice3: []u8 = scrambled[24..31];
    printPhrase(justice1, justice2, justice3);

    std.debug.print("\n", .{});
}

fn printPhrase(part1: []u8, part2: []u8, part3: []u8) void {
    std.debug.print("'{s} {s} {s}.' ", .{ part1, part2, part3 });
}
