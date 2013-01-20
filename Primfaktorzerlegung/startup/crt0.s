/**
 *******************************************************************************
 * \file    crt0.s
 *******************************************************************************
 * \brief   Startup code
 *			- vector table
 *			- initialialize SDRAM (only if .set FLASH,1)
 * 			- setup clocks
 *			- initialize stacks
 *			- initialize data section
 *			- clear bss section (uninitialized data)
 *			- exececute BSP_STARTUP_init
 *			- branch in main
 *
 * \version	2.1
 * \date	26.06.08
 * \author	M.Muehlemann
 *
 *
 *******************************************************************************
 *
 * \svn
 * \li   \$LastChangedDate: 2008-06-26 13:33:54 +0200 (Do, 26 Jun 2008) $
 * \li   \$LastChangedRevision: 1784 $
 * \li   \$LastChangedBy: sce2 $
 *******************************************************************************
 */

.include "../startup/pxa270.s"			/* include PXA270 register definitions   */

/*.set FLASH,1 */
.set SDRAM_STARTADDRESS,0xa0000000


/* Stack Sizes ****************************************************************/
.global UND_STACK_SIZE
.global ABT_STACK_SIZE
.global FIQ_STACK_SIZE
.global IRQ_STACK_SIZE
.global SVC_STACK_SIZE
.global USR_STACK_SIZE
.set  UND_STACK_SIZE, 0x00000200	/* stack for "undefined instruction"	  */
.set  ABT_STACK_SIZE, 0x00000200	/* stack for "abort" interrupts			  */
.set  FIQ_STACK_SIZE, 0x00000200	/* stack for "FIQ" interrupts			  */
.set  IRQ_STACK_SIZE, 0X00000200	/* stack for "IRQ" normal interrupts	  */
.set  SVC_STACK_SIZE, 0x00000200	/* stack for "SVC" supervisor mode		  */
.set  USR_STACK_SIZE, 0x00002000	/* stack for "User" mode				  */

/* Standard definitions of Mode bits and Interrupt (I & F) flags (ion CPSR)	***/
.set  MODE_USR, 0x10				/* Normal User Mode						  */
.set  MODE_FIQ, 0x11				/* FIQ Processing Fast Interrupts Mode	  */
.set  MODE_IRQ, 0x12				/* IRQ Processing Standard Interrupts Mode*/
.set  MODE_SVC, 0x13				/* Software Interrupts Mode				  */
.set  MODE_ABT, 0x17				/* Abort Processing memory Faults Mode	  */
.set  MODE_UND, 0x1B				/* Undefined Instructions Mode			  */
.set  MODE_SYS, 0x1F 				/* System Priviledged Operating Mode	  */

.set  I_BIT, 0x80					/* when I bit is set, IRQ is disabled	  */
.set  F_BIT, 0x40					/* when F bit is set, FIQ is disabled	  */

.text
.arm								/* generate ARM-Code					  */


.global _startup
.section .startup

/************* Exception vector table *****************************************/
_startup:
reset:			b Reset_Handler		/* 0x00 reset vector 					  */
undefvec:		b UNDEF_Routine		/* 0x04 undef. instruction vector		  */
wivec:			b SWI_Routine		/* 0x08 software interrupt vector		  */
pabtvec:		b PA_Routine		/* 0x0c prefetch abort vector			  */
dabtvec:		b DA_Routine		/* 0x10 data abort vector				  */
rsvdvec:		b rsvdvec			/* 0x14 reserved (not used by XSCALE)	  */
irqvec:			b UART_read_irq		/* 0x18 interrupt vector		  		  */
fiqvec:			b FIQ_Routine		/* 0x1c fast interrupt vector		  	  */

/*
 * The following macro should be used when software needs to be
 * assured that a CP15 update has taken effect.
 * It may only be used while in a privileged mode, because it
 * accesses CP15.
 */
.macro cp_wait
    MRC P15, 0, R0, C2, C0, 0 @ arbitrary read of CP15
    MOV R0, R0                @ wait for it
    SUB PC, PC, #4            @ branch to next instruction
    @ At this point, any previous CP15 writes are
    @ guaranteed to have taken effect.
.endm

Reset_Handler:

