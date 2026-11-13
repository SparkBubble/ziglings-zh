//
// 匿名结构体值字面量（不要与结构体类型混淆）使用 '.{}' 语法：
//
//     .{
//          .center_x = 15,
//          .center_y = 12,
//          .radius = 6,
//     }
//
// 这些字面量总是在编译时完整求值。上面的例子可以强制转换为上一个练习中
// “圆结构体”的 i32 变体。
//
// 或者像下面这样让它们完全保持匿名：
//
//     fn bar(foo: anytype) void {
//         print("a:{} b:{}\n", .{foo.a, foo.b});
//     }
//
//     bar(.{
//         .a = true,
//         .b = false,
//     });
//
// 上面的例子会打印 "a:true b:false"。
//
const print = @import("std").debug.print;

pub fn main() void {
    printCircle(.{
        .center_x = @as(u32, 205),
        .center_y = @as(u32, 187),
        .radius = @as(u32, 12),
    });
}

// 请补全这个函数，它会打印表示圆的匿名结构体。
fn printCircle(???) void {
    print("x:{} y:{} radius:{}\n", .{
        circle.center_x,
        circle.center_y,
        circle.radius,
    });
}
