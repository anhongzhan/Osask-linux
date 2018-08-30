void bootmain(void){
//注意这里的函数名字为bootmain，因为在entry.S中设定的入口名字也是bootmain，两者要保持一致
	int i;
	for(i=0xa0000;i<0xaffff;i++){
		write_mem8(i,15);
	}
}
