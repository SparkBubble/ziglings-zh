//
// 位操作的另一个用途是将位设为标志。
// 这在处理列表并保存各项状态时尤其有用，例如在数字列表中为每个质数设置标志。
//
// 例如，来看看 Exercism 上的 Pangram 练习：
// https://exercism.org/tracks/zig/exercises/pangram
//
// 全字母句是指至少使用一次字母表中每个字母的句子。
// 它不区分大小写。最著名的英语全字母句是：
//
//           "The quick brown fox jumps over the lazy dog."
//
// 有几种方法可以记录全字母句中出现过的字母（出现一次或多次都无所谓）。
//
// 例如，可以创建一个 bool 数组，对句子中出现的每个字母将对应位置设为 'true'
//（按字母顺序，a=0、b=1 等）。但这种方法既不节省内存，也不够快。
// 我们改用原理相近但更简单的方法：定义一个至少有 26 位的变量（如 u32），
// 并将每个字母对应位置的位设为 1。
//
// Zig 标准库提供了相关函数，但为了学到东西，我们还是不用这些额外帮助。
//
const std = @import("std");
const ascii = std.ascii;
const print = std.debug.print;

pub fn main() !void {
    // 检查是否为全字母句
    print("Is this a pangram? {}!\n", .{isPangram("The quick brown fox jumps over the lazy dog.")});
}

fn isPangram(str: []const u8) bool {
    // 首先检查字符串是否至少有 26 个字符
    if (str.len < 26) return false;

    // 使用一个 32 位变量，其中需要用到 26 位
    var bits: u32 = 0;

    // 遍历字符串中的所有字符
    for (str) |c| {
        // 如果字符是字母
        if (ascii.isAscii(c) and ascii.isAlphabetic(c)) {
            // 就将对应位置的位设为 1
            //
            // 这里用一个小技巧：ASCII 表中的字母从 65 开始，且按顺序编号，
            // 因此只要用当前字符减去首字母（此处为 'a'），
            // 就能得到目标位的位置。
            bits |= @as(u32, 1) << @truncate(ascii.toLower(c) - 'a');
        }
    }
    // 最后检查 26 位是否全部置位；如果是，就知道给定字符串是全字母句。
    //
    // 但我们应该比较什么？
    return bits == 0x???;
}
