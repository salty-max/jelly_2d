package main

import gl "vendor:OpenGL"
import SDL "vendor:sdl2"

import j "jelly"

update :: proc(ctx: ^j.GameContext, delta: f32) {}

draw :: proc(ctx: ^j.GameContext) {}

main :: proc() {
    j.track_memory()

    ctx := j.init("Toto", 1920, 1080, 0x11111b)

    j.run(update, draw)

    j.shutdown()
}
