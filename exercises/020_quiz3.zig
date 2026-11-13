//
// 看看能否运用目前学到的知识。我们将创建两个函数：一个包含 "for" 循环，
// 另一个包含 "while" 循环。
//
// 下面这两个函数都简单地标记为 "loop"。
//
const std = @import("std");

pub fn main() void {
    const my_numbers = [4]u16{ 5, 6, 7, 8 };

    printPowersOfTwo(my_numbers);
    std.debug.print("\n", .{});
}

// 你不常见到这种写法：函数接受一个恰好包含四个 u16 数的数组。
// 通常不会这样把数组传给函数。稍后我们会学习切片和指针，
// 现在先用已学过的知识。
//
// 这个函数会打印内容，但不返回任何值。
//
fn printPowersOfTwo(numbers: [4]u16) ??? {
    loop (numbers) |n| {
        std.debug.print("{} ", .{twoToThe(n)});
    }
}

// 这个函数看起来和上一个练习中的 twoToThe() 很像，但别被迷惑了！
// 它没有借助标准库来完成计算！
//
fn twoToThe(number: u16) ??? {
    var n: u16 = 0;
    var total: u16 = 1;

    loop (n < number) : (n += 1) {
        total *= 2;
    }

    return ???;
}
