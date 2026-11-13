//
// 还记得练习 55 和 56 中用联合构建的蚂蚁与蜜蜂模拟器吗？
// 当时我们演示了联合如何让我们统一处理不同的数据类型。
//
// 一个巧妙之处是使用带标签的联合，通过 switch 创建一个函数，
// 用来打印蚂蚁*或*蜜蜂的状态：
//
//   switch (insect) {
//      .still_alive => ...      //（打印蚂蚁相关信息）
//      .flowers_visited => ...  //（打印蜜蜂相关信息）
//   }
//
// 模拟原本运行得很好，直到一只新昆虫来到虚拟花园：蚱蜢！
//
// Zoraptera 博士开始把蚱蜢代码加入程序，但随后她发出愤怒的嘶嘶声，
// 从键盘前退开了。她意识到，每种昆虫的代码放在一处，而打印每种昆虫的
// 代码放在另一处，等模拟扩展到数百种昆虫时会很难维护。
//
// 幸运的是，Zig 还有另一个编译时特性可以帮我们摆脱困境，叫作 'inline else'。
//
// 我们可以用下面的写法替换这些重复代码：
//
//   switch (thing) {
//       .a => |a| special(a),
//       .b => |b| normal(b),
//       .c => |c| normal(c),
//       .d => |d| normal(d),
//       .e => |e| normal(e),
//       ...
//   }
//
// 替换为：
//
//   switch (thing) {
//       .a => |a| special(a),
//       inline else => |t| normal(t),
//   }
//
// 我们可以为某些情况编写特殊处理，然后由 Zig 帮我们处理其余匹配项。
//
// 有了这个特性，你决定创建 Insect 联合，并提供一个统一的 'print()' 函数。
// 这样每种昆虫都可以负责打印自己的信息。Zoraptera 博士也终于能冷静下来，
// 不再啃家具了。
//
const std = @import("std");

const Ant = struct {
    still_alive: bool,

    pub fn print(self: Ant) void {
        std.debug.print("Ant is {s}.\n", .{if (self.still_alive) "alive" else "dead"});
    }
};

const Bee = struct {
    flowers_visited: u16,

    pub fn print(self: Bee) void {
        std.debug.print("Bee visited {} flowers.\n", .{self.flowers_visited});
    }
};

// 这是新加入的蚱蜢。注意，我们也给每种昆虫添加了 print 方法。
const Grasshopper = struct {
    distance_hopped: u16,

    pub fn print(self: Grasshopper) void {
        std.debug.print("Grasshopper hopped {} meters.\n", .{self.distance_hopped});
    }
};

const Insect = union(enum) {
    ant: Ant,
    bee: Bee,
    grasshopper: Grasshopper,

    // 多亏了 'inline else'，我们可以把这个 print() 看作接口方法。
    // 这个联合中任何具有 print() 方法的成员，都可以由外部代码统一处理，
    // 而无需了解其他细节。真酷！
    pub fn print(self: Insect) void {
        switch (self) {
            inline else => |case| return case.print(),
        }
    }
};

pub fn main() !void {
    const my_insects = [_]Insect{
        Insect{ .ant = Ant{ .still_alive = true } },
        Insect{ .bee = Bee{ .flowers_visited = 17 } },
        Insect{ .grasshopper = Grasshopper{ .distance_hopped = 32 } },
    };

    std.debug.print("=== Doctor Zoraptera's Insect Report ===\n", .{});
    for (my_insects) |insect| {
        // 快完成了！我们希望在这里通过一次方法调用打印每种昆虫。
        ???
    }
}

// 上面 Insect 联合中的 print() 方法，展示了与面向对象中抽象数据类型
// 非常相似的概念。也就是说，Insect 类型不包含底层数据，而 print() 函数
// 实际上也不负责打印。
//
// 接口的作用是支持泛型编程：把不同事物当作相同事物处理，以减少代码杂乱和概念复杂度。
//
// 每日昆虫报告不必关心报告中*具体有哪些*昆虫——它们都会通过接口以相同方式打印！
//
// Zoraptera 博士很喜欢这个方案。
