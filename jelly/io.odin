package jelly

import "core:bufio"
import "core:fmt"
import "core:mem"
import "core:os"

io_read_file :: proc(path: string) -> []byte {
    data, ok := os.read_entire_file(path, context.temp_allocator)
    if !ok {
        fmt.eprintln("Could not read file: ", path)
        os.exit(1)
    }

    defer delete(data, context.temp_allocator)

    return data
}

io_write_file :: proc(path: string, data: string) {
    bytes := transmute([]byte)(data)
    ok := os.write_entire_file(path, bytes)
    if !ok {
        fmt.eprintln("Could not write file: ", path)
        os.exit(1)
    }
}
