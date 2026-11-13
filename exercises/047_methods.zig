//
// 救命！邪恶的外星生物把蛋藏在地球各处，
// 现在这些蛋开始孵化了！
//
// 投身战斗前，你需要了解三件事：
//
// 1. 可以将函数附加到结构体（以及其他“类型定义”）上：
//
//     const Foo = struct{
//         pub fn hello() void {
//             std.debug.print("Foo says hello!\n", .{});
//         }
//     };
//
// 2. 结构体成员函数位于该结构体的“命名空间”中，调用时先写“命名空间”，
//    再使用“点号语法”：
//
//     Foo.hello();
//
// 3. 这些函数有个很棒的特性：如果第一个参数是结构体实例（或指向它的指针），
//    就可以用该实例代替类型作为命名空间：
//
//     const Bar = struct{
//         pub fn a(self: Bar) void {}
//         pub fn b(this: *Bar, other: u8) void {}
//         pub fn c(bar: *const Bar) void {}
//     };
//
//    var bar = Bar{};
//    bar.a() // is equivalent to Bar.a(bar)
//    bar.b(3) // is equivalent to Bar.b(&bar, 3)
//    bar.c() // is equivalent to Bar.c(&bar)
//
//    注意，参数名称并不重要。有些人用 self，有些人用类型名称的小写形式，
//    你也可以按实际情况自行命名。
//
//    “等等，”你疑惑地看着 a() 和 b()，“为什么一个接受 'self'，另一个接受 '*self'？”
//    观察得很仔细！
//
//    归根结底只需问一个问题：函数需要修改这个结构体吗？
//
//      * 需要修改它？接受指针 (*Bar)。否则你修改的只是副本，函数一返回，
//        改动就消失了，噗。
//      * 只读取它？直接用 Bar 就可以。
//       （结构体很大时仍可用 *const Bar 避免复制；小结构体复制成本很低。）
//
//    下面会看到：zap() 按值接受 'self: HeatRay'，因为它只读取射线伤害；
//    但它以 '*Alien' 接受外星人，因为射线应该造成伤害，也就是要真正修改
//    外星人的生命值，而不是改一个临时副本。
//
// 好了，你已经全副武装。
//
// 现在请用射线消灭所有外星人，否则地球就要完蛋了！
//
const std = @import("std");

// 看看这个丑陋的 Alien 结构体。知己知彼！
const Alien = struct {
    health: u8,

    // 我们讨厌这个方法：
    pub fn hatch(strength: u8) Alien {
        return Alien{
            .health = strength * 5,
        };
    }
};

// 你可靠的武器。用它射击外星人！
const HeatRay = struct {
    damage: u8,

    // 我们喜欢这个方法：
    pub fn zap(self: HeatRay, alien: *Alien) void {
        alien.health -= if (self.damage >= alien.health) alien.health else self.damage;
    }
};

pub fn main() void {
    // 看看这些实力各异的外星人！
    var aliens = [_]Alien{
        Alien.hatch(2),
        Alien.hatch(1),
        Alien.hatch(3),
        Alien.hatch(3),
        Alien.hatch(5),
        Alien.hatch(3),
    };

    var aliens_alive = aliens.len;
    const heat_ray = HeatRay{ .damage = 7 }; // We've been given a heat ray weapon.

    // 我们会持续检查是否已经消灭所有外星人。
    while (aliens_alive > 0) {
        aliens_alive = 0;

        // 通过引用遍历每个外星人（* 会将捕获值设为指针）
        for (&aliens) |*alien| {

            // *** 在这里用热射线攻击外星人！***
            ???.zap(???);

            // 如果外星人的生命值仍大于 0，它就还活着。
            if (alien.health > 0) aliens_alive += 1;
        }

        std.debug.print("{} aliens. ", .{aliens_alive});
    }

    std.debug.print("Earth is saved!\n", .{});
}
