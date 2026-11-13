//
// 我们已经了解了 Zig 中可以使用的多种类型。大致如下：
//
//                          u8  单个元素
//                         *u8  单元素指针
//                        []u8  切片（运行时已知大小）
//                       [5]u8  含 5 个 u8 的数组
//                       [*]u8  多元素指针（零个或多个）
//                 enum {a, b}  唯一值 a 和 b 的集合
//                error {e, f}  唯一错误值 e 和 f 的集合
//      struct {y: u8, z: i32}  值 y 和 z 的组合
// union(enum) {a: u8, b: i32}  值为 u8 或 i32 的单个值
//
// 上述任意类型的值都可以赋给 "var" 或 "const"，以此通过赋值后的名称
// 允许或禁止修改（可变性）：
//
//     const a: u8 = 5; // 不可变
//       var b: u8 = 5; // 可变
//
// 上述任意类型也可以组成错误联合类型或可选类型：
//
//     var a: E!u8 = 5; // 可以是 u8，也可以是错误集合 E 中的错误
//     var b: ?u8 = 5;  // 可以是 u8，也可以是 null
//
// 了解这些之后，也许我们可以帮帮当地的一位隐士。他写了一个小 Zig 程序，
// 用来规划穿越树林的行程，但程序里有些错误。
//
// *************************************************************
// *                     关于本练习的说明                     *
// *                                                           *
// * 你不必阅读并理解程序中的每一处内容。这个例子很长，    *
// * 可以快速浏览，然后只关注真正出错的几个部分！          *
// *                                                           *
// *************************************************************
//
const print = @import("std").debug.print;

// grue 是对游戏 Zork 的致敬。
const TripError = error{ Unreachable, EatenByAGrue };

// 先来看地图上的地点。每个地点都有名称，以及隐士估算的距离或行程难度。
//
// 注意，地点声明为可变（var），因为之后需要给它们指定路径。为什么呢？
// 因为路径中包含指向地点的指针，如果现在就赋值会形成依赖循环！
const Place = struct {
    name: []const u8,
    paths: []const Path = undefined,
};

var a = Place{ .name = "Archer's Point" };
var b = Place{ .name = "Bridge" };
var c = Place{ .name = "Cottage" };
var d = Place{ .name = "Dogwood Grove" };
var e = Place{ .name = "East Pond" };
var f = Place{ .name = "Fox Pond" };

//           隐士手绘的 ASCII 地图
//  +---------------------------------------------------+
//  |         * Archer's Point                ~~~~      |
//  | ~~~                              ~~~~~~~~         |
//  |   ~~~| |~~~~~~~~~~~~      ~~~~~~~                 |
//  |         Bridge     ~~~~~~~~                       |
//  |  ^             ^                           ^      |
//  |     ^ ^                      / \                  |
//  |    ^     ^  ^       ^        |_| Cottage          |
//  |   Dogwood Grove                                   |
//  |                  ^     <boat>                     |
//  |  ^  ^  ^  ^          ~~~~~~~~~~~~~    ^   ^       |
//  |      ^             ~~ East Pond ~~~               |
//  |    ^    ^   ^       ~~~~~~~~~~~~~~                |
//  |                           ~~          ^           |
//  |           ^            ~~~ <-- short waterfall    |
//  |   ^                 ~~~~~                         |
//  |            ~~~~~~~~~~~~~~~~~                      |
//  |          ~~~~ Fox Pond ~~~~~~~    ^         ^     |
//  |      ^     ~~~~~~~~~~~~~~~           ^ ^          |
//  |                ~~~~~                              |
//  +---------------------------------------------------+
//
// 我们会根据地图上的地点数量在程序中预留内存。注意，不需要指定这个值的类型，
// 因为程序编译完成后并不会实际使用它！（暂时不理解也没关系。）
const place_count = 6;

// 现在来创建地点之间的所有路径。每条路径从一个地点通往另一个地点，并带有距离。
const Path = struct {
    from: *const Place,
    to: *const Place,
    dist: u8,
};

