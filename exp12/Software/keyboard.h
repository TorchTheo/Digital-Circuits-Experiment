#include "sys.h"

#define KEYBOARD_START      0x00300000

// TODO: 等待硬件提供以下3个接口
#define ASCII               0x00300000
#define KEYBOARD_HEAD       0x00300001
#define KEYBOARD_TAIL       0x00300002



int __read_info();

int __handle_info(char*);

void __init_buffer();

int __single_read(char);

int __read_buffer(char*);