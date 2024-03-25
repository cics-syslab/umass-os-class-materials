#include "uart.h"
#include "util.h"
#include "main.h"

// We have moved the old main loop code into our uart handler.
// This keeps things encapsulated which is a key part of good
// software design.
char main_cmd_buf[MAIN_MAX_CMD_LEN] = { 0 };
unsigned char main_idx = 0;

void main_print_prompt() {
    uart_write('>');
    uart_write(' ');
}

// We have separated the code that handles the command processing
// from the code that handles the interrupt. Many operating systems
// use this strategy creating a bottom-half and top-half of the
// driver. The bottom half is small and fast to handle interrupts,
// while the top half is larger and more complex. Later when we
// implement threads and multiprocessing this separation will make
// our lives much easier.
void main_handle_input(char c) {
/* BEGIN DELETE BLOCK */
    if (c == MAIN_ASCII_NEW_LINE || c == MAIN_ASCII_CARRIAGE_RETURN) {
        // Insert null terminator in place of newline character,
        // otherwise we might read into old commands in the buffer
        main_cmd_buf[main_idx] = 0;
        main_idx++;
        // Convert the carriage return to a newline and echo it back to user
        util_print_buf("\n");
        // Process commands if the user has typed anything besides a newline
        if (main_idx > 1) {
            // Parse special commands.
            // Credit to my wonderful friend Charlie and my lovely girlfriend Elizabeth Sheridan.
            // A reminder that this is your os and you can personalize it.
            if (util_strcmp(main_cmd_buf, "hello") == 0) {
                util_print_buf("world");
            } else if (util_strcmp(main_cmd_buf, "charlie") == 0) {
                util_print_buf("weinstock");
            } else if (util_strcmp(main_cmd_buf, "elizabeth") == 0) {
                util_print_buf("\n");
                util_print_buf("  _________.__                 .__    .___              \n");
                util_print_buf(" /   _____/|  |__   ___________|__| __| _/____    ____  \n");
                util_print_buf(" \\_____  \\ |  |  \\_/ __ \\_  __ \\  |/ __ |\\__  \\  /    \\ \n");
                util_print_buf(" /        \\|   Y  \\  ___/|  | \\/  / /_/ | / __ \\|   |  \\\n");
                util_print_buf("/_______  /|___|  /\\___  >__|  |__\\____ |(____  /___|  /\n");
                util_print_buf("        \\/      \\/     \\/              \\/     \\/     \\/ \n");
            } else {
                util_print_buf("command not recognized: ");
                util_print_buf(main_cmd_buf);
            }
            // Make a newline after the output
            util_print_buf("\n");
        }
        main_print_prompt();
        main_idx = 0;
    } else if (c == MAIN_ASCII_DELETE) {
        // Overwrite last character with a space on screen,
        // don't save delete character and decrement idx
        // to remove last character. No need to add null
        // terminator, it always gets inserted on newline.
        // Important check: only delete if there is actually
        // a character to be deleted! (idx > 0)
        if (main_idx > 0) { 
            util_print_buf("\b \b");
            main_idx--; 
        }
    } else {
        // Make sure to always leave a null terminator, otherwise
        // *bad things* will happen. Don't save \n or \r
        if (main_idx < MAIN_MAX_CMD_LEN - 1) {
            main_cmd_buf[main_idx] = c;
            main_idx++;
        }
        // Echo the character back to the console
        uart_write(c);
    }
/* END DELETE BLOCK */
}

// All of the input is now handled by the trap, so we have nothing to
// do in the main loop except wait for an interrupt. We could've used
// a spin loop, but as you may have noticed, this actually uses quite
// a bit of power. What we really want to do is to tell the CPU to do
// nothing until an interrupt arrives. Conveniently riscv has a 
// "Wait For Interrupt (wfi)" command that does just that. So our new
// loop will just continuously sleep the CPU while waiting for a
// keyboard interrupt.
void main() {
    // main_handle_input is only called when a key is typed, so we 
    // need to print it here the first time before the user has typed
    // anything.
    main_print_prompt();
    while (1) {
        asm("wfi");
    }
}