// 顺便说一下，如果你觉得下面的代码需要大量繁琐的手工劳动，那你没看错！
// Zig 的强大特性之一，是允许编写在编译时运行的代码来“自动生成”重复代码
//（类似其他语言中的宏），不过我们还没学到这部分！
const a_paths = [_]Path{
    Path{
        .from = &a, // from: Archer's Point
        .to = &b, //   to: Bridge
        .dist = 2,
    },
};

const b_paths = [_]Path{
    Path{
        .from = &b, // from: Bridge
        .to = &a, //   to: Archer's Point
        .dist = 2,
    },
    Path{
        .from = &b, // from: Bridge
        .to = &d, //   to: Dogwood Grove
        .dist = 1,
    },
};

const c_paths = [_]Path{
    Path{
        .from = &c, // from: Cottage
        .to = &d, //   to: Dogwood Grove
        .dist = 3,
    },
    Path{
        .from = &c, // from: Cottage
        .to = &e, //   to: East Pond
        .dist = 2,
    },
};

const d_paths = [_]Path{
    Path{
        .from = &d, // from: Dogwood Grove
        .to = &b, //   to: Bridge
        .dist = 1,
    },
    Path{
        .from = &d, // from: Dogwood Grove
        .to = &c, //   to: Cottage
        .dist = 3,
    },
    Path{
        .from = &d, // from: Dogwood Grove
        .to = &f, //   to: Fox Pond
        .dist = 7,
    },
};

const e_paths = [_]Path{
    Path{
        .from = &e, // from: East Pond
        .to = &c, //   to: Cottage
        .dist = 2,
    },
    Path{
        .from = &e, // from: East Pond
        .to = &f, //   to: Fox Pond
        .dist = 1, // (one-way down a short waterfall!)
    },
};

const f_paths = [_]Path{
    Path{
        .from = &f, // from: Fox Pond
        .to = &d, //   to: Dogwood Grove
        .dist = 7,
    },
};

// 找到穿越树林的最佳路线后，我们就把它整理成一次“行程”。行程是一系列由路径连接的地点。
// 我们用 TripItem 联合体，让地点和路径可以放在同一个数组中。
const TripItem = union(enum) {
    place: *const Place,
    path: *const Path,

    // 这个辅助函数用于正确打印两种不同类型的项目。
    fn printMe(self: TripItem) void {
        switch (self) {
            // 哎呀！隐士忘了如何在 switch 语句中捕获联合体的值。
            // 请将每个值捕获为 'p'，让打印语句正常工作！
            .place => print("{s}", .{p.name}),
            .path => print("--{}->", .{p.dist}),
        }
    }
};

// 所有神奇之处都发生在隐士的笔记本中。每条笔记记录一个已发现的地点、到达该处所走的路径，
// 以及从起点到此处的距离。如果找到更好的路径（距离更短），就更新记录。
// 这些记录也充当“待办清单”，用来跟踪接下来要探索的路径。
const NotebookEntry = struct {
    place: *const Place,
    coming_from: ?*const Place,
    via_path: ?*const Path,
    dist_to_reach: u16,
};

