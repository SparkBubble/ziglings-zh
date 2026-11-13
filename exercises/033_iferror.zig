//
// 我们再来看看第一个错误处理练习。这次要介绍 "if" 语句的一种错误处理形式。
//
//     if (foo) |value| {
//
//         // foo 没有出错；value 是 foo 中不表示错误的那个值
//
//     } else |err| {
//
//         // foo 出错了；err 是 foo 中的错误值
//
//     }
//
// 我们还会更进一步，使用 switch 语句处理不同错误类型。
//
//     if (foo) |value| {
//         ...
//     } else |err| switch (err) {
//         ...
//     }
//
const MyNumberError = error{
    TooBig,
    TooSmall,
};

const std = @import("std");

pub fn main() void {
    const nums = [_]u8{ 2, 3, 4, 5, 6 };

    for (nums) |num| {
        std.debug.print("{}", .{num});

        const n = numberMaybeFail(num);
        if (n) |value| {
            std.debug.print("={}. ", .{value});
        } else |err| switch (err) {
            MyNumberError.TooBig => std.debug.print(">4. ", .{}),
            // 请在此处添加 TooSmall 的匹配项，并让它打印："<4. "
        }
    }

    std.debug.print("\n", .{});
}

// 这次让 numberMaybeFail() 返回错误联合类型，而不是单独的错误值。
fn numberMaybeFail(n: u8) MyNumberError!u8 {
    if (n > 4) return MyNumberError.TooBig;
    if (n < 4) return MyNumberError.TooSmall;
    return n;
}
