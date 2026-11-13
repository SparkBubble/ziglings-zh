//
// 我们通过切片指定长度，成功从多项目指针得到可打印的字符串。
//
// 但在强制转换“丢失”哨兵后，我们还能回到以哨兵结尾的指针吗？
//
// 可以。Zig 的内置函数 @ptrCast() 能做到这一点。看它的签名：
//
//     @ptrCast(value: anytype) anytype
//
// 试试看能否用它解决同一个多项目指针问题，而且不需要指定长度！
//
const print = @import("std").debug.print;

pub fn main() void {
    // 我们再次将以哨兵结尾的字符串强制转换为多项目指针，
    // 这样就没有长度或哨兵信息了。
    const data: [*]const u8 = "Weird Data!";

    // 请将 'data' 转换为 'printable'：
    const printable: [*:0]const u8 = ???;

    print("{s}\n", .{printable});
}
