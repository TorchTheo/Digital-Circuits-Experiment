#include "utils.h"
#include "sys.h"
#include "stddef.h"
unsigned int *time = (unsigned int *) CLOCK_ADDR;
int rand(){
	unsigned int ms = *time;
	unsigned int seed = 100;
	return __umodsi3(ms, seed);
}	
void *memcpy(void *dst,const void *src,size_t size)
{
    char *psrc;  //源地址
    char *pdst;  //目标地址

    if(NULL == dst || NULL == src)
    {
        return NULL;
    }
    //源地址在前，对应上述情况2，需要自后向前拷贝
    if((src < dst)&&(char *)src+size > (char *)dst)
    {
        psrc = (char *)src + size - 1;
        pdst = (char *)dst + size - 1;
        while(size--)
        {
            *pdst-- = *psrc--;
        }
    }
    else    //源地址在后，对应上述第一种情况，直接逐个拷贝*pdst++=*psrc++即可
    {
        psrc = (char *)src;
        pdst = (char *)dst;
        while(size--)
        {
            *pdst++ = *psrc++;
        }
    }
    return pdst;
}

int __strlen(char* start_str){
	int cnt = 0;
	while(*start_str != '\0'){
		cnt++;
		start_str++;
	}
	return cnt;
}

int __strcmp(char* str1, int len1, char* str2, int len2){
	if(len1 != len2) return 0;
	for(int i = 0; i < len1; i++){
		if(*str1 != *str2) return 0;
		str1++;
		str2++;
	}
	return 1;
}
