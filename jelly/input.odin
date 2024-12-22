package jelly

import sdl "vendor:sdl2"

InputKey :: enum {
    INPUT_KEY_LEFT,
    INPUT_KEY_RIGHT,
    INPUT_KEY_UP,
    INPUT_KEY_DOWN,
    INPUT_KEY_ESCAPE,
}

KeyState :: enum {
    KS_UNPRESSED,
    KS_PRESSED,
    KS_HELD,
}

InputState :: struct {
    keys: [5]KeyState,
}

update_key_state :: proc(current_state: u8, key_state: ^KeyState) {
    if current_state != 0 {
        if key_state^ > .KS_HELD {
            key_state^ = .KS_HELD
        } else {
            key_state^ = .KS_PRESSED
        }
    } else {
        key_state^ = .KS_UNPRESSED
    }
}

input_update :: proc() {
    keyboard_state := sdl.GetKeyboardState(nil)

    update_key_state(
        keyboard_state[ctx.config.keybinds[InputKey.INPUT_KEY_LEFT]],
        &ctx.input.keys[InputKey.INPUT_KEY_LEFT],
    )
    update_key_state(
        keyboard_state[ctx.config.keybinds[InputKey.INPUT_KEY_RIGHT]],
        &ctx.input.keys[InputKey.INPUT_KEY_RIGHT],
    )
    update_key_state(
        keyboard_state[ctx.config.keybinds[InputKey.INPUT_KEY_UP]],
        &ctx.input.keys[InputKey.INPUT_KEY_UP],
    )
    update_key_state(
        keyboard_state[ctx.config.keybinds[InputKey.INPUT_KEY_DOWN]],
        &ctx.input.keys[InputKey.INPUT_KEY_DOWN],
    )
    update_key_state(
        keyboard_state[ctx.config.keybinds[InputKey.INPUT_KEY_ESCAPE]],
        &ctx.input.keys[InputKey.INPUT_KEY_ESCAPE],
    )
}
