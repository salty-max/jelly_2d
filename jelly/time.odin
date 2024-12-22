package jelly

import sdl "vendor:sdl2"

TimeState :: struct {
    delta:       f32,
    now:         f32,
    last:        f32,
    frame_last:  f32,
    frame_delay: f32,
    frame_time:  f32,
    frame_rate:  u32,
    frame_count: u32,
}

time_init :: proc(fps: u32) {
    ctx.time.frame_rate = fps
    ctx.time.frame_delay = 1000.0 / f32(fps)
}

time_update :: proc() {
    ctx.time.now = f32(sdl.GetTicks())
    ctx.time.delta = (ctx.time.now - ctx.time.last) / 1000.0
    ctx.time.last = ctx.time.now
    ctx.time.frame_time += 1

    if ctx.time.now - ctx.time.frame_last >= 1000 {
        ctx.time.frame_rate = ctx.time.frame_count
        ctx.time.frame_count = 0
        ctx.time.frame_last = ctx.time.now
    }
}

time_update_late :: proc() {
    ctx.time.frame_time = f32(sdl.GetTicks()) - ctx.time.now

    if ctx.time.frame_delay > ctx.time.frame_time {
        sdl.Delay(u32(ctx.time.frame_delay - ctx.time.frame_time))
    }
}
