#include "uart.h"
#include "util.h"

#define MAX_CMD_LEN 16

char cmd_buf[MAX_CMD_LEN] = { 0 };
unsigned char idx = 0;
char input = 0;

void print_prompt() {
    uart_write('>');
    uart_write(' ');
}

void main() {
    print_prompt();
    while (1) {
        input = uart_read();
        if (input == '\n' || input == '\r') {
            // Insert null terminator in place of newline character,
            // otherwise we might read into old commands in the buffer
            cmd_buf[idx] = 0;
            // Convert the carriage return to a newline and echo it back to user
            print_buf("\n");
            // There is always a newline at the end, ignore it
            if (idx > 1) {
                // Parse special commands.
                // Credit to my wonderful friend Charlie and my lovely girlfriend Elizabeth Sheridan.
                // A reminder to always personalize your os and also stop working on it 
                // occasionally and get some fresh air.
                if (strcmp(cmd_buf, "hello") == 0) {
                    print_buf("world");
                } else if (strcmp(cmd_buf, "charlie") == 0) {
                    print_buf("weinstock");
                } else if (strcmp(cmd_buf, "elizabeth") == 0) {
                    print_buf("\n");
                    print_buf("  _________.__                 .__    .___              \n");
                    print_buf(" /   _____/|  |__   ___________|__| __| _/____    ____  \n");
                    print_buf(" \\_____  \\ |  |  \\_/ __ \\_  __ \\  |/ __ |\\__  \\  /    \\ \n");
                    print_buf(" /        \\|   Y  \\  ___/|  | \\/  / /_/ | / __ \\|   |  \\\n");
                    print_buf("/_______  /|___|  /\\___  >__|  |__\\____ |(____  /___|  /\n");
                    print_buf("        \\/      \\/     \\/              \\/     \\/     \\/ \n");
                } else {
                    print_buf("command not recognized: ");
                    print_buf(cmd_buf);
                }
                // Make a newline after the output
                print_buf("\n");
            }
            print_prompt();
            idx = 0;
        } else if (input == '\x7f') {
            // Overwrite last character with a space on screen,
            // don't save delete character and decrement idx
            // to remove last character. No need to add null
            // terminator, it always gets inserted on newline.
            // Important check: only delete if there is actually
            // a character to be deleted! (idx > 0)
            if (idx > 0) { 
                print_buf("\b \b");
                idx--; 
            }

        } else {
            // Make sure to always leave a null terminator, otherwise
            // *bad things* will happen. Don't save \n or \r
            if (idx < MAX_CMD_LEN - 1) {
                cmd_buf[idx] = input;
                idx++;
            }
            // Echo the character back to the console
            uart_write(input);
        }
    }
}