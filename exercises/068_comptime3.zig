//
// 也可以将 'comptime' 放在函数参数前，要求传给函数的参数
// 必须在编译时已知。其实我们一直在使用这样的函数：std.debug.print()：
//
//     fn print(comptime fmt: []const u8, args: anytype) void
//
// 注意，格式字符串参数 'fmt' 标记为 'comptime'。这样做的一个好处是，
// 格式字符串可以在编译时检查错误，而不是等到运行时才崩溃。
//
//（实际格式化由 std.Io.Writer.print() 完成，其中包含一个完全在编译时
// 运行的完整格式字符串解析器！）
//
const print = @import("std").debug.print;

// 这个结构体是模型船的模型。我们可以按任意比例缩放：1:2 是实物的一半，
// 1:32 是实物的三十二分之一，以此类推。
const Schooner = struct {
    name: []const u8,
    scale: u32 = 1,
    hull_length: u32 = 143,
    bowsprit_length: u32 = 34,
    mainmast_height: u32 = 95,

    fn scaleMe(self: *Schooner, comptime scale: u32) void {
        comptime var my_scale = scale;

        // 这里做了件很巧妙的事：我们预先考虑到有人可能会误设比例为 1:0。
        // 我们没有让它在运行时导致除零错误，而是将其变成编译错误。
        //
        // 大多数时候，这可能是正确的做法。但我们的模型船程序很随意，
        // 我们只想让它“按我的意思来”并继续运行。
        //
        // 请修改这里，让比例为 0 时改为设成 1。
        if (my_scale == 0) @compileError("Scale 1:0 is not valid!");

        self.scale = my_scale;
        self.hull_length /= my_scale;
        self.bowsprit_length /= my_scale;
        self.mainmast_height /= my_scale;
    }

    fn printMe(self: Schooner) void {
        print("{s} (1:{}, {} x {})\n", .{
            self.name,
            self.scale,
            self.hull_length,
            self.mainmast_height,
        });
    }
};

pub fn main() void {
    var whale = Schooner{ .name = "Whale" };
    var shark = Schooner{ .name = "Shark" };
    var minnow = Schooner{ .name = "Minnow" };

    // 嘿，我们不能直接把这个运行时变量作为参数传给 scaleMe() 方法。
    // 怎样才能做到这一点？
    var scale: u32 = undefined;

    scale = 32; // 1:32 scale

    minnow.scaleMe(scale);
    minnow.printMe();

    scale -= 16; // 1:16 scale

    shark.scaleMe(scale);
    shark.printMe();

    scale -= 16; // 1:0 scale (oops, but DON'T FIX THIS!)

    whale.scaleMe(scale);
    whale.printMe();
}
//
// 深入探索：
//
// 如果你真的尝试按 1:0 的比例制作模型，会发生什么？
//
//    A) 你已经完成了！
//    B) 你会遭受精神上的除零错误。
//    C) 你会制造一个奇点并摧毁整个星球。
//
// 那么按 0:1 的比例制作模型又会怎样？
//
//    A) 你已经完成了！
//    B) 你会把虚无仔细布置成原始虚无的样子，只是无限大。
//    C) 你会制造一个奇点并摧毁整个星球。
//
// 答案就在 Ziglings 包装的背面。
