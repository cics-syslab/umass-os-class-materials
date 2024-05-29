#include "uart.h"
#include "util.h"

/*
TODO:
Declare any global variables you need to implement your shell.
Remember that all global variables should be prefixed with the
name of the file they're in.

Declare any helper functions you need to implement your shell.
Remember that any functions should be prefixed with the name of
the file they're in.
*/
/* BEGIN DELETE BLOCK */
#define MAX_CMD_LEN 16

char main_cmd_buf[MAX_CMD_LEN] = { 0 };
unsigned char main_idx = 0;
char main_input = 0;

void main_print_prompt() {
    uart_write('>');
    uart_write(' ');
}
/* END DELETE BLOCK */

void main() {
    /* 
    TODO:
    Implement a simple shell. It should print a prompt, then accept user input.
    Every key the user types should be echoed back to the user using the UART.
    Once they hit the enter key, the current command should be "executed". To
    keep this shell simple, execution means the shell either prints output 
    specific to the command for example 'hello' -> 'world' or "Command 'AAA' 
    not recognized" (AAA should be replaced with the actual command the user 
    typed) if the command is not recognized. You should implement at least 
    one command, it can be whatever you want, and have whatever output you
    want. The shell should also support the backspace key. It should do
    exactly what you expect, replacing the last character with a blank space
    and moving the cursor backwards. It should only delete characters the user
    typed (not the prompt).
    */
/* BEGIN DELETE BLOCK */
    main_print_prompt();
    while (1) {
        main_input = uart_read();
        if (main_input == '\n' || main_input == '\r') {
            // Insert null terminator in place of newline character,
            // otherwise we might read into old commands in the buffer
            main_cmd_buf[main_idx] = 0;
            // Convert the carriage return to a newline and echo it back to user
            util_print_buf("\n");
            // There is always a newline at the end, ignore it
            if (main_idx > 1) {
                // Parse special commands.
                // Credit to my wonderful friend Charlie and my lovely girlfriend Elizabeth Sheridan.
                // A reminder to always personalize your os and also stop working on it 
                // occasionally and get some fresh air.
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
        } else if (main_input == '\x7f') {
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
            if (main_idx < MAX_CMD_LEN - 1) {
                main_cmd_buf[main_idx] = main_input;
                main_idx++;
            }
            // Echo the character back to the console
            uart_write(main_input);
        }
    }
/* END DELETE BLOCK */
}