//
// 到目前为止，我们一直只在控制台打印输出，这足以应付打外星人和隐士记账。
//
// 不过，许多其他任务需要与文件系统交互，它是计算机上组织文件的基础结构。
//
// 文件系统通过目录提供分层存储结构。目录中可以包含文件和其他目录，
// 从而形成可遍历的树状结构。
//
// 幸运的是，Zig 标准库提供了简单的文件系统交互 API，详见：
//
// https://ziglang.org/documentation/master/std/#std.Io
//
// 本练习将尝试：
//   - 创建新目录
//   - 打开目录中的文件
//   - 向文件写入内容
//
// 注意：为简单起见，我们不使用缓冲，逐字节写入。
// 实际应用中通常会使用缓冲区来提升性能。后续练习会讲解缓冲 I/O。
//
const std = @import("std");

pub fn main(init: std.process.Init) !void {
    // 默认 I/O 实现
    const io = init.io;

    // 首先获取当前工作目录
    const cwd: std.Io.Dir = std.Io.Dir.cwd();

    // 然后尝试创建 /output/ 目录来存放输出文件。
    cwd.createDir(io, "output", .default_dir) catch |e| switch (e) {
        // 你可能会多次运行此程序，而目录可能已经创建，
        // 因此遇到这种错误时需要什么也不做。
        //
        // 我们要捕获 error.PathAlreadyExists 并忽略它
        ??? => {},
        // 如果发生其他意外错误，就将其向上传递
        else => return e,
    };

    // 接下来尝试打开刚创建的目录。
    // 等等……打开目录也可能失败！这里该怎么处理？
    var output_dir: std.Io.Dir = cwd.openDir(io, "output", .{});
    defer output_dir.close(io);

    // 尝试打开文件 `zigling.txt`，并向上传递任何错误
    const file: std.Io.File = try output_dir.createFile(io, "zigling.txt", .{});
    // 用完文件后及时关闭是个好习惯，这样其他程序才能读取它，也能避免数据损坏。
    // 但这里我们还没写完文件。
    // 要是 Zig 有个关键字能把代码“延后”到作用域末尾执行就好了……
    file.close(io);

    // 不能把这些行移到关闭文件的代码之前！
    var file_writer = file.writer(io, &.{});
    const writer = &file_writer.interface;

    const byte_written = try writer.write("It's zigling time!");
    std.debug.print("Successfully wrote {d} bytes.\n", .{byte_written});
}
// 要确认文件是否写入成功，可以：
// 1. 在文本编辑器中打开文件，或者
// 2. 使用以下命令之一在控制台打印文件内容
//    Linux/macOS:   >> cat ./output/zigling.txt
//    Windows (CMD): >> type .\output\zigling.txt
//
//
// 关于创建文件的更多内容
//
// 请注意：
// ... try output_dir.createFile(io, "zigling.txt", .{});
//                                                  ^^^
//                 我们将这个匿名结构体传给了函数调用
//
// 这是具有默认字段值的结构体 `CreateFlag`
// {
//      read: bool = false,
//      truncate: bool = true,
//      exclusive: bool = false,
//      lock: Lock = .none,
//      lock_nonblocking: bool = false,
//      mode: Mode = default_mode
// }
//
// 问题：
//   - 如果打开文件后还想读取它，应该怎么做？
//   - 查看 `std.Io.Dir` 结构体的文档：
//     https://ziglang.org/documentation/master/std/#std.Io.Dir
//       - 能找到打开文件的函数吗？删除文件的函数呢？
//       - 这些函数支持哪些选项？
