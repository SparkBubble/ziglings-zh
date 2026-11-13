//
// ------------------------------------------------------------
//  TOP SECRET  TOP SECRET  TOP SECRET  TOP SECRET  TOP SECRET
// ------------------------------------------------------------
//
// 准备好了解关于 Zig 字符串字面量的真相了吗？
//
// 真相如下：
//
//     @TypeOf("foo") == *const [3:0]u8
//
// 这意味着字符串字面量是“指向以零结尾（以空字符结尾）的定长 u8 数组的常量指针”。
//
// 现在你知道了。你配得上这个秘密。欢迎加入秘密俱乐部！
//
// ------------------------------------------------------------
//
// 既然字符串长度已知，为什么 Zig 还要用零/空字符哨兵来终止字符串？
//
// 为了通用性！Zig 字符串既兼容以空字符结尾的 C 字符串，也能强制转换为
// 多种其他 Zig 类型：
//
//     const a: [5]u8 = "array".*;
//     const b: *const [16]u8 = "pointer to array";
//     const c: []const u8 = "slice";
//     const d: [:0]const u8 = "slice with sentinel";
//     const e: [*:0]const u8 = "many-item pointer with sentinel";
//     const f: [*]const u8 = "many-item pointer";
//
// 除了 'f' 之外都可以打印。（没有哨兵的多项目指针无法安全打印，因为我们不知道它在哪里结束！）
//
const print = @import("std").debug.print;

const WeirdContainer = struct {
    data: [*]const u8,
    length: usize,
};

pub fn main() void {
    // WeirdContainer 是一种不太方便的字符串存储方式。
    //
    // 由于它是没有哨兵终止的多项目指针，'data' 字段会“丢失”字符串字面量
    // "Weird Data!" 的长度信息和哨兵终止信息。
    //
    // 幸运的是，'length' 字段让我们仍然可以使用这个值。
    const foo = WeirdContainer{
        .data = "Weird Data!",
        .length = 11,
    };

    // 如何从 'foo' 得到可打印的值？一种方法是把它转换成长度已知的类型。
    // 我们确实有长度……这个问题你以前已经解决过！
    //
    // 给你一个大提示：还记得如何取得切片吗？
    const printable = ???;

    print("{s}\n", .{printable});
}
