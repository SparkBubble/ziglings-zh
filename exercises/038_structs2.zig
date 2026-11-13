//
// 用结构体将值分组不只是为了方便。它还让我们能在存储值、
// 将值传给函数等场景中，把它们当作一个整体处理。
//
// 本练习演示如何将结构体存入数组，以及如何通过循环打印它们。
//
const std = @import("std");

const Role = enum {
    wizard,
    thief,
    bard,
    warrior,
};

const Character = struct {
    role: Role,
    gold: u32,
    health: u8,
    experience: u32,
};

pub fn main() void {
    var chars: [2]Character = undefined;

    // 睿智的 Glorp
    chars[0] = Character{
        .role = Role.wizard,
        .gold = 20,
        .health = 100,
        .experience = 10,
    };

    // 请添加具有以下属性的“大嗓门 Zump”：
    //
    //     role       bard
    //     gold       10
    //     health     100
    //     experience 20
    //
    // 不妨先不添加 Zump 就运行程序。会发生什么？为什么？

    // 用循环打印所有 RPG 角色：
    for (chars, 0..) |c, num| {
        std.debug.print("Character {} - G:{} H:{} XP:{}\n", .{
            num + 1, c.gold, c.health, c.experience,
        });
    }
}

// 如果你按上面的提示试过不添加 Zump 就运行程序，会看到一些看起来像“垃圾”的值。
// 在调试模式（默认模式）下，Zig 会把重复的二进制模式 "10101010"
//（十六进制为 0xAA）写入所有未定义的位置，方便调试时发现它们。
