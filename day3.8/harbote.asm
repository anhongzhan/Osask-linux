;harbote.asm

;有关BOOT_INFO
CYLS	EQU	0x0ff0	;设定启动区
LEDS	EQU	0x0ff1
VMODE	EQU	0x0ff2	;关于颜色数目的信息。颜色的位数
SCRNX	EQU	0x0ff4	;分辨率的X(screen x)
SCRNY	EQU	0x0ff6	;分辨率的Y(screen y)
VRAM	EQU	0x0ff8	;图像缓冲开始地址

	ORG	0xc400	;这个程序要被装在到内存的什么地方呢？
	mov	al,0x13	;VGA 显卡　320*200*8位彩色
	mov	ah,0x00	
	int 	0x10
	mov	byte [VMODE],8	;记录画面模式
	mov	word [SCRNX],320
	mov	word [SCRNY],200
	mov	DWORD [VRAM],0x000a0000
;用BIOS获得键盘上各种LED指示灯的状态
	mov	ah,0x02
	int	0x16	;keyboard BIOS
	mov	[LEDS],al
fin:
	hlt
	jmp	fin
