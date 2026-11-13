//
// 了解方法的工作方式后，让我们用一些 Elephant 方法
// 再帮帮大象们。
//
const std = @import("std");

const Elephant = struct {
    letter: u8,
    tail: ?*Elephant = null,
    visited: bool = false,

    // 新的 Elephant 方法！
    pub fn getTail(self: *Elephant) *Elephant {
        return self.tail.?; // Remember, this means "orelse unreachable"
    }

    pub fn hasTail(self: *Elephant) bool {
        return (self.tail != null);
    }

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

    visitElephants(&elephantA);

    std.debug.print("\n", .{});
}

// 此函数从第一头大象开始，沿着象鼻访问下一头大象，遍历每头大象一次。
fn visitElephants(first_elephant: *Elephant) void {
    var e = first_elephant;

    while (true) {
        e.print();
        e.visit();

        // 这里要么取得下一头大象，要么停止：
        // 应该使用哪个方法？
        e = if (e.hasTail()) e.??? else break;
    }
}

// Zig 的枚举也可以有方法！这条注释原本邀请大家寻找实际使用枚举方法的例子。
// 最早提交的五个拉取请求被采纳，列在这里：
//
// 1) drforester：我在 Zig 源码中找到了一个：
// https://github.com/ziglang/zig/blob/041212a41cfaf029dc3eb9740467b721c76f406c/src/Compilation.zig#L2495
//
// 2) bbuccianti：我找到了一个！
// https://github.com/ziglang/zig/blob/6787f163eb6db2b8b89c2ea6cb51d63606487e12/lib/std/debug.zig#L477
//
// 3) GoldsteinE：找到了很多，这里举一个
// https://github.com/ziglang/zig/blob/ce14bc7176f9e441064ffdde2d85e35fd78977f2/lib/std/target.zig#L65
//
// 4) SpencerCDixon：目前很喜欢这门语言 :-)
// https://github.com/ziglang/zig/blob/a502c160cd51ce3de80b3be945245b7a91967a85/src/zir.zig#L530
//
// 5) tomkun：这里还有一个枚举方法
// https://github.com/ziglang/zig/blob/4ca1f4ec2e3ae1a08295bc6ed03c235cb7700ab9/src/codegen/aarch64.zig#L24