// +------------------------------------------------+
// |                 ~ 隐士的笔记本 ~                |
// +---+----------------+----------------+----------+
// |   |      地点      |      来源      |   距离   |
// +---+----------------+----------------+----------+
// | 0 | Archer's Point | null           |        0 |
// | 1 | Bridge         | Archer's Point |        2 | < next_entry
// | 2 | Dogwood Grove  | Bridge         |        1 |
// | 3 |                |                |          | < end_of_entries
// |                      ...                       |
// +---+----------------+----------------+----------+
//
const HermitsNotebook = struct {
    // @splat() 可以一次给数组中的多个元素赋值，而不必逐个列出。
    // 这里用它将数组初始化为一组 null 值。
    entries: [place_count]?NotebookEntry = @splat(null),

    // next_entry 用来跟踪我们在“待办清单”中的位置。
    next_entry: u8 = 0,

    // 标记笔记本中空白区域的起始位置。
    end_of_entries: u8 = 0,

    // 我们经常需要按地点查找记录。如果没有找到，就返回 null。
    fn getEntry(self: *HermitsNotebook, place: *const Place) ?*NotebookEntry {
        for (&self.entries, 0..) |*entry, i| {
            if (i >= self.end_of_entries) break;

            // 隐士就是在这里卡住了。我们需要返回一个指向 NotebookEntry 的可选指针。
            //
            // 而 "entry" 恰好相反：它是指向可选 NotebookEntry 的指针！
            //
            // 要从一种类型得到另一种类型，需要解引用 "entry"（使用 .*），
            // 从可选值中取出非 null 值（使用 .?），然后返回该值的地址。
            // if 语句展示了解引用和可选值“解包”如何配合使用。
            // 记住，使用 "&" 运算符返回地址。
            if (place == entry.*.?.place) return entry;
            // 试着让你的答案有这么长：__________；
        }
        return null;
    }

    // checkNote() 方法是这本神奇笔记本的核心。给定一条新的 NotebookEntry 结构体笔记，
    // 我们会检查是否已经有对应地点的记录。
    //
    // 如果还没有，就把这条记录连同所走路径和距离一起添加到笔记本末尾。
    //
    // 如果已经有记录，就检查这条路径是否比之前记录的“更好”（距离更短）。
    // 如果是，就用新记录覆盖旧记录。
    fn checkNote(self: *HermitsNotebook, note: NotebookEntry) void {
        const existing_entry = self.getEntry(note.place);

        if (existing_entry == null) {
            self.entries[self.end_of_entries] = note;
            self.end_of_entries += 1;
        } else if (note.dist_to_reach < existing_entry.?.dist_to_reach) {
            existing_entry.?.* = note;
        }
    }

    // 接下来的两个方法让我们可以把笔记本当作“待办清单”使用。
    fn hasNextEntry(self: *HermitsNotebook) bool {
        return self.next_entry < self.end_of_entries;
    }

    fn getNextEntry(self: *HermitsNotebook) *const NotebookEntry {
        defer self.next_entry += 1; // Increment after getting entry
        return &self.entries[self.next_entry].?;
    }

    // 搜索完地图后，我们就计算出了到每个地点的最短路径。要收集从起点到目的地的完整行程，
    // 需要从目的地的笔记记录开始，沿着 coming_from 指针反向走回起点。
    // 最终得到的 TripItem 数组会以逆序保存行程。
    //
    // 行程数组必须作为参数传入，因为我们希望由 main() 函数“拥有”数组内存。
    // 如果在此函数的栈帧（为函数“局部”数据分配的空间）中创建数组，
    // 然后返回指向它的指针或切片，你觉得会发生什么？
    //
    // 看来隐士忘了给这个函数的返回值指定某些东西。可能是什么呢？
    fn getTripTo(self: *HermitsNotebook, trip: []?TripItem, dest: *Place) void {
        // 从目的地记录开始。
        const destination_entry = self.getEntry(dest);

        // 如果从未到达指定目的地，此函数就需要返回错误。（这在我们的地图中不会发生，
        // 因为每个地点都能从其他地点到达。）
        if (destination_entry == null) {
            return TripError.Unreachable;
        }

        // 变量分别保存当前检查的记录，以及用于追踪行程项目追加位置的索引。
        var current_entry = destination_entry.?;
        var i: u8 = 0;

        // 每轮循环结束时，继续表达式都会增加索引。你看得出为什么要增加 2 吗？
        while (true) : (i += 2) {
            trip[i] = TripItem{ .place = current_entry.place };

            // 如果记录的来源为空，说明已经回到起点，可以结束了。
            if (current_entry.coming_from == null) break;

            // 否则，这条记录就有对应路径。
            trip[i + 1] = TripItem{ .path = current_entry.via_path.? };

            // 现在沿着“来源”记录继续前进。如果按地点找不到这条来源记录，
            // 程序肯定出了严重问题！（这种情况真的不该发生。你检查过 grue 吗？）
            // 注意：这里不需要修正任何内容。
            const previous_entry = self.getEntry(current_entry.coming_from.?);
            if (previous_entry == null) return TripError.EatenByAGrue;
            current_entry = previous_entry.?;
        }
    }
};

