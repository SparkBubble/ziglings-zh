//
// 如果 Zig 中还没有等效函数，通常会使用 C 函数。当然，这种情况越来越少了。;-)
//
// 正如上一个练习所示，集成 C 函数非常简单，因此我们自然可以在自己的程序中
// 使用种类繁多的 C 函数。来看个例子：
//
// 假设有一个 765.2 度的角。若要将它归一化，就需要减去 X * 360 度，
// 得到正确的角度。该怎么做？一种好方法是使用取模函数。
// 但写成 "765.2 % 360" 只适用于编译时已知的浮点值。
// 在 Zig 中，我们会改用 @mod(a, b)。
//
// 现在假设 Zig 无法完成这项操作，只能使用 C 标准库函数。
// "math" 库中有一个名为 "fmod" 的函数；"f" 表示浮点数，
// 意味着它可以对实数取模。用这个函数应该就能归一化角度。开始吧。

const std = @import("std");

const c = @cImport({
    // 这里需要什么？
    ???
});

pub fn main() !void {
    const angle = 765.2;
    const circle = 360;

    // 这里调用 C 函数 'fmod'，得到归一化后的角度。
    const result = c.fmod(angle, circle);

    // 使用格式说明符设置精度并截去多余小数位。
    std.debug.print("The normalized angle of {d: >3.1} degrees is {d: >3.1} degrees.\n", .{ angle, result });
}
