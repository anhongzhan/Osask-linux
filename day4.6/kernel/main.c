#include<header.h>
void bootmain(void){
	int i;
	char *p;

	init_palette();//设定调色板

	for(i=0xa0000;i<=0xaffff;i++){
		p = (char*)i;		
		*p = i & 0x0f;
	}

	for(;;){
		io_halt();
	}
}
