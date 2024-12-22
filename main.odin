package main

import "core:fmt"
import "core:mem"
import "core:sync"

import gl "vendor:OpenGL"
import SDL "vendor:sdl2"

import j "jelly"

main :: proc() {
    when ODIN_DEBUG {
        track: mem.Tracking_Allocator
        mem.tracking_allocator_init(&track, context.allocator)
        context.allocator = mem.tracking_allocator(&track)

        defer {
            if len(track.allocation_map) > 0 {
                fmt.eprintf(
                    "=== %v allocations not freed: ===\n",
                    len(track.allocation_map),
                )
                for _, entry in track.allocation_map {
                    fmt.eprintf(
                        "- %v bytes @ %v\n",
                        entry.size,
                        entry.location,
                    )
                }
            }
            if len(track.bad_free_array) > 0 {
                fmt.eprintf(
                    "=== %v incorrect frees: ===\n",
                    len(track.bad_free_array),
                )
                for entry in track.bad_free_array {
                    fmt.eprintf("- %p @ %v\n", entry.memory, entry.location)
                }
            }
            mem.tracking_allocator_destroy(&track)
        }
    }

    ctx := j.init("Toto", 1920, 1080, 0x11111b)

    update :: proc(ctx: ^j.GameContext) {}

    draw :: proc(ctx: ^j.GameContext) {
        j.render_quad(
            j.vec2(f32(ctx.render.width) * 0.5, f32(ctx.render.height) * 0.5),
            j.vec2(100, 100),
            0xf38ba8,
        )
    }

    j.run(update, draw)

    j.shutdown()
}
