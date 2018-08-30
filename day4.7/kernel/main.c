#include<header.h>
void bootmain(void){
	int i;
	char *p;

	init_palette();//设定调色板

	for(i=0xa0000;i<=0xaffff;i++){
		p = (char*)i;		
		*p = i & 0x0f;
	}

	clear_screen(15);//由于一进来这里显示的是"my kernel is running"等字符串，这里刷屏为灰色，去除字符串

	p = (char*)0xa0000;
	boxfill8(p, 320, 1, 20, 20, 120, 120);
	boxfill8(p, 320, 2, 70, 50, 170, 150);
	boxfill8(p, 320, 4, 120, 80, 220, 180);	

	for(;;){
		io_halt();
	}
}
