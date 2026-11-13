//
// 循环体是代码块，而代码块也是表达式。我们已经看到它们可以计算并返回值。
// 进一步来说，还可以通过添加“标签”为代码块命名：
//
//     my_label: { ... }
//
// 为代码块添加标签后，就可以用 'break' 退出该代码块。
//
//     outer_block: {           // outer block
//         while (true) {       // inner block
//             break :outer_block;
//         }
//         unreachable;
//     }
//
// 刚才我们学过，可以用 break 语句返回值。这是否意味着可以从任意带标签的代码块
// 返回值？没错！
//
//     const foo = make_five: {
//         const five = 1 + 1 + 1 + 1 + 1;
//         break :make_five five;
//     };
//
// 标签也可以用于循环。能够指定层级跳出嵌套循环，不是每天都会用到，
// 但需要时非常方便。有时，从内层循环返回值实在太好用了，几乎像作弊一样
//（而且能帮你避免创建许多临时变量）。
//
//     const bar: u8 = two_loop: while (true) {
//         while (true) {
//             break :two_loop 2;
//         }
//     } else 0;
//
// 上例中的 break 会退出标记为 "two_loop" 的外层循环，并返回值 2。
// else 分支属于外层 two_loop；如果循环在没有执行 break 的情况下结束，
// 就会计算这个分支。
//
// 最后，代码块标签也可以与 'continue' 语句一起使用：
//
//     my_while: while (true) {
//         continue :my_while;
//     }
//
const print = @import("std").debug.print;

// 如前所述，我们很快会明白为什么这两个数字不需要显式类型。继续加油！
const ingredients = 4;
const foods = 4;

const Food = struct {
    name: []const u8,
    requires: [ingredients]bool,
};

//                 辣椒  通心粉   番茄酱       奶酪
// ------------------------------------------------------
//  奶酪通心粉                  x                     x
//  辣椒通心粉        x        x
//  意面                       x          x
//  奶酪辣椒         x                              x
// ------------------------------------------------------

const menu: [foods]Food = [_]Food{
    Food{
        .name = "Mac & Cheese",
        .requires = [ingredients]bool{ false, true, false, true },
    },
    Food{
        .name = "Chili Mac",
        .requires = [ingredients]bool{ true, true, false, false },
    },
    Food{
        .name = "Pasta",
        .requires = [ingredients]bool{ false, true, true, false },
    },
    Food{
        .name = "Cheesy Chili",
        .requires = [ingredients]bool{ true, false, false, true },
    },
};

pub fn main() void {
    // 欢迎来到美国餐厅！选择你喜欢的食材，我们会为你准备美味餐点。
    //
    // 顾客须知：并非所有食材组合都能做成餐点。默认餐点是芝士通心粉。
    //
    // 开发者须知：根据数组位置硬编码食材编号，对这个小例子来说没问题，
    // 但在真实应用中简直不可原谅！
    const wanted_ingredients = [_]u8{ 0, 3 }; // Chili, Cheese

    // 检查菜单中的每种食物……
    const meal = food_loop: for (menu) |food| {

        // 接下来检查制作这道食物所需的每种食材……
        for (food.requires, 0..) |required, required_ingredient| {

            // 这不是必需食材，跳过。
            if (!required) continue;

            // 检查顾客是否选择了这种食材。
            //（记住，want_it 是食材在每种食物必需食材列表中的索引。）
            const found = for (wanted_ingredients) |want_it| {
                if (required_ingredient == want_it) break true;
            } else false;

            // 没有找到这种必需食材，所以无法制作这道食物。继续外层循环。
            if (!found) continue :food_loop;
        }

        // 如果执行到这里，说明顾客选择了制作这道食物所需的全部食材。
        //
        // 请从循环中返回这道食物。
        break;
    };
    // ^ 哎呀！如果找不到顾客所选食材对应的食物，我们忘了返回默认食物芝士通心粉。

    print("Enjoy your {s}!\n", .{meal.name});
}

// 挑战：还可以去掉内层循环中的 'found' 变量。试试看能否做到！
