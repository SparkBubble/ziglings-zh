//
// 能在编译时将类型传给函数，可以让我们生成适用于多种类型的代码。
// 但这并不能帮我们向函数传入不同类型的值。
//
// 为此，我们有 'anytype' 占位符，它会让 Zig 在编译时推断参数的实际类型。
//
//     fn foo(thing: anytype) void { ... }
//
// 接下来可以使用 @TypeOf()、@typeInfo()、@typeName()、@hasDecl() 和
// @hasField() 等内置函数，进一步检查传入的类型。所有这些逻辑都会完全在编译时执行。
//
const print = @import("std").debug.print;

// 定义三个结构体：Duck、RubberDuck 和 Duct。注意，Duck 和 RubberDuck
// 都包含在各自命名空间（也称为“声明”）中定义的 waddle() 和 quack() 方法。

const Duck = struct {
    eggs: u8,
    loudness: u8,
    location_x: i32 = 0,
    location_y: i32 = 0,

    pub fn waddle(self: *Duck, x: i16, y: i16) void {
        self.location_x += x;
        self.location_y += y;
    }

    pub fn quack(self: Duck) void {
        if (self.loudness < 4) {
            print("\"Quack.\" ", .{});
        } else {
            print("\"QUACK!\" ", .{});
        }
    }
};

const RubberDuck = struct {
    in_bath: bool = false,
    location_x: i32 = 0,
    location_y: i32 = 0,

    pub fn waddle(self: *RubberDuck, x: i16, y: i16) void {
        self.location_x += x;
        self.location_y += y;
    }

    pub fn quack(self: RubberDuck) void {
        // 将表达式赋给 '_'，可以在忽略该值的同时安全地“使用”它。
        _ = self;
        print("\"Squeek!\" ", .{});
    }

    fn listen(self: RubberDuck, dev_talk: []const u8) void {
        // 聆听开发者讨论编程问题。
        // 默默思考问题。发出有帮助的声音。
        _ = dev_talk;
        self.quack();
    }
};

const Duct = struct {
    diameter: u32,
    length: u32,
    galvanized: bool,
    connection: ?*Duct = null,

    fn connect(self: *Duct, other: *Duct) !void {
        if (self.diameter == other.diameter) {
            self.connection = other;
        } else {
            return DuctError.UnmatchedDiameters;
        }
    }
};

const DuctError = error{UnmatchedDiameters};

pub fn main() void {
    // 这是真鸭子！
    const ducky1 = Duck{
        .eggs = 0,
        .loudness = 3,
    };

    // 这不是真鸭子，但它会 quack() 和 waddle()，所以仍然算“鸭子”。
    const ducky2 = RubberDuck{
        .in_bath = false,
    };

    // 这东西和鸭子完全不沾边。
    const ducky3 = Duct{
        .diameter = 17,
        .length = 165,
        .galvanized = true,
    };

    print("ducky1: {}, ", .{isADuck(ducky1)});
    print("ducky2: {}, ", .{isADuck(ducky2)});
    print("ducky3: {}\n", .{isADuck(ducky3)});
}

// 这个函数有一个在编译时推断类型的参数。它使用 @TypeOf() 和 @hasDecl()
// 执行鸭子类型判断（“如果它走路像鸭子，叫声也像鸭子，那它就是鸭子”），
// 以确定该类型是否是“鸭子”。
fn isADuck(possible_duck: anytype) bool {
    // 我们将使用 @hasDecl() 判断该类型是否具备作为“鸭子”所需的一切。
    //
    // 在这个例子中，如果 Foo 类型有 increment() 方法，'has_increment' 就为 true：
    //
    //     const has_increment = @hasDecl(Foo, "increment");
    //
    // 请确保 MyType 同时具有 waddle() 和 quack() 方法：
    const MyType = @TypeOf(possible_duck);
    const walks_like_duck = ???;
    const quacks_like_duck = ???;

    const is_duck = walks_like_duck and quacks_like_duck;

    if (is_duck) {
        // 我们还在这里调用 quack() 方法，以证明 Zig 允许我们对足够像鸭子的
        // 任意对象执行鸭子行为。
        //
        // 因为所有检查和推断都在编译时执行，所以仍然具有完整的类型安全：
        // 如果尝试对没有 quack() 方法的结构体（例如 Duct）调用该方法，
        // 会得到编译错误，而不是运行时崩溃或异常！
        possible_duck.quack();
    }

    return is_duck;
}
