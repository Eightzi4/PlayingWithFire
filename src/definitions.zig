pub const Vector2 = struct {
    x: i32,
    y: i32,
};

pub fn Vector(comptime T: type, comptime N: usize) type {
    return struct {
        data: [N]T = undefined,
    };
}

pub fn is_mouse_hovering_over(mouse_pos: Vector2, start: Vector2, size: Vector2) bool {
    return mouse_pos.x >= start.x and mouse_pos.x < start.x + size.x and mouse_pos.y >= start.y and mouse_pos.y < start.y + size.y;
}
