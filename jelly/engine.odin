package jelly

import "core:fmt"

import gl "vendor:OpenGL"
import SDL "vendor:sdl2"

GameContext :: struct {
    config: Config,
    render: RenderState,
    input:  InputState,
    time:   TimeState,
}

ctx: ^GameContext

init :: proc(
    title: string,
    width, height: i32,
    clear_color: u32 = 0x000000,
    target_fps: u32 = 60,
) -> ^GameContext {
    fmt.println("\033[34mJelly Engine v0.1\033[0m")

    ctx = new(GameContext, context.allocator)
    ctx.render = RenderState {
        window      = render_init_window(title, width, height),
        width       = width,
        height      = height,
        clear_color = clear_color,
    }

    render_init()
    config_init()
    time_init(target_fps)

    return ctx
}

run :: proc(
    update: proc(ctx: ^GameContext, delta: f32),
    draw: proc(ctx: ^GameContext),
) {
    loop: for {
        time_update()

        event: SDL.Event
        for SDL.PollEvent(&event) {
            #partial switch event.type {
            case .QUIT:
                break loop
            }
        }

        input_update()

        assert(update != nil, "Update function is nil")
        update(ctx, ctx.time.delta)

        assert(draw != nil, "Draw function is nil")
        render_begin()
        render_quad(
            vec2(f32(ctx.render.width) * 0.5, f32(ctx.render.height) * 0.5),
            vec2(100, 100),
            0xf38ba8,
        )
        draw(ctx)
        render_end()

        time_update_late()
    }
}

shutdown :: proc() {
    SDL.GL_DeleteContext(SDL.GL_GetCurrentContext())
    SDL.DestroyWindow(ctx.render.window)
    SDL.Quit()

    free(ctx)
}
