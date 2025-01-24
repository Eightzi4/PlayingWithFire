const rl = @import("raylib");

pub const Vec2 = struct {
    x: i32,
    y: i32,

    const Self = @This();

    pub fn add(self: Self, other: Self) Self {
        var result: [2]i32 = undefined;
        for (0..2) |i| {
            result[i] = self.data[i] + other.data[i];
        }
        return .{ .data = result };
    }
};

pub fn isMouseHoveringOver(mouse_pos: Vec2, start: Vec2, size: Vec2) bool {
    return mouse_pos.x >= start.x and mouse_pos.x < start.x + size.x and mouse_pos.y >= start.y and mouse_pos.y < start.y + size.y;
}

pub fn loadImg(comptime path: []const u8) !rl.Image {
    var img = try rl.loadImage("C:/Users/samue/Desktop/Other/Programming/VScode/Zig/PlayingWithFire/assets/images/" ++ path);
    img.resizeCanvas(50, 50, 0, 0, rl.Color.white);
    return img;
}
