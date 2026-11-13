//
// 前置条件：
//    - 完成 exercise/109_files.zig，或者
//    - 创建文件 {project_root}/output/zigling.txt，内容为 `It's zigling time!`（共 18 字节）
//
// 如果写入文件后不读取它，那写文件还有什么意义呢？
// 我们来写个程序读取刚刚创建的文件。
//
// 假设你已经创建了所需文件。
//
// 好，仔细听，步骤如下：
//    - 首先打开 {project_root}/output/ 目录
//    - 然后打开该目录中的文件 `zigling.txt`
//    - 接着用字母 'A' 初始化一个字符数组并打印它
//    - 然后将文件内容读入数组
//    - 最后打印刚读出的内容
//
// 注意：为简单起见，我们不使用缓冲，逐字节读取。
// 实际应用中通常会使用缓冲区来提升性能。后续练习会讲解缓冲 I/O。

const std = @import("std");

pub fn main(init: std.process.Init) !void {
    const io = init.io;

    // 获取当前工作目录
    const cwd = std.Io.Dir.cwd();

    // 假设你完成了 109_files 练习，尝试打开 ./output
    var output_dir = try cwd.openDir(io, "output", .{});
    defer output_dir.close(io);

    // 尝试打开文件
    const file = try output_dir.openFile(io, "zigling.txt", .{});
    defer file.close(io);

    // 创建一个完全由字母 'A' 初始化的 u8 数组。
    // 数组长度需要自行选择，64 看起来不错。还记得数组重复函数吗？
    var content: ??? = ???('A');
    // 这里应该打印：`AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA`
    std.debug.print("{s}\n", .{content});

    var file_reader = file.reader(io, &.{});
    const reader = &file_reader.interface;

    // 好吧，看来威胁暴力在这里行不通。你能在这里找到读取内容的方法吗？
    // https://ziglang.org/documentation/master/std/#std.Io.Reader
    // 提示：寻找一个读入切片的方法
    const bytes_read = zig_read_the_file_or_i_will_fight_you(&content);

    // 哇，喊得太大声了。我知道你很期待 Ziglings 时间，不过稍微冷静一下。
    // 能否只打印从文件中读到的内容？
    std.debug.print("Successfully Read {d} bytes: {s}\n", .{
        bytes_read,
        content, // change this line only
    });
}
