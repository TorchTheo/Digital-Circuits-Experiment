#include "sys.h"
#include "keyboard.h"


// char hello[]="Hello World!\n";
// char prompt[] = "[:)]%";  // 命令行提示符
extern vga_line;
extern __line;

int main();

//setup the entry point
void entry()
{
    asm("lui sp, 0x00120"); //set stack to high address of the dmem
    asm("addi sp, sp, -4");
    main();
}

int main()
{
    vga_init();
  
    // putstr(hello);
    // putstr(prompt);
    // putstr("\n");
    // putstr(prompt);
    // putstr("\n");
    // putstr(prompt);
    // putstr("\n");
    // putstr(prompt);
    // putstr("\n");
    // putstr(prompt);
    putch('[');
    __sys_time();
    putstr("]%");
    while (1)
    {
        if(__read_info()) {
            putch('[');
            __sys_time();
            putstr("]%");
        }
    };
    return 0;
}