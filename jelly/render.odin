package jelly

import "core:fmt"
import "core:os"

import gl "vendor:OpenGL"
import SDL "vendor:sdl2"

RenderState :: struct {
    window:                                                      ^SDL.Window,
    width, height:                                               i32,
    vao_quad, vbo_quad, ebo_quad, shader_default, texture_color: u32,
    projection:                                                  Mat4,
    clear_color:                                                 u32,
}

render_begin :: proc() {
    clear_color := hex_to_gl(ctx.render.clear_color)
    gl.ClearColor(clear_color.x, clear_color.y, clear_color.z, clear_color.w)
    gl.Clear(gl.COLOR_BUFFER_BIT)
}

render_end :: proc() {
    SDL.GL_SwapWindow(ctx.render.window)
}

render_quad :: proc(position, size: Vec2, color: u32) {
    render: ^RenderState = &ctx.render
    gl.UseProgram(render.shader_default)

    model := mat4_idendity()
    mat4_translate_3d(&model, vec3(position.x, position.y, 0))
    mat4_scale_aniso(&model, vec3(size.x, size.y, 1))

    u_model_loc := gl.GetUniformLocation(render.shader_default, "u_model")
    assert(u_model_loc != -1, "Failed to get u_model location")

    gl.UniformMatrix4fv(u_model_loc, 1, gl.FALSE, &model[0][0])

    color_arr := hex_to_gl_array(color)
    u_color_loc := gl.GetUniformLocation(render.shader_default, "u_color")
    assert(u_color_loc != -1, "Failed to get u_color location")

    gl.Uniform4fv(u_color_loc, 1, &color_arr[0])

    gl.BindVertexArray(render.vao_quad)
    gl.BindTexture(gl.TEXTURE_2D, render.texture_color)
    gl.DrawElements(gl.TRIANGLES, 6, gl.UNSIGNED_INT, nil)

    gl.BindVertexArray(0)
}

render_init_window :: proc(title: string, width, height: i32) -> ^SDL.Window {
    if (SDL.Init(SDL.INIT_VIDEO) < 0) {
        fmt.eprintln("Could not initialize SDL: %s\n", SDL.GetError())
        os.exit(1)
    }

    window := SDL.CreateWindow(
        cstring(raw_data(title)),
        SDL.WINDOWPOS_CENTERED,
        SDL.WINDOWPOS_CENTERED,
        width,
        height,
        SDL.WINDOW_OPENGL,
    )
    if window == nil {
        fmt.eprintln("Could not create window: %s\n", SDL.GetError())
        os.exit(1)
    }

    gl_context := SDL.GL_CreateContext(window)
    if gl_context == nil {
        fmt.eprintln("Could not create OpenGL context: %s\n", SDL.GetError())
    }

    SDL.GL_MakeCurrent(window, gl_context)
    gl.load_up_to(3, 3, SDL.gl_set_proc_address)

    fmt.println("OpenGL loaded successfully")
    fmt.println("OpenGL Version: ", gl.GetString(gl.VERSION))
    fmt.println("OpenGL Renderer: ", gl.GetString(gl.RENDERER))
    fmt.println("OpenGL Vendor: ", gl.GetString(gl.VENDOR))

    return window
}

render_init_quad :: proc(vao, vbo, ebo: ^u32) {
    vertices := [20]f32 {
        // positions      // uvs
        0.5,
        0.5,
        0.0,
        0.0,
        0.0, // top right
        0.5,
        -0.5,
        0.0,
        0.0,
        1.0, // bottom right
        -0.5,
        -0.5,
        0.0,
        1.0,
        1.0, // bottom left
        -0.5,
        0.5,
        0.0,
        1.0,
        0.0, // top left
    }

    indices := [6]u32 {
        0,
        1,
        3, // first triangle
        1,
        2,
        3, // second triangle
    }

    gl.GenVertexArrays(1, vao)
    gl.GenBuffers(1, vbo)
    gl.GenBuffers(1, ebo)

    gl.BindVertexArray(vao^)

    gl.BindBuffer(gl.ARRAY_BUFFER, vbo^)
    gl.BufferData(
        gl.ARRAY_BUFFER,
        len(vertices) * size_of(f32),
        &vertices,
        gl.STATIC_DRAW,
    )

    gl.BindBuffer(gl.ELEMENT_ARRAY_BUFFER, ebo^)
    gl.BufferData(
        gl.ELEMENT_ARRAY_BUFFER,
        len(indices) * size_of(u32),
        &indices,
        gl.STATIC_DRAW,
    )

    // position attribute
    gl.VertexAttribPointer(
        0,
        3,
        gl.FLOAT,
        gl.FALSE,
        5 * size_of(f32),
        cast(uintptr)(0),
    )
    gl.EnableVertexAttribArray(0)

    // texture attribute
    gl.VertexAttribPointer(
        1,
        2,
        gl.FLOAT,
        gl.FALSE,
        5 * size_of(f32),
        3 * size_of(f32),
    )
    gl.EnableVertexAttribArray(1)

    gl.BindVertexArray(0)
}

