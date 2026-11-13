//
// 处理错误联合类型的一种方法是用 "catch" 捕获错误，
// 并将其替换为默认值。
//
//     foo = canFail() catch 6;
//
// 如果 canFail() 出错，foo 就会等于 6。
//
const std = @import("std");

const MyNumberError = error{TooSmall};

pub fn main() void {
    const a: u32 = addTwenty(44) catch 22;
    const b: u32 = addTwenty(4) ??? 22;

    std.debug.print("a={}, b={}\n", .{ a, b });
}

// 请为这个函数指定返回类型。
// 提示：它是错误联合类型。
fn addTwenty(n: u32) ??? {
    if (n < 5) {
        return MyNumberError.TooSmall;
    } else {
        return n + 20;
    }
}
