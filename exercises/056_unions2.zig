//
// 必须手动跟踪联合体中激活的字段，确实很不方便，对吧？
//
// 幸好，Zig 还有“带标签联合体”，可以在联合体中存储一个枚举值，
// 用来表示哪个字段处于激活状态。
//
//     const FooTag = enum{ small, medium, large };
//
//     const Foo = union(FooTag) {
//         small: u8,
//         medium: u32,
//         large: u64,
//     };
//
// 现在可以直接对联合体使用 switch，操作激活字段：
//
//     var f = Foo{ .small = 10 };
//
//     switch (f) {
//         .small => |my_small| do_something(my_small),
//         .medium => |my_medium| do_something(my_medium),
//         .large => |my_large| do_something(my_large),
//     }
//
// 让我们的 Insects 使用带标签联合体吧（Zoraptera 博士表示赞同）。
//
const std = @import("std");

const InsectStat = enum { flowers_visited, still_alive };

const Insect = union(InsectStat) {
    flowers_visited: u16,
    still_alive: bool,
};

pub fn main() void {
    const ant = Insect{ .still_alive = true };
    const bee = Insect{ .flowers_visited = 16 };

    std.debug.print("Insect report! ", .{});

    // 真的只要传入这个联合体就这么简单吗？
    printInsect(???);
    printInsect(???);

    std.debug.print("\n", .{});
}

fn printInsect(insect: Insect) void {
    switch (???) {
        .still_alive => |a| std.debug.print("Ant alive is: {}. ", .{a}),
        .flowers_visited => |f| std.debug.print("Bee visited {} flowers. ", .{f}),
    }
}

// 顺便问一下，联合体有没有让你想起可选值和错误？可选值基本上是“null 联合体”，
// 错误则使用“错误联合类型”。现在我们也可以加入自定义联合体，处理各种情况：
//          union(Tag) { value: u32, toxic_ooze: void }
