//
// 哨兵值表示数据结束。假设有一串小写字母，其中大写 'S' 是
// 哨兵，用来表示序列结束：
//
//     abcdefS
//
// 如果序列中也允许大写字母，'S' 就不适合作为哨兵，因为它不能再作为
// 序列中的普通值：
//
//     abcdQRST
//          ^-- 哎呀！序列中的最后一个字母是 R！
//
// 常见的字符串结束标记是值 0。ASCII 和 Unicode 将它称为“空字符”。
//
// Zig 支持以哨兵结尾的数组、切片和指针：
//
//     const a: [4:0]u32       =  [4:0]u32{1, 2, 3, 4};
//     const b: [:0]const u32  = &[4:0]u32{1, 2, 3, 4};
//     const c: [*:0]const u32 = &[4:0]u32{1, 2, 3, 4};
//
// 数组 'a' 存储 5 个 u32 值，最后一个值为 0。不过编译器会为你处理
// 这个细节，因此可以把 'a' 当作只有 4 个元素的普通数组。
//
// 切片 'b' 只能指向以 0 结尾的数组，但除此之外与普通切片一样。
//
// 指针 'c' 和我们在练习 054 中学到的多项目指针完全一样，只是保证以 0 结尾。
// 因此，即使不知道长度，我们也能安全地找到这个多项目指针的末尾。
//（普通多项目指针做不到这一点！）
//
// 重要：哨兵值必须与它所终止的数据类型相同！
//
const print = @import("std").debug.print;
const sentinel = @import("std").meta.sentinel;

pub fn main() void {
    // 这是一个以 0 结尾的 u32 值数组：
    var nums = [_:0]u32{ 1, 2, 3, 4, 5, 6 };

    // 这是一个以 0 结尾的多项目指针：
    const ptr: [*:0]u32 = &nums;

    // 好玩的是，我们把位置 3 的值替换成哨兵值 0。这似乎有点淘气。
    nums[3] = 0;

    // 现在，一个以 0 结尾的数组和一个多项目指针引用着相同的数据：
    // 这个数字序列以哨兵值结尾，同时也包含这个值。
    //
    // 尝试遍历并打印这两者，就能看出它们的相似之处和不同之处。
    //
    //（结果是数组会完整打印，包括中间的哨兵值 0；多项目指针则会在遇到
    // 第一个哨兵值时停止。）
    printSequence(nums);
    printSequence(ptr);

    print("\n", .{});
}

// 这是通用序列打印函数。它几乎完成了，但还有几处缺失，请修正！
fn printSequence(my_seq: anytype) void {
    const my_typeinfo = @typeInfo(@TypeOf(my_seq));

    // my_typeinfo 中的 TypeInfo 是一个联合类型。我们用 switch 根据传入的
    // my_seq 类型，处理 Array 或 Pointer 字段的打印：
    switch (my_typeinfo) {
        .array => {
            print("Array:", .{});

            // 遍历 my_seq 中的元素。
            for (???) |s| {
                print("{}", .{s});
            }
        },
        .pointer => {
            // 看看这个，很酷：
            const my_sentinel = sentinel(@TypeOf(my_seq));
            print("Many-item pointer:", .{});

            // 遍历 my_seq 中的元素，直到遇到哨兵值。
            var i: usize = 0;
            while (??? != my_sentinel) {
                print("{}", .{my_seq[i]});
                i += 1;
            }
        },
        else => unreachable,
    }
    print(". ", .{});
}
