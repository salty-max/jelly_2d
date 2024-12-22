package jelly

import "core:fmt"
import "core:os"
import "core:strings"

import sdl "vendor:sdl2"

Config :: struct {
    keybinds: [5]sdl.Scancode,
}

CONFIG_DEFAULT :: `[controls]
left = a
right = d
up = w
down = s
escape = escape

`


tmp_buffer: [20]u8

config_get_value :: proc(config_buffer: string, key: string) -> cstring {
    line_start := strings.index(config_buffer, key)
    if line_start == -1 {
        fmt.eprintln(
            "Could not find config value: ",
            key,
            ". Try deleting config.ini and restarting.",
        )
        return cstring("")
    }

    curr := line_start + len(key)
    // Move pointer to '='
    for config_buffer[curr] != '=' {
        curr += 1
    }
    // Skip '='
    curr += 1

    // Skip whitespace
    for config_buffer[curr] == ' ' {
        curr += 1
    }

    // Copy value to buffer
    i := 0
    for config_buffer[curr] != '\n' && i < len(tmp_buffer) - 1 {
        tmp_buffer[i] = config_buffer[curr]
        i += 1
        curr += 1
    }

    // Null terminate
    tmp_buffer[i] = 0

    // Return as cstring
    return cstring(&tmp_buffer[0])
}


load_controls :: proc(config_buffer: string) {
    config_key_bind(.INPUT_KEY_LEFT, config_get_value(config_buffer, "left"))
    config_key_bind(.INPUT_KEY_RIGHT, config_get_value(config_buffer, "right"))
    config_key_bind(.INPUT_KEY_UP, config_get_value(config_buffer, "up"))
    config_key_bind(.INPUT_KEY_DOWN, config_get_value(config_buffer, "down"))
    config_key_bind(
        .INPUT_KEY_ESCAPE,
        config_get_value(config_buffer, "escape"),
    )
}

config_load :: proc() -> bool {
    file_config, ok := io_read_file("config.ini")
    if !ok {
        return false
    }

    data := string(file_config)
    load_controls(data)
    return true
}

config_init :: proc() {
    if !os.exists("config.ini") {
        fmt.println(
            "\033[33mConfig file not found, creating default config.ini\033[0m",
        )
        ok := io_write_file("config.ini", CONFIG_DEFAULT)
        if !ok {
            fmt.eprintln("Failed to create config file")
            return
        }

        fmt.println("Created default config.ini file")
    }

    if !config_load() {
        fmt.eprintln("Failed to load config file")
        return
    }

    fmt.println("\033[36mLoaded config file\033[0m")
}

config_key_bind :: proc(key: InputKey, key_name: cstring) {
    scan_code := sdl.GetScancodeFromName(key_name)
    if scan_code == sdl.SCANCODE_UNKNOWN {
        fmt.eprintln("Unknown key name: %s", key_name)
        return
    }

    ctx.config.keybinds[key] = scan_code
}
