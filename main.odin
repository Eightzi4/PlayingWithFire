package main

import "core:fmt"
import "core:mem"
import rl "vendor:raylib"

main :: proc() {
	when USE_TRACKING_ALLOCATOR {
		mem.tracking_allocator_init(&tracking_allocator, context.allocator)
		context.allocator = mem.tracking_allocator(&tracking_allocator)
	}
	defer when USE_TRACKING_ALLOCATOR {
		if len(tracking_allocator.allocation_map) > 0 {
			for _, allocator_entry in tracking_allocator.allocation_map {
				fmt.printfln(
					"[!] Leaked %v bytes at %v",
					allocator_entry.size,
					allocator_entry.location,
				)
			}

			fmt.printfln(
				"[!] Total %v bytes were not freed!",
				tracking_allocator.current_memory_allocated,
			)
		} else do fmt.println("[*] All memory was freed!")
	}

	generate_wall_grid()
	generate_barrel_grid()

	rl.InitWindow(SCREEN_SIZE.x, SCREEN_SIZE.y, "🔥 Playing with Fire 🔥")
	defer rl.CloseWindow()

	rl.SetTargetFPS(rl.GetMonitorRefreshRate(rl.GetCurrentMonitor()))

	load_textures()
	defer unload_textures()

	for !rl.WindowShouldClose() {
		update_dynamites_timer()

		handle_player_input()

		rl.BeginDrawing()
		defer rl.EndDrawing()

		draw_gui()
		draw_background(Vec2{i32(rl.GetMousePosition().x), i32(rl.GetMousePosition().y)})
		draw_players()
		draw_dynamites()
	}

	delete(dynamites)
}
