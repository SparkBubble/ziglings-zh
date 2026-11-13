//
// 我们已经在练习 030、031 和 111 中学过 switch 语句。它们也适用于 packed 容器：

const S = packed struct(u2) {
    a: bool,
    b: i1,
};

// 试着让它编译通过，但不要添加 `else` 分支！

comptime {
    const s: S = .{ .a = true, .b = -1 };
    switch (s) {
        .{ .a = true, .b = -1 } => {}, // ok!
        .{ .a = true, .b = ??? },
        .{ .a = ???, .b = 0 },
        .{ .a = ???, .b = ??? },
        => @compileError("We don't want to end up here!"),
    }
}

// 可以看到，对 packed 结构体使用 switch 相当直接。
// 但对 packed 联合体使用 switch 时会发现，它从不跟踪当前活动标签，调试模式下也一样！
// 这意味着 packed 联合体只根据位模式进行比较（同整数一样）。

const U = packed union(u2) {
    a: u2,
    b: i2,
};

// 找出并删除重复的分支！

comptime {
    const u: U = .{ .a = 3 };
    switch (u) {
        .{ .a = 3 } => {}, // ok!
        .{ .a = 2 },
        .{ .b = 1 },
        .{ .b = -1 },
        .{ .a = 0 },
        => @compileError("We don't want to end up here!"),
    }
}

// packed 联合体没有活动标签的概念，因此访问其中任意字段始终合法。
// 这有助于从不同角度无缝查看同一份数据。
//
// 试着将下面的浮点数变为负数：

// IEEE 754 binary16 浮点格式
const Float = packed union(u16) {
    value: f16,
    bits: packed struct(u16) {
        significand: u10,
        exponent: u5,
        sign: u1,
    },
};

pub fn main() void {
    // 提醒：浮点数的符号位为 1 时，数值为负！

    var number: Float = .{ .value = 2.34 };
    number.bits.??? = ???;
    if (number.value != -2.34) {
        std.debug.print("Make it negative!\n", .{});
    }
}

// packed 容器的介绍到此结束。下次需要控制单个位时，可以考虑这个强大的替代方案！
//

const std = @import("std");
