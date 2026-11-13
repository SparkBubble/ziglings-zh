const std = @import("std");
const print = std.debug.print;

// 我们要（滥）用 Zig 的强大功能来创造动物混种！
// 你觉得鳄鱼鼠会是什么样子？呃。
//
// 还是试试鼠羊驼吧。
//
// 我们将创建一个在编译时运行的函数，并传入描述目标生物的简短代码。
// Mouse 用 "m" 表示，Llama 用 "lm" 表示。因此 MouseLlama 混种写作 "mlm"。

const Animal = enum {
    Mouse,
    Llama,
    Gator,
};

// makeCreature 接受组成混种生物的动物数量（这样我们就知道需要多大的围栏）
// 以及格式字符串，例如 MouseLlama 对应的 "mlm"。
fn makeCreature(comptime count: usize, comptime fmt: []const u8) [count]Animal {

    // 因为并非每种动物都用单个字符表示，所以我们需要在解析过程中记录状态。
    // 例如，看到 "m" 时，它代表一只新 Mouse，还是一个 Llama 的结尾？
    const State = enum {
        start, // Ready to start a new animal.
        l, // This means we've seen an "l", so if we see an "m", we know it's a Llama.
    };
    var state = State.start;

    // 我们返回一个由动物组成的数组来表示这种生物。（这就是我们需要 'count'
    // 参数的原因：数组必须有长度。）
    var animals: [count]Animal = undefined;
    var next_animal: usize = 0;

    inline for (fmt) |char| {

        // 如果需要调试变量，这里很适合添加 @compileLog() 调用……
        //（看过 main() 后再回来试试。）

        switch (state) {
            .start => switch (char) {
                // 我们看到了 Llama 的开头。
                'l' => state = .l,

                // Mouse 更小。一个 "m" 就是一整只 Mouse。
                'm' => {
                    animals[next_animal] = .Mouse;
                    next_animal += 1;
                },

                // 如果出现问题，@compileError 可以让构建立即停止。
                // 它类似 @compileLog，但会打印消息，而不是检查值。
                //
                // 你觉得遇到 Gator 时会怎样？它会和其他动物组合，还是会报错？
                'g' => ???,

                else => @compileError(std.fmt.comptimePrint("No animal starts with '{c}'!", .{char})),
            },

            .l => switch (char) {
                // 我们看到了 Llama 的结尾。
                'm' => {
                    animals[next_animal] = .Llama;
                    next_animal += 1;
                    // 这里缺少一些内容。处理完一只 Llama 后，我们需要准备好
                    // 从新动物重新_开始_……
                    ???
                },

                else => @compileError("Only llamas start with 'l'!"),
            },
        }
    }

    if (state != .start) {
        @compileError("Oh no, an incomplete llama!");
    }
    if (next_animal != count) {
        @compileError("Creature is missing an animal (format string too short).");
    }

    return animals;
}

pub fn main() void {
    // 修复上面的 ??? 后，只有把这个 makeCreature 调用移到 main 外面，
    // 才能让它在编译时运行并成功。
    //
    // 如果调用仍放在这里，Zig 会尝试在运行时创建生物，然后你会看到一个有趣的错误。
    //
    // 你可能会以为状态弄混了，但如果用 @compileLog 检查 makeCreature 中的变量，
    // 就会发现 Zig 正试图将编译时值与 "[runtime value]" 比较，这永远不会匹配。
    //
    // 你可以在 makeCreature 的两个变量前添加 "comptime" 来解决这个问题……
    const creature = makeCreature(2, "mlm");

    for (creature) |animal| {
        // @tagName 会返回一个字符串，表示当前枚举的哪个变体。
        // 这样就能直接打印动物名称，不必在这里重复列出。
        print("{s}", .{@tagName(animal)});
    }
    print(" joins the crew!", .{});
}
