//
// 有好几次，我们都很想在程序中使用循环，但因为要做的事情只能在编译时完成，
// 所以没法使用循环。结果只好像普通人一样手动完成。哼！我们可是程序员！
// 这种工作就该交给计算机。
//
// 'inline for' 会在编译时执行，因此在上面那种不允许使用普通运行时
// 'for' 循环的场景中，也可以通过编程遍历一系列项目：
//
//     inline for (.{ u8, u16, u32, u64 }) |T| {
//         print("{} ", .{@typeInfo(T).int.bits});
//     }
//
// 在上面的例子中，我们遍历了一个类型列表，这些类型只能在编译时使用。
//
const print = @import("std").debug.print;

// 还记得练习 065 中用内置函数进行反射的 Narcissus 吗？他又回来了，而且乐在其中。
const Narcissus = struct {
    me: *Narcissus = undefined,
    myself: *Narcissus = undefined,
    echo: void = undefined,
};

pub fn main() void {
    print("Narcissus has room in his heart for:", .{});

    // 上次检查 Narcissus 结构体时，我们不得不手动访问三个字段。
    // 'if' 语句几乎原样重复了三次。真糟糕！
    //
    // 请使用 'inline for'，对下方对应切片中的每个字段执行这段代码
    //（这些切片长度相同）！

    const field_names = @typeInfo(Narcissus).@"struct".field_names;
    const field_types = @typeInfo(Narcissus).@"struct".field_types;

    ??? {
        if (field_type != void) {
            print(" {s}", .{field_name});
        }
    }

    // 完成后，回头看看练习 065，并将你写的代码与那里的可怕写法比较一下！

    print(".\n", .{});
}
