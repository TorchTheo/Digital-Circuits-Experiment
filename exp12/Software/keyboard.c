#include "keyboard.h"
#include "IOChecker.h"

char __buffer[256];
int len = 0;
char* __keyboard_buffer = (char*) KEYBOARD_START;
char* __ascii = (char*) ASCII;
int* __keyboard_head = (int*) KEYBOARD_HEAD;
int* __keyboard_tail = (int*) KEYBOARD_TAIL;

void __init_buffer() {
    for(int i = 0; i < 256; i++)
        __buffer[i] = 0;
    len = 0;
}

int __read_info() {
    char __keyboard_info[256];
    char __index = 0;
    while(*__keyboard_head != *__keyboard_tail) {
        __keyboard_info[__index] = *__ascii;
        __index++;
        (*__keyboard_head) ++;
    }
    __keyboard_info[__index] = 0; // 添加字符串末尾结束符
    return __handle_info(__keyboard_info); 
}

int __handle_info(char* __keyboard_info) {// 处理缓冲区中读到的所有字符
    putstr(__keyboard_info);
    //__init_buffer(); // 初始化指令缓冲区  暂时注释了此条
    return __read_buffer(__keyboard_info); // 将字符缓冲区的内容处理后放入buffer
}

int __read_buffer(char* __keyboard_info) {
    for(; *__keyboard_info != 0; __keyboard_info++) {
	// putch(65); // add_by_cjg
        int t = __single_read(*__keyboard_info); // 每一步单独调用__single_read来处理单个字符并接受返回值
        if(!t) { // 读到一个非换行符的字符
		continue;
        } else if(t == 2){ // 读到一个空的换行符
		return true;
        } else { // 读到换行符且长度指令缓冲区长度不为空
		// putstr(__buffer);
	        // putch('\n');
	        IO_check(__buffer, len);
	    	// len = 0;
		    __init_buffer();
       		return true;
        }
    }
    return false;
}

int __single_read(char ch) {
    if(ch == 8) { // 退格
        if(len) // 当缓冲区中有内容时才删除
            __buffer[--len] = 0;
        return false;
    } else if(ch == 10) { // 换行符
        if(!len) // 单独的一个换行符
            return redundant;
        else
            return true;
    } else {
        __buffer[len++] = ch;
        return false;
    }
}
