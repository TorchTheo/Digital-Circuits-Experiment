#include "calculator.h"

// unsigned int __mulsi3(unsigned int a, unsigned int b)
// {
//     unsigned int res = 0;

//     while (a)
//     {
//         if (a & 1)
//             res += b;
//         a >>= 1;
//         b <<= 1;
//     }
//     return res;
// }

// unsigned int __umodsi3(unsigned int a, unsigned int b)
// {
//     unsigned int bit = 1;
//     unsigned int res = 0;

//     while (b < a && bit && !(b & (1UL << 31)))
//     {
//         b <<= 1;
//         bit <<= 1;
//     }
//     while (bit)
//     {
//         if (a >= b)
//         {
//             a -= b;
//             res |= bit;
//         }
//         bit >>= 1;
//         b >>= 1;
//     }
//     return a;
// }
// unsigned int __udivsi3(unsigned int a, unsigned int b)
// {
//     unsigned int bit = 1;
//     unsigned int res = 0;

//     while (b < a && bit && !(b & (1UL << 31)))
//     {
//         b <<= 1;
//         bit <<= 1;
//     }
//     while (bit)
//     {

//         if (a >= b)
//         {

//             a -= b;
//             res |= bit;
//         }
//         bit >>= 1;
//         b >>= 1;
//     }
//     return res;
// }
void cal(char *start_pos, int len, char *res)
{
    char tmp[100];
    int op[100];
    for(int i = 0; i < 100; i++) op[i] = 0;
    for (int i = 0; i < len; i++)
    {
            tmp[i] = *start_pos;
            start_pos++;
    }
    int cnt = 0, tem = 0, num[100];
    int last_0_flag = 0;
    for (int i = 0; i < len; i++)
    {
            if (!('0' <= tmp[i] && tmp[i] <= '9'))
            {
                if (tem != 0 || last_0_flag == 1)
                {
                    num[cnt++] = tem;
                    tem = 0;
                    last_0_flag = 0;
                }
                else if(i == 0 || (tmp[i - 1] != ')' && !('0' <= tmp[i - 1] && tmp[i - 1] <= '9'))){
                    len += 2;
                    for(int j = len - 1; j >= i + 2; j--){
                            tmp[j] = tmp[j - 2];
                    }
                    tmp[i + 1] = '1';
                    tmp[i + 2] = '*';
                    op[i] = 1;
                }
            }
            else
            {
                tem = __mulsi3(tem, 10) + tmp[i] - '0';
                if(tem == 0) last_0_flag = 1;
                else last_0_flag = 0;
            }
    }
    if (tem != 0 || last_0_flag) num[cnt++] = tem; // 需要处理最后一个操作数是0 的情况！！

    int cnt_stack = 0, cnt_token = 0, tem_num = 0, stack[100], token[100]; // stack为操作符栈  token为后缀表达式
    stack[0] = '#';                                                        // '#'
    int priority_map[100];
    // cnt_stack 指向当前最后一个有效操作符
    // init the map
    priority_map[35] = 0; // #
    priority_map[40] = 1; // (
    priority_map[43] = 2; // +
    priority_map[45] = 2; // -
    priority_map[42] = 3; // *
    priority_map[47] = 3; // /
    priority_map[41] = 4; // )

    int flag = 0;
    int minus_flag = 1;
    int suf_op_pos[100];
    for(int i = 0; i < 100; i++) suf_op_pos[i] = 0;
    for (int i = 0; i < len; i++)
    {
            if (('0' <= tmp[i] && tmp[i] <= '9'))
            { // num
                if (!flag)
                {
                    flag = 1;
                    token[cnt_token] = num[tem_num++] * minus_flag;
                    suf_op_pos[cnt_token] = 1;
                    minus_flag = 1;
                    cnt_token++;
                }
            }
            else
            { // op
                flag = 0;
                if (tmp[i] == '(')
                {                             // st[i] = 1
                    stack[++cnt_stack] = '('; // (
                }
                else if (tmp[i] == '+' || (tmp[i] == '-' && !op[i]))
                {
                    while (cnt_stack && priority_map[stack[cnt_stack]] >= priority_map[(int)tmp[i]])
                    {
                        token[cnt_token++] = -stack[cnt_stack];
                        cnt_stack--;
                    }
                    stack[++cnt_stack] = tmp[i];
                }
                else if (tmp[i] == '*' || tmp[i] == '/')
                {
                    while (cnt_stack && priority_map[stack[cnt_stack]] >= priority_map[(int)tmp[i]])
                    {
                        token[cnt_token++] = -stack[cnt_stack];
                        cnt_stack--;
                    }
                    stack[++cnt_stack] = tmp[i];
                }
                else if (tmp[i] == ')')
                {
                    while (cnt_stack && stack[cnt_stack] != '(')
                    {
                        token[cnt_token++] = -stack[cnt_stack];
                        cnt_stack--;
                    }
                    cnt_stack--;
                }
                else if(tmp[i] == '-'){
                    minus_flag = -1;
                }
                else
                {
                    // ignore the space
                }
            }
    }
    while (cnt_stack)
    {
            token[cnt_token++] = -stack[cnt_stack];
            cnt_stack--;
    }
    // for(int i = 0; i < cnt_token; i++) cout << token[i] << endl;
    int cal_num = 0, cal_stack[100];
    for (int i = 0; i < cnt_token; i++)//
    {
            if (suf_op_pos[i])
            {
                cal_stack[cal_num++] = token[i];
            }
            else if (token[i] == -43)
            {
                cal_stack[cal_num - 2] = cal_stack[cal_num - 2] + cal_stack[cal_num - 1];
                cal_num--;
            }
            else if (token[i] == -45)
            {
                cal_stack[cal_num - 2] = cal_stack[cal_num - 2] - cal_stack[cal_num - 1];
                cal_num--;
            }
            else if (token[i] == -42)
            {
                cal_stack[cal_num - 2] = __mulsi3(cal_stack[cal_num - 2], cal_stack[cal_num - 1]);
                cal_num--;
            }
            else if (token[i] == -47)
            {
                cal_stack[cal_num - 2] = __divsi3(cal_stack[cal_num - 2], cal_stack[cal_num - 1]);
                cal_num--;
            }
    }
    // IO_out
    int tot = 0, digit[100];
    if(cal_stack[0] < 0){
            *res = '-';
            res++;
            cal_stack[0] = -cal_stack[0];
    }
    else if(cal_stack[0] == 0){
            *res = '0';
            res++;
    }
    while (cal_stack[0]){
            digit[tot++] = __umodsi3(cal_stack[0], 10);
            cal_stack[0] = __udivsi3(cal_stack[0], 10);
    }
    for (int i = 0; i < tot; i++, res++)
            *res = '0' + digit[tot - i - 1];
    *res = '\0';
}


void fib(char* start_pos, int len, char* res){
    char tmp[100];
    for(int i = 0; i < len; i++){
        tmp[i] = *start_pos;
        start_pos++;
    }
    int cnt = 0, tem = 0, num[100];
    for(int i = 0; i < len; i++){
        if(!('0' <= tmp[i] && tmp[i] <= '9')){
                if(tem != 0){
                        num[cnt++] = tem;
                        tem = 0;
                }
        }
        else{
                tem = __mulsi3(tem, 10) + tmp[i] - '0';
        }
    }
    if(tem != 0) num[cnt++] = tem;

    //cal the fib
    unsigned int fib[100];
    fib[1] = 1;
    fib[2] = 1;
    for(int i = 3; i <= num[0]; i++){
        fib[i] = fib[i - 1] + fib[i - 2];
    }
    // IO_out
    int tot = 0, digit[100];
    while(fib[num[0]]){
            digit[tot++] = __umodsi3(fib[num[0]], 10);
            fib[num[0]] = __udivsi3(fib[num[0]], 10);
    }
    for(int i = 0; i < tot; i++) res[i] = '0' + digit[tot - i - 1];
    res[tot] = '\0';
    //for(int i = 0; i < cnt_token; i++) cout << token[i] << endl;
}
