#include<header.h>

void bootmain(void){
	int i = 0xa0000;
	char *p = (char*)i;
	for(i=0x0;i<0xffff;i++){
		p[i] = i & 0x0f;
	}
}
