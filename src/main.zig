const std = @import("std");

const rl = @import("raylib");
const utl = @import("utilities.zig");

const SCREEN_SIZE = utl.Vec2{ .x = 950, .y = 650 };
const GUI_SIZE: i32 = 200;
const GRID_SIZE = utl.Vec2{ .x = 15, .y = 13 };
const CELL_SIZE: i32 = SCREEN_SIZE.y / GRID_SIZE.y;
const WALL_MAP = blk: {
    var map = [_][GRID_SIZE.x]bool{[_]bool{false} ** GRID_SIZE.x} ** GRID_SIZE.y;

    for (0..GRID_SIZE.y) |y| {
        for (0..GRID_SIZE.x) |x| {
            if (@mod(y, GRID_SIZE.y - 1) == 0 or @mod(x, GRID_SIZE.x - 1) == 0 or @mod(x, 2) == 0 and @mod(y, 2) == 0) {
                map[y][x] = true;
            }
        }
    }

    break :blk map;
};

var BARREL_MAP: [GRID_SIZE.y][GRID_SIZE.x]bool = .{.{false} ** GRID_SIZE.x} ** GRID_SIZE.y;

pub fn main() !void {
    var prng = std.Random.DefaultPrng.init(@intCast(std.time.timestamp()));
    const random = prng.random();

    for (0..GRID_SIZE.y) |y| {
        for (0..GRID_SIZE.x) |x| {
            if (!WALL_MAP[y][x] and (random.boolean() or random.boolean())) {
                BARREL_MAP[y][x] = true;
            }
        }
    }

    rl.initWindow(SCREEN_SIZE.x, SCREEN_SIZE.y, "🔥 Playing with Fire 🔥");
    rl.setTargetFPS(rl.getMonitorRefreshRate(rl.getCurrentMonitor()));

    const wall_img = try utl.loadImg("wall.png");
    defer rl.unloadImage(wall_img);
    const wall_txr = try rl.loadTextureFromImage(wall_img);
    defer rl.unloadTexture(wall_txr);

    const ground_img = try utl.loadImg("ground.jpg");
    defer rl.unloadImage(ground_img);
    const ground_txr = try rl.loadTextureFromImage(ground_img);
    defer rl.unloadTexture(ground_txr);

    const barrel_img = try utl.loadImg("barrel.png");
    defer rl.unloadImage(barrel_img);
    const barrel_txr = try rl.loadTextureFromImage(barrel_img);
    defer rl.unloadTexture(barrel_txr);

    while (!rl.windowShouldClose()) {
        const mouse_pos = utl.Vec2{ .x = @intFromFloat(rl.getMousePosition().x), .y = @intFromFloat(rl.getMousePosition().y) };

        rl.beginDrawing();
        defer rl.endDrawing();

        rl.drawRectangle(0, 0, GUI_SIZE, SCREEN_SIZE.y, rl.Color.gray);

        for (0..@intCast(GRID_SIZE.y)) |y| {
            for (0..@intCast(GRID_SIZE.x)) |x| {
                const posX = GUI_SIZE + CELL_SIZE * @as(i32, @intCast(x));
                const posY = CELL_SIZE * @as(i32, @intCast(y));

                if (utl.isMouseHoveringOver(
                    mouse_pos,
                    utl.Vec2{ .x = posX, .y = posY },
                    utl.Vec2{ .x = CELL_SIZE, .y = CELL_SIZE },
                )) {
                    rl.drawRectangle(
                        posX,
                        posY,
                        CELL_SIZE,
                        CELL_SIZE,
                        rl.Color.yellow,
                    );

                    BARREL_MAP[y][x] = false;
                } else {
                    const texture = blk: {
                        if (WALL_MAP[y][x]) {
                            break :blk wall_txr;
                        } else if (BARREL_MAP[y][x]) {
                            break :blk barrel_txr;
                        } else {
                            break :blk ground_txr;
                        }
                    };

                    rl.drawTexture(texture, posX, posY, rl.Color.white);
                }
            }
        }
    }

    rl.closeWindow();
}
