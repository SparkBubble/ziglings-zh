//
// 和整数一样，想要修改结构体时可以传递它的指针。
// 需要保存对结构体的引用（即指向它的“链接”）时，指针也很有用。
//
//     const Vertex = struct{ x: u32, y: u32, z: u32 };
//
//     var v1 = Vertex{ .x=3, .y=2, .z=5 };
//
//     var pv: *Vertex = &v1;   // <-- 指向该结构体的指针
//
// 注意，访问结构体字段时，不需要解引用 "pv" 指针：
//
//     YES: pv.x
//     NO:  pv.*.x
//
// 可以编写以结构体指针为参数的函数。这个 foo() 函数会修改结构体 v：
//
//     fn foo(v: *Vertex) void {
//         v.x += 2;
//         v.y += 3;
//         v.z += 7;
//     }
//
// 调用方式如下：
//
//     foo(&v1);
//
// 我们再来看看 RPG 的例子，编写一个 printCharacter() 函数，
// 通过引用接受 Character 并打印它……*如果*它有链接的“导师”角色，也一并打印。
//
const std = @import("std");

const Class = enum {
    wizard,
    thief,
    bard,
    warrior,
};

const Character = struct {
    class: Class,
    gold: u32,
    health: u8 = 100, // You can provide default values
    experience: u32,

    // 这里需要用 '?' 来允许 null 值，但我会到后面才解释。先别告诉别人。
    mentor: ?*Character = null,
};

pub fn main() void {
    var mighty_krodor = Character{
        .class = Class.wizard,
        .gold = 10000,
        .experience = 2340,
    };

    var glorp = Character{ // Glorp!
        .class = Class.wizard,
        .gold = 10,
        .experience = 20,
        .mentor = &mighty_krodor, // Glorp's mentor is the Mighty Krodor
    };

    // 请修正我！
    // 请将 Glorp 传给 printCharacter()：
    printCharacter(???);
}

// 注意，这个函数的 "c" 参数是指向 Character 结构体的指针。
fn printCharacter(c: *Character) void {
    // 这是一个新知识：对枚举使用 switch 时，不必写出完整的枚举名称。
    // 当 switch 的值是 Class 枚举类型时，Zig 会将 ".wizard" 理解为 "Class.wizard"：
    const class_name = switch (c.class) {
        .wizard => "Wizard",
        .thief => "Thief",
        .bard => "Bard",
        .warrior => "Warrior",
    };

    std.debug.print("{s} (G:{} H:{} XP:{})\n", .{
        class_name,
        c.gold,
        c.health,
        c.experience,
    });

    // 后面会解释如何检查并捕获“可选”值（这与上面提到的 '?' 有关）。
    if (c.mentor) |mentor| {
        std.debug.print("  Mentor: ", .{});
        printCharacter(mentor);
    }
}
