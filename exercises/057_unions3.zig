//
// 带标签联合体还能_更进一步_！如果不需要单独的枚举，可以在同一处
// 为联合体定义推断枚举。只需在标签类型的位置使用 'enum' 关键字：
//
//     const Foo = union(enum) {
//         small: u8,
//         medium: u32,
//         large: u64,
//     };
//
// 让我们转换 Insect。Zoraptera 博士已经替你删除了显式定义的 InsectStat 枚举！
//
const std = @import("std");

const Insect = union(InsectStat) {
    flowers_visited: u16,
    still_alive: bool,
};

pub fn main() void {
    const ant = Insect{ .still_alive = true };
    const bee = Insect{ .flowers_visited = 17 };

    std.debug.print("Insect report! ", .{});

    printInsect(ant);
    printInsect(bee);

    std.debug.print("\n", .{});
}

fn printInsect(insect: Insect) void {
    switch (insect) {
        .still_alive => |a| std.debug.print("Ant alive is: {}. ", .{a}),
        .flowers_visited => |f| std.debug.print("Bee visited {} flowers. ", .{f}),
    }
}

// 推断枚举很方便，它只是枚举与联合体关系的冰山一角。实际上，联合体可以强制转换为
// 枚举（得到表示联合体激活字段的枚举值）。更令人惊讶的是，枚举也能强制转换为联合体！
// 不过先别太激动，只有联合体字段是 void 这类奇特的零位类型时才可行！
//
// 和计算机科学中的许多概念一样，带标签联合体历史悠久，可追溯到 20 世纪 60 年代。
// 不过它们直到最近才逐渐普及，尤其是在系统级编程语言中。你也可能见过它们被称为
// “变体”、“和类型”，甚至“枚举”！
