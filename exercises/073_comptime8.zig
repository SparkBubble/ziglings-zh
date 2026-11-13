//
// 实际上，可以在任何表达式前加上 'comptime'，强制它在编译时运行。
//
// 执行函数：
//
//     comptime llama();
//
// 获取值：
//
//     bar = comptime baz();
//
// 执行整个代码块：
//
//     comptime {
//         bar = baz + biff();
//         llama(bar);
//     }
//
// 从代码块中获取值：
//
//     var llama = comptime bar: {
//         const baz = biff() + bonk();
//         break :bar baz;
//     }
//
const print = @import("std").debug.print;

const llama_count = 5;
const llamas = [llama_count]u32{ 5, 10, 15, 20, 25 };

pub fn main() void {
    // 我们原本想取最后一只 llama。请修正这个简单错误，让断言不再失败。
    const my_llama = getLlama(5);

    print("My llama value is {}.\n", .{my_llama});
}

fn getLlama(i: usize) u32 {
    // 我们在这个函数开头放置了 assert() 作为防护，避免出错。
    // 这里的 'comptime' 关键字意味着错误会在编译时被发现！
    //
    // 没有 'comptime' 时，代码仍然能运行，但断言会在运行时失败并触发 PANIC，
    // 体验就没那么好了。
    //
    // 遗憾的是，现在会报错，因为必须保证参数 'i' 在编译时已知。
    // 你能对上面的 'i' 参数做些什么来满足这一点？
    comptime assert(i < llama_count);

    return llamas[i];
}

// 趣闻：这个 assert() 函数与 Zig 标准库中的 std.debug.assert() 完全相同。
fn assert(ok: bool) void {
    if (!ok) unreachable;
}
//
// 额外趣闻：我不小心把本练习中所有的 'foo' 都替换成了 'llama'，对此毫不后悔！