pub fn main() void {
    // 隐士在这里决定想去哪里。程序正常运行后，试试地图上的其他地点！
    const start = &a; // Archer's Point
    const destination = &f; // Fox Pond

    // 将每个 Path 数组作为切片存入对应 Place。正如上面提到的，必须延后建立这些引用，
    // 避免编译器计算每个项目的内存分配时出现依赖循环。
    a.paths = a_paths[0..];
    b.paths = b_paths[0..];
    c.paths = c_paths[0..];
    d.paths = d_paths[0..];
    e.paths = e_paths[0..];
    f.paths = f_paths[0..];

    // 现在创建笔记本实例，并添加第一条“起点”记录。注意其中的 null 值。
    // 查看上方 checkNote() 方法的注释，了解这条记录如何加入笔记本。
    var notebook = HermitsNotebook{};
    var working_note = NotebookEntry{
        .place = start,
        .coming_from = null,
        .via_path = null,
        .dist_to_reach = 0,
    };
    notebook.checkNote(working_note);

    // 持续从笔记本中获取下一条记录（第一条就是刚添加的“起点”记录），直到没有记录为止；
    // 此时所有可到达的地点都已检查完毕。
    while (notebook.hasNextEntry()) {
        const place_entry = notebook.getNextEntry();

        // 对于每条从当前地点出发的路径，创建一条新笔记（NotebookEntry），记录目的地，
        // 以及从起点到达该地点的总距离。再读一遍 checkNote() 的注释，了解其工作方式。
        for (place_entry.place.paths) |*path| {
            working_note = NotebookEntry{
                .place = path.to,
                .coming_from = place_entry.place,
                .via_path = path,
                .dist_to_reach = place_entry.dist_to_reach + path.dist,
            };
            notebook.checkNote(working_note);
        }
    }

    // 上面的循环完成后，我们就计算出了到每个可达地点的最短路径！现在需要为行程预留内存，
    // 并让隐士的笔记本从目的地开始反向填入路线。注意，这是我们第一次实际使用 destination！
    var trip: [place_count * 2]?TripItem = @splat(null);

    notebook.getTripTo(trip[0..], destination) catch |err| {
        print("Oh no! {}\n", .{err});
        return;
    };

    // 使用下面的辅助函数打印行程。
    printTrip(trip[0..]);
}

// 记住，行程由一系列交替的 TripItem 组成，包含从目的地到起点的 Place 或 Path。
// 行程数组的剩余空间会是 null，因此需要反向遍历项目并跳过 null，
// 直到到达数组最前方的目的地。
fn printTrip(trip: []?TripItem) void {
    // 我们用 @intCast() 将 usize 类型的长度转换为 u8。它和 @import() 一样是内置函数，
    // 后面的练习会详细介绍。
    var i: u8 = @intCast(trip.len);

    while (i > 0) {
        i -= 1;
        if (trip[i] == null) continue;
        trip[i].?.printMe();
    }

    print("\n", .{});
}

// 深入了解：
//
// 在计算机科学术语中，地图地点称为“节点”或“顶点”，路径称为“边”。
// 它们共同组成一个“带权有向图”。每条路径都有距离（也称“权重”），所以是“带权”；
// 每条路径都从一个地点指向另一个地点，所以是“有向”（无向图则允许沿边双向通行）。
//
// 我们把新的笔记记录追加到列表末尾，再从头开始依次探索（像“待办清单”一样），
// 因此笔记本相当于“先进先出”（FIFO）队列。
//
// 借助这个“待办”队列，我们会先检查所有较近的路径，再尝试更远的路径，
// 这就是“广度优先搜索”（BFS）。
//
// 由于会追踪“最低代价”路径，也可以说我们执行的是“最小代价搜索”。
//
// 更具体地说，隐士的笔记本最接近由 Edward F. Moore 提出的最短路径更快算法（SPFA）。
// 如果把简单的 FIFO 队列换成“优先队列”，基本上就实现了 Dijkstra 算法。
// 优先队列会按“权重”排序取出项目（在本例中，会将距离最短的路径放在队首）。
// Dijkstra 算法效率更高，因为它能更快排除较长路径。（在纸上推演一下，就能明白原因！）
