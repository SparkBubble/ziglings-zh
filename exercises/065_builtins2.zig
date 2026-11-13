//
// Zig 有用于数学运算的内置函数，例如……
//
//      @sqrt        @sin           @cos
//      @exp         @log           @floor
//
// ……还有许多类型转换操作，例如……
//
//      @as          @errorFromInt  @floatFromInt
//      @ptrFromInt  @intFromPtr    @backingInt
//
// 雨天时花点时间浏览 Zig 官方文档中的完整内置函数列表，也很值得。
// 里面有一些非常酷的功能。看看 @call、@compileLog、@embedFile 和 @src！
//
//                            ...
//
// 现在我们只探索 Zig 众多内省能力中的三个，以此结束对内置函数的介绍：
//
// 1. @This() 类型
//
// 返回函数调用所在的最内层结构体、枚举或联合体。
//
// 2. @typeInfo(comptime T: type) @import("std").builtin.Type
//
// 返回数据结构中任意类型的信息；根据检查的类型不同，所含信息也不同。
//
// 3. @TypeOf(...) 类型
//
// 返回所有输入参数共有的类型（每个参数可以是任意表达式）。类型会通过“同级类型解析”确定，
// 这与编译器推断类型时使用的过程相同。
//
//（注意，返回类型的两个函数都以大写字母开头？这是 Zig 中的标准命名习惯。）
//
const print = @import("std").debug.print;

const Narcissus = struct {
    me: *Narcissus = undefined,
    myself: *Narcissus = undefined,
    echo: void = undefined, // Alas, poor Echo!

    fn FetchTheMostBeautifulType() type {
        return @This();
    }
};

pub fn main() void {
    var narcissus: Narcissus = Narcissus{};

    // 哎呀！'me' 和 'myself' 字段不能保持 undefined。请在这里设置它们：
    narcissus.me = &narcissus;
    narcissus.??? = ???;

    // 这里从三个不同引用中确定一个“同级类型”（它们恰巧都指向同一个对象）。
    const Type1 = @TypeOf(narcissus, narcissus.me.*, narcissus.myself.*);

    // 糟了，调用这个函数时似乎出错了。我们把它当作方法调用；如果它有 self 参数，
    // 这样调用就行。但它没有。（见上文。）
    //
    // 修正方法很微妙，但影响很大！
    const Type2 = narcissus.FetchTheMostBeautifulType();

    // 现在打印一句关于纳西瑟斯的精辟话语。
    print("A {s} loves all {s}es. ", .{
        maximumNarcissism(Type1),
        maximumNarcissism(Type2),
    });

    //   His final words as he was looking in
    //   those waters he habitually watched
    //   were these:
    //       "Alas, my beloved boy, in vain!"
    //   The place gave every word back in reply.
    //   He cried:
    //            "Farewell."
    //   And Echo called:
    //                   "Farewell!"
    //
    //     --Ovid, The Metamorphoses
    //       译者：Ian Johnston

    print("He has room in his heart for:", .{});

    // `field_names` 是字符串切片，保存结构体字段的名称。
    // `field_types` 是类型切片，保存结构体字段的类型，
    //               保证与 `field_names` 长度相同。
    const field_names = @typeInfo(Narcissus).@"struct".field_names;
    const field_types = @typeInfo(Narcissus).@"struct".field_types;

    // 请补全这些 'if' 语句：如果字段类型为 'void'，就不打印字段名。
    //（void 是零位类型，完全不占空间！）
    if (field_???[???] != void) {
        print(" {s}", .{field_???[???]});
    }

    if (field_???[???] != void) {
        print(" {s}", .{field_???[???]});
    }

    if (field_???[???] != void) {
        print(" {s}", .{field_???[???]});
    }

    // 啧，看看上面这些重复代码！不知道你怎么想，反正我浑身不自在。
    //
    // 唉，这里不能用普通的 'for' 循环，因为 'fields' 只能在编译时求值。
    // 看来我们早该学习 "comptime" 了，对吧？别担心，很快就会讲到。

    print(".\n", .{});
}

// 注意：这个练习最初不包含下面的函数。Zig 0.10.0 之后，`@typeName` 开始在返回的类型名前
// 加上源文件名。例如，"Narcissus" 变成了 "065_builtins2.Narcissus"。
//
// 为了解决这个问题，我们添加了这个函数来去掉类型名前的文件名。
//（它会返回从 "." 之后开始的类型名切片。）
//
// 我们会在练习 070 再次见到 @typeName。现在你可以看到，它接受一个 Type，
// 并返回一个 u8“字符串”。
fn maximumNarcissism(myType: type) []const u8 {
    const find = @import("std").mem.find;

    // 将 "065_builtins2.Narcissus" 转换为 "Narcissus"
    const name = @typeName(myType);
    return name[find(u8, name, ".").? + 1 ..];
}
