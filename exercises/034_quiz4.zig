//
// 测验时间。看看你能否让这个程序正常运行！
//
// 可以用任意方法解决，只要输出结果为：
//
//     my_num=42
//
const std = @import("std");

const NumError = error{IllegalNumber};

pub fn main(init: std.process.Init) !void {
    const io = init.io;
    var stdout_writer = std.Io.File.stdout().writer(io, &.{});
    const stdout = &stdout_writer.interface;

    const my_num: u32 = getNumber();

    try stdout.print("my_num={}\n", .{my_num});
}

// 这个函数显然很奇怪，也无法正常工作。但本次测验不需要修改它。
fn getNumber() NumError!u32 {
    if (false) return NumError.IllegalNumber;
    return 42;
}
