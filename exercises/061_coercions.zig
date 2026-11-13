//
// Zig 的类型强制转换规则相当合乎逻辑，很快就能学完。
//
// 1. 类型总是可以变得_更受限制_。
//
//    var foo: u8 = 5;
//    var p1: *u8 = &foo;
//    var p2: *const u8 = p1; // 从可变转为不可变
//
// 2. 数值类型可以强制转换为_更大_的类型。
//
//    var n1: u8 = 5;
//    var n2: u16 = n1; // 整数“拓宽”
//
//    var n3: f16 = 42.0;
//    var n4: f32 = n3; // 浮点数“拓宽”
//
// 3. 指向数组的单元素指针可以强制转换为切片或多元素指针。
//
//    const arr: [3]u8 = [3]u8{5, 6, 7};
//    const s: []const u8 = &arr;  // 转为切片
//    const p: [*]const u8 = &arr; // 转为多元素指针
//
// 4. 可变的单元素指针可以强制转换为指向长度为 1 的数组的单元素指针。（有意思！）
//
//    var five: u8 = 5;
//    var a_five: *[1]u8 = &five;
//
// 5. 载荷类型和值 null 可以强制转换为可选类型。
//
//    var num: u8 = 5;
//    var maybe_num: ?u8 = num; // 载荷类型
//    maybe_num = null;         // null
//
// 6. 载荷类型和错误可以强制转换为错误联合类型。
//
//    const MyError = error{Argh};
//    var char: u8 = 'x';
//    var char_or_die: MyError!u8 = char; // 载荷类型
//    char_or_die = MyError.Argh;         // 错误
//
// 7. 'undefined' 可以强制转换为任意类型（否则它就没法用了！）
//
// 8. 编译期数值可以强制转换为兼容类型。
//
//    几乎每个练习程序都展示过这个用法；很快我们会在令人开窍的 comptime 主题中
//    进行完整、详细的讲解。
//
// 9. 带标签联合体可以强制转换为当前标签枚举。
//
// 10. 当带标签字段是只有一个值的零长度类型（例如 void）时，枚举可以转换为带标签联合体。
//
// 11. 零位类型（例如 void）可以强制转换为单元素指针。
//
// 最后三条比较冷门，欢迎在 Zig 官方语言文档中了解更多并自行编写实验。

const print = @import("std").debug.print;

pub fn main() void {
    var letter: u8 = 'A';

    const my_letter:   ???   = &letter;
    //               ^^^^^^^
    //           在这里填写你的类型。
    // 必须能从 &letter（类型为 *u8）强制转换。
    // 提示：使用强制转换规则 4 和 5。

    // 类型正确后，下面就能正常工作：
    print("Letter: {u}\n", .{my_letter.?.*[0]});
}
