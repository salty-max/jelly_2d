package jelly

import "core:math"

Mat4 :: [4][4]f32

mat4_idendity :: proc() -> Mat4 {
    result := Mat4{}
    result[0][0] = 1.0
    result[1][1] = 1.0
    result[2][2] = 1.0
    result[3][3] = 1.0
    return result
}

mat4_ortho :: proc(left, right, bottom, top, near, far: f32) -> Mat4 {
    result := mat4_idendity()
    result[0][0] = 2.0 / (right - left)
    result[1][1] = 2.0 / (top - bottom)
    result[2][2] = -2.0 / (far - near)
    result[3][0] = -(right + left) / (right - left)
    result[3][1] = -(top + bottom) / (top - bottom)
    result[3][2] = -(far + near) / (far - near)
    return result
}

mat4_proj :: proc(fov, aspect, near, far: f32) -> Mat4 {
    top := near * math.tan(fov / 2.0)
    right := top * aspect
    return mat4_ortho(-right, right, -top, top, near, far)
}

mat4_lookat :: proc(eye, center, up: Vec3) -> Mat4 {
    f := vec3_normalize(vec3_sub(center, eye))
    s := vec3_normalize(vec3_cross(f, vec3_normalize(up)))
    u := vec3_cross(s, f)
    result := mat4_idendity()
    result[0][0] = s.x
    result[0][1] = u.x
    result[0][2] = -f.x
    result[1][0] = s.y
    result[1][1] = u.y
    result[1][2] = -f.y
    result[2][0] = s.z
    result[2][1] = u.z
    result[2][2] = -f.z
    mat4_translate_3d(&result, vec3(-eye.x, -eye.y, -eye.z))
    return result
}

mat4_mul :: proc(a: ^Mat4, b: Mat4) {
    result := Mat4{}
    for i in 0 ..< 4 {
        for j in 0 ..< 4 {
            a[i][j] =
                a[0][j] * b[i][0] +
                a[1][j] * b[i][1] +
                a[2][j] * b[i][2] +
                a[3][j] * b[i][3]
        }
    }
}

mat4_translate_2d :: proc(m: ^Mat4, v: Vec2) {
    m[3][0] += v.x
    m[3][1] += v.y
}

mat4_translate_3d :: proc(m: ^Mat4, v: Vec3) {
    m[3][0] += v.x
    m[3][1] += v.y
    m[3][2] += v.z
}

mat4_translate_x :: proc(m: ^Mat4, x: f32) {
    m[3][0] += x
}

mat4_translate_y :: proc(m: ^Mat4, y: f32) {
    m[3][1] += y
}

mat4_translate_z :: proc(m: ^Mat4, z: f32) {
    m[3][2] += z
}

mat4_scale :: proc(m: ^Mat4, s: f32) {
    m[0][0] *= s
    m[1][1] *= s
    m[2][2] *= s
}

mat4_scale_x :: proc(m: ^Mat4, x: f32) {
    m[0][0] *= x
}

mat4_scale_y :: proc(m: ^Mat4, y: f32) {
    m[1][1] *= y
}

mat4_scale_z :: proc(m: ^Mat4, z: f32) {
    m[2][2] *= z
}

mat4_scale_aniso :: proc(m: ^Mat4, v: Vec3) {
    for i in 0 ..< 3 {
        m[0][i] *= v.x
        m[1][i] *= v.y
        m[2][i] *= v.z
    }
}

mat4_rotate_x :: proc(m: ^Mat4, x: f32) {
    m[1][1] = math.cos(x)
    m[1][2] = -math.sin(x)
    m[2][1] = math.sin(x)
    m[2][2] = math.cos(x)
}

mat4_rotate_y :: proc(m: ^Mat4, y: f32) {
    m[0][0] = math.cos(y)
    m[0][2] = math.sin(y)
    m[2][0] = -math.sin(y)
    m[2][2] = math.cos(y)
}

mat4_rotate_z :: proc(m: ^Mat4, z: f32) {
    m[0][0] = math.cos(z)
    m[0][1] = -math.sin(z)
    m[1][0] = math.sin(z)
    m[1][1] = math.cos(z)
}

mat4_rotate :: proc(m: ^Mat4, v: Vec3) {
    if v.x != 0.0 {
        mat4_rotate_x(m, v.x)
    }
    if v.y != 0.0 {
        mat4_rotate_y(m, v.y)
    }
    if v.z != 0.0 {
        mat4_rotate_z(m, v.z)
    }
}
