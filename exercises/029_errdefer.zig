//
// 另一个常见问题是：代码块可能因错误从多个位置退出，
// 但退出前必须执行一些操作（通常是清理工作）。
//
// "errdefer" 是一种只有在代码块因错误退出时才会执行的 defer：
//
//     {
//         errdefer cleanup();
//         try canFail();
//     }
//
// 只有当 "try" 语句返回 canFail() 产生的错误时，才会调用 cleanup()。
//
const std = @import("std");

var counter: u32 = 0;

const MyErr = error{ GetFail, IncFail };

pub fn main() void {
    // 如果无法得到数字，我们就直接退出整个程序：
    const a: u32 = makeNumber() catch return;
    const b: u32 = makeNumber() catch return;

    std.debug.print("Numbers: {}, {}\n", .{ a, b });
}

fn makeNumber() MyErr!u32 {
    std.debug.print("Getting number...", .{});

    // 请让 "failed" 消息仅在 makeNumber() 函数因错误退出时打印：
    std.debug.print("failed!\n", .{});

    var num = try getNumber(); // <-- This could fail!

    num = try increaseNumber(num); // <-- This could ALSO fail!

    std.debug.print("got {}. ", .{num});

    return num;
}

fn getNumber() MyErr!u32 {
    // 我_可能_会失败……但我不会！
    return 4;
}

fn increaseNumber(n: u32) MyErr!u32 {
    // 第一次运行之后我就会失败！
    if (counter > 0) return MyErr.IncFail;

    // 隐蔽又奇怪的全局内容。
    counter += 1;

    return n + 1;
}