/************ mask all interrupts ***********************************************/
	mov r1,#0;
	ldr r0,=ICMR
	str r1, [r0]
	ldr r0,=ICMR2
	str r1, [r0]

/************ initialize Memory- and SDRAM-Controller *************************/

.ifdef FLASH
	/* refer section 6.4.10 in the PXA27x manual  							  */
	/* 1. wait at least 200 uS until clocks are stabilized					  */
	ldr r0, =OSCR
	mov r1, #0
	str r1,[r0]				/* reset OS-Timer (Clock: 3.25MHz)				  */
wait_loop:
	ldr r1,[r0]
	cmp r1,#0x290			/* 0x290 ~ 650-> 650*1/3.25MHz ~ 200 us 		  */
	bls wait_loop


	/* step 1a. initialize memory controller								  */
	mov r0, #MEMC_BASE		/* load memory controller base address			  */

	ldr r1, =0x000095f2
	str r1, [r0,#MSC0_OFFSET]

	ldr r1, =0x0000f974
	str r1, [r0,#MSC1_OFFSET]

	ldr r1, =0x00000000
	str r1, [r0,#MSC2_OFFSET]

	/* step 1c.  set the DVAL<0> and DVAL<1> polarity to active high*/
	ldr r1, =0x00010001
	str r1, [r0,#FLYCNFG_OFFSET]

	/* step 1d. Reset the system aprppropriatley
	9 col adress bits, 13 row address bits, 4 SDRAM banks,
	tRP=3clks, CL=3, tRCD=3 clks, tRAS=7clks, tRC=10 clks
	normal addressing mode, All ADRAM disabled 								  */
	ldr r1, =0x08000ac8
	str r1, [r0,#MDCNFG_OFFSET]

	/* step 1e: Configure refresh											  */
	ldr r1, =0x23ca401E;
	str r1, [r0,#MDREFR_OFFSET]


	/* K0RUN=1
	K0DB2=1, K0DB4=1
	K0FREE=1, K1FREE=0, K2FREE=0
	-> Self-refresh */
	ldr r1, =0x20ca401E;
	str r1, [r0,#MDREFR_OFFSET]

	/* step 2: Initialize Synchronous static FLASH							  */
	ldr r1, =0x40044004;
	str r1, [r0,#SXCNFG_OFFSET]
	SXCNFG = 0x40044004;

	/* step 3: Toggle SDRAM controller through the following state sequence:
		K0FREE=0, K1FREE=0, K2FREE=0
		K1RUN=1,K2DB2=0
		-> Self-refresh (1 too) */
	ldr r1, =0x2043601E;
	str r1, [r0,#MDREFR_OFFSET]

	/* SLFRSH = 0															  */
	ldr r1, =0x2003601E;
	str r1, [r0,#MDREFR_OFFSET]

	/* E1PIN = 1															  */
	ldr r1, =0x2003e01E;
	str r1, [r0,#MDREFR_OFFSET]
	/* -> NOP (wo write required)											  */

	/* step 4: configure , but not enable SDRAM Partition					  */
	ldr r1, =0x08000ac8;
	str r1, [r0,#MDCNFG_OFFSET]

	ldr r1, =0xffffffff;
	str r1, [r0,#BSCNTR0_OFFSET]

	ldr r1, =0xffffff5f;
	str r1, [r0,#BSCNTR1_OFFSET]

	ldr r1, =0xffffffff;
	str r1, [r0,#BSCNTR2_OFFSET]

	ldr r1, =0xffffffff;
	str r1, [r0,#BSCNTR3_OFFSET]

	/* step 5 wait at least 200 uS											  */
	ldr r2, =OSCR
	mov r3, #0
	str r3,[r2]				/* reset OS-Timer (Clock: 3.25MHz)				  */
wait_loop1:
	ldr r3,[r2]
	cmp r3,#0x290			/* 0x290 ~ 650-> 650*1/3.25MHz ~ 200 us 		  */
	bls wait_loop1

	/* step 7: trigger 8 refresh cycles										  */
	ldr r2,=SDRAM_STARTADDRESS
	mov r1,#0
	mov r3,#8
loop3:
	str r1,[r2]
	subs r3,r3,#1
	bne loop3

    /* step 9: Enable SDRAM Partition 0 									  */
	ldr r1, =0x08000ac9;
	str r1, [r0,#MDCNFG_OFFSET]

    /* step 10: Write the MDMRS register to trigger an MRS command to
                all enabled SDRAM banks
     -> PALL -> MRS -> NOP */
    ldr r1, =0x00000000;
	str r1, [r0,#MDMRS_OFFSET]

    /* step 11: enable auto-power-down
    APD = 0 */
    ldr r1, =0x2013e01E;
	str r1, [r0,#MDREFR_OFFSET]

.endif

/************ initialize Clocks ***********************************************/
	ldr	r0,  =CKEN
	ldr	r1,  =0x00400000 /* disable all clocks expect the memory controller	  */
	str	r1,  [r0]

	ldr	r0,  =CCCR
	ldr	r1,  =0x02000290 /* setup core clock to 520 MHz (l=16, 2N=5, A=1)	  */
	str	r1,  [r0]

	/* write CLKCFG register */
	mov r1, #0xb	/* T=1, F=1, B=1									  */
	mcr	p14, 0, r1, c6, c0, 0

	/* Re-write MDREFR */
	ldr	r0, =MEMC_BASE
	ldr	r1, [r0, #MDREFR_OFFSET]
	str	r1, [r0, #MDREFR_OFFSET]

/************ Enable the Instruction Cache ************************************/
    MRC P15, 0, R0, C1, C0, 0   /* Get the control register                   */
    ORR R0, R0, #0x1000         /* set bit 12 -- the I bit                    */
    MCR P15, 0, R0, C1, C0, 0   /* Set the control register                   */
    cp_wait

/************ Enable the Instruction Cache ************************************/
    MCR p15, 0, r0, c7, c10, 4 @ Drain pending data operations...
    @ (see Chapter 7.2.8, Register 7: Cache functions)
    MRC p15, 0, r0, c1, c0, 0  @ Get current control register
    ORR r0, r0, #4             @ Enable DCache by setting ‘C’ (bit 2)
    MCR p15, 0, r0, c1, c0, 0  @ And update the Control register
/************ Setup a stack for each mode *************************************/

	ldr r0, =_und_stack_top_address
	/* Undefined Instruction Mode 											  */
	msr CPSR_c, #MODE_UND|I_BIT|F_BIT 	/* switch in UndefinedInstruction Mode*/
	mov sp, r0
	sub r0, r0, #UND_STACK_SIZE

	/* Abort Mode 															  */
	msr CPSR_c, #MODE_ABT|I_BIT|F_BIT 	/* switch in Abort Mode				  */
	mov sp, r0
	sub r0, r0, #ABT_STACK_SIZE

	/* FIQ Mode 															  */
	msr CPSR_c, #MODE_FIQ|I_BIT|F_BIT 	/* switch in FIQ Mode				  */
	mov sp, r0
	sub r0, r0, #FIQ_STACK_SIZE

	/* IRQ Mode 															  */
	msr CPSR_c, #MODE_IRQ|I_BIT|F_BIT 	/* switch in IRQ Mode				  */
	mov sp, r0
	sub r0, r0, #IRQ_STACK_SIZE

	/* switch in Supervisor Mode											  */
	msr CPSR_c, #MODE_SVC|I_BIT|F_BIT 	/* switch in Supervisor Mode		  */
	mov sp, r0
	sub r0, r0, #SVC_STACK_SIZE

	/* switch in User Mode													  */
	msr CPSR_c, #MODE_SYS|I_BIT|F_BIT 	/* switch in User Mode				  */
	mov sp, r0

/* copy .data section initialize ininialized variables	***********************/
    ldr     R1, =_etext
    ldr     R2, =_data
    ldr     R3, =_edata
cpydata_loop:
  	cmp     R2, R3
    ldrlo   R0, [R1], #4
	strlo   R0, [R2], #4
	blo     cpydata_loop

/* Clear .bss section (uninitialized data, stack) *****************************/
    mov     R0, #0
    ldr     R1, =_bss_start
    ldr     R2, =_bss_end
zerobss_loop:
	cmp     R1, R2
    strlo   R0, [R1], #4
    blo     zerobss_loop

/* Enter the C code  **********************************************************/
    bl BSP_STARTUP_init
    b main
loop:
    b loop


.end
