package jelly

import "core:bufio"
import "core:fmt"
import "core:mem"
import "core:os"

io_read_file :: proc(path: string) -> ([]byte, bool) {
    data, ok := os.read_entire_file(path, context.temp_allocator)
    if !ok {
        return nil, false
    }

    defer delete(data, context.temp_allocator)

    return data, true
}

io_write_file :: proc(path: string, data: string) -> bool {
    bytes := transmute([]byte)(data)
    ok := os.write_entire_file(path, bytes)
    if !ok {
        return false
    }

    return true
}
