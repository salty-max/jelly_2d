package jelly

import "core:strconv"

rgb_to_gl :: proc(color: Vec4) -> Vec4 {
    return vec4(
        f32(color.x) / 255.0,
        f32(color.y) / 255.0,
        f32(color.z) / 255.0,
        f32(color.w) / 255.0,
    )
}

hex_to_rgb :: proc(hex: u32) -> Vec4 {
    r := (hex >> 16) & 0xFF
    g := (hex >> 8) & 0xFF
    b := hex & 0xFF

    // handle alpha channel
    if hex > 0xFFFFFF {
        a := (hex >> 24) & 0xFF
        return vec4(f32(r), f32(g), f32(b), f32(a))
    }

    return vec4(f32(r), f32(g), f32(b), 255.0)
}

hex_to_gl :: proc(hex: u32) -> Vec4 {
    return rgb_to_gl(hex_to_rgb(hex))
}

hex_to_gl_array :: proc(hex: u32) -> [4]f32 {
    color := hex_to_gl(hex)
    return [4]f32{color.x, color.y, color.z, color.w}
}
