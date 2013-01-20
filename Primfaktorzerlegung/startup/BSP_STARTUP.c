/**
 ***************************************************************************
 * \file    BSP_STARTUP.c			
 ***************************************************************************
 * \brief   Startupcode for the CARME-Board
 * 
 * \version	4.0.0.0
 * \date	22.09.06
 * \author	sce2
 *
 * 
 *************************************************************************** 
 *  
 * \svn
 * \li	 \$LastChangedDate: 2008-06-26 13:33:25 +0200 (Do, 26 Jun 2008) $
 * \li	 \$LastChangedRevision: 1783 $
 * \li	 \$LastChangedBy: sce2 $
 * \history
 * \li 22.09.06, V1.0.0.0, sce2, created
 * \li 15.05.07, V4.0.0.0, sce2, problem with FIQ handler fixed timer 7-11, 
 * Keyboard and UCB1400 handler added
 ***************************************************************************
 */
#include <stdio.h>
#include <pxa270.h>

/*
*********************************************************************************************************
*  function prototypes
**********************************************************************************************************
*/
void DA_Routine( void ) __attribute__((interrupt("ABORT")));
void FIQ_Routine( void ) __attribute__((interrupt("FIQ")));
void IRQ_Routine( void ) __attribute__((interrupt("IRQ"))) ;
void PA_Routine( void ) __attribute__((interrupt("ABORT")));
void SWI_Routine( void ) __attribute__((interrupt("SWI")));
void UNDEF_Routine( void ) __attribute__((interrupt("UNDEF")));

// external function declaration
#ifdef I2C_INTERRUPT
	void BSP_I2C_IRQHandler();
#endif

#ifdef CAN_INTERRUPT
	#define GPIOX_INTERRUPT
	void BSP_CAN_IRQHandler();
#endif

#ifdef CARMEIO1_INTERRUPT
	#define GPIOX_INTERRUPT
	void BSP_CARMEIO1_IRQHandler();
#endif	
	
#ifdef CARMEIO2_INTERRUPT
	#define GPIOX_INTERRUPT
	void BSP_CARMEIO2_IRQHandler();
#endif		
	
#ifdef MIN3IO_INTERRUPT
	#define GPIOX_INTERRUPT
	void BSP_MIN3IO_IRQHandler();
#endif
	
#ifdef USB_INTERRUPT
	void BSP_USB_IRQHandler();
#endif

#ifdef UART1_INTERRUPT
	#ifndef UART0_INTERRUPT
	void BSP_UART_isr(unsigned char UART_NB);
	#endif
#endif

#ifdef UART0_INTERRUPT
	void BSP_UART_isr(unsigned char UART_NB);
#endif	
	
#ifdef TIMER_4_11_INTERRUPT
	void BSP_TIMER_isr(void);
#endif
	
#ifdef KEYBOARD_INTERRUPT
	void BSP_PS2_KeyBoardIRQHandler(void);
#endif
	
#ifdef UCB1400_INTERRUPT
	void BSP_UCB1400_isr(void);
#endif
				
/**
 *****************************************************************************
 * \fn IRQ_Routine()
 *****************************************************************************
 * \brief 
 * This Interrupthandler is calles when a IRQ occures. It will call the 
 * appropriate function.             									
 * When the Preprocessor-Directive USER_IRQ_ROUTINE is defined, the user must
 * implement his own function.           									
 *****************************************************************************
 * \noparam      none
 *****************************************************************************
 *  \author     E. Stucki                                                   
 *                                                                  
 *  \date       02.10.2006                                   
 *      
 *  \todo       - Add additional Interrupts
 * 				- Default IRQ-Handler                                                                         
 *****************************************************************************
 */
