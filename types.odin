package main

import rl "vendor:raylib"

Vec2 :: [2]i32

Texture :: enum {
	GROUND,
	WALL,
	BARREL,
	BLUE_PLAYER,
	RED_PLAYER,
	BLUE_DYNAMITE,
	RED_DYNAMITE,
}

Key_Bindings :: struct {
	left, right, up, down, throw_dynamite: rl.KeyboardKey,
}

Team_Color :: enum {
	BLUE,
	RED,
	YELLOW,
	GREEN,
}

Player :: struct {
	position:     Vec2,
	key_bindings: Key_Bindings,
	team_color:   Team_Color,
}

Dynamite :: struct {
	position:   Vec2,
	team_color: Team_Color,
	timer:      int,
}
