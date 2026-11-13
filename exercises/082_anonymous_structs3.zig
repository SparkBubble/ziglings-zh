//
// 甚至可以创建不带字段名称的匿名结构体字面量：
//
//     .{
//         false,
//         @as(u32, 15),
//         @as(f64, 67.12)
//     }
//
// 我们称其为“元组”。在许多编程语言中，这个术语表示一种按索引顺序
// 而非名称引用字段的数据类型。为此，Zig 编译器会自动为结构体分配
// 0、1、2 等数字字段名。
//
// 由于裸数字不是合法标识符（foo.0 是语法错误），我们必须使用 @"" 语法引用它们。
// 例如：
//
//     const foo = .{ true, false };
//
//     print("{} {}\n", .{foo.@"0", foo.@"1"});
//
// 上面的例子会打印 "true false"。
//
// 嘿，等一下……
//
// 如果 print 函数需要的是 .{}，我们还需要拆开“元组”再放进另一个元组吗？
// 不需要！这是多余的！下面也会打印相同内容：
//
//     print("{} {}\n", foo);
//
// 啊哈！现在我们知道 print() 接受一个“元组”了。各种知识开始串起来了。
//
const print = @import("std").debug.print;

pub fn main() void {
    // 一个“元组”：
    const foo = .{
        true,
        false,
        @as(i32, 42),
        @as(f32, 3.141592),
    };

    // 我们将实现这个函数：
    printTuple(foo);

    // 既然可以，那就顺便玩一下：
    const nothing = .{};
    print("\n", nothing);
}

// 我们来编写自己的通用“元组”打印函数。它接受一个“元组”，并按以下格式打印每个字段：
//
//     "name"(type):value
//
// 示例：
//
//     "0"(bool):true
//
// 你需要自己把这些内容组合起来。别担心，注释中已经说明了所需的一切。
fn printTuple(tuple: anytype) void {
    // 1. 获取输入参数 'tuple' 中的字段列表。你会用到：
    //
    //     @TypeOf() - 接受一个值，并返回它的类型。
    //
    //     @typeInfo() - 接受一个类型，并返回包含该类型专属字段的 TypeInfo 联合。
    //
    //     结构体类型的字段类型列表可在 TypeInfo 的 @"struct".field_types 中找到。
    //
    //     示例：
    //
    //         @typeInfo(Circle).@"struct".field_types
    //
    // 这会是一个字段类型数组。
    const field_types = ???;

    // 这会是一个字段名称数组。
    const field_names = ???;

    // 2. 遍历每个字段。这必须在编译时完成。
    //
    //     提示：还记得 'inline' 循环吗？
    //
    for (???, ???) |???, ???| {
        // 3. 打印字段名称、类型和值。
        //
        //     你会用到这个内置函数：
        //
        //         @field(lhs: anytype, comptime field_name: []const u8)
        //
        //     第一个参数是要访问的值，第二个参数是包含目标字段名称的字符串。
        //     函数会返回该字段的值。
        //
        //     示例：
        //
        //         @field(foo, "x"); // 返回 foo.x 处的值
        //
        // 第一个字段应打印为："0"(bool):true
        //
        // 提示：注意！如果 'lhs' 是类型，@field() 会查找声明；如果它是值，则会查找数据。
        //
        print("\"{s}\"({any}):{any} ", .{
            field_name,
            field_type,
            ???,
        });
    }
}
