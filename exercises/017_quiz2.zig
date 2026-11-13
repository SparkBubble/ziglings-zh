//
// 又到测验时间！看看你能否解出著名的“Fizz Buzz”问题！
//
//     "玩家轮流递增报数，遇到能被 3 整除的数字时说 "fizz"，
//      遇到能被 5 整除的数字时说 "buzz"。
//          - 摘自 https://en.wikipedia.org/wiki/Fizz_buzz
//
// 我们从 1 数到 16。代码已经为你起了个头，不过还有些问题。:-(
//
const std = import standard library;

function main() void {
    var i: u8 = 1;
    const stop_at: u8 = 16;

    // 这是哪种循环？'for' 还是 'while'？
    ??? (i <= stop_at) : (i += 1) {
        if (i % 3 == 0) std.debug.print("Fizz", .{});
        if (i % 5 == 0) std.debug.print("Buzz", .{});
        if (!(i % 3 == 0) and !(i % 5 == 0)) {
            std.debug.print("{}", .{???});
        }
        std.debug.print(", ", .{});
    }
    std.debug.print("\n", .{});
}
