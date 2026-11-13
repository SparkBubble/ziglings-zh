//
// 你已经在练习 011、012、013 和 014 中学过 while 循环，
// 在练习 030 和 031 中学过 switch 表达式，也在练习 063 中见过标签的用法。
//
// 将 while 循环、switch 语句与 continue 和 break 组合起来，
// 可以构建非常简洁的状态机。
//
// 例如：
//
//      pub fn main() void {
//          var op: u8 = 1;
//          while (true) {
//              switch (op) {
//                  1 => { op = 2; continue; },
//                  2 => { op = 3; continue; },
//                  3 => return,
//                  else => {},
//              }
//              break;
//          }
//          std.debug.print("This statement cannot be reached\n", .{});
//      }
//
// 结合目前学到的内容，我们现在可以学习带标签的 switch。
//
// 带标签的 switch 是一种语法糖，还附带各种“糖果”（性能优势）。不相信？看源码：
// https://github.com/ziglang/zig/pull/21367
//
// 以下是用带标签的 switch 实现的前一个例子：
//
//      pub fn main() void {
//          foo: switch (@as(u8, 1)) {
//              1 => continue :foo 2,
//              2 => continue :foo 3,
//              3 => return,
//              else => {},
//          }
//          std.debug.print("This statement cannot be reached\n", .{});
//      }
//
// 第二个例子的执行流程如下：
//  1. switch 从值 '1' 开始；
//  2. 匹配到 case '1' 后，使用 continue 重新计算带标签的 switch，此时提供值 '2'；
//  3. case '2' 重复相同过程，不过现在要计算的值是 '3'；
//  4. 最终进入 case '3' 并直接从整个函数返回，因此不会执行调试打印语句；
//  5. 本例的输入没有明确且穷尽的模式，实际上可以是任意 u8 整数，
//     因此需要用 'else => {}' 分支处理所有未显式匹配的情况。
//
//
const std = @import("std");

const PullRequestState = enum(u8) {
    Draft,
    InReview,
    Approved,
    Rejected,
    Merged,
};

pub fn main() void {
    // 糟了，你的拉取请求一直被拒绝，该怎么修复？
    pr: switch (PullRequestState.Draft) {
        PullRequestState.Draft => continue :pr PullRequestState.InReview,
        PullRequestState.InReview => continue :pr PullRequestState.Rejected,
        PullRequestState.Approved => continue :pr PullRequestState.Merged,
        PullRequestState.Rejected => {
            std.debug.print("The pull request has been rejected.\n", .{});
            return;
        },
        PullRequestState.Merged => break, // Would you know where to break to?
    }
    std.debug.print("The pull request has been merged.\n", .{});
}
