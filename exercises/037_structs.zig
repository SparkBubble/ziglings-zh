//
// 将值分组后，可以把下面的内容：
//
//     point1_x = 3;
//     point1_y = 16;
//     point1_z = 27;
//     point2_x = 7;
//     point2_y = 13;
//     point2_z = 34;
//
// 改写成这样：
//
//     point1 = Point{ .x=3, .y=16, .z=27 };
//     point2 = Point{ .x=7, .y=13, .z=34 };
//
// 上面的 Point 是 "struct"（structure 的缩写，结构体）的一个例子。
// 这个结构体类型可以这样定义：
//
//     const Point = struct{ x: u32, y: u32, z: u32 };
//
// 用结构体存储一些有趣的东西吧：一个角色扮演游戏人物！
//
const std = @import("std");

// 我们会用枚举指定人物职业。
const Role = enum {
    wizard,
    thief,
    bard,
    warrior,
};

// 请为这个结构体添加名为 "health" 的新属性，并将其设为 u8 整数类型。
const Character = struct {
    role: Role,
    gold: u32,
    experience: u32,
};

pub fn main() void {
    // 请将 Glorp 的生命值初始化为 100。
    var glorp_the_wise = Character{
        .role = Role.wizard,
        .gold = 20,
        .experience = 10,
    };

    // Glorp 获得了一些金币。
    glorp_the_wise.gold += 5;

    // 哎哟！Glorp 挨了一拳！
    glorp_the_wise.health -= 10;

    std.debug.print("Your wizard has {} health and {} gold.\n", .{
        glorp_the_wise.health,
        glorp_the_wise.gold,
    });
}
