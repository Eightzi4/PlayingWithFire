package main

import "core:mem"

USE_TRACKING_ALLOCATOR :: ODIN_OPTIMIZATION_MODE == .Minimal
when USE_TRACKING_ALLOCATOR do tracking_allocator: mem.Tracking_Allocator