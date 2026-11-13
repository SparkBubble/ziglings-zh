//
// 我们已经看到，Zig 会隐式地在编译时进行一些求值。
// 但有时你会想明确要求在编译时求值。为此，我们有一个新关键字：
//
//  .     .   .      o       .          .       *  . .     .
//    .  *  |     .    .            .   .     .   .     * .    .
//        --o--            comptime        *    |      ..    .
//     *    |       *  .        .    .   .    --*--  .     *  .
//  .     .    .    .   . . .      .        .   |   .    .  .
//（ASCII 图案描绘了星空中冉冉升起的 "comptime"）
//
// 将 'comptime' 放在变量声明前，可以保证该变量的每次使用
// 都会在编译时进行。
//
// 简单来说，比较下面两条语句：
//
//    var bar1 = 5;            // ERROR!
//    comptime var bar2 = 5;   // OKAY!
//
// 第一条会报错，因为 Zig 假设可变标识符（用 'var' 声明）会在运行时使用，
// 而我们没有为它指定运行时类型（例如 u8 或 f32）。在运行时使用大小未定的
// comptime_int 属于内存犯罪，你被逮捕了。
//
// 第二条没有问题，因为我们告诉 Zig 'bar2' 是编译时变量。
// Zig 会帮我们确保这一点，并在我们出错时告知。
//
const print = @import("std").debug.print;

pub fn main() void {
    //
    // 在这个刻意构造的例子中，我们决定用一个变量计数来分配数组！
    // 但还缺了点什么……
    //
    var count = 0;

    count += 1;
    const a1: [count]u8 = @splat('A');

    count += 1;
    const a2: [count]u8 = @splat('B');

    count += 1;
    const a3: [count]u8 = @splat('C');

    count += 1;
    const a4: [count]u8 = @splat('D');

    print("{s} {s} {s} {s}\n", .{ a1, a2, a3, a4 });

    // 内置函数奖励内容！
    //
    // 内置函数 @compileLog() 类似 print 语句，但它只在编译时运行。
    // Zig 编译器会将 @compileLog() 调用视为错误，因此你应该临时使用它
    // 来调试编译时逻辑。
    //
    // 试着取消这一行的注释并调整它（复制、移动），看看它会做什么：
    //@compileLog("Count at compile time: ", count);
}
