package jelly

import "base:intrinsics"
import "core:math"

Vec2 :: struct {
    x, y: f32,
}

Vec3 :: struct {
    x, y, z: f32,
}

Vec4 :: struct {
    x, y, z, w: f32,
}

vec2 :: proc(x, y: f32) -> Vec2 {
    return Vec2{x, y}
}

vec_2_zero :: proc() -> Vec2 {
    return Vec2{0, 0}
}

vec_2_one :: proc() -> Vec2 {
    return Vec2{1, 1}
}

vec3 :: proc(x, y, z: f32) -> Vec3 {
    return Vec3{x, y, z}
}

vec_3_zero :: proc() -> Vec3 {
    return Vec3{0, 0, 0}
}

vec_3_one :: proc() -> Vec3 {
    return Vec3{1, 1, 1}
}

vec4 :: proc(x, y, z, w: f32) -> Vec4 {
    return Vec4{x, y, z, w}
}

vec_4_zero :: proc() -> Vec4 {
    return Vec4{0, 0, 0, 0}
}

vec_4_one :: proc() -> Vec4 {
    return Vec4{1, 1, 1, 1}
}

vec2_add :: proc(a, b: Vec2) -> Vec2 {
    return Vec2{a.x + b.x, a.y + b.y}
}

vec3_add :: proc(a, b: Vec3) -> Vec3 {
    return Vec3{a.x + b.x, a.y + b.y, a.z + b.z}
}

vec4_add :: proc(a, b: Vec4) -> Vec4 {
    return Vec4{a.x + b.x, a.y + b.y, a.z + b.z, a.w + b.w}
}

vec2_sub :: proc(a, b: Vec2) -> Vec2 {
    return Vec2{a.x - b.x, a.y - b.y}
}

vec3_sub :: proc(a, b: Vec3) -> Vec3 {
    return Vec3{a.x - b.x, a.y - b.y, a.z - b.z}
}

vec4_sub :: proc(a, b: Vec4) -> Vec4 {
    return Vec4{a.x - b.x, a.y - b.y, a.z - b.z, a.w - b.w}
}

vec2_mul :: proc(a: Vec2, b: f32) -> Vec2 {
    return Vec2{a.x * b, a.y * b}
}

vec3_mul :: proc(a: Vec3, b: f32) -> Vec3 {
    return Vec3{a.x * b, a.y * b, a.z * b}
}

vec4_mul :: proc(a: Vec4, b: f32) -> Vec4 {
    return Vec4{a.x * b, a.y * b, a.z * b, a.w * b}
}

vec2_div :: proc(a: Vec2, b: f32) -> Vec2 {
    return Vec2{a.x / b, a.y / b}
}

vec3_div :: proc(a: Vec3, b: f32) -> Vec3 {
    return Vec3{a.x / b, a.y / b, a.z / b}
}

vec4_div :: proc(a: Vec4, b: f32) -> Vec4 {
    return Vec4{a.x / b, a.y / b, a.z / b, a.w / b}
}

vec2_dot :: proc(a, b: Vec2) -> f32 {
    return a.x * b.x + a.y * b.y
}

vec3_dot :: proc(a, b: Vec3) -> f32 {
    return a.x * b.x + a.y * b.y + a.z * b.z
}

vec4_dot :: proc(a, b: Vec4) -> f32 {
    return a.x * b.x + a.y * b.y + a.z * b.z + a.w * b.w
}

vec2_cross :: proc(a, b: Vec2) -> f32 {
    return a.x * b.y - a.y * b.x
}

vec3_cross :: proc(a, b: Vec3) -> Vec3 {
    return Vec3 {
        a.y * b.z - a.z * b.y,
        a.z * b.x - a.x * b.z,
        a.x * b.y - a.y * b.x,
    }
}

vec4_cross :: proc(a, b: Vec4) -> Vec4 {
    return Vec4 {
        a.y * b.z - a.z * b.y,
        a.z * b.x - a.x * b.z,
        a.x * b.y - a.y * b.x,
        0,
    }
}

vec2_length :: proc(a: Vec2) -> f32 {
    return math.sqrt(a.x * a.x + a.y * a.y)
}

vec3_length :: proc(a: Vec3) -> f32 {
    return math.sqrt(a.x * a.x + a.y * a.y + a.z * a.z)
}

vec4_length :: proc(a: Vec4) -> f32 {
    return math.sqrt(a.x * a.x + a.y * a.y + a.z * a.z + a.w * a.w)
}

vec2_normalize :: proc(a: Vec2) -> Vec2 {
    len := vec2_length(a)
    return Vec2{a.x / len, a.y / len}
}

vec3_normalize :: proc(a: Vec3) -> Vec3 {
    len := vec3_length(a)
    return Vec3{a.x / len, a.y / len, a.z / len}
}

vec4_normalize :: proc(a: Vec4) -> Vec4 {
    len := vec4_length(a)
    return Vec4{a.x / len, a.y / len, a.z / len, a.w / len}
}
