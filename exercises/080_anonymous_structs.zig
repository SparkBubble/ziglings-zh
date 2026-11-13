//
// 结构体类型在命名之前始终是“匿名”的：
//
//     struct {};
//
// 到目前为止，我们一直用下面这种方式给结构体类型命名：
//
//     const Foo = struct {};
//
// * @typeName(Foo) 的值是 "<文件名>.Foo"。
//
// 从函数返回结构体时，结构体也会获得一个名称：
//
//     fn Bar() type {
//         return struct {};
//     }
//
//     const MyBar = Bar();  // 保存结构体类型
//     const bar = Bar() {}; // 创建结构体实例
//
// * @typeName(Bar()) 的值是 "<文件名>.Bar()"。
// * @typeName(MyBar) 的值是 "<文件名>.Bar()"。
// * @typeName(@TypeOf(bar)) 的值是 "<文件名>.Bar()"。
//
// 也可以使用完全匿名的结构体。@typeName(struct {}) 的值是
// "<文件名>.<函数>__struct_<nnn>"。
//
const print = @import("std").debug.print;

// 这个函数通过返回匿名结构体类型来创建泛型数据结构
//（从函数返回后，它就不再是匿名类型了）。
fn Circle(comptime T: type) type {
    return struct {
        center_x: T,
        center_y: T,
        radius: T,
    };
}

pub fn main() void {
    //
    // 试着补全这两个变量初始化表达式，创建可以存储以下值的圆结构体实例：
    //
    // * circle1 应存储 i32 整数
    // * circle2 应存储 f32 浮点数
    //
    const circle1 = ??? {
        .center_x = 25,
        .center_y = 70,
        .radius = 15,
    };

    const circle2 = ??? {
        .center_x = 25.234,
        .center_y = 70.999,
        .radius = 15.714,
    };

    print("[{s}: {},{},{}] ", .{
        stripFname(@typeName(@TypeOf(circle1))),
        circle1.center_x,
        circle1.center_y,
        circle1.radius,
    });

    print("[{s}: {d:.1},{d:.1},{d:.1}]\n", .{
        stripFname(@typeName(@TypeOf(circle2))),
        circle2.center_x,
        circle2.center_y,
        circle2.radius,
    });
}

// 还记得练习 065 中类型名称的“自恋修正”吗？这里也要做同样的事：
// 使用硬编码切片返回类型名称。这只是为了让输出更漂亮。满足一下虚荣心吧，
// 程序员都很美。
fn stripFname(mytype: []const u8) []const u8 {
    return mytype[22..];
}
// 在“真正的”程序中，上面的写法会立刻引起警觉。
