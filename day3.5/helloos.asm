cyls equ 10	;3.4添加　代表扇区
;hello.nas
	org 0x7c00;跳转到内存地址0x7c00处
 fat12:
	;设定fat12格式
	jmp entry
	db 0x90
	db "chris_zz";	8bytes
	dw 512
	db 1
	dw 1
	db 2
	dw 224
	dw 2880
	db 0xf0
	dw 9
	dw 18
	dw 2
	dd 0
	dd 2880
	db 0,0,0x29
	dd 0xffffffff
	db "My First OS"
	db "FAT12   "
 entry:
	;程序主要部分
	mov ax, 0
	mov ss, ax
	mov ds, ax
	mov es, ax
 	mov sp, 0x7c00
 	mov si, msg

;---------------------3.3添加部分
;读磁盘
	mov ax,0x0820
	mov es,ax
	mov ch,0	;柱面0
	mov dh,0	;扇区0
	mov cl,2	;扇区2
	
	;mov si,0	;记录失败次数的寄存器

readloop:
	mov si,0	;记录失败次数的寄存器

retry:
	mov ah,0x02	;读入磁盘
	mov al,1	;一个扇区
	mov bx,0
	mov dl,0x00	;A驱动器
	int 0x13	;调用磁盘bios
	jnc next	;没出错的话跳转到fin
	add si,1
	cmp si,5
	jae error
	mov ah,0x00
	mov dl,0x00
	int 0x13
	jmp retry

next:
	mov ax,es	;把内存地址后移0x200
	add ax,0x0020	
	mov es,ax	;因为没有add es,0x200指令，所以这里绕个弯
	add cl,1	;往cl里加１
	cmp cl,18	;比较cl与18
	jbe readloop	;如果cl<=18,跳转至readloop
;---------------------3.4 添加部分
	mov cl,1	;一个软盘有80柱面　2个磁头　18扇区
	add dh,1	;3.3里面我们比较读取了18个扇区
	cmp dh,2	;3.4里面我们要读取十个柱面
	jb readloop	;每个柱面包含18个扇区
	mov dh,0
	add ch,1
	cmp ch,cyls
	jb readloop
;---------------------end 3.4添加部分
;---------------------end 3.3添加部分
 putloop:
	;循环显示字符
	;通过0x10中断，显示一个字符
	mov al, [si]
	add si, 1
	cmp al, 0
	je fin
	mov ah, 0x0e
	mov bx, 10
	int 0x10
	jmp putloop
 fin:
	;当需要显示的信息都显示完毕，那么进入死循环
	hlt
	jmp fin
 msg:
	;设定需要显示的字符
	db 0x0a, 0x0a
	db "============="
	db 0x0a
	db 0x0d
	db "Nice day ~~~"
	db 0x0a
	db 0x0d
	db "This is my first 0S"
	db 0x0a
	db 0x0d
	db "copyright GPL"
	db 0x0a
	db 0x0d
	db 0

;---------------------------------3.4添加部分
error:
	db 0x0a, 0x0a
	db "-----------------------"
	db 0x0a
	db 0x0d
	db "error"
	db 0x0a, 0x0d
;---------------------------------end 3.4添加部分
 endpart:
	times 510-($-$$) db 0
	db 0x55, 0xaa
