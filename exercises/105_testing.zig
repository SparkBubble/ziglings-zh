//
// Zig 的一大优势是内置了测试系统，因此可以很好地实践测试驱动开发（TDD）。
// Zig 甚至更进一步：测试可以直接写在源文件中。
//
// 这样做有几个优点。一方面，源代码和相关测试代码放在同一个文件中更清晰；
// 另一方面，其他人只需查看源码中的测试并进行对照，就更容易理解函数的预期行为。
//
// 如果想了解 Zig 标准库等内容的工作方式，这种方法尤其有帮助。
// 此外，向 Zig 社区报告 bug 时，附上包含测试的小示例也非常实用。
//
// 因此，本练习将介绍 Zig 测试基础。测试的基本流程是：向函数传入参数并取得返回值，
// 然后与预期值比较。若两者一致，测试通过；否则会显示错误信息。
//
//          testing.expect(foo(param1, param2) == expected);
//
// 还可以进行其他比较，也可以构造偏差或错误，并检查函数是否作出适当响应，
// 从而通过测试。
//
// 可以通过 Zig 构建系统运行测试，也可以用 "zig test xyz.zig" 直接测试单个模块。
//
// 两种方式都可以通过脚本自动运行测试，例如在提交到 Git 仓库后。
// Ziglings 也广泛使用这种做法。
//
const std = @import("std");
const testing = std.testing;

// 这是一个简单函数，将传入的参数相加并返回结果。
fn add(a: f16, b: f16) f16 {
    return a + b;
}

// 相关测试总是以关键字 "test" 开始，后面跟着测试任务的描述，
// 再在花括号中写出测试用例。
test "add" {

    // 第一个测试检查 '41' 加 '1' 是否得到正确结果 '42'。
    try testing.expect(add(41, 1) == 42);

    // 也可以按以下方式执行这个测试：
    try testing.expectEqual(42, add(41, 1));

    // 这次测试加上一个负数：
    try testing.expect(add(5, -4) == 1);

    // 再测试一次浮点运算：
    try testing.expect(add(1.5, 1.5) == 3);
}

// 另一个简单函数，返回两个参数相减的结果。
fn sub(a: f16, b: f16) f16 {
    return a - b;
}

// 对应的测试与上一个差别不大，只是其中有一个需要你修正的错误。
test "sub" {
    try testing.expect(sub(10, 5) == 6);

    try testing.expect(sub(3, 1.5) == 1.5);
}

// 这个函数用分子除以分母。分母不能为零，因此函数会检查这一点，
// 若分母为零则返回错误。
fn divide(a: f16, b: f16) !f16 {
    if (b == 0) return error.DivisionByZero;
    return a / b;
}

test "divide" {
    try testing.expect((divide(2, 2) catch unreachable) == 1);
    try testing.expect((divide(-1, -1) catch unreachable) == 1);
    try testing.expect((divide(10, 2) catch unreachable) == 5);
    try testing.expect((divide(1, 3) catch unreachable) == 0.3333333333333333);

    // 现在测试分母为零时函数是否返回错误。但应该检查哪种错误？
    try testing.expectError(error.???, divide(15, 0));
}
