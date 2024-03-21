#include "uart.h"
#include "util.h"

#define MAX_CMD_LEN 16

char main_cmd_buf[MAX_CMD_LEN] = { 0 };
unsigned char main_idx = 0;
char main_input = 0;

void main_print_prompt() {
    uart_write('>');
    uart_write(' ');
}

void main() {
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
}