//
// 信不信由你，程序有时确实会出错。
//
// 在 Zig 中，错误也是一种值。错误会有名称，便于识别可能出错的情况。
// 错误在“错误集合”中定义，它就是一组带名称的错误。
//
// 错误集合已经有了开头，但缺少 "TooSmall" 这一项。请在需要的地方补上！
const MyNumberError = error{
    TooBig,
    ???,
    TooFour,
};

const std = @import("std");

pub fn main() void {
    const nums = [_]u8{ 2, 3, 4, 5, 6 };

    for (nums) |n| {
        std.debug.print("{}", .{n});

        const number_error = numberFail(n);

        if (number_error == MyNumberError.TooBig) {
            std.debug.print(">4. ", .{});
        }
        if (???) {
            std.debug.print("<4. ", .{});
        }
        if (number_error == MyNumberError.TooFour) {
            std.debug.print("=4. ", .{});
        }
    }

    std.debug.print("\n", .{});
}

// 注意，这个函数可以返回 MyNumberError 错误集合中的任意成员。
fn numberFail(n: u8) MyNumberError {
    if (n > 4) return MyNumberError.TooBig;
    if (n < 4) return MyNumberError.TooSmall; // <---- this one is free!
    return MyNumberError.TooFour;
}
