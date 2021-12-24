#include "IOChecker.h"
#include "coremark.h"
#include "core_portme.h"
#define clk_addr 0x00400000
void IO_check(char* start_pos, int len){
    char tmp[100];
    for(int i = 0; i < len; i++){
            tmp[i] = *start_pos;
            start_pos++;
    }
    tmp[len] = '\0';
    char help[4] = {'h', 'e', 'l', 'p'};
    char hel[5] = {'h', 'e', 'l', 'l', 'o'};
    char fi[4] = {'f', 'i', 'b', ' '};
    char time[4] = {'t', 'i', 'm', 'e'};
    char clear[5] = {'c', 'l', 'e', 'a', 'r'};
    char core_mark[3] = {'r', 'u', 'n'};
    char uke[] = "Unknown Command\n";
    if(__strcmp(tmp, len, hel, 5)){
        char hel_world[] = "Hello World!";
        putstr(hel_world);
        putch(10);
    }
    else if(__strcmp(tmp, 4, fi, 4)){
        char res[100];
        fib(tmp, len, res);
        putstr(res);
        putch(10);
    }
    else if(__strcmp(tmp, 4, time, 4)){ //time
        __sys_time();
        putch('\n');
    }
    else if(tmp[len - 1] == '='){
        char res[100];
        cal(tmp, len, res);
        putstr(res);
        putch(10);
    }
    else if(__strcmp(tmp, 4, help, 4)) {
	const char _h_hello[352]  = {'-', '-', 'h', 'e', 'l', 'l', 'o', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', 'p', 'r', 'i', 'n', 't', ' ', 'h', 'e', 'l', 'l', 'o', ' ', 'o', 'n', ' ', 't', 'h', 'e', ' ', 's', 'c', 'r', 'e', 'e', 'n', 10, '-', '-', 'f', 'i', 'b', ' ', '[', 'n', ']', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', 'p', 'r', 'i', 'n', 't', ' ', 't', 'h', 'e', ' ', 'n', '-', 't', 'h', ' ', 'n', 'u', 'm', 'b', 'e', 'r', ' ', 'o', 'f', ' ', 'F', 'i', 'b', 'o', 'n', 'a', 'c', 'c', 'i', ' ', 's', 'e', 'q', 'u', 'e', 'n', 'c', 'e', 10, '-', '-', '[', 'e', 'x', 'p', 'r', ']', '=', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', 'c', 'a', 'l', 'c', 'u', 'l', 'a', 't', 'e', ' ', 't', 'h', 'e', ' ', 'e', 'x', 'p', 'r', 'e', 's', 's', 'i', 'o', 'n', ' ', 'a', 'n', 'd', ' ', 'p', 'r', 'i', 'n', 't', ' ', 't', 'h', 'e', ' ', 'a', 'n', 's', 'w', 'e', 'r', 10, '-', '-', 't', 'i', 'm', 'e', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', 'p', 'r', 'i', 'n', 't', ' ', 't', 'h', 'e', ' ', 't', 'i', 'm', 'e', ' ', 'o', 'f', ' ', 't', 'h', 'e', ' ', 'c', 'o', 'm', 'p', 'u', 't', 'e', 'r', ' ', 'o', 'n', ' ', 't', 'h', 'e', ' ', 's', 'c', 'r', 'e', 'e', 'n', 10, '-', '-', 'c', 'l', 'e', 'a', 'r', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', 'c', 'l', 'e', 'a', 'r', ' ', 'a', 'l', 'l', ' ', 't', 'h', 'e', ' ', 'i', 'n', 'f', 'o', 'r', 'm', 'a', 't', 'i', 'o', 'n', ' ', 'a', 'n', 'd', ' ', 'i', 'n', 'i', 't', ' ', 't', 'h', 'e', ' ', 's', 'c', 'r', 'e', 'e', 'n', 10, '-', '-', 'r', 'u', 'n', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', 'r', 'u', 'n', ' ', 't', 'h', 'e', ' ', 'b', 'e', 'n', 'c', 'h', 'm', 'a', 'r', 'k', ' ', 't', 'e', 's', 't', ' ', 'a', 'n', 'd', ' ', 's', 'h', 'o', 'w', ' ', 't', 'h', 'e', ' ', 's', 'c', 'o', 'r', 'e', 10};
		
        putstr(_h_hello);
    }
    else if(__strcmp(tmp, 5, clear, 5)) {
        __clear_screen();
    }
    else if(__strcmp(tmp, 3, core_mark, 3)){
    	core_main();
    }
    else{
        putstr(uke);
    }
}
