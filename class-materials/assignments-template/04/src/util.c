#include "uart.h"


void util_print_buf(char *buf) {
    unsigned char print_idx = 0;
    while (buf[print_idx] != 0) {
        uart_write(buf[print_idx]);
        print_idx++;
    }
}

int util_strcmp(char *str1, char *str2) {
    const unsigned char *s1 = (const unsigned char *) str1;
    const unsigned char *s2 = (const unsigned char *) str2;
    unsigned char c1, c2;
    do {
        c1 = (unsigned char) *s1++;
        c2 = (unsigned char) *s2++;
        if (c1 == '\0') { return c1 - c2; }
    } while (c1 == c2);
    
    return c1 - c2;
}