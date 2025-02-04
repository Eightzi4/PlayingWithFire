package main

// Imports
import "core:fmt"
import "core:mem"
import rl "vendor:raylib"

// Configuration
USE_TRACKING_ALLOCATOR :: ODIN_OPTIMIZATION_MODE == .Minimal
when USE_TRACKING_ALLOCATOR do tracking_allocator: mem.Tracking_Allocator

// Global constants
GUI_SIZE :: 200
SCREEN_SIZE :: Vec2{950, 650}
GRID_SIZE :: Vec2{15, 13}
CELL_SIZE :: SCREEN_SIZE.y / GRID_SIZE.y

wall_grid := [GRID_SIZE.y][GRID_SIZE.x]bool{}
barrel_grid := [GRID_SIZE.y][GRID_SIZE.x]bool{}
texture_asset_names := [?]string{ "ground.jpg", "wall.png", "barrel.png" };
textures := [len(texture_asset_names)]rl.Texture2D{}

@(init)
init :: proc() {
	when USE_TRACKING_ALLOCATOR {
		mem.tracking_allocator_init(&tracking_allocator, context.allocator)
		context.allocator = mem.tracking_allocator(&tracking_allocator)
	}

	for y in 0 ..< GRID_SIZE.y {
		for x in 0 ..< GRID_SIZE.x {
			wall_grid[y][x] =
				(y % (GRID_SIZE.y - 1) == 0 ||
					x % (GRID_SIZE.x - 1) == 0 ||
					(x % 2 == 0 && y % 2 == 0))
		}
	}

	rl.InitWindow(SCREEN_SIZE.x, SCREEN_SIZE.y, "🔥 Playing with Fire 🔥")
	rl.SetTargetFPS(rl.GetMonitorRefreshRate(rl.GetCurrentMonitor()))
	load_textures()
	spawn_barrels()
}

@(deferred_none = deinit)
main :: proc() {
	for !rl.WindowShouldClose() {
		mouse_pos := Vec2{i32(rl.GetMousePosition().x), i32(rl.GetMousePosition().y)}

		rl.BeginDrawing()
		defer rl.EndDrawing()
		rl.DrawRectangle(0, 0, GUI_SIZE, SCREEN_SIZE.y, rl.GRAY)

		for y in 0 ..< GRID_SIZE.y {
			for x in 0 ..< GRID_SIZE.x {
				posX := GUI_SIZE + CELL_SIZE * x
				posY := CELL_SIZE * y

				if is_mouse_hovering_over(mouse_pos, Vec2{posX, posY}, Vec2{CELL_SIZE, CELL_SIZE}) {
					rl.DrawRectangle(
						GUI_SIZE + CELL_SIZE * x,
						CELL_SIZE * y,
						CELL_SIZE,
						CELL_SIZE,
						rl.YELLOW,
					)

					barrel_grid[y][x] = false
				} else {
					texture := textures[0]

					switch {
						case barrel_grid[y][x]:
							texture = textures[2]
						case wall_grid[y][x]:
							texture = textures[1]
					}

					rl.DrawTexture(texture, posX, posY, rl.WHITE)
				}
			}
		}
	}
}

deinit :: proc() {
	unload_textures()
	rl.CloseWindow()

	when USE_TRACKING_ALLOCATOR {
		if len(tracking_allocator.allocation_map) > 0 {
			for _, i in tracking_allocator.allocation_map {
				fmt.printfln("[!] Leaked %v bytes at %v", i.size, i.location)
			}
	
			fmt.printfln("[!] Total %v bytes were not freed!", tracking_allocator.current_memory_allocated)
		} else do fmt.println("[!] All memory was freed!")
	}
}