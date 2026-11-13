//
// 在早期版本的 Zig 中，async/await 使用 'suspend'、'resume' 和 'async' 等
// 特殊关键字直接操作栈帧。这些关键字现在已经不存在了！
//
// Zig 0.16 用统一的 I/O 接口 std.Io 替代了它们。这个接口使用 VTable 模式
//（由函数指针组成的结构体）抽象不同的并发后端：
//
//   * Threaded  - 基于线程池的 I/O
//   * Evented   - 根据操作系统选择最佳事件循环后端：
//       * Uring    用于 Linux（io_uring）
//       * Kqueue   用于 BSD/macOS
//       * Dispatch 用于 macOS（Grand Central Dispatch）
//
// Io 结构体本身很小：
//
//     const Io = struct {
//         userdata: ?*anyopaque,   // 后端的不透明状态
//         vtable: *const VTable,   // 函数指针表
//     };
//
// 你的代码会接收一个 Io 值并调用它的方法。后端在初始化时选定，
// 你的代码不需要知道具体使用了哪个后端！
//
// 在 Zig 0.16 中，main() 接收 std.process.Init 结构体，以启用 I/O 和并发支持：
//
//     pub fn main(init: std.process.Init) !void {
//         const io = init.io;
//         // ... 使用 io ...
//     }
//
// 从简单的开始。修正 main 函数，从 init 中取出 Io 接口，然后用它获取当前时间。
//
const std = @import("std");

pub fn main(init: std.process.Init) !void {
    const io = init.???;

    // 使用 Io 接口获取当前挂钟时间。
    // 提示：Timestamp.now() 接受 Io 和 Clock 类型（.real 表示挂钟）。
    const timestamp = std.Io.Timestamp.now(io, .real);

    // 打印从 Unix 纪元起经过的秒数。
    std.debug.print("Current time: {}s since epoch\n", .{timestamp.toSeconds()});
}