render_init_shaders :: proc(state: ^RenderState) {
    state.shader_default = render_shader_create(
        "shaders/default.vert.glsl",
        "shaders/default.frag.glsl",
    )
    state.projection = mat4_ortho(
        0,
        f32(state.width),
        0,
        f32(state.height),
        -2,
        2,
    )

    gl.UseProgram(state.shader_default)

    u_projection_loc := gl.GetUniformLocation(
        state.shader_default,
        "u_projection",
    )
    assert(u_projection_loc != -1, "Failed to get u_projection location")

    gl.UniformMatrix4fv(u_projection_loc, 1, false, &state.projection[0][0])
}

render_init_color_texture :: proc(texture: ^u32) {
    gl.GenTextures(1, texture)
    gl.BindTexture(gl.TEXTURE_2D, texture^)

    color := [4]u8{255, 255, 255, 255}

    gl.TexImage2D(
        gl.TEXTURE_2D,
        0,
        gl.RGBA,
        1,
        1,
        0,
        gl.RGBA,
        gl.UNSIGNED_BYTE,
        &color[0],
    )
    gl.BindTexture(gl.TEXTURE_2D, 0)
}

render_shader_create :: proc(vert_path, frag_path: string) -> u32 {
    success: i32
    log: u8

    vert_data := io_read_file(vert_path)
    frag_data := io_read_file(frag_path)

    vert_src := cstring(raw_data(vert_data))
    frag_src := cstring(raw_data(frag_data))

    vert_shader := gl.CreateShader(gl.VERTEX_SHADER)
    assert(vert_shader != 0, "Failed to create vertex shader")
    defer gl.DeleteShader(vert_shader)

    gl.ShaderSource(vert_shader, 1, &vert_src, nil)
    gl.CompileShader(vert_shader)
    gl.GetShaderiv(vert_shader, gl.COMPILE_STATUS, &success)

    if success == 0 {
        gl.GetShaderInfoLog(vert_shader, 512, nil, &log)
        fmt.eprintln(
            "Vertex shader compilation failed: ",
            vert_path,
            "\n",
            log,
        )
        os.exit(1)
    }

    frag_shader := gl.CreateShader(gl.FRAGMENT_SHADER)
    assert(frag_shader != 0, "Failed to create fragment shader")
    defer gl.DeleteShader(frag_shader)

    gl.ShaderSource(frag_shader, 1, &frag_src, nil)
    gl.CompileShader(frag_shader)
    gl.GetShaderiv(frag_shader, gl.COMPILE_STATUS, &success)

    if success == 0 {
        gl.GetShaderInfoLog(frag_shader, 512, nil, &log)
        fmt.eprintln(
            "Fragment shader compilation failed: ",
            frag_path,
            "\n",
            log,
        )
        os.exit(1)
    }

    program := gl.CreateProgram()
    assert(program != 0, "Failed to create shader program")

    gl.AttachShader(program, vert_shader)
    gl.AttachShader(program, frag_shader)
    gl.LinkProgram(program)
    gl.GetProgramiv(program, gl.LINK_STATUS, &success)

    if success == 0 {
        gl.GetProgramInfoLog(program, 512, nil, &log)
        fmt.eprintln(
            "Shader program linking failed: ",
            vert_path,
            " ",
            frag_path,
            "\n",
            log,
        )
        os.exit(1)
    }

    return program
}
