//
// 学过可选类型后，我们可以把它们用于结构体。
// 上次看大象时，我们必须把三头大象连成一个“环”，
// 让最后一条象鼻连回第一头大象。这是因为当时我们完全没有
// “象鼻不指向另一头大象”的概念！
//
// 我们还会介绍方便的 `.?` 简写：
//
//     const foo = bar.?;
//
// 这等同于
//
//     const foo = bar orelse unreachable;
//
// 看看下面如何使用这个简写，根据可选值是否存在来改变控制流。
//
// 现在让我们把这些象鼻改成可选的！
//
const std = @import("std");

const Elephant = struct {
    letter: u8,
    tail: *Elephant = null, // Hmm... tail needs something...
    visited: bool = false,
};

pub fn main() void {
    var elephantA = Elephant{ .letter = 'A' };
    var elephantB = Elephant{ .letter = 'B' };
    var elephantC = Elephant{ .letter = 'C' };

    // 连接大象，让每条象鼻都“指向”下一头大象。
    linkElephants(&elephantA, &elephantB);
    linkElephants(&elephantB, &elephantC);

    // 如果尝试连接一头不存在的大象，`linkElephants` 会停止程序！
    // 取消下面的注释，看看会发生什么。
    // const missingElephant: ?*Elephant = null;
    // linkElephants(&elephantC, missingElephant);

    visitElephants(&elephantA);

    std.debug.print("\n", .{});
}

// 如果 e1 和 e2 是指向有效大象的指针，
// 此函数会连接它们，让 e1 的象鼻“指向” e2。
fn linkElephants(e1: ?*Elephant, e2: ?*Elephant) void {
    e1.?.tail = e2.?;
}

// 此函数从第一头大象开始，沿着象鼻访问下一头大象，遍历每头大象一次。
fn visitElephants(first_elephant: *Elephant) void {
    var e = first_elephant;

    while (!e.visited) {
        std.debug.print("Elephant {u}. ", .{e.letter});
        e.visited = true;

        // 遇到不再指向其他大象的象鼻时，我们应该停止。
        // 要怎样写才能做到这一点？

        // 提示：我们需要类似 `.?` 的效果，
        // 但不是结束程序，而是退出循环……
        e = e.tail ???
    }
}