#ifndef USER_IRQ_ROUTINE
void IRQ_Routine (void) {
	unsigned int irq = ICHP;
	if(irq&ICHP_VAL_IRQ){
		irq = (irq >> 16);
		irq &= 0x3f;
		switch (irq) {
			#ifdef I2C_INTERRUPT
			case PER_ID_I2C:
				BSP_I2C_IRQHandler();
				break;
			#endif
						
			#ifdef TIMER_INTERRUPT
			case PER_ID_OSTIMER_0:	
				BSP_Timer_IRQHandler();
				break;
			#endif
			#ifdef TIMER_4_11_INTERRUPT
			case PER_ID_OST:
				BSP_TIMER_isr();
				break;
			#endif
			#ifdef GPIOX_INTERRUPT
			case PER_ID_GPIO_X:	
				#ifdef CAN_INTERRUPT
			  	if(GEDR1&(1<<20)){
					BSP_CAN_IRQHandler();
					GEDR1 = (1<<20);
			  	}
			  	#endif
			  	#ifdef MIN3IO_INTERRUPT
			  	if ((GEDR2 & 0x6c000000) || (GEDR3 & 0x180200) || (GEDR0&(1<<13))) {
			  		BSP_MIN3IO_IRQHandler();
			  		GEDR2 |= 0x6c000000;
			  		GEDR3 |= 0x180200;
			  		GEDR0 |= (1<<13);
			  	}
			  	#endif
				#ifdef CARMEIO1_INTERRUPT
				if (GEDR3 & 0x000000e8) {
					BSP_CARMEIO1_IRQHandler();
					GEDR3 |= 0x000000e8;
				}
				#endif
				#ifdef CARMEIO2_INTERRUPT
				if ((GEDR1 & 0x38) | (GEDR3 & 0x181000)) {
					BSP_CARMEIO2_IRQHandler();
					GEDR1 |= 0x00181000;
					GEDR3 |= 0x00000038;
				}
				#endif
				#ifdef KEYBOARD_INTERRUPT
				if (GEDR0 & 0x100000) {
					BSP_PS2_KeyBoardIRQHandler();
					GEDR0 |= 0x100000;
				}
				#endif
				break;						
			#endif
				
			#ifdef USB_INTERRUPT
			case PER_ID_UDC:	
				BSP_USB_IRQHandler();
				break;
			#endif
			#ifdef UCB1400_INTERRUPT
			case PER_ID_AC97:
				BSP_UCB1400_isr();
				break;	
			#endif
			#ifdef UART0_INTERRUPT
			case PER_ID_FFUART:
				BSP_UART_isr(0);
				break;
			#endif
			#ifdef UART1_INTERRUPT
			case PER_ID_BTUART:
				BSP_UART_isr(1);
				break;
			#endif
			default: 	while (1) ;
						break;	
		}
	}
}
#endif

/**
 *****************************************************************************
 * \fn FIQ_Routine()
 *****************************************************************************
 *\brief 
 * This Interrupthandler is calles when a FIQ occures. It will call the 
 * appropriate function.             									
 * When the Preprocessor-Directive USER_FIQ_ROUTINE is defined, the user must
 * implement his own function.           									
 *****************************************************************************
 * \return      none
 *****************************************************************************
 *  \author     E. Stucki                                                   
 *                                                                  
 *  \date       02.10.2006                                   
 *      
 *  \todo       - Add additional Interrupts  
 * 				- Default FIQ-Handler                                                                       
 *****************************************************************************
 */
#ifndef USER_FIQ_ROUTINE
void FIQ_Routine (void) {
  	unsigned int fiq = ICHP;
  	if(fiq&ICHP_VAL_FIQ){
  		fiq &= 0x3f;
  		switch (fiq) {
						#ifdef I2C_Interrupt
			case 18: 	BSP_I2cInterruptHandler();
						break;
						#endif
			default: 	while (1) ;
						break;	
		}
	}
}
#endif

/**
 *****************************************************************************
 * \fn SWI_Routine()
 *****************************************************************************
 *\brief 
 * This function is called when a Software Interrupt occures.
 * When the Preprocessor-Directive USER_SWI_ROUTINE is defined, the user must
 * implement his own function.           									
 *****************************************************************************
 * \return      none
 *****************************************************************************
 *  \author     E. Stucki                                                   
 *                                                                  
 *  \date       02.10.2006                                   
 *      
 *  \todo       - Stub for interrupt (may be replaced later)                                                                        
 *
 *  \bug        The swi id is unknown
 *****************************************************************************
 */
#ifndef USER_SWI_ROUTINE
void SWI_Routine (void) {
  	while (1) ;	
}
#endif

/**
 *****************************************************************************
 * \fn UNDEF_Routine()
 *****************************************************************************
 * \brief 
 * This function is called when a Undefined instruction is executed.             									
 * When the Preprocessor-Directive USER_UNDEF_ROUTINE is defined, the user must
 * implement his own function.           									
 *****************************************************************************
 * \return      none
 *****************************************************************************
 *  \author     E. Stucki                                                   
 *                                                                  
 *  \date       02.10.2006                                   
 *      
 *  \todo       - Stub for interrupt (may be replaced later)                                                                        
 *
 *  \bug        No bugs known
 *****************************************************************************
 */
#ifndef USER_UNDEF_ROUTINE
void UNDEF_Routine (void) {
	while (1) ;	
}
#endif

