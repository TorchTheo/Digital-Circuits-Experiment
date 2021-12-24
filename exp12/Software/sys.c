#include "sys.h"

char *vga_start = (char *)VGA_START;
unsigned char *__vga_offset = (unsigned char *) VGA_START_OFF;
unsigned int *__millisec = (unsigned int *) CLOCK_ADDR;
int vga_line = 0; // 显存行
int vga_ch = 0;
char __line = 0; // 显示行
char __last_word_of_pre_line[1 << 8];
int __is_new_line = 0;

void vga_init()
{
    *__vga_offset = 0;
    vga_line = 0;
    __line = 0;
    vga_ch = 0;
    __is_new_line = 0;
    for (int i = 0; i < VGA_MAXLINE; i++)
        for (int j = 0; j < VGA_MAXCOL; j++)
            vga_start[VGA(i, j)] = 0;
}

void putch(char ch)
{
    if (ch == 8) //backspace
    {
        // vga_start[VGA(vga_line, vga_ch)] = 0;
        if(__is_new_line) {
            if(!vga_ch) {
                if(!__line) {
                    if(vga_line) {
                        *__vga_offset -= VGA_MAXCOL;
                        vga_line--;
                        vga_ch = __last_word_of_pre_line[vga_line];
                    }
                } else {
                    vga_line--;
                    __line--;
                    vga_ch = __last_word_of_pre_line[vga_line];
                }
                __is_new_line--;
            } else
                vga_ch--;
        } else
            if(vga_ch > PROMPT_SIZE)
                vga_ch--;
        vga_start[VGA(vga_line, vga_ch)] = 0;
        return;
    }
    if (ch == 10) //enter
    {
        __is_new_line = 0;
        __last_word_of_pre_line[vga_line] = vga_ch;
        vga_ch = 0;
        vga_line++;
        __line++;
        if(__line >= VGA_MAXLINE) {
            __clear_line(vga_line);
            *__vga_offset += VGA_MAXCOL;
        }
        return;
    }
    vga_start[VGA(vga_line, vga_ch)] = ch;
    vga_ch++;
    if (vga_ch >= VGA_MAXCOL)
    {
        __is_new_line++;
        __last_word_of_pre_line[vga_line] = VGA_MAXCOL;
        vga_line++;
        vga_ch = 0;
        __line++;
        if(__line >= VGA_MAXLINE) {
            __clear_line(vga_line);
            *__vga_offset += VGA_MAXCOL;
        }
    }
    return;
}

void putstr(char *str)
{
    for (char *p = str; *p != 0; p++)
        putch(*p);
}

void __clear_line(int _line) {
    for(int i = 0; i < VGA_MAXCOL; i++)
        (vga_start + *__vga_offset)[VGA(_line, i)] = 0;
}

void __clear_screen() {
    if(*__vga_offset)
        *__vga_offset -= VGA_MAXCOL;
    for(int i = 0; i < VGA_MAXLINE; i++)
        for(int j = 0; j < VGA_MAXCOL; j++)
            (vga_start + (*__vga_offset))[VGA(i, j)] = 0;
    vga_line = __udivsi3(*__vga_offset, VGA_MAXCOL);
    vga_ch = 0;
    __is_new_line = 0;
    __line = 0;
}

void __sys_time() {
    unsigned int ms = *__millisec;
    unsigned int hour = __udivsi3(ms, MS2HOUR);
    unsigned int minute = __udivsi3(ms - __mulsi3(hour, MS2HOUR), MS2MINUTE);
    unsigned int sec = __udivsi3(ms - __mulsi3(hour, MS2HOUR) - __mulsi3(minute, MS2MINUTE), MS2SECOND);
    char res[100];
    int index = 0;
    int count = 2;
    while(sec) {
        res[index] = __umodsi3(sec, 10) + '0';
        sec = __udivsi3(sec, 10);
        index++;
        count --;
    }
    while(count) {
        res[index++] = '0';
        count--;
    }
    count = 2;
    res[index++] = ':';
    while(minute) {
        res[index] = __umodsi3(minute, 10) + '0';
        minute = __udivsi3(minute, 10);
        index++;
        count--;
    }
    while(count) {
        res[index++] = '0';
        count--;
    }
    count = 2;
    res[index++] = ':';
    while(hour) {
        res[index] = __umodsi3(hour, 10) + '0';
        hour = __udivsi3(hour, 10);
        index++;
        count--;
    }
    while(count) {
        res[index++] = '0';
        count--;
    }
    char temp;
    for(int i = 0; i < (index >> 1); i++) {
        temp = res[i];
        res[i] = res[index - i - 1];
        res[index - i - 1] = temp;
    }
    res[index] = 0;
    putstr(res);
    // putch('\n');
}
