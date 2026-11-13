//
//    "大象沿着小径
//     一路漫步
//
//     牵着彼此的手
//     用尾巴相连。"
//
//     选自《牵手》
//       by Lenore M. Link
//
const std = @import("std");

const Elephant = struct {
    letter: u8,
    tail: *Elephant = undefined,
    visited: bool = false,
};

pub fn main() void {
    var elephantA = Elephant{ .letter = 'A' };
    //（请在这里添加大象 B！）
    var elephantC = Elephant{ .letter = 'C' };

    // 将大象连接起来，让每条尾巴都“指向”下一头大象。
    // 它们组成一个环：A->B->C->A……
    elephantA.tail = &elephantB;
    //（请在这里将大象 B 的尾巴连接到大象 C！）
    elephantC.tail = &elephantA;

    visitElephants(&elephantA);

    std.debug.print("\n", .{});
}

// 这个函数从第一头大象开始，沿着尾巴访问下一头大象，确保每头大象只访问一次。
// 如果不将大象“标记”为已访问（设置 visited=true），循环就会无限进行！
fn visitElephants(first_elephant: *Elephant) void {
    var e = first_elephant;

    while (!e.visited) {
        std.debug.print("Elephant {u}. ", .{e.letter});
        e.visited = true;
        e = e.tail;
    }
}
