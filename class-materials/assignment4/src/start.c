#include "main.h"
#include "plic.h"
#include "timer.h"
#include "trap.h"
#include "uart.h"

void start() {
  uart_init();
  plicinit();
  plicinithart();
  trapinithart();
  timerinit();
  main();
}