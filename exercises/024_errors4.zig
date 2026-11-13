//
// 用 `catch` 将错误替换成默认值有点简单粗暴，因为这样不区分错误类型。
//
// 使用以下形式，catch 可以捕获错误值并执行额外操作：
//
//     canFail() catch |err| {
//         if (err == FishError.TunaMalfunction) {
//             ...
//         }
//     };
//
const std = @import("std");

const MyNumberError = error{
    TooSmall,
    TooBig,
};

pub fn main() void {
    // 下面的 "catch 0" 暂时是处理 makeJustRight() 返回的错误联合类型的权宜办法。
    const a: u32 = makeJustRight(44) catch 0;
    const b: u32 = makeJustRight(14) catch 0;
    const c: u32 = makeJustRight(4) catch 0;

    std.debug.print("a={}, b={}, c={}\n", .{ a, b, c });
}

// 在这个有点荒唐的例子中，我们把修正数字的工作拆给了四个（！）函数：
//
//     makeJustRight()   调用 fixTooBig()，无法修复任何错误。
//     fixTooBig()       调用 fixTooSmall()，修复 TooBig 错误。
//     fixTooSmall()     调用 detectProblems()，修复 TooSmall 错误。
//     detectProblems()  返回数字或错误。
//
fn makeJustRight(n: u32) MyNumberError!u32 {
    return fixTooBig(n) catch |err| {
        return err;
    };
}

fn fixTooBig(n: u32) MyNumberError!u32 {
    return fixTooSmall(n) catch |err| {
        if (err == MyNumberError.TooBig) {
            return 20;
        }

        return err;
    };
}

fn fixTooSmall(n: u32) MyNumberError!u32 {
    // 糟糕，这里缺了很多！不过别担心，它几乎和上面的 fixTooBig() 一样。
    //
    // 如果得到 TooSmall 错误，应返回 10。
    // 如果得到其他错误，应返回该错误。
    // 否则，返回这个 u32 数值。
    return detectProblems(n) ???;
}

fn detectProblems(n: u32) MyNumberError!u32 {
    if (n < 10) return MyNumberError.TooSmall;
    if (n > 20) return MyNumberError.TooBig;
    return n;
}
