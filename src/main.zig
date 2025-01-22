const std = @import("std");

const rl = @import("raylib");
const d = @import("definitions.zig");

const SCREEN_SIZE = d.Vector2{ .x = 950, .y = 650 };
const GUI_SIZE: i32 = 200;
const GRID_SIZE = d.Vector2{ .x = 15, .y = 13 };
const CELL_SIZE: i32 = SCREEN_SIZE.y / GRID_SIZE.y;

pub fn main() void {
    rl.initWindow(SCREEN_SIZE.x, SCREEN_SIZE.y, "Playing with Fire");
    rl.setTargetFPS(rl.getMonitorRefreshRate(rl.getCurrentMonitor()));

    while (!rl.windowShouldClose()) {
        const mouse_pos = d.Vector2{ .x = @intFromFloat(rl.getMousePosition().x), .y = @intFromFloat(rl.getMousePosition().y) };

        rl.beginDrawing();
        defer rl.endDrawing();

        rl.drawRectangle(0, 0, GUI_SIZE, SCREEN_SIZE.y, rl.Color.gray);

        for (0..GRID_SIZE.y) |y_usize| {
            const y: i32 = @intCast(y_usize);

            for (0..GRID_SIZE.x) |x_usize| {
                const x: i32 = @intCast(x_usize);

                const posX = GUI_SIZE + CELL_SIZE * x;
                const posY = CELL_SIZE * y;

                rl.drawRectangle(
                    GUI_SIZE + CELL_SIZE * x,
                    CELL_SIZE * y,
                    CELL_SIZE,
                    CELL_SIZE,
                    if (d.is_mouse_hovering_over(mouse_pos, .{ .x = posX, .y = posY }, .{ .x = CELL_SIZE, .y = CELL_SIZE })) rl.Color.yellow else rl.Color.red,
                );
            }
        }
    }

    rl.closeWindow();
}
