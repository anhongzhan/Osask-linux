
kernel.out：     文件格式 elf32-i386


Disassembly of section .text:

0000c400 <start>:

  


  # Set up the important data segment registers (DS, ES, SS).
  xorw    %ax,%ax             # Segment number zero
    c400:	31 c0                	xor    %eax,%eax
  movw    %ax,%ds             # -> Data Segment
    c402:	8e d8                	mov    %eax,%ds
  movw    %ax,%es             # -> Extra Segment
    c404:	8e c0                	mov    %eax,%es
  movw    %ax,%ss             # -> Stack Segment
    c406:	8e d0                	mov    %eax,%ss
  
  movb $0x13,%al  # ;vga 320x200x8 位,color mode 
    c408:	b0 13                	mov    $0x13,%al
  movb $0x00,%ah
    c40a:	b4 00                	mov    $0x0,%ah
  int $0x10
    c40c:	cd 10                	int    $0x10
  
#save color mode in ram 0x0ff0
 movb $8,(VMODE)
    c40e:	c6 06 f2             	movb   $0xf2,(%esi)
    c411:	0f 08                	invd   
 movw $320,(SCRNX)
    c413:	c7 06 f4 0f 40 01    	movl   $0x1400ff4,(%esi)
 movw $200,(SCRNY)
    c419:	c7 06 f6 0f c8 00    	movl   $0xc80ff6,(%esi)
 movl $0x000a0000,(VRAM)
    c41f:	66 c7 06 f8 0f       	movw   $0xff8,(%esi)
    c424:	00 00                	add    %al,(%eax)
    c426:	0a 00                	or     (%eax),%al

 #get keyboard led status
 movb	$0x02,%ah 
    c428:	b4 02                	mov    $0x2,%ah
 int     $0x16			#keyboard interrupts
    c42a:	cd 16                	int    $0x16
 movb   %al,(LEDS)
    c42c:	a2 f1 0f be 65       	mov    %al,0x65be0ff1
		
		
		
#diplay something
  movw $msg,%si
    c431:	c4                   	(bad)  
  call puts
    c432:	e8 5d 00 be 81       	call   81bec494 <__bss_start+0x81bdff08>
  
  movw $try,%si
    c437:	c4                   	(bad)  
  call puts
    c438:	e8 57 00 fa fc       	call   fcfac494 <__bss_start+0xfcf9ff08>

0000c43d <seta20.1>:
  # Enable A20:
  #   For backwards compatibility with the earliest PCs, physical
  #   address line 20 is tied low, so that addresses higher than
  #   1MB wrap around to zero by default.  This code undoes this. 
seta20.1:
  inb     $0x64,%al               # Wait for not busy
    c43d:	e4 64                	in     $0x64,%al
  testb   $0x2,%al
    c43f:	a8 02                	test   $0x2,%al
  jnz     seta20.1
    c441:	75 fa                	jne    c43d <seta20.1>

  movb    $0xd1,%al               # 0xd1 -> port 0x64
    c443:	b0 d1                	mov    $0xd1,%al
  outb    %al,$0x64
    c445:	e6 64                	out    %al,$0x64

0000c447 <seta20.2>:

seta20.2:
  inb     $0x64,%al               # Wait for not busy
    c447:	e4 64                	in     $0x64,%al
  testb   $02,%al
    c449:	a8 02                	test   $0x2,%al
  jnz     seta20.2
    c44b:	75 fa                	jne    c447 <seta20.2>

  movb    $0xdf,%al               # 0xdf -> port 0x60
    c44d:	b0 df                	mov    $0xdf,%al
  outb    %al,$0x60
    c44f:	e6 60                	out    %al,$0x60

  # Switch from real to protected mode, using a bootstrap GDT       this is vip ,but i don`t know it clearly now
  # and segment translation that makes virtual addresses 
  # identical to their physical addresses, so that the 
  # effective memory map does not change during the switch.
  lgdt    gdtdesc
    c451:	0f 01 16             	lgdtl  (%esi)
    c454:	d8 c4                	fadd   %st(4),%st
  movl    %cr0, %eax
    c456:	0f 20 c0             	mov    %cr0,%eax
  orl     $CR0_PE_ON, %eax
    c459:	66 83 c8 01          	or     $0x1,%ax
  movl    %eax, %cr0
    c45d:	0f 22 c0             	mov    %eax,%cr0
  
  # Jump to next instruction, but in 32-bit code segment.
  # Switches processor into 32-bit mode.
  ljmp    $PROT_MODE_CSEG, $protcseg
    c460:	ea                   	.byte 0xea
    c461:	a5                   	movsl  %ds:(%esi),%es:(%edi)
    c462:	c4 08                	les    (%eax),%ecx
	...

0000c465 <msg>:
    c465:	0d 0a 0a 0d 6d       	or     $0x6d0d0a0a,%eax
    c46a:	79 20                	jns    c48c <try+0xb>
    c46c:	6b 65 72 6e          	imul   $0x6e,0x72(%ebp),%esp
    c470:	65 6c                	gs insb (%dx),%es:(%edi)
    c472:	20 69 73             	and    %ch,0x73(%ecx)
    c475:	20 72 75             	and    %dh,0x75(%edx)
    c478:	6e                   	outsb  %ds:(%esi),(%dx)
    c479:	69 6e 67 20 6a 6f 73 	imul   $0x736f6a20,0x67(%esi),%ebp
	...

0000c481 <try>:
    c481:	0d 0a 0a 0d 74       	or     $0x740d0a0a,%eax
    c486:	72 79                	jb     c501 <color_screen+0x4>
    c488:	20 69 74             	and    %ch,0x74(%ecx)
    c48b:	20 61 67             	and    %ah,0x67(%ecx)
    c48e:	61                   	popa   
    c48f:	69                   	.byte 0x69
    c490:	6e                   	outsb  %ds:(%esi),(%dx)
	...