/**
 *****************************************************************************
 * \fn DA_Routine ()
 *****************************************************************************
 * \brief 
 * This function is called when a Data Abort occures.             									
 * When the Preprocessor-Directive USER_DA_ROUTINE is defined, the user must
 * implement his own function.           									
 *****************************************************************************
 * \return      none
 *****************************************************************************
 *  \author     E. Stucki                                                   
 *                                                                  
 *  \date       02.10.2006                                   
 *      
 *  \todo       - Stub for interrupt (may be replaced later)                                                                        
 *
 *  \bug        No bugs known
 *****************************************************************************
 */
#ifndef USER_DA_ROUTINE
void DA_Routine (void) {
  	while(1);
}
#endif

/**
 *****************************************************************************
 * \fn PA_Routine()
 *****************************************************************************
 *\brief 
 * This function is called when a Prefetch Abort occures.             									
 * When the Preprocessor-Directive USER_PA_ROUTINE is defined, the user must
 * implement his own function.           									
 *****************************************************************************
 * \return      none
 *****************************************************************************
 *  \author     E. Stucki                                                   
 *                                                                  
 *  \date       02.10.2006                                   
 *      
 *  \todo       - Stub for interrupt (may be replaced later)                                                                        
 *
 *  \bug        No bugs known
 *****************************************************************************
 */
#ifndef USER_PA_ROUTINE
void PA_Routine (void) {
    while(1);	
}
#endif

/**
 *****************************************************************************
 * \fn unsigned int 	pxa27x_get_freq(void)
 *****************************************************************************
 *\brief 
 * TReturn the current lclk requency in units of 1kHz. This code was copied from
 * uboot.         									
 *****************************************************************************
 * \return      Core frequency
 *****************************************************************************
 *  \author     E. Stucki                                                   
 *                                                                  
 *  \date       22.12.2006                                   
 *      
 * \todo		adaption to Code conventions 
 * 
 * \bug        No bugs known
 *****************************************************************************
 */
unsigned int pxa27x_get_freq(void)
{
	unsigned int freq, n,l, ccsr;

	if (CCCR & (1 << 31))
		return 13000;
	ccsr =CCSR;
	l= ccsr & 0x0000001F;	/*	Get L	*/	
	n= (ccsr & 0x00000780)>>7;	/*	Get 2N	*/	
	if( n <2 )	n=2;
	freq = (13 * l * n * 1000 )>>1;	/*	in kHz*/
	return freq;
}

/**
 *****************************************************************************
 * \fn BSP_STARTUP_init()
 *****************************************************************************
 *\brief 
 * startup initialization of the Board. This function is called 
 * 				  befor the main function.            									
 *****************************************************************************
 * \return      	none
 *****************************************************************************
 *  \author     E. Stucki                                                   
 *                                                                  
 *  \date       10.10.2006                                   
 *      
 *****************************************************************************
 */
void BSP_STARTUP_init() {
	
	MSC0 &= ~0xffff0000;	// clear all flags for CS1 (CAN controller)
	MSC0 |= 0x7ff40000; 	// VLIO mode, 32 bit
	
	MSC1 &= ~0xffff0000;	// clear all flags for CS3 (CPLD controller)
	MSC1 |= 0x7ff40000;		// VLIO mode, 32 bit

	// initialize nCS<1,2,3,4> signals (for flash memory)
	GPSR0 	|= 0x00008000;	// nCS<1>
	GPDR0 	|= 0x00008000;	// nCS<1>
	GPSR2 	|= 0x0001c000;	// nCS<2,3,4>
	GPDR2 	|= 0x0001c000;	// nCS<2,3,4>
	
	GAFR0_L &= ~0xc0000000;	// nCS<1>
	GAFR2_L &= ~0xf0000000;	// nCS<2,3>
	GAFR2_U &= ~0x00000003;	// nCS<4>
	
	GAFR0_L |= 0x80000000;	// nCS<1>
	GAFR2_L |= 0xa0000000;	// nCS<2,3>
	GAFR2_U |= 0x00000002;	// nCS<4>
	
	// RDY (GPIO18)
    GPDR0 &= ~(1<<18);            // RDY (GPIO18) as input
    GAFR0_U &= ~(0x00000030);
    GAFR0_U |= 0x00000010;        // alternate function 1(RDY)

    // nPWE (GPIO49)
	GPDR1 |= (1<<17);			// nPWE (GPIO49) as output
	GAFR1_U &= ~(0x0000000c);
	GAFR1_U |= 0x00000008;		// alternate function 2(nPWE)
	
	PSSR |= PSSR_RDH;				// clears the Read Disable Hold bit
	
	// switch of linebuffering for stdout
	setvbuf(stdout, NULL, _IONBF, 0);
	// switch of linebuffering for stdin
	setvbuf(stdin, NULL, _IONBF, 0);
	// switch of linebuffering for stderr
	setvbuf(stderr, NULL, _IONBF, 0);

}
