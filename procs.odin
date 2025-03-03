package main

import "core:math/rand"
import "core:os"
import "core:strings"
import rl "vendor:raylib"

draw_gui :: proc() {
	rl.DrawRectangle(0, 0, GUI_SIZE, SCREEN_SIZE.y, rl.GRAY)
}

draw_background :: proc(mouse_pos: Vec2) {
	for y in 0 ..< GRID_SIZE.y {
		for x in 0 ..< GRID_SIZE.x {
			posX := GUI_SIZE + CELL_SIZE * x
			posY := CELL_SIZE * y

			if is_mouse_hovering_over(mouse_pos, {posX, posY}, {CELL_SIZE, CELL_SIZE}) {
				rl.DrawRectangle(
					GUI_SIZE + CELL_SIZE * x,
					CELL_SIZE * y,
					CELL_SIZE,
					CELL_SIZE,
					rl.YELLOW,
				)

				barrel_grid[y][x] = false
			} else {
				texture: rl.Texture2D = ---

				switch {
				case barrel_grid[y][x]:
					texture = textures[.BARREL]
				case wall_grid[y][x]:
					texture = textures[.WALL]
				case:
					texture = textures[.GROUND]
				}

				rl.DrawTexture(texture, posX, posY, rl.WHITE)
			}
		}
	}
}

draw_players :: proc() {
	for player in players do rl.DrawTexture(textures[.BLUE_PLAYER if player.team_color == .BLUE else .RED_PLAYER], player.position.x, player.position.y, rl.WHITE)
}

draw_dynamites :: proc() {
	for dynamite in dynamites do rl.DrawTexture(textures[.BLUE_DYNAMITE if dynamite.team_color == .BLUE else .RED_DYNAMITE], dynamite.position.x, dynamite.position.y, rl.WHITE)
}

handle_player_input :: proc() {
	for &player in players {
		if rl.IsKeyDown(player.key_bindings.left) do player.position.x -= 1
		if rl.IsKeyDown(player.key_bindings.right) do player.position.x += 1
		if rl.IsKeyDown(player.key_bindings.up) do player.position.y -= 1
		if rl.IsKeyDown(player.key_bindings.down) do player.position.y += 1

		if rl.IsKeyPressed(player.key_bindings.throw_dynamite) do spawn_dynamite(&player)
	}
}

spawn_dynamite :: proc(player: ^Player) {
	append(&dynamites, Dynamite{position = player.position, team_color = player.team_color, timer = 500})
}

update_dynamites_timer :: proc() {
	for &dynamite, i in dynamites {
		dynamite.timer -= 1
		if dynamite.timer == 0 do remove_range(&dynamites, i, i + 1)
	}
}

// Generates random boolean
random_bool :: proc(gen := context.random_generator) -> bool {
	return rand.uint32(gen) % 2 == 0
}

// Returns true if the mouse is hovering over the given rectangle, start being it's top-left corner
is_mouse_hovering_over :: proc(mouse_pos, start, size: Vec2) -> bool {
	return(
		mouse_pos.x >= start.x &&
		mouse_pos.x < start.x + size.x &&
		mouse_pos.y >= start.y &&
		mouse_pos.y < start.y + size.y \
	)

}

// Generates a wall grid
generate_wall_grid :: proc() {
	for y in 0 ..< GRID_SIZE.y {
		for x in 0 ..< GRID_SIZE.x {
			wall_grid[y][x] =
				(y % (GRID_SIZE.y - 1) == 0 ||
					x % (GRID_SIZE.x - 1) == 0 ||
					(x % 2 == 0 && y % 2 == 0))
		}
	}
}

// Randomly place barrels on the grid, avoiding walls and player spawns
// TODO: Only avoid occupied player spawns
generate_barrel_grid :: proc() {
	for y in 0 ..< GRID_SIZE.y {
		for x in 0 ..< GRID_SIZE.x {
			top := y
			bottom := GRID_SIZE.y - y - 1
			left := x
			right := GRID_SIZE.x - x - 1

			is_player_spawn :=
				(min(left, right) < 4 &&
					min(top, bottom) < 4 &&
					min(left, right) + min(top, bottom) < 5)

			if is_player_spawn do continue

			barrel_grid[y][x] = !wall_grid[y][x] && (random_bool() || random_bool())
		}
	}
}


load_textures :: proc() {
	for &texture, i in textures {
		path_to_texture := strings.concatenate([]string{textures_path, texture_asset_names[i]})
		defer delete(path_to_texture)
		image := rl.LoadImage(strings.unsafe_string_to_cstring(path_to_texture))

		rl.ImageResizeCanvas(&image, 50, 50, 0, 0, rl.WHITE)

		texture = rl.LoadTextureFromImage(image)
	}
}

unload_textures :: proc() {
	for texture in textures do rl.UnloadTexture(texture)
}