0000c492 <puts>:
 try:
  .asciz "\r\n\n\rtry it again"

puts:

	movb (%si),%al
    c492:	8a 04 83             	mov    (%ebx,%eax,4),%al
	add $1,%si
    c495:	c6 01 3c             	movb   $0x3c,(%ecx)
	cmp $0,%al
    c498:	00 74 09 b4          	add    %dh,-0x4c(%ecx,%ecx,1)
	je over
	movb $0x0e,%ah
    c49c:	0e                   	push   %cs
	movw $15,%bx
    c49d:	bb 0f 00 cd 10       	mov    $0x10cd000f,%ebx
	int $0x10
	jmp puts
    c4a2:	eb ee                	jmp    c492 <puts>

0000c4a4 <over>:
over:
	ret	
    c4a4:	c3                   	ret    

0000c4a5 <protcseg>:
	
	
  .code32                     # Assemble for 32-bit mode
protcseg:
  # Set up the protected-mode data segment registers
  movw    $PROT_MODE_DSEG, %ax    # Our data segment selector
    c4a5:	66 b8 10 00          	mov    $0x10,%ax
  movw    %ax, %ds                # -> DS: Data Segment
    c4a9:	8e d8                	mov    %eax,%ds
  movw    %ax, %es                # -> ES: Extra Segment
    c4ab:	8e c0                	mov    %eax,%es
  movw    %ax, %fs                # -> FS
    c4ad:	8e e0                	mov    %eax,%fs
  movw    %ax, %gs                # -> GS
    c4af:	8e e8                	mov    %eax,%gs
  movw    %ax, %ss                # -> SS: Stack Segment
    c4b1:	8e d0                	mov    %eax,%ss
  
  # Set up the stack pointer and call into C.
  movl    $start, %esp
    c4b3:	bc 00 c4 00 00       	mov    $0xc400,%esp
  call bootmain
    c4b8:	e8 21 00 00 00       	call   c4de <bootmain>

0000c4bd <spin>:

  # If bootmain returns (it shouldn't), loop.
spin:
  jmp spin
    c4bd:	eb fe                	jmp    c4bd <spin>
    c4bf:	90                   	nop

0000c4c0 <gdt>:
	...
    c4c8:	ff                   	(bad)  
    c4c9:	ff 00                	incl   (%eax)
    c4cb:	00 00                	add    %al,(%eax)
    c4cd:	9a cf 00 ff ff 00 00 	lcall  $0x0,$0xffff00cf
    c4d4:	00                   	.byte 0x0
    c4d5:	92                   	xchg   %eax,%edx
    c4d6:	cf                   	iret   
	...

0000c4d8 <gdtdesc>:
    c4d8:	17                   	pop    %ss
    c4d9:	00 c0                	add    %al,%al
    c4db:	c4 00                	les    (%eax),%eax
	...

0000c4de <bootmain>:
 *        Company:  ZJUT
 *
 * ==================================================
 */
#include<header.h>
void bootmain(void){
    c4de:	55                   	push   %ebp
    c4df:	89 e5                	mov    %esp,%ebp
    c4e1:	eb fe                	jmp    c4e1 <bootmain+0x3>

0000c4e3 <clear_screen>:
#include<header.h>

void clear_screen(char color) //15:pure white
{
    c4e3:	55                   	push   %ebp
    c4e4:	89 e5                	mov    %esp,%ebp
    c4e6:	0f b6 55 08          	movzbl 0x8(%ebp),%edx
  int i;
  for(i=0xa0000;i<0xaffff;i++)
    c4ea:	b8 00 00 0a 00       	mov    $0xa0000,%eax
  {
  write_mem8(i,color);  //if we write 15 ,all pixels color will be white,15 mens pure white ,so the screen changes into white
    c4ef:	88 10                	mov    %dl,(%eax)
#include<header.h>

void clear_screen(char color) //15:pure white
{
  int i;
  for(i=0xa0000;i<0xaffff;i++)
    c4f1:	83 c0 01             	add    $0x1,%eax
    c4f4:	3d ff ff 0a 00       	cmp    $0xaffff,%eax
    c4f9:	75 f4                	jne    c4ef <clear_screen+0xc>
  {
  write_mem8(i,color);  //if we write 15 ,all pixels color will be white,15 mens pure white ,so the screen changes into white

  }
}
    c4fb:	5d                   	pop    %ebp
    c4fc:	c3                   	ret    

0000c4fd <color_screen>:

void color_screen(char color) //15:pure white
{
    c4fd:	55                   	push   %ebp
    c4fe:	89 e5                	mov    %esp,%ebp
  int i;
  color=color;
  for(i=0xa0000;i<0xaffff;i++)
    c500:	b8 00 00 0a 00       	mov    $0xa0000,%eax
  {
  write_mem8(i,i&0x0f);  //if we write 15 ,all pixels color will be white,15 mens pure white ,so the screen changes into white
    c505:	89 c2                	mov    %eax,%edx
    c507:	83 e2 0f             	and    $0xf,%edx
    c50a:	88 10                	mov    %dl,(%eax)

void color_screen(char color) //15:pure white
{
  int i;
  color=color;
  for(i=0xa0000;i<0xaffff;i++)
    c50c:	83 c0 01             	add    $0x1,%eax
    c50f:	3d ff ff 0a 00       	cmp    $0xaffff,%eax
    c514:	75 ef                	jne    c505 <color_screen+0x8>
  {
  write_mem8(i,i&0x0f);  //if we write 15 ,all pixels color will be white,15 mens pure white ,so the screen changes into white

  }
    c516:	5d                   	pop    %ebp
    c517:	c3                   	ret    
