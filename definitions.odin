package main

import "core:math/rand"
import "core:strings"
import rl "vendor:raylib"

Vec2 :: [2]i32

// Returns true if the mouse is hovering over the given rectangle, start being it's top-left corner
is_mouse_hovering_over :: proc(mouse_pos, start, size: Vec2) -> bool {
    return mouse_pos.x >= start.x && mouse_pos.x < start.x + size.x && 
           mouse_pos.y >= start.y && mouse_pos.y < start.y + size.y
}

// Generates random boolean
random_bool :: proc(gen := context.random_generator) -> bool {
    return rand.uint32(gen) % 2 == 0
}

// Randomly place barrels on the grid, avoiding walls and player spawns
// TODO: Only avoid occupied player spawns
spawn_barrels :: proc() {
	for y in 0 ..< GRID_SIZE.y {
		for x in 0 ..< GRID_SIZE.x {
			barrel_grid[y][x] = !wall_grid[y][x] && (random_bool() || random_bool())
		}
	}
}

load_textures :: proc() {
	for &texture, i in textures {
		catted_strings := [2]string{ABSOLUTE_PATH_TO_ASSETS, texture_asset_names[i]}
		string_file := strings.concatenate(catted_strings[:])
		defer delete(string_file)
		cstring_file := strings.clone_to_cstring(string_file)
		defer delete(cstring_file)
		image := rl.LoadImage(cstring_file)

		rl.ImageResizeCanvas(&image, 50, 50, 0, 0, rl.WHITE)

		texture = rl.LoadTextureFromImage(image)
	}
}

unload_textures :: proc() {
	for texture in textures do rl.UnloadTexture(texture)
}