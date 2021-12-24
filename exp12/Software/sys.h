#define __SIZE_TYPE  long unsigned int
typedef __SIZE_TYPE__  size_t;
typedef int uint32_t;
#define __modsi3 __umodsi3
#define __divsi3 __udivsi3
#define VGA_START       0x00200000
#define VGA_LINE_O      0x00210000
#define VGA_START_OFF   0x10000000
#define CLOCK_ADDR      0x00400000
#define VGA_MAXLINE     30
#define LINE_MASK       0x003f
#define VGA_MAXCOL      71
#define true            1
#define false           0
#define redundant       2
#define PROMPT_SIZE     11
// #define VGA(x, y)       ((x) << 7) + ((x) << 6) + ((x) << 4) + ((x) << 2) + (x) + (y)
#define VGA(x, y)       ((x) << 6) + ((x) << 2) + ((x) << 1) + x + y
#define MUL70(x)        ((x) << 6) + ((x) << 2) + ((x) << 1)

#define MS2HOUR         3600000
#define MS2MINUTE       60000
#define MS2SECOND       1000


void putstr(char* str);
void putch(char ch);

void vga_init(void);

void __clear_line(int);

void __clear_screen();

void __sys_time();

