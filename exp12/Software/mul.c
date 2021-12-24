unsigned int __mulsi3(unsigned int a, unsigned int b) {
    unsigned int res = 0;
    while (a) {
        if (a & 1) res += b;
        a >>= 1;
        b <<= 1;
    }
    return res;
}

unsigned int __umodsi3(unsigned int a, unsigned int b) {
    unsigned int bit = 1;
    unsigned int res = 0;

    while (b < a && bit && !(b & (1UL << 31))) {
        b <<= 1;
        bit <<= 1;
    }
    while (bit) {
        if (a >= b) {
            a -= b;
            res |= bit;
        }
        bit >>= 1;
        b >>= 1;
    }
    return a;
}

unsigned int __udivsi3(unsigned int a, unsigned int b) {
    unsigned int bit = 1;
    unsigned int res = 0;

    while (b < a && bit && !(b & (1UL << 31))) {
        b <<= 1;
        bit <<= 1;
    }
    while (bit) {
        if (a >= b) {
            a -= b;
            res |= bit;
        }
        bit >>= 1;
        b >>= 1;
    }
    return res;
}

int divideCore(int dividend, int divisor ) {
	int result = 0;
	while (dividend <= divisor) {
		int value = divisor;
		int quotient = 1;
		while (value >= 0x00000000 && dividend <= value + value) {
			quotient += quotient;
			value += value;

		}

		result += quotient;
		dividend -= value;

	}

	return result;
}
int __divsi3(int dividend, int divisor) {
	if (dividend == 0x80000000 && divisor == -1) {
		return 0xffffffff;
	}

	int negative = 2;

	if (dividend > 0) {
		negative--;
		dividend = -dividend;
	}

	if (divisor > 0) {
		negative--;
		divisor = -divisor;
	}
	int result = divideCore(dividend, divisor);
	return negative == -1 ? -result : result;

}

int __modsi3(int a, int b){
    unsigned int bit = 1;
    unsigned int res = 0;
    int flag = 1;
    if(a < 0){
	    a = -a;
	    flag = __mulsi3(flag, -1);
    }
    if(b < 0){
            b = -b;
            flag = __mulsi3(flag, -1);
    }
    while (b < a && bit && !(b & (1UL << 31))) {
        b <<= 1;
        bit <<= 1;
    }
    while (bit) {
        if (a >= b) {
            a -= b;
            res |= bit;
        }
        bit >>= 1;
        b >>= 1;
    }
    return __mulsi3(a, flag);
}
