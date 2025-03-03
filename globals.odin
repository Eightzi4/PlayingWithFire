package main

import "core:os"
import "core:strings"
import rl "vendor:raylib"

GUI_SIZE :: 200
SCREEN_SIZE :: Vec2{950, 650}
GRID_SIZE :: Vec2{15, 13}
CELL_SIZE :: SCREEN_SIZE.y / GRID_SIZE.y

wall_grid: [GRID_SIZE.y][GRID_SIZE.x]bool
barrel_grid: [GRID_SIZE.y][GRID_SIZE.x]bool

textures_path := strings.concatenate([]string{os.get_current_directory(), "/assets/images/"})
texture_asset_names := [?]string{"ground.jpg", "wall.png", "barrel.png", "player.png", "player2.png", "dynamite.png", "dynamite2.png"}
textures: [Texture]rl.Texture2D

players := [?]Player {
	{
		key_bindings = {
			left = rl.KeyboardKey.A,
			right = rl.KeyboardKey.D,
			up = rl.KeyboardKey.W,
			down = rl.KeyboardKey.S,
			throw_dynamite = rl.KeyboardKey.SPACE,
		},
        position = {250, 50},
        team_color = .BLUE
	},
    {
		key_bindings = {
			left = rl.KeyboardKey.LEFT,
			right = rl.KeyboardKey.RIGHT,
			up = rl.KeyboardKey.UP,
			down = rl.KeyboardKey.DOWN,
			throw_dynamite = rl.KeyboardKey.ENTER,
		},
        position = {850, 550},
        team_color = .RED
	},
}

dynamites: [dynamic]Dynamite