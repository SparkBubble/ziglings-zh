//
// 既然你已经了解 "defer" 的工作方式，我们来用它做点更有趣的事。
//
const std = @import("std");

pub fn main() void {
    const animals = [_]u8{ 'g', 'c', 'd', 'd', 'g', 'z' };

    for (animals) |a| printAnimal(a);

    std.debug.print("done.\n", .{});

    std.debug.print("Answer to everything? {d}\n", .{calculateTheUltimateQuestionOfLife()});
}

// 这个函数_应该_把动物名称放在括号中打印，例如 "(Goat) "，
// 但即使函数有四处可能返回，我们也得想办法打印右括号！
fn printAnimal(animal: u8) void {
    std.debug.print("(", .{});

    std.debug.print(") ", .{}); // <---- how?!

    if (animal == 'g') {
        std.debug.print("Goat", .{});
        return;
    }
    if (animal == 'c') {
        std.debug.print("Cat", .{});
        return;
    }
    if (animal == 'd') {
        std.debug.print("Dog", .{});
        return;
    }

    std.debug.print("Unknown", .{});
}

// 这个函数应该计算生命、宇宙以及一切终极问题的答案，
// 但为了收集更多数据，它需要尽可能晚地执行。
//
// 同一个代码块中有多个 defer 时，它们会按相反顺序执行。
// 这个例子看起来也许有些傻，但在某些情况下很重要，例如：
// 容器中的元素需要先于容器本身反初始化。
fn calculateTheUltimateQuestionOfLife() u32 {
    var x: u32 = 100;

    // 试着重新排列语句，得到答案 42。
    {
        defer x = x / 10;
        defer x = x + 11;
        defer x = x * 2;
    }

    return x;
}
