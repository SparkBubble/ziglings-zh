//
// 现在来创建一个带参数的函数。下面是一个接受两个参数的例子。
// 可以看到，参数和其他类型一样声明为（"名称": "类型"）：
//
//     fn myFunction(number: u8, is_lucky: bool) void {
//         ...
//     }
//
const std = @import("std");

pub fn main() void {
    std.debug.print("Powers of two: {} {} {} {}\n", .{
        twoToThe(1),
        twoToThe(2),
        twoToThe(3),
        twoToThe(4),
    });
}

// 请为这个函数添加正确的输入参数。
// 你需要弄清楚我们期望的参数名称和类型。返回类型已经为你指定。
//
fn twoToThe(???) u32 {
    return std.math.pow(u32, 2, my_number);
    // std.math.pow(type, a, b) 接受一个数值类型和两个该类型的数
    //（或可强制转换为该类型的数），并以相同数值类型返回“a 的 b 次方”。
}
