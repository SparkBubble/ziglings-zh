//
// 我们已经在练习 100、101 和测验 113 中学过许多使用位运算进行位操作的知识。
// 已学的方法完全可行，但创建掩码、逐位移位很快就会变得繁琐又难处理。
// 有没有更好、更方便的方式来控制单个位呢？
//
// 幸运的是，Zig 有一个专门用于此目的的关键字：
//
//     packed
//
// 单独使用它并不会产生效果。要发挥它的作用（并让程序编译通过），
// 必须将它附加到 struct 或 union 声明上：
//
//     const Foo = packed struct { ... };
//     const Bar = packed union { ... };
//
// 那么这个关键字究竟做什么？回答这个问题前，我们先谈谈*容器布局*。
//
// 普通结构体和联合体使用 `auto` 布局；它不保证容器大小或字段顺序，这些完全由编译器决定
//（不过在同一个编译单元中，大小和字段顺序*确实*保证一致）。
//
// 在容器上添加 `packed` 关键字后，它就会使用 `packed` 布局：所有字段会紧密地*打包*在一起，
// 中间没有填充，并保证字段顺序与源代码中的声明顺序一致。对于结构体，容器大小保证等于
// 所有字段的位大小之和。对于联合体，所有字段的位大小必须完全相同（不允许填充！），
// 联合体本身也保证恰好是这个大小。
//
// 如果你熟悉 C，可能听说过另一种语境下的结构体打包：调整字段顺序以尽量减少对齐填充
//（或让编译器替你完成）。这*不是* Zig 的 `packed` 关键字的用途！
//
// 试着让下面的 comptime 断言通过：

const PackedStruct = packed struct {
    a: u2,
    b: u?,
};

comptime {
    assert(@bitSizeOf(PackedStruct) == 6);
}

const PackedUnion = packed union {
    a: bool,
    b: u?,
};

comptime {
    assert(@bitSizeOf(PackedUnion) == 1);
}

// 现在，如何运用这些新知识来操作位呢？
//
// 你可能已经猜到，`packed` 容器非常适合表示位标志，或其他紧密排列的位大小值集合，
// 这类数据常见于文件头和网络协议中。
//
// 来看一个真实例子：LZ4 压缩格式（†）定义了一种描述压缩数据的帧格式。
// 每个 LZ4 帧都有一个描述符，其中包含一个 'FLG' 字节，用于指定帧的内容：

/// |  BitNb  |  7-6  |   5   |    4     |  3   |    2     |   1    |   0  |
/// | ------- |-------|-------|----------|------|----------|--------|------|
/// |FieldName|Version|B.Indep|B.Checksum|C.Size|C.Checksum|Reserved|DictID|
///
const FLG = packed struct(u8) {
    dict_id: bool,
    reserved: u1 = 0,
    content_checksum: bool,
    content_size: bool,
    block_checksum: bool,
    block_independence: bool,
    version: u2,
};

// 等等，struct 关键字后面的 `(u8)` 是什么？整数和这些内容有什么关系？
// 正好借此机会说明一点：packed 结构体和 packed 联合体其实并不是真正的结构体或联合体……
// 它们只是伪装起来的整数！实际上，它们的字段只是底层位范围的便捷名称。
// 为了更容易满足 packed 容器的大小要求，Zig 允许像枚举一样为其指定*底层整数类型*。
//
// 对于 `FLG`，我们希望结构体恰好占一个字节，因此指定 `u8` 为底层整数类型。
// 可以安全地使用内置函数 `@bitCast` 在 packed 容器和底层整数之间转换。
// LZ4 规范还要求保留位始终为零，因此最好将 `reserved` 的默认值设为 `0`。
//
// packed 结构体的字段从底层整数的最低有效位开始，直到最高有效位结束。
// 无论目标平台采用何种字节序，都是如此。
//
// 试着解决下面的报错：

const Bits = packed struct(u4) {
    a: u1 = 0,
    b: u1 = 0,
    c: u1 = 0,
    d: u1 = 0,
};

pub fn main() void {
    {
        const expected: Bits = @bitCast(@as(u4, 0b1000));
        const my_bits: Bits = .{};
        if (my_bits != expected) complain(my_bits, expected, @src());
    }

    {
        const expected: Bits = @bitCast(@as(u4, 0b0001));
        const my_bits: Bits = .{};
        if (my_bits != expected) complain(my_bits, expected, @src());
    }

    {
        const expected: Bits = @bitCast(@as(u4, 0b0010));
        const my_bits: Bits = .{};
        if (my_bits != expected) complain(my_bits, expected, @src());
    }

    {
        const expected: Bits = @bitCast(@as(u4, 0b0011));
        const my_bits: Bits = .{};
        if (my_bits != expected) complain(my_bits, expected, @src());
    }

    {
        const expected: Bits = @bitCast(@as(u4, 0b1101));
        const my_bits: Bits = .{};
        if (my_bits != expected) complain(my_bits, expected, @src());
    }
}

// 可以看到，等值比较（`==` 和 `!=`）适用于 packed 结构体和 packed 联合体。
// 不过 packed 容器没有自然顺序，因此不能对它们使用其他比较运算符。
//
// 也可以在 `switch` 语句中使用 packed 容器，下一练习会介绍！
//
// 由于 packed 容器对内存布局做出了严格保证，因此只有少数类型可以作为其中的字段类型：
//
// - 整数
// - 浮点数
// - bool
// - void
// - 显式指定底层整数类型的枚举
// - packed 联合体
// - packed 结构体
//

const std = @import("std");
const assert = std.debug.assert;

fn complain(my_bits: Bits, expected: Bits, src_loc: std.builtin.SourceLocation) void {
    std.debug.print(
        "That's not quite right! You've got 0b{b:0>4}, but we want 0b{b:0>4} in line {d}.\n",
        .{ @as(u4, @bitCast(my_bits)), @as(u4, @bitCast(expected)), src_loc.line },
    );
}

// (†) https://github.com/lz4/lz4/blob/5c4c1fb2354133e1f3b087a341576985f8114bd5/doc/lz4_Frame_format.md#frame-descriptor
