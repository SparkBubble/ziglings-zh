//
// 联合体可以在同一个内存地址存储不同类型和大小的数据。这是怎么做到的？
// 编译器会预留足够的空间，以容纳你可能要存储的最大数据。
//
// 在这个例子中，Foo 实例总会占用 u64 大小的内存，即使当前存储的是 u8。
//
//     const Foo = union {
//         small: u8,
//         medium: u32,
//         large: u64,
//     };
//
// 语法看起来和结构体一样，但 Foo 只能存储 small、medium、large 中的一种值。
// 某个字段激活后，其他未激活字段便不能访问。要更改激活字段，需赋一个全新的实例：
//
//     var f = Foo{ .small = 5 };
//     f.small += 5;                  // OKAY
//     f.medium = 5432;               // ERROR!
//     f = Foo{ .medium = 5432 };     // OKAY
//
// 联合体允许“重复利用”同一块内存，因此可以节省空间。它们也提供了一种原始的多态。
// 无论 Foo 中存储的是哪种大小的无符号整数，fooBar() 都可以接受它：
//
//     fn fooBar(f: Foo) void { ... }
//
// 不过，fooBar() 怎么知道哪个字段处于激活状态？Zig 有一种很好的跟踪方式，
// 但现在我们只能手动记录。
//
// 看看能否让这个程序运行起来！
//
const std = @import("std");

// 我们刚开始编写一个简单的生态系统模拟。
// 昆虫用蜜蜂或蚂蚁表示。蜜蜂存储当天拜访过的花朵数量，
// 蚂蚁则只存储它们是否还活着。
const Insect = union {
    flowers_visited: u16,
    still_alive: bool,
};

// 因为需要指定昆虫类型，所以我们会使用枚举（还记得它吗？）。
const AntOrBee = enum { a, b };

pub fn main() void {
    // 我们先创建一只蜜蜂和一只蚂蚁来测试：
    const ant = Insect{ .still_alive = true };
    const bee = Insect{ .flowers_visited = 15 };

    std.debug.print("Insect report! ", .{});

    // 哎呀！这里出错了。
    printInsect(ant, AntOrBee.c);
    printInsect(bee, AntOrBee.c);

    std.debug.print("\n", .{});
}

// 古怪的 Zoraptera 博士说，我们只能用一个函数打印昆虫。
// Z 博士个子不高，有时令人费解，但我们不会质疑她。
fn printInsect(insect: Insect, what_it_is: AntOrBee) void {
    switch (what_it_is) {
        .a => std.debug.print("Ant alive is: {}. ", .{insect.still_alive}),
        .b => std.debug.print("Bee visited {} flowers. ", .{insect.flowers_visited}),
    }
}
