package jelly

import gl "vendor:OpenGL"
import SDL "vendor:sdl2"

GameContext :: struct {
    render: RenderState,
}

ctx: ^GameContext

init :: proc(
    title: string,
    width, height: i32,
    clear_color: u32 = 0x000000,
) -> ^GameContext {
    ctx = new(GameContext, context.allocator)
    ctx.render = RenderState {
        window      = render_init_window(title, width, height),
        width       = width,
        height      = height,
        clear_color = clear_color,
    }

    render: ^RenderState = &ctx.render
    render_init_quad(&render.vao_quad, &render.vbo_quad, &render.ebo_quad)
    render_init_shaders(render)
    render_init_color_texture(&render.texture_color)

    return ctx
}

run :: proc(update: proc(ctx: ^GameContext), draw: proc(ctx: ^GameContext)) {
    loop: for {
        event: SDL.Event
        for SDL.PollEvent(&event) {
            #partial switch event.type {
            case .KEYDOWN:
                #partial switch event.key.keysym.sym {
                case .ESCAPE:
                    break loop
                }
            case .QUIT:
                break loop
            }
        }

        assert(update != nil, "Update function is nil")
        update(ctx)

        assert(draw != nil, "Draw function is nil")
        render_begin()
        draw(ctx)
        render_end()
    }
}

shutdown :: proc() {
    SDL.GL_DeleteContext(SDL.GL_GetCurrentContext())
    SDL.DestroyWindow(ctx.render.window)
    SDL.Quit()

    free(ctx)
}
