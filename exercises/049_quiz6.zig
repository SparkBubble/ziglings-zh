//
//    "Trunks and tails
//     Are handy things"

//     from Holding Hands
//       by Lenore M. Link
//
// 象鼻的部分已经搞清楚了，你能实现长鼻子吗？
//
const std = @import("std");

const Elephant = struct {
    letter: u8,
    tail: ?*Elephant = null,
    trunk: ?*Elephant = null,
    visited: bool = false,

    // Elephant 象鼻方法！
    pub fn getTail(self: *Elephant) *Elephant {
        return self.tail.?; // Remember, this means "orelse unreachable"
    }

    pub fn hasTail(self: *Elephant) bool {
        return (self.tail != null);
    }

    // 在这里编写 Elephant 长鼻方法！
    // ---------------------------------------------------

    ???

    // ---------------------------------------------------

    pub fn visit(self: *Elephant) void {
        self.visited = true;
    }

    pub fn print(self: *Elephant) void {
        // 打印大象字母和是否已访问 [v]
        const v: u8 = if (self.visited) 'v' else ' ';
        std.debug.print("{u}{u} ", .{ self.letter, v });
    }
};

pub fn main() void {
    var elephantA = Elephant{ .letter = 'A' };
    var elephantB = Elephant{ .letter = 'B' };
    var elephantC = Elephant{ .letter = 'C' };

    // 连接大象，让每条象鼻都“指向”下一头大象。
    elephantA.tail = &elephantB;
    elephantB.tail = &elephantC;

    // 再连接大象，让每条长鼻都“指向”上一头大象。
    elephantB.trunk = &elephantA;
    elephantC.trunk = &elephantB;

    visitElephants(&elephantA);

    std.debug.print("\n", .{});
}

// 此函数从象鼻到长鼻，访问每头大象两次。
fn visitElephants(first_elephant: *Elephant) void {
    var e = first_elephant;

    // 沿着象鼻前进！
    while (true) {
        e.print();
        e.visit();

        // 这里要么取得下一头大象，要么停止。
        if (e.hasTail()) {
            e = e.getTail();
        } else {
            break;
        }
    }

    // 沿着长鼻前进！
    while (true) {
        e.print();

        // 这里要么取得上一头大象，要么停止。
        if (e.hasTrunk()) {
            e = e.getTrunk();
        } else {
            break;
        }
    }
}
