//
// 好消息！现在我们已经掌握了足够的知识，可以理解 Zig 中“真正的”Hello World
// 程序了——它使用系统标准输出资源……而这可能会失败！
//
const std = @import("std");

// 注意，现在 main() 的定义返回 "!void"，而不只是 "void"。
// 由于没有指定错误类型，Zig 会推断错误类型。这适用于 main()，
// 但在某些情况下会让函数更难（函数指针）甚至无法使用（递归）。
//
// 更多信息请参阅：
// https://ziglang.org/documentation/master/#Inferred-Error-Sets
//
pub fn main(init: std.process.Init) !void {
    // 输入输出操作的实例；我们稍后会进一步了解。
    const io = init.io;

    // 获取标准输出的 Writer……
    var stdout_writer = std.Io.File.stdout().writer(io, &.{});
    // ……并提取它的接口，这样就能向其 print()。
    const stdout = &stdout_writer.interface;

    // 与 std.debug.print() 不同，标准输出 Writer 可能会出错。
    // 我们不在意具体是什么错误，只希望能将它作为 main() 的返回值向上传递。
    //
    // 我们刚学过一个可以完成这件事的语句。
    stdout.print("Hello world!\n", .{});
}

// 你现在可能会想：“为什么要这么做，而不用熟悉的 'std.debug.print()' 呢？”
// 需要理解的是：'std.debug.print()' 将内容输出到 stderr，
// 而使用 stdout_writer 的方式会输出到 stdout。
// 常见做法是将一个命令的输出通过管道传给其他命令；要让管道正常工作，
// 后续命令期望输入来自 stdout，而不是 stderr。
