//
// 如果你觉得上个练习已经深入到底了，那就抓紧帽子，
// 我们现在要潜入计算机炽热的核心。
//
//（大喊）在这里，位和字节像炽热浓稠的液体一样从 RAM 流向 CPU。
// 力量无比惊人。但这和 Zig 程序中的数据有什么关系？
// 让我们回到文本编辑器，一探究竟。
//
// 啊，这样好多了。现在来看看一些熟悉的 Zig 代码。
//
// @import() 会将导入的代码加入你的代码中。这里，标准库代码被加入程序，
// 并和程序一起编译。程序运行时，这些内容都会加载到 RAM 中。对了，
// 我们命名为 "const std" 的东西是什么？它是一个结构体！
//
const std = @import("std");

// 还记得之前 RPG 角色的 Character 结构体吗？结构体其实是处理内存的一种
// 便捷方式。这些字段（gold、health、experience）都是特定大小的值，
// 把它们相加就是整个结构体的大小。

const Character = struct {
    gold: u32 = 0,
    health: u8 = 100,
    experience: u32 = 0,
};

// 这里创建了一个名为 "the_narrator" 的 Character 结构体常量（不可变实例）。
// 它作为数据保存在程序中，并和指令代码一样，在程序运行时加载到 RAM。
// 这份数据在内存中的相对位置是硬编码的，地址和值都不会改变。

const the_narrator = Character{
    .gold = 12,
    .health = 99,
    .experience = 9000,
};

// 这个 "global_wizard" 角色也很相似。数据地址不会改变，但数据本身可以改变，
// 因为它是 var 而不是 const。

var global_wizard = Character{};

// 函数是存放在特定地址上的指令代码。Zig 函数参数总是不可变的，它们存储在“栈”上。
// 栈是一种数据结构，而“栈”指的是为程序预留的一块 RAM。CPU 对栈上的压入和弹出
// 操作有专门支持，因此它是非常高效的内存存储区域。
//
// 此外，函数执行时，输入参数通常会加载到 CPU 的核心部件——寄存器中。
//
// 这里的 main() 函数没有输入参数，但仍会有一个栈条目（称为“栈帧”）。

pub fn main() void {

    // 这里的 "glorp" 角色会分配在栈上，因为 glorp 的每个实例都可变，
    // 因此只属于这次函数调用。

    var glorp = Character{
        .gold = 30,
    };

    // "reward_xp" 这个值很有意思。它不可变，所以即使是局部值，也可以放在全局数据区，
    // 供所有调用共享。不过它很小，也可能直接以内联字面量的形式放进使用它的指令代码中。
    // 具体由编译器决定。

    const reward_xp: u32 = 200;

    // 现在回到文件开头导入的 "std" 结构体。导入后它只是普通的 Zig 值，
    // 因此也可以为它的字段和声明取新名字。"debug" 指向另一个结构体，
    // 而 "print" 是那个结构体命名空间中的公开函数。
    //
    // 将 std.debug.print 函数赋给名为 "print" 的常量，之后就能使用这个新名称！

    const print = ???;

    // 现在来看看 Zig 中对值进行赋值和取指针。
    //
    // 我们试试用三种不同方式创建新名称，访问 glorp 角色并修改其中一个值。
    //
    // "glorp_access1" 这个名字取错了！我们让 Zig 为另一个 Character 结构体分配内存。
    // 因此把 glorp 赋给 glorp_access1 时，实际上复制了所有字段！现在有两个独立角色。
    //
    // 不需要修正这里。但请比较它和下面两种赋值方式在程序输出中的差异！

    var glorp_access1: Character = glorp;
    glorp_access1.gold = 111;
    print("1:{}!. ", .{glorp.gold == glorp_access1.gold});

    // 注意：
    //
    //     如果这里用 const Character 而不是 var，修改 gold 字段会导致编译错误，
    //     因为 const 值不可变！
    //
    // "glorp_access2" 能实现我们的目的。它指向原始 glorp 的地址。
    // 还要记住，访问结构体字段时会隐式解引用一次，所以从 glorp_access2
    // 访问 "gold" 字段和直接从 glorp 访问看起来一样。

    var glorp_access2: *Character = &glorp;
    glorp_access2.gold = 222;
    print("2:{}!. ", .{glorp.gold == glorp_access2.gold});

    // "glorp_access3" 很有意思。它也是指针，但它是 const。这样不能修改 gold 吗？
    // 并非如此！还记得之前关于指针的实验吗？常量指针不能改变它_指向的目标_，
    // 但目标地址上的值仍可变！所以我们_可以_修改它。

    const glorp_access3: *Character = &glorp;
    glorp_access3.gold = 333;
    print("3:{}!. ", .{glorp.gold == glorp_access3.gold});

    // 注意：
    //
    //     如果这里使用 *const Character 指针，就_不行_，会产生编译错误，
    //     因为值本身变成不可变了！
    //
    // 接着看……
    //
    // 参数传入函数后，在函数内部_总是_常量，
    // 不管它们在调用函数中是如何声明的。
    //
    // 示例：
    // fn foo(arg: u8) void {
    //    arg = 42; // Error, 'arg' is const!
    // }
    //
    // fn bar() void {
    //    var arg: u8 = 12;
    //    foo(arg);
    //    ...
    // }
    //
    // 了解这一点后，试试看能否让 levelUp() 按预期工作：
    // 将指定数量加到传入角色的经验值上。
    //
    print("XP before:{}, ", .{glorp.experience});

    // 在这里完成修正 1/2：
    levelUp(glorp, reward_xp);

    print("after:{}.\n", .{glorp.experience});
}

// 在这里完成修正 2/2：
fn levelUp(character_access: Character, xp: u32) void {
    character_access.experience += xp;
}

// 还有更多！
//
// 数据段（在编译时分配）和“栈”（在运行时分配）并不是程序数据存入内存的唯二位置，
// 只是效率最高的地方。有时只有等程序运行后，我们才知道需要多少内存。
// 此外，分配给程序的栈内存大小也有限制（通常由操作系统设置）。
// 遇到这些情况时，就要用“堆”。
//
// 你可以按需使用堆内存（当然不能超过物理限制），但管理堆的效率低得多，
// 因为 CPU 没有像处理栈那样内置支持堆中项目的增删操作。此外，根据分配方式，
// 程序可能需要付出很高的成本来管理堆内存。之后我们会学习堆分配器。
//
// 呼！信息量真不少。好消息是，下一个练习会回到 Zig 语言特性的学习，
// 学完就能马上用来做更多事情！
