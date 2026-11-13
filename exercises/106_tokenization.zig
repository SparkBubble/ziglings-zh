//
// 标准库功能在 Zig 中越来越重要。首先，了解各个函数的实现方式很有帮助，
// 因为它们可以很好地作为自定义函数的范例。此外，这些标准函数也是 Zig 基础环境的一部分。
//
// 也就是说，它们在每个系统上都可用。因此值得在 Ziglings 中学习它们，
// 这是掌握重要技能的好方法。例如，我们经常需要处理文件中的大量数据。
// 对于这种顺序读取和处理，Zig 提供了一些实用函数，我们会在后续练习中仔细了解。
//
// Zig 官网发布了一个很好的例子，取代了有些老套的 'Hello world!'。
//
// 我们并非不喜欢 'Hello world!'，只是它无法充分展现 Zig 的优雅。
// 如果有人初次浏览官网时没能因此着迷，就太可惜了。这个例子更合适，
// 因此我们用它来引入分词，因为它非常适合说明基本原理。
//
// 后续练习还会读取并处理大型文件中的数据，到时你会更清楚这些功能有多实用。
//
// 先分析 Zig 官网的示例，并解释其中最重要的部分。
//
//    const std = @import("std");
//
//    // 这里定义了一个标准库函数，用于将字符串中的数字转换为相应的整数值。
//    const parseInt = std.fmt.parseInt;
//
//    // 定义测试用例
//    test "parse integers" {
//
//        // 字符串中传入了四个数字。
//        // 注意，各个值之间用空格或逗号分隔。
//        const input = "123 67 89,99";
//
//        // 处理输入值需要内存，因此这里定义了一个分配器。
//        const gpa = std.testing.allocator;
//
//        // 初始化一个用于存放数字的数组。
//        var list: std.ArrayList(u32) = .empty;
//
//        // 这样就不会忘记必须进行的清理，编译器也不会抱怨。
//        defer list.deinit(gpa);
//
//        // 接下来是关键部分：调用标准分词器（Zig 提供了多个），
//        // 查找各个分隔符（还记得吗，是空格和逗号）的位置，并将结果交给迭代器。
//        var it = std.mem.tokenizeAny(u8, input, " ,");
//
//        // 现在可以在循环中处理迭代器，并逐个取出数字。
//        while (it.next()) |num| {
//            // 但要注意：这些数字目前仍是字符串。
//            // 此时整数解析器就派上用场了，它会将字符串转换为真正的整数值。
//            const n = try parseInt(u32, num, 10);
//
//            // 最后，将各个值存入数组。
//            try list.append(gpa, n);
//        }
//
//        // 为了进行后续测试，创建第二个静态数组，并直接填入预期值。
//        const expected = [_]u32{ 123, 67, 89, 99 };
//
//        // 现在可以将从字符串转换出的数字与预期值比较，
//        // 从而成功完成测试。
//        for (expected, list.items) |exp, actual| {
//            try std.testing.expectEqual(exp, actual);
//        }
//    }
//
// 官网示例就介绍到这里。我们再总结一下基本步骤：
//
// - 有一组按顺序排列的数据，各项之间由不同字符分隔。
//
// - 为了进一步处理（例如存入数组），必须读取这些数据、分隔各项，并在必要时转换为目标格式。
//
// - 需要一个足够大的缓冲区来存放数据。
//
// - 如果数据量已知，可以在编译时静态创建缓冲区；否则可以在运行时使用内存分配器动态创建。
//
// - 使用分词器按相应分隔符拆分数据，并存入预留内存中；通常还要转换为目标格式。
//
// - 现在就可以用正确格式方便地进一步处理数据。
//
// 这些步骤基本上总是相同的。数据来自文件，还是由用户通过键盘输入，并不重要。
// 区别只在细节上，因此 Zig 提供了不同的分词器。后续练习会进一步介绍。
//
// 现在我们也来编写一个小程序对数据分词，毕竟需要练习。
// 假设我们想统计这首小诗中的单词数：
//
//      My name is Ozymandias, King of Kings;
//      Look on my Works, ye Mighty, and despair!
//            by Percy Bysshe Shelley
//
//
const std = @import("std");
const print = std.debug.print;

pub fn main() !void {

    // 输入内容
    const poem =
        \\My name is Ozymandias, King of Kings;
        \\Look on my Works, ye Mighty, and despair!
    ;

    // 现在需要分词器，但这里应该使用哪个？
    var it = std.mem.tokenizeAny(u8, poem, ???);

    // 打印所有单词并统计数量
    var cnt: usize = 0;
    while (it.next()) |word| {
        cnt += 1;
        print("{s}\n", .{word});
    }

    // 打印结果
    print("This little poem has {d} words!\n", .{cnt});
}
