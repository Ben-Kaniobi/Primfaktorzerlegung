/*
 ***************************************************************************
 * \file    pxa270.s
 ***************************************************************************
 * \brief   This program is free software/* you can redistribute it and/or modify
 *			it under the terms of the GNU General Public License version 2 as
 * 			published by the Free Software Foundation.
 *
 * Copyright:	MontaVista Software Inc.
 *
 * \version	0.3
 * \date	Jun 15, 2001
 * \author	Nicolas Pitre
 *
 ***************************************************************************
 *
 * \remark  Subversion:
 * 			$LastChangedDate: 2008-06-26 13:33:54 +0200 (Do, 26 Jun 2008) $
 * 			$LastChangedRevision: 1784 $
 * 			$LastChangedBy: sce2 $
 * 			Last Modifications:
 *			- 2003/01/20: Robert Schwebel <r.schwebel@pengutronix.de
 *   		  Original file taken from linux-2.4.19-rmk4-pxa1. Added some definitions.
 *   		  Added include for hardware.h (for __REG definition)
 * 			- 2005/10/10: Martin Aebersold (aom1) <martin.aebersold@bfh.ch>
 *   		  Replaced __REG as pointer type to access the registers for standalone
 *            apps with the gnu toolchain.
 * 			- 2006/09/22: Erwin Stucki (sce2) <erwin.stucki@bfh.ch>
 * 			  Added some definitions for the PXA270.
 ***************************************************************************
 *  \todo - This file was built for the pxa255. There are still some missing registers
 * 				completed Modules: 	Interrupt, SSP and PWM
 *
 **************************************************************************
 */

.ifndef _PXA_REGS_H_
.set _PXA_REGS_H_, 1


/* PXA Chip selects */

.arm
.set PXA_CS0_PHYS,	0x00000000
.set PXA_CS1_PHYS,	0x04000000
.set PXA_CS2_PHYS,	0x08000000
.set PXA_CS3_PHYS,	0x0C000000
.set PXA_CS4_PHYS,	0x10000000
.set PXA_CS5_PHYS,	0x14000000


/*
 * DMA Controller
 */

.set DCSR0, 0x40000000 			/* DMA Control / Status Register for Channel 0*/
.set DCSR1, 0x40000004 			/* DMA Control / Status Register for Channel 1*/
.set DCSR2, 0x40000008 			/* DMA Control / Status Register for Channel 2*/
.set DCSR3, 0x4000000c 			/* DMA Control / Status Register for Channel 3*/
.set DCSR4, 0x40000010 			/* DMA Control / Status Register for Channel 4*/
.set DCSR5, 0x40000014 			/* DMA Control / Status Register for Channel 5*/
.set DCSR6, 0x40000018 			/* DMA Control / Status Register for Channel 6*/
.set DCSR7, 0x4000001c 			/* DMA Control / Status Register for Channel 7*/
.set DCSR8, 0x40000020 			/* DMA Control / Status Register for Channel 8*/
.set DCSR9, 0x40000024 			/* DMA Control / Status Register for Channel 9*/
.set DCSR10, 0x40000028			/* DMA Control / Status Register for Channel 10*/
.set DCSR11, 0x4000002c			/* DMA Control / Status Register for Channel 11*/
.set DCSR12, 0x40000030	 		/* DMA Control / Status Register for Channel 12*/
.set DCSR13, 0x40000034			/* DMA Control / Status Register for Channel 13*/
.set DCSR14, 0x40000038 		/* DMA Control / Status Register for Channel 14*/
.set DCSR15, 0x4000003c 		/* DMA Control / Status Register for Channel 15*/


.set DINT, 0x400000f0 			/* DMA Interrupt Register*/

.set DRCMR0, 0x40000100 		/* Request to Channel Map Register for DREQ 0*/
.set DRCMR1, 0x40000104 		/* Request to Channel Map Register for DREQ 1*/
.set DRCMR2, 0x40000108 		/* Request to Channel Map Register for I2S receive Request*/
.set DRCMR3, 0x4000010c 		/* Request to Channel Map Register for I2S transmit Request*/
.set DRCMR4, 0x40000110 		/* Request to Channel Map Register for BTUART receive Request*/
.set DRCMR5, 0x40000114 		/* Request to Channel Map Register for BTUART transmit Request.*/
.set DRCMR6, 0x40000118 		/* Request to Channel Map Register for FFUART receive Request*/
.set DRCMR7, 0x4000011c 		/* Request to Channel Map Register for FFUART transmit Request*/
.set DRCMR8, 0x40000120 		/* Request to Channel Map Register for AC97 microphone Request*/
.set DRCMR9, 0x40000124 		/* Request to Channel Map Register for AC97 modem receive Request*/
.set DRCMR10, 0x40000128		/* Request to Channel Map Register for AC97 modem transmit Request*/
.set DRCMR11, 0x4000012c		/* Request to Channel Map Register for AC97 audio receive Request*/
.set DRCMR12, 0x40000130		/* Request to Channel Map Register for AC97 audio transmit Request*/
.set DRCMR13, 0x40000134 		/* Request to Channel Map Register for SSP receive Request*/
.set DRCMR14, 0x40000138 		/* Request to Channel Map Register for SSP transmit Request*/
.set DRCMR15, 0x4000013c 		/* Reserved*/
.set DRCMR16, 0x40000140 		/* Reserved*/
.set DRCMR17, 0x40000144 		/* Request to Channel Map Register for ICP receive Request*/
.set DRCMR18, 0x40000148 		/* Request to Channel Map Register for ICP transmit Request*/
.set DRCMR19, 0x4000014c 		/* Request to Channel Map Register for STUART receive Request*/
.set DRCMR20, 0x40000150 		/* Request to Channel Map Register for STUART transmit Request*/
.set DRCMR21, 0x40000154 		/* Request to Channel Map Register for MMC receive Request*/
.set DRCMR22, 0x40000158 		/* Request to Channel Map Register for MMC transmit Request*/
.set DRCMR23, 0x4000015c 		/* Reserved*/
.set DRCMR24, 0x40000160 		/* Reserved*/
.set DRCMR25, 0x40000164 		/* Request to Channel Map Register for USB endpoint 1 Request*/
.set DRCMR26, 0x40000168 		/* Request to Channel Map Register for USB endpoint 2 Request*/
.set DRCMR27, 0x4000016C 		/* Request to Channel Map Register for USB endpoint 3 Request*/
.set DRCMR28, 0x40000170 		/* Request to Channel Map Register for USB endpoint 4 Request*/
.set DRCMR29, 0x40000174 		/* Reserved*/
.set DRCMR30, 0x40000178 		/* Request to Channel Map Register for USB endpoint 6 Request*/
.set DRCMR31, 0x4000017C 		/* Request to Channel Map Register for USB endpoint 7 Request*/
.set DRCMR32, 0x40000180 		/* Request to Channel Map Register for USB endpoint 8 Request*/
.set DRCMR33, 0x40000184 		/* Request to Channel Map Register for USB endpoint 9 Request*/
.set DRCMR34, 0x40000188 		/* Reserved*/
.set DRCMR35, 0x4000018C 		/* Request to Channel Map Register for USB endpoint 11 Request*/
.set DRCMR36, 0x40000190 		/* Request to Channel Map Register for USB endpoint 12 Request*/
.set DRCMR37, 0x40000194 		/* Request to Channel Map Register for USB endpoint 13 Request*/
.set DRCMR38, 0x40000198 		/* Request to Channel Map Register for USB endpoint 14 Request*/
.set DRCMR39, 0x4000019C 		/* Reserved*/

.set DRCMR68, 0x40001110 		/* Request to Channel Map Register for Camera FIFO 0 Request*/
.set DRCMR69, 0x40001114 		/* Request to Channel Map Register for Camera FIFO 1 Request*/
.set DRCMR70, 0x40001118 		/* Request to Channel Map Register for Camera FIFO 2 Request*/

.set DRCMRRXSADR,		DRCMR2
.set DRCMRTXSADR,		DRCMR3
.set DRCMRRXBTRBR,		DRCMR4
.set DRCMRTXBTTHR,		DRCMR5
.set DRCMRRXFFRBR,		DRCMR6
.set DRCMRTXFFTHR,		DRCMR7
.set DRCMRRXMCDR,		DRCMR8
.set DRCMRRXMODR,		DRCMR9
.set DRCMRTXMODR,		DRCMR10
.set DRCMRRXPCDR,		DRCMR11
.set DRCMRTXPCDR,		DRCMR12
.set DRCMRRXSSDR,		DRCMR13
.set DRCMRTXSSDR,		DRCMR14
.set DRCMRRXICDR,		DRCMR17
.set DRCMRTXICDR,		DRCMR18
.set DRCMRRXSTRBR,		DRCMR19
.set DRCMRTXSTTHR,		DRCMR20
.set DRCMRRXMMC,		DRCMR21
.set DRCMRTXMMC,		DRCMR22

.set DRCMR_CHLNUM,	0x0f		/* mask for Channel Number (read / write)*/

.set DDADR0, 0x40000200 		/* DMA Descriptor Address Register Channel 0*/
.set DSADR0, 0x40000204 		/* DMA Source Address Register Channel 0*/
.set DTADR0, 0x40000208 		/* DMA Target Address Register Channel 0*/
.set DCMD0, 0x4000020c 			/* DMA Command Address Register Channel 0*/
.set DDADR1, 0x40000210 		/* DMA Descriptor Address Register Channel 1*/
.set DSADR1, 0x40000214 		/* DMA Source Address Register Channel 1*/
.set DTADR1, 0x40000218 		/* DMA Target Address Register Channel 1*/
.set DCMD1, 0x4000021c 			/* DMA Command Address Register Channel 1*/
.set DDADR2, 0x40000220 		/* DMA Descriptor Address Register Channel 2*/
.set DSADR2, 0x40000224 		/* DMA Source Address Register Channel 2*/
.set DTADR2, 0x40000228 		/* DMA Target Address Register Channel 2*/
.set DCMD2, 0x4000022c 			/* DMA Command Address Register Channel 2*/
.set DDADR3, 0x40000230 		/* DMA Descriptor Address Register Channel 3*/
.set DSADR3, 0x40000234 		/* DMA Source Address Register Channel 3*/
.set DTADR3, 0x40000238 		/* DMA Target Address Register Channel 3*/
.set DCMD3, 0x4000023c 			/* DMA Command Address Register Channel 3*/
.set DDADR4, 0x40000240 		/* DMA Descriptor Address Register Channel 4*/
.set DSADR4, 0x40000244 		/* DMA Source Address Register Channel 4*/
.set DTADR4, 0x40000248 		/* DMA Target Address Register Channel 4*/
.set DCMD4, 0x4000024c 			/* DMA Command Address Register Channel 4*/
.set DDADR5, 0x40000250		 	/* DMA Descriptor Address Register Channel 5*/
.set DSADR5, 0x40000254 		/* DMA Source Address Register Channel 5*/
.set DTADR5, 0x40000258 		/* DMA Target Address Register Channel 5*/
.set DCMD5, 0x4000025c 			/* DMA Command Address Register Channel 5*/
.set DDADR6, 0x40000260 		/* DMA Descriptor Address Register Channel 6*/
.set DSADR6, 0x40000264 		/* DMA Source Address Register Channel 6*/
.set DTADR6, 0x40000268 		/* DMA Target Address Register Channel 6*/
.set DCMD6, 0x4000026c 			/* DMA Command Address Register Channel 6*/
.set DDADR7, 0x40000270 		/* DMA Descriptor Address Register Channel 7*/
.set DSADR7, 0x40000274 		/* DMA Source Address Register Channel 7*/
.set DTADR7, 0x40000278 		/* DMA Target Address Register Channel 7*/
.set DCMD7, 0x4000027c 			/* DMA Command Address Register Channel 7*/
.set DDADR8, 0x40000280	 		/* DMA Descriptor Address Register Channel 8*/
.set DSADR8, 0x40000284 		/* DMA Source Address Register Channel 8*/
.set DTADR8, 0x40000288 		/* DMA Target Address Register Channel 8*/
.set DCMD8, 0x4000028c 			/* DMA Command Address Register Channel 8*/
.set DDADR9, 0x40000290 		/* DMA Descriptor Address Register Channel 9*/
.set DSADR9, 0x40000294 		/* DMA Source Address Register Channel 9*/
.set DTADR9, 0x40000298 		/* DMA Target Address Register Channel 9*/
.set DCMD9, 0x4000029c 			/* DMA Command Address Register Channel 9*/
.set DDADR10, 0x400002a0 		/* DMA Descriptor Address Register Channel 10*/
.set DSADR10, 0x400002a4 		/* DMA Source Address Register Channel 10*/
.set DTADR10, 0x400002a8 		/* DMA Target Address Register Channel 10*/
.set DCMD10, 0x400002ac 		/* DMA Command Address Register Channel 10*/
.set DDADR11, 0x400002b0 		/* DMA Descriptor Address Register Channel 11*/
.set DSADR11, 0x400002b4 		/* DMA Source Address Register Channel 11*/
.set DTADR11, 0x400002b8 		/* DMA Target Address Register Channel 11*/
.set DCMD11, 0x400002bc 		/* DMA Command Address Register Channel 11*/
.set DDADR12, 0x400002c0 		/* DMA Descriptor Address Register Channel 12*/
.set DSADR12, 0x400002c4 		/* DMA Source Address Register Channel 12*/
.set DTADR12, 0x400002c8 		/* DMA Target Address Register Channel 12*/
.set DCMD12, 0x400002cc 		/* DMA Command Address Register Channel 12*/
.set DDADR13, 0x400002d0	 	/* DMA Descriptor Address Register Channel 13*/
.set DSADR13, 0x400002d4 		/* DMA Source Address Register Channel 13*/
.set DTADR13, 0x400002d8 		/* DMA Target Address Register Channel 13*/
.set DCMD13, 0x400002dc 		/* DMA Command Address Register Channel 13*/
.set DDADR14, 0x400002e0 		/* DMA Descriptor Address Register Channel 14*/
.set DSADR14, 0x400002e4 		/* DMA Source Address Register Channel 14*/
.set DTADR14, 0x400002e8 		/* DMA Target Address Register Channel 14*/
.set DCMD14, 0x400002ec 		/* DMA Command Address Register Channel 14*/
.set DDADR15, 0x400002f0 		/* DMA Descriptor Address Register Channel 15*/
.set DSADR15, 0x400002f4 		/* DMA Source Address Register Channel 15*/
.set DTADR15, 0x400002f8 		/* DMA Target Address Register Channel 15*/
.set DCMD15, 0x400002fc 		/* DMA Command Address Register Channel 15*/

/*
 * UARTs
 */

/* Full Function UART (FFUART)*/
.set FFRBR, 0x40100000 			/* Receive Buffer Register (read only)*/
.set FFTHR, 0x40100000 			/* Transmit Holding Register (write only)*/
.set FFIER, 0x40100004 			/* Interrupt Enable Register (read/write)*/
.set FFIIR, 0x40100008 			/* Interrupt ID Register (read only)*/
.set FFFCR, 0x40100008 			/* FIFO Control Register (write only)*/
.set FFLCR, 0x4010000C 			/* Line Control Register (read/write)*/
.set FFMCR, 0x40100010 			/* Modem Control Register (read/write)*/
.set FFLSR, 0x40100014 			/* Line Status Register (read only)*/
.set FFMSR, 0x40100018 			/* Modem Status Register (read only)*/
.set FFSPR, 0x4010001C 			/* Scratch Pad Register (read/write)*/
.set FFISR, 0x40100020 			/* Infrared Selection Register (read/write)*/
.set FFFOR, 0x40100024 			/* Receive FIFO Occupancy Register (read/write)*/
.set FFDLL, 0x40100000 			/* Divisor Latch Low Register (DLAB = 1) (read/write)*/
.set FFDLH, 0x40100004 			/* Divisor Latch High Register (DLAB = 1) (read/write)*/

/* Bluetooth UART (BTUART)*/
.set BTRBR, 0x40200000 			/* Receive Buffer Register (read only)*/
.set BTTHR, 0x40200000 			/* Transmit Holding Register (write only)*/
.set BTIER, 0x40200004 			/* Interrupt Enable Register (read/write)*/
.set BTIIR, 0x40200008 			/* Interrupt ID Register (read only)*/
.set BTFCR, 0x40200008 			/* FIFO Control Register (write only)*/
.set BTLCR, 0x4020000C 			/* Line Control Register (read/write)*/
.set BTMCR, 0x40200010 			/* Modem Control Register (read/write)*/
.set BTLSR, 0x40200014 			/* Line Status Register (read only)*/
.set BTMSR, 0x40200018 			/* Modem Status Register (read only)*/
.set BTSPR, 0x4020001C 			/* Scratch Pad Register (read/write)*/
.set BTISR, 0x40200020 			/* Infrared Selection Register (read/write)*/
.set BTFOR, 0x40200024 			/* Receive FIFO Occupancy Register (read/write)*/
.set BTDLL, 0x40200000 			/* Divisor Latch Low Register (DLAB = 1) (read/write)*/
.set BTDLH, 0x40200004 			/* Divisor Latch High Register (DLAB = 1) (read/write)*/

/* Standard UART (STUART)*/
.set STRBR, 0x40700000 			/* Receive Buffer Register (read only)*/
.set STTHR, 0x40700000 			/* Transmit Holding Register (write only)*/
.set STIER, 0x40700004 			/* Interrupt Enable Register (read/write)*/
.set STIIR, 0x40700008 			/* Interrupt ID Register (read only)*/
.set STFCR, 0x40700008 			/* FIFO Control Register (write only)*/
.set STLCR, 0x4070000C 			/* Line Control Register (read/write)*/
.set STMCR, 0x40700010 			/* Modem Control Register (read/write)*/
.set STLSR, 0x40700014 			/* Line Status Register (read only)*/
.set STMSR, 0x40700018 			/* Reserved*/
.set STSPR, 0x4070001C 			/* Scratch Pad Register (read/write)*/
.set STISR, 0x40700020 			/* Infrared Selection Register (read/write)*/
.set STFOR, 0x40700024 			/* Receive FIFO Occupancy Register (read/write)*/
.set STDLL, 0x40700000 			/* Divisor Latch Low Register (DLAB = 1) (read/write)*/
.set STDLH, 0x40700004 			/* Divisor Latch High Register (DLAB = 1) (read/write)*/

/*
 /* I2C registers*/


.set IBMR, 0x40301680 			/* I2C Bus Monitor Register - IBMR*/
.set IDBR, 0x40301688 			/* I2C Data Buffer Register - IDBR*/
.set ICR	, 0x40301690 		/* I2C Control Register - ICR*/
.set ISR	, 0x40301698 		/* I2C Status Register - ISR*/
.set ISAR, 0x403016A0 			/* I2C Slave Address Register - ISAR*/

.set PWRIBMR, 0x40f00180 		/* Power I2C Bus Monitor Register-IBMR*/
.set PWRIDBR, 0x40f00188 		/* Power I2C Data Buffer Register-IDBR*/
.set PWRICR, 0x40f00190 		/* Power I2C Control Register - ICR*/
.set PWRISR, 0x40f00198 		/* Power I2C Status Register - ISR*/
.set PWRISAR, 0x40f001A0 		/* Power I2C Slave Address Register-ISAR*/

/* ----- Control register bits ----------------------------------------*/

.set ICR_START,	0x1				/* start bit*/
.set ICR_STOP,	0x2				/* stop bit*/
.set ICR_ACKNAK,	0x4				/* send ACK(0) or NAK(1)*/
.set ICR_TB,		0x8 			/* transfer byte bit*/
.set ICR_MA,		0x10			/* master abort*/
.set ICR_SCLE,	0x20			/* master clock enable*/
.set ICR_IUE,		0x40		/* unit enable*/
.set ICR_GCD,		0x80		/* general call disable*/
.set ICR_ITEIE,	0x100			/* enable tx interrupts*/
.set ICR_IRFIE,	0x200			/* enable rx interrupts*/
.set ICR_BEIE,	0x400			/* enable bus error ints*/
.set ICR_SSDIE,	0x800			/* slave STOP detected int enable*/
.set ICR_ALDIE,	0x1000  		/* enable arbitration interrupt*/
.set ICR_SADIE,	0x2000			/* slave address detected int enable*/
.set ICR_UR,		0x4000			/* unit reset*/
.set ICR_FM,		0x8000			/* Fast Mode*/

/* ----- Status register bits -----------------------------------------*/

.set ISR_RWM,         0x1		/* read/write mode*/
.set ISR_ACKNAK,      0x2		/* ack/nak status*/
.set ISR_UB,          0x4		/* unit busy*/
.set ISR_IBB,         0x8		/* bus busy*/
.set ISR_SSD,         0x10		/* slave stop detected*/
.set ISR_ALD,         0x20		/* arbitration loss detected*/
.set ISR_ITE,         0x40   	 /* tx buffer empty*/
.set ISR_IRF,         0x80   	 /* rx buffer full*/
.set ISR_GCAD,        0x100		/* general call address detected*/
.set ISR_SAD,         0x200		/* slave address detected*/
.set ISR_BED,         0x400  	 /* bus error no ACK/NAK*/

/*
 * AC97 Controller registers
*/

.set POCR, 0x40500000  			/* PCM Out Control Register*/

.set PICR, 0x40500004  			/* PCM In Control Register*/

.set MCCR, 0x40500008  			/* Mic In Control Register*/

.set GCR, 0x4050000C  			/* Global Control Register*/

.set POSR, 0x40500010  			/* PCM Out Status Register*/

.set PISR, 0x40500014  			/* PCM In Status Register*/

.set MCSR, 0x40500018  			/* Mic In Status Register*/

.set GSR, 0x4050001C  			/* Global Status Register*/

.set CAR, 0x40500020  			/* CODEC Access Register*/

.set PCDR, 0x40500040  			/* PCM FIFO Data Register*/
.set MCDR, 0x40500060  			/* Mic-in FIFO Data Register*/

.set MOCR, 0x40500100  			/* Modem Out Control Register */

.set MICR, 0x40500108  			/* Modem In Control Register */

.set MOSR, 0x40500110  			/* Modem Out Status Register */

.set MISR, 0x40500118  			/* Modem In Status Register */

.set MODR, 0x40500140  			/* Modem FIFO Data Register */

.set PAC_REG_BASE, 0x40500200 	/* Primary Audio Codec*/
.set SAC_REG_BASE, 0x40500300 	/* Secondary Audio Codec*/
.set PMC_REG_BASE, 0x40500400 	/* Primary Modem Codec*/
.set SMC_REG_BASE, 0x40500500 	/* Secondary Modem Codec*/

/*
 * USB Device Controller
 */
.set UDCCR, 0x40600000			/* UDC Control Register */



.set UDCICR0, 0x40600004		/* UDC Interrupt Control register 0*/

.set UDCICR1, 0x40600008		/* UDC Interrupt Control register 1*/


.set UDCISR0, 0x4060000c		/* UDC Interrupt Status register 0*/

 .set UDCISR1, 0x40600010		/* UDC Interrupt Status register 1*/


.set UDCFNR, 0x40600014			/* UDC Frame Number Register */

.set UDCOTGICR, 0x40600018		/* UDC OTG Interrupt Control Register */
.set UDCOTGISR, 0x4060001C		/* UDC OTG Interrupt Status Register */

.set UP2OCR, 0x40600020			/* USB Port 2 Output Control Register */


.set UP3OCR, 0x40600024			/* USB Port 3 Output Control Register */


.set UDCCSR0, 0x40600100		/* ep 0 control/status Register */

/* Control/status registers for Endpoints A-X*/
.set UDCCSRA, 0x40600104		/* UDC Control/Status Register Endpoint A*/
.set UDCCSRB, 0x40600108		/* UDC Control/Status Register Endpoint B*/
.set UDCCSRC, 0x4060010C		/* UDC Control/Status Register Endpoint C*/
.set UDCCSRD, 0x40600110		/* UDC Control/Status Register Endpoint D*/
.set UDCCSRE, 0x40600114		/* UDC Control/Status Register Endpoint E*/
.set UDCCSRF, 0x40600118		/* UDC Control/Status Register Endpoint F*/
.set UDCCSRG, 0x4060011C		/* UDC Control/Status Register Endpoint G*/
.set UDCCSRH, 0x40600120		/* UDC Control/Status Register Endpoint H*/
.set UDCCSRI, 0x40600124		/* UDC Control/Status Register Endpoint I*/
.set UDCCSRJ, 0x40600128		/* UDC Control/Status Register Endpoint J*/
.set UDCCSRK, 0x4060012C		/* UDC Control/Status Register Endpoint K*/
.set UDCCSRL, 0x40600130		/* UDC Control/Status Register Endpoint L*/
.set UDCCSRM, 0x40600134		/* UDC Control/Status Register Endpoint M*/
.set UDCCSRN, 0x40600138		/* UDC Control/Status Register Endpoint N*/
.set UDCCSRP, 0x4060013C		/* UDC Control/Status Register Endpoint P*/
.set UDCCSRQ, 0x40600140		/* UDC Control/Status Register Endpoint Q*/
.set UDCCSRR, 0x40600144		/* UDC Control/Status Register Endpoint R*/
.set UDCCSRS, 0x40600148		/* UDC Control/Status Register Endpoint S*/
.set UDCCSRT, 0x4060014C		/* UDC Control/Status Register Endpoint T*/
.set UDCCSRU, 0x40600150		/* UDC Control/Status Register Endpoint U*/
.set UDCCSRV, 0x40600154		/* UDC Control/Status Register Endpoint V*/
.set UDCCSRW, 0x40600158		/* UDC Control/Status Register Endpoint W*/
.set UDCCSRX, 0x4060015C		/* UDC Control/Status Register Endpoint X*/



/* Endpoint ByteCount register*/
.set UDCBCR0, 0x40600200	 	/* UDC Byte Count Register Eondpoint 0*/
.set UDCBCRA, 0x40600204		/* UDC Byte Count Register Endpoint A*/
.set UDCBCRB, 0x40600208		/* UDC Byte Count Register Endpoint B*/
.set UDCBCRC, 0x4060020C		/* UDC Byte Count Register Endpoint C*/
.set UDCBCRD, 0x40600210		/* UDC Byte Count Register Endpoint D*/
.set UDCBCRE, 0x40600214		/* UDC Byte Count Register Endpoint E*/
.set UDCBCRF, 0x40600218		/* UDC Byte Count Register Endpoint F*/
.set UDCBCRG, 0x4060021C		/* UDC Byte Count Register Endpoint G*/
.set UDCBCRH, 0x40600220		/* UDC Byte Count Register Endpoint H*/
.set UDCBCRI, 0x40600224		/* UDC Byte Count Register Endpoint I*/
.set UDCBCRJ, 0x40600228		/* UDC Byte Count Register Endpoint J*/
.set UDCBCRK, 0x4060022C		/* UDC Byte Count Register Endpoint K*/
.set UDCBCRL, 0x40600230		/* UDC Byte Count Register Endpoint L*/
.set UDCBCRM, 0x40600234		/* UDC Byte Count Register Endpoint M*/
.set UDCBCRN, 0x40600238		/* UDC Byte Count Register Endpoint N*/
.set UDCBCRP, 0x4060023C		/* UDC Byte Count Register Endpoint P*/
.set UDCBCRQ, 0x40600240		/* UDC Byte Count Register Endpoint Q*/
.set UDCBCRR, 0x40600244		/* UDC Byte Count Register Endpoint R*/
.set UDCBCRS, 0x40600248		/* UDC Byte Count Register Endpoint S*/
.set UDCBCRT, 0x4060024C		/* UDC Byte Count Register Endpoint T*/
.set UDCBCRU, 0x40600250		/* UDC Byte Count Register Endpoint U*/
.set UDCBCRV, 0x40600254		/* UDC Byte Count Register Endpoint V*/
.set UDCBCRW, 0x40600258		/* UDC Byte Count Register Endpoint W*/
.set UDCBCRX, 0x4060025C		/* UDC Byte Count Register Endpoint X*/

 /* Endpoint Data Register */
.set UDCDR0, 0x40600300		/* UDC Data Register Endpoint 0*/
.set UDCDRA, 0x40600304		/* UDC Data Register Endpoint A*/
.set UDCDRB, 0x40600308		/* UDC Data Register Endpoint B*/
.set UDCDRC, 0x4060030C		/* UDC Data Register Endpoint C*/
.set UDCDRD, 0x40600310		/* UDC Data Register Endpoint D*/
.set UDCDRE, 0x40600314		/* UDC Data Register Endpoint E*/
.set UDCDRF, 0x40600318		/* UDC Data Register Endpoint F*/
.set UDCDRG, 0x4060031C		/* UDC Data Register Endpoint G*/
.set UDCDRH, 0x40600320		/* UDC Data Register Endpoint H*/
.set UDCDRI, 0x40600324		/* UDC Data Register Endpoint I*/
.set UDCDRJ, 0x40600328		/* UDC Data Register Endpoint J*/
.set UDCDRK, 0x4060032C		/* UDC Data Register Endpoint K*/
.set UDCDRL, 0x40600330		/* UDC Data Register Endpoint L*/
.set UDCDRM, 0x40600334		/* UDC Data Register Endpoint M*/
.set UDCDRN, 0x40600338		/* UDC Data Register Endpoint N*/
.set UDCDRP, 0x4060033C		/* UDC Data Register Endpoint P*/
.set UDCDRQ, 0x40600340		/* UDC Data Register Endpoint Q*/
.set UDCDRR, 0x40600344		/* UDC Data Register Endpoint R*/
.set UDCDRS, 0x40600348		/* UDC Data Register Endpoint S*/
.set UDCDRT, 0x4060034C		/* UDC Data Register Endpoint T*/
.set UDCDRU, 0x40600350		/* UDC Data Register Endpoint U*/
.set UDCDRV, 0x40600354		/* UDC Data Register Endpoint V*/
.set UDCDRW, 0x40600358		/* UDC Data Register Endpoint W*/
.set UDCDRX, 0x4060035C		/* UDC Data Register Endpoint X*/
.set UDCCRA, 0x40600404		/* UDC Configuration Register Endpoint A*/
.set UDCCRB, 0x40600408		/* UDC Configuration Register Endpoint B*/
.set UDCCRC, 0x4060040C		/* UDC Configuration Register Endpoint C*/
.set UDCCRD, 0x40600410		/* UDC Configuration Register Endpoint D*/
.set UDCCRE, 0x40600414		/* UDC Configuration Register Endpoint E*/
.set UDCCRF, 0x40600418		/* UDC Configuration Register Endpoint F*/
.set UDCCRG, 0x4060041C		/* UDC Configuration Register Endpoint G*/
.set UDCCRH, 0x40600420		/* UDC Configuration Register Endpoint H*/
.set UDCCRI, 0x40600424		/* UDC Configuration Register Endpoint I*/
.set UDCCRJ, 0x40600428		/* UDC Configuration Register Endpoint J*/
.set UDCCRK, 0x4060042C		/* UDC Configuration Register Endpoint K*/
.set UDCCRL, 0x40600430		/* UDC Configuration Register Endpoint L*/
.set UDCCRM, 0x40600434		/* UDC Configuration Register Endpoint M*/
.set UDCCRN, 0x40600438		/* UDC Configuration Register Endpoint N*/
.set UDCCRP, 0x4060043C		/* UDC Configuration Register Endpoint P*/
.set UDCCRQ, 0x40600440		/* UDC Configuration Register Endpoint Q*/
.set UDCCRR, 0x40600444		/* UDC Configuration Register Endpoint R*/
.set UDCCRS, 0x40600448		/* UDC Configuration Register Endpoint S*/
.set UDCCRT, 0x4060044C		/* UDC Configuration Register Endpoint T*/
.set UDCCRU, 0x40600450		/* UDC Configuration Register Endpoint U*/
.set UDCCRV, 0x40600454		/* UDC Configuration Register Endpoint V*/
.set UDCCRW, 0x40600458		/* UDC Configuration Register Endpoint W*/
.set UDCCRX, 0x4060045C		/* UDC Configuration Register Endpoint X*/



/*
 * USB Host Controller
 */
.set UHCREV     , 0x4C000000
.set UHCHCON    , 0x4C000004
.set UHCCOMS    , 0x4C000008
.set UHCINTS    , 0x4C00000C
.set UHCINTE    , 0x4C000010
.set UHCINTD    , 0x4C000014
.set UHCHCCA    , 0x4C000018
.set UHCPCED    , 0x4C00001C
.set UHCCHED    , 0x4C000020
.set UHCCCED    , 0x4C000024
.set UHCBHED    , 0x4C000028
.set UHCBCED    , 0x4C00002C
.set UHCDHEAD   , 0x4C000030
.set UHCFMI     , 0x4C000034
.set UHCFMR     , 0x4C000038
.set UHCFMN     , 0x4C00003C
.set UHCPERS    , 0x4C000040
.set UHCLST     , 0x4C000044
.set UHCRHDA    , 0x4C000048
.set UHCRHDB    , 0x4C00004C
.set UHCRHS     , 0x4C000050
.set UHCRHPS1   , 0x4C000054
.set UHCRHPS2   , 0x4C000058
.set UHCRHPS3   , 0x4C00005C
.set UHCSTAT    , 0x4C000060
.set UHCHR      , 0x4C000064
.set UHCHIE     , 0x4C000068
.set UHCHIT     , 0x4C00006C


/*
 * Fast Infrared Communication Port
 */

.set ICCR0, 0x40800000 		/* ICP Control Register 0*/
.set ICCR1, 0x40800004 		/* ICP Control Register 1*/
.set ICCR2, 0x40800008 		/* ICP Control Register 2*/
.set ICDR, 0x4080000c 		/* ICP Data Register */
.set ICSR0, 0x40800014 		/* ICP Status Register 0*/
.set ICSR1, 0x40800018 		/* ICP Status Register 1*/


/*
 * Real Time Clock
 */

.set RCNR, 0x40900000 		/* RTC Count Register */
.set RTAR, 0x40900004 		/* RTC Alarm Register */
.set RTSR, 0x40900008 		/* RTC Status Register */
.set RTTR, 0x4090000C 		/* RTC Timer Trim Register */
.set RDAR1 , 0x40900018 	/* Wristwatch Day Alarm Reg 1*/
.set RDAR2 , 0x40900020 	/* Wristwatch Day Alarm Reg 2*/
.set RYAR1 , 0x4090001C 	/* Wristwatch Year Alarm Reg 1*/
.set RYAR2 , 0x40900024 	/* Wristwatch Year Alarm Reg 2*/
.set SWAR1 , 0x4090002C 	/* Stopwatch Alarm Register 1*/
.set SWAR2 , 0x40900030 	/* Stopwatch Alarm Register 2*/
.set PIAR  , 0x40900038 	/* Periodic Interrupt Alarm Register */
.set RDCR  , 0x40900010 	/* RTC Day Count Register */
.set RYCR  , 0x40900014 	/* RTC Year Count Register */
.set SWCR  , 0x40900028 	/* Stopwatch Count Register */
.set RTCPICR ,0x40900034	/* Periodic Interrupt Counter Register */



/*
 * OS Timer & Match Registers 
 */

/* General Timer Registers */
.set OSSR, 0x40A00014 		/* OS Timer Status Register */
.set OWER, 0x40A00018 		/* OS Timer Watchdog Enable Register */
.set OIER, 0x40A0001C 		/* OS Timer Interrupt Enable Register */
.set OSNR, 0x40A00020 		/* OS Timer Snapshot Register */

/* OS Timer 0*/
.set OSMR0, 0x40A00000 		/* OS Timer 0 Match Register */
.set OSCR, 0x40A00010 		/* OS Timer 0 Counter Register */

/* OS Timer 1*/
.set OSMR1, 0x40A00004 		/* OS Timer 1 Match Register */

/* OS Timer 2*/
.set OSMR2, 0x40A00008 		/* OS Timer 2 Match Register */

/* OS Timer 3*/
.set OSMR3, 0x40A0000C 		/* OS Timer 3 Match Register */

/* OS Timer 4*/
.set OSMR4 , 0x40A00080 	/* OS Timer 4 Match Register */
.set OSCR4 , 0x40A00040 	/* OS Timer 4 Counter Register */
.set OMCR4 , 0x40A000C0 	/* OS Timer 4 Control Register */

/* OS Timer 5*/
.set OSMR5 , 0x40A00084 	/* OS Timer 5 Match Register */
.set OSCR5 , 0x40A00044 	/* OS Timer 5 Counter Register */
.set OMCR5 , 0x40A000C4 	/* OS Timer 5 Control Register */

/* OS Timer 6*/
.set OSMR6 , 0x40A00088 	/* OS Timer 6 Match Register */
.set OSCR6 , 0x40A00048 	/* OS Timer 6 Counter Register */
.set OMCR6 , 0x40A000C8 	/* OS Timer 6 Control Register */

/* OS Timer 7*/
.set OSMR7 , 0x40A0008C 	/* OS Timer 7 Match Register */
.set OSCR7 , 0x40A0004C 	/* OS Timer 7 Counter Register */
.set OMCR7 , 0x40A000CC 	/* OS Timer 7 Control Register */

/* OS Timer 8*/
.set OSMR8 , 0x40A00090 	/* OS Timer 8 Match Register */
.set OSCR8 , 0x40A00050 	/* OS Timer 8 Counter Register */
.set OMCR8 , 0x40A000D0 	/* OS Timer 8 Control Register */

/* OS Timer 9*/
.set OSMR9 , 0x40A00094 	/* OS Timer 9 Match Register */
.set OSCR9 , 0x40A00054 	/* OS Timer 9 Counter Register */
.set OMCR9 , 0x40A000D4 	/* OS Timer 9 Control Register */

/* OS Timer 10*/
.set OSMR10, 0x40A00098 	/* OS Timer 10 Match Register */
.set OSCR10, 0x40A00058 	/* OS Timer 10 Counter Register */
.set OMCR10, 0x40A000D8 	/* OS Timer 10 Control Register */

/* OS Timer 11 */
.set OSMR11, 0x40A0009C 	/* OS Timer 11 Match Register */
.set OSCR11, 0x40A0005C 	/* OS Timer 11 Counter Register */
.set OMCR11, 0x40A000DC 	/* OS Timer 11 Control Register */

/*
 * Pulse Width Modulator
 */

/* PWM 0*/
.set PWMCR0, 0x40B00000 	/* PWM 0 Control Register */
.set PWMDCR0, 0x40B00004	/* PWM 0 Duty Cycle Register */
.set PWMPCR0, 0x40B00008	/* PWM 0 Period Control Register */

/* PWM 1*/
.set PWMCR1, 0x40C00000 	/* PWM 1 Control Register */
.set PWMDCR1, 0x40C00004	/* PWM 1 Duty Cycle Register */
.set PWMPCR1, 0x40C00008	/* PWM 1 Period Control Register */

/* PWM 2*/
.set PWMCR2, 0x40B00010 	/* PWM 2 Control Register */
.set PWMDCR2, 0x40B00014 	/* PWM 2 Duty Cycle Register */
.set PWMPCR2, 0x40B00018	/* PWM 2 Period Control Register */

/* PWM 3*/
.set PWMCR3, 0x40C00010 	/* PWM 3 Control Register */
.set PWMDCR3, 0x40C00014 	/* PWM 3 Duty Cycle Register */
.set PWMPCR3, 0x40C00018 	/* PWM 3 Period Control Register */


/*
 * Interrupt Controller
 */

.set ICIP, 0x40D00000 		/* Interrupt Controller IRQ Pending Register */
.set ICMR, 0x40D00004 		/* Interrupt Controller Mask Register */
.set ICLR, 0x40D00008 		/* Interrupt Controller Level Register */
.set ICFP, 0x40D0000C 		/* Interrupt Controller FIQ Pending Register */
.set ICPR, 0x40D00010 		/* Interrupt Controller Pending Register */
.set ICCR, 0x40D00014 		/* Interrupt Controller Control Register */
.set ICHP, 0x40D00018 		/* Interrupt Controller Control Register */

.set ICIP2, 0x40D0009C	 	/* Interrupt Controller IRQ Pending Register 2*/
.set ICMR2, 0x40D000A0 		/* Interrupt Controller Mask Register 2*/
.set ICLR2, 0x40D000A4 		/* Interrupt Controller Level Register 2*/
.set ICFP2, 0x40D000A8 		/* Interrupt Controller FIQ Pending Register 2*/
.set ICPR2, 0x40D000AC 		/* Interrupt Controller Pending Register 2*/

.set IPR0, 0x40D0001C 		/* Interrupt Priority Register 0*/
.set IPR1, 0x40D00020 		/* Interrupt Priority Register 1*/
.set IPR2, 0x40D00024 		/* Interrupt Priority Register 2*/
.set IPR3, 0x40D00028 		/* Interrupt Priority Register 3*/
.set IPR4, 0x40D0002C 		/* Interrupt Priority Register 4*/
.set IPR5, 0x40D00030 		/* Interrupt Priority Register 5*/
.set IPR6, 0x40D00034 		/* Interrupt Priority Register 6*/
.set IPR7, 0x40D00038 		/* Interrupt Priority Register 7*/
.set IPR8, 0x40D0003C 		/* Interrupt Priority Register 8*/
.set IPR9, 0x40D00040 		/* Interrupt Priority Register 9*/
.set IPR10, 0x40D00044		/* Interrupt Priority Register 10*/
.set IPR11, 0x40D00048		/* Interrupt Priority Register 11*/
.set IPR12, 0x40D0004C 		/* Interrupt Priority Register 12*/
.set IPR13, 0x40D00050 		/* Interrupt Priority Register 13*/
.set IPR14, 0x40D00054 		/* Interrupt Priority Register 14*/
.set IPR15, 0x40D00058 		/* Interrupt Priority Register 15*/
.set IPR16, 0x40D0005C 		/* Interrupt Priority Register 16*/
.set IPR17, 0x40D00060 		/* Interrupt Priority Register 17*/
.set IPR18, 0x40D00064 		/* Interrupt Priority Register 18*/
.set IPR19, 0x40D00068 		/* Interrupt Priority Register 19*/
.set IPR20, 0x40D0006C 		/* Interrupt Priority Register 20*/
.set IPR21, 0x40D00070 		/* Interrupt Priority Register 21*/
.set IPR22, 0x40D00074 		/* Interrupt Priority Register 22*/
.set IPR23, 0x40D00078 		/* Interrupt Priority Register 23*/
.set IPR24, 0x40D0007C 		/* Interrupt Priority Register 24*/
.set IPR25, 0x40D00080 		/* Interrupt Priority Register 25*/
.set IPR26, 0x40D00084 		/* Interrupt Priority Register 26*/
.set IPR27, 0x40D00088 		/* Interrupt Priority Register 27*/
.set IPR28, 0x40D0008C 		/* Interrupt Priority Register 28*/
.set IPR29, 0x40D00090 		/* Interrupt Priority Register 29*/
.set IPR30, 0x40D00094 		/* Interrupt Priority Register 30*/
.set IPR31, 0x40D00098 		/* Interrupt Priority Register 31*/
.set IPR32, 0x40D000B0 		/* Interrupt Priority Register 32*/
.set IPR33, 0x40D000B4 		/* Interrupt Priority Register 33*/
.set IPR34, 0x40D000B8 		/* Interrupt Priority Register 34*/
.set IPR35, 0x40D000BC 		/* Interrupt Priority Register 35*/
.set IPR36, 0x40D000C0 		/* Interrupt Priority Register 36*/
.set IPR37, 0x40D000C4 		/* Interrupt Priority Register 37*/
.set IPR38, 0x40D000C8 		/* Interrupt Priority Register 38*/
.set IPR39, 0x40D000CC 		/* Interrupt Priority Register 39*/


.set PER_ID_SSP3,			0			/* SSP_3 service request*/
.set PER_ID_MSL,			1			/* MSL interface interrupt*/
.set PER_ID_UHC2,			2			/* USB Host interrupt 2*/
.set PER_ID_UHC1,			3			/* USB Host interrupt 1 (OHCI)*/
.set PER_ID_KP,				4			/* Keypad controller interrupt*/
.set PER_ID_MS,				5			/* Memory stick interrupt*/
.set PER_ID_POWI2C,			6			/* Power I2C interrupt*/
.set PER_ID_OST,			7			/* OS timer matches registers 4-11*/
.set PER_ID_GPIO_0,			8			/* GPIO<0> detects an edge*/
.set PER_ID_GPIO_1,			9			/* GPIO<1> detects an edge*/
.set PER_ID_GPIO_X,			10			/* GPIO<x> "OR" of the GPIO edge detect (except 0 and 1)*/
.set PER_ID_UDC,			11			/* USB client interrupt*/
.set PER_ID_PMU,			12			/* PMU (performance monitor) interrupt*/
.set PER_ID_I2S,			13			/* I2S Interrupt*/
.set PER_ID_AC97,			14			/* AC 97 interrupt*/
.set PER_ID_USIM,			15			/* Smart card interface*/
.set PER_ID_SSP2,			16			/* SSP_2 service request*/
.set PER_ID_LCD,			17			/* LCD controller service request*/
.set PER_ID_I2C,			18			/* I2C service request*/
.set PER_ID_ICP,			19			/* TX or RX error in infrared communication port*/
.set PER_ID_STUART,			20			/* TX or RX error in STUART*/
.set PER_ID_BTUART,			21			/* TX or RX error in BTUART*/
.set PER_ID_FFUART,			22			/* TX or RX error in FFUART*/
.set PER_ID_MMC,			23			/* Flash Card status/Error detection*/
.set PER_ID_SSP1,			24			/* SSP_1 service request*/
.set PER_ID_DMA,			25			/* DMA Channel service request*/
.set PER_ID_OSTIMER_0,		26			/* OS timer equals Match register 0*/
.set PER_ID_OSTIMER_1,		27			/* OS timer equals Match register 1*/
.set PER_ID_OSTIMER_2,		28			/* OS timer equals Match register 2*/
.set PER_ID_OSTIMER_3,		29			/* OS timer equals Match register 3*/
.set PER_ID_RTC_1HZ,		30			/* 1 Hz clock tic occured*/
.set PER_ID_RTC_ALRM,		31			/* RTC equals Alarm Register */
.set PER_ID_TPM,			32			/* Trusted Platform Module interrupt*/
.set PER_ID_QCI,			33			/* Quick Capture Interface interrupt*/



/*
 * General Purpose I/O
 */

.set GPLR0, 0x40E00000 		/* GPIO Pin-Level Register GPIO<31:0> */
.set GPLR1, 0x40E00004 		/* GPIO Pin-Level Register GPIO<63:32> */
.set GPLR2, 0x40E00008 		/* GPIO Pin-Level Register GPIO<80:64> */

.set GPDR0, 0x40E0000C 		/* GPIO Pin Direction Register GPIO<31:0> */
.set GPDR1, 0x40E00010 		/* GPIO Pin Direction Register GPIO<63:32> */
.set GPDR2, 0x40E00014 		/* GPIO Pin Direction Register GPIO<80:64> */

.set GPSR0, 0x40E00018 		/* GPIO Pin Output Set Register GPIO<31:0> */
.set GPSR1, 0x40E0001C 		/* GPIO Pin Output Set Register GPIO<63:32> */
.set GPSR2, 0x40E00020 		/* GPIO Pin Output Set Register GPIO<80:64> */

.set GPCR0, 0x40E00024 		/* GPIO Pin Output Clear Register GPIO<31:0> */
.set GPCR1, 0x40E00028 		/* GPIO Pin Output Clear Register GPIO <63:32> */
.set GPCR2, 0x40E0002C 		/* GPIO Pin Output Clear Register GPIO <80:64> */

.set GRER0, 0x40E00030 		/* GPIO Rising-Edge Detect Register GPIO<31:0> */
.set GRER1, 0x40E00034 		/* GPIO Rising-Edge Detect Register GPIO<63:32> */
.set GRER2, 0x40E00038 		/* GPIO Rising-Edge Detect Register GPIO<80:64> */

.set GFER0, 0x40E0003C 		/* GPIO Falling-Edge Detect Register GPIO<31:0> */
.set GFER1, 0x40E00040 		/* GPIO Falling-Edge Detect Register GPIO<63:32> */
.set GFER2, 0x40E00044 		/* GPIO Falling-Edge Detect Register GPIO<80:64> */

.set GEDR0, 0x40E00048 		/* GPIO Edge Detect Status Register GPIO<31:0> */
.set GEDR1, 0x40E0004C 		/* GPIO Edge Detect Status Register GPIO<63:32> */
.set GEDR2, 0x40E00050 		/* GPIO Edge Detect Status Register GPIO<80:64> */

.set GAFR0_L, 0x40E00054 	/* GPIO Alternate Function Select Register GPIO<15:0> */
.set GAFR0_U, 0x40E00058 	/* GPIO Alternate Function Select Register GPIO<31:16> */
.set GAFR1_L, 0x40E0005C 	/* GPIO Alternate Function Select Register GPIO<47:32> */
.set GAFR1_U, 0x40E00060 	/* GPIO Alternate Function Select Register GPIO<63:48> */
.set GAFR2_L, 0x40E00064 	/* GPIO Alternate Function Select Register GPIO<79:64> */
.set GAFR2_U, 0x40E00068 	/* GPIO Alternate Function Select Register GPIO 80 */



/*
 * Power Manager
 */


.set PMCR, 0x40F00000 		/* Power Manager Control Register */
.set PSSR, 0x40F00004 		/* Power Manager Sleep Status Register */
.set PSPR, 0x40F00008 		/* Power Manager Scratch Pad Register */
.set PWER, 0x40F0000C 		/* Power Manager Wake-up Enable Register */
.set PRER, 0x40F00010 		/* Power Manager GPIO Rising-Edge Detect Enable Register */
.set PFER, 0x40F00014 		/* Power Manager GPIO Falling-Edge Detect Enable Register */
.set PEDR, 0x40F00018 		/* Power Manager GPIO Edge Detect Status Register */
.set PCFR, 0x40F0001C 		/* Power Manager General Configuration Register */
.set PGSR0, 0x40F00020		/* Power Manager GPIO Sleep State Register for GP[31-0] */
.set PGSR1, 0x40F00024		/* Power Manager GPIO Sleep State Register for GP[63-32]*/
.set PGSR2, 0x40F00028		/* Power Manager GPIO Sleep State Register for GP[84-64]*/
.set PGSR3, 0x40F0002C 		/* Power Manager GPIO Sleep State Register for GP[118-96]*/
.set RCSR, 0x40F00030 		/* Reset Controller Status Register */

.set    PSLR, 0x40F00034   	/*Power Manager Sleep Config Register */
.set    PSTR, 0x40F00038  	/*Power Manager Standby Config Register */
.set    PSNR, 0x40F0003C  	/*Power Manager Sense Config Register */
.set    PVCR, 0x40F00040 	/*Power Manager VoltageControl Register */
.set    PKWR, 0x40F00050   	/* Power Manager KB Wake-up Enable Reg*/
.set    PKSR, 0x40F00054   	/* Power Manager KB Level-Detect Register */

/*
 * SSP Serial Port Registers 
 */


/* SSP 1*/
.set SSCR0_1, 0x41000000 	/* SSP 1 Control Register 0*/
.set SSCR1_1, 0x41000004 	/* SSP 1 Control Register 1*/
.set SSSR_1, 0x41000008 	/* SSP 1 Status Register */
.set SSITR_1, 0x4100000C 	/* SSP 1 Interrupt Test Register */
.set SSDR_1, 0x41000010 	/* (Write / Read) SSP 1 Data Write Register/SSP Data Read Register */

.set SSTO_1, 0x41000028 	/* SSP 1 Time-Out Register */
.set SSPSP_1, 0x4100002C 	/* SSP 1 Programmable Serial Protocol*/
.set SSTSA_1, 0x41000030 	/* SSP 1 TX Timeslot Active Register */
.set SSRSA_1, 0x41000034 	/* SSP 1 RX Timeslot Active Register */
.set SSTSS_1, 0x41000038 	/* SSP 1 Timeslot Status Register */
.set SSACD_1, 0x4100003C 	/* SSP 1 Audio Clock Divider Register */

/* SSP 2*/
.set SSCR0_2, 0x41700000 	/* SSP 2 Control Register 0*/
.set SSCR1_2, 0x41700004 	/* SSP 2 Control Register 1*/
.set SSSR_2, 0x41700008 	/* SSP 2 Status Register */
.set SSITR_2, 0x4170000C 	/* SSP 2 Interrupt Test Register */
.set SSDR_2, 0x41700010 	/* (Write / Read) SSP 2 Data Write Register /SSP Data Read Register */

.set SSTO_2, 0x41700028 	/* SSP 2 Time-Out Register */
.set SSPSP_2, 0x4170002C	/* SSP 2 Programmable Serial Protocol*/
.set SSTSA_2, 0x41700030 	/* SSP 2 TX Timeslot Active Register */
.set SSRSA_2, 0x41700034 	/* SSP 2 RX Timeslot Active Register */
.set SSTSS_2, 0x41700038 	/* SSP 2 Timeslot Status Register */
.set SSACD_2, 0x4170003C 	/* SSP 2 Audio Clock Divider Register */

/* SSP 3 */
.set SSCR0_3, 0x41900000 	/* SSP 3 Control Register 0*/
.set SSCR1_3, 0x41900004 	/* SSP 3 Control Register 1*/
.set SSSR_3, 0x41900008 	/* SSP 3 Status Register */
.set SSITR_3, 0x4190000C 	/* SSP 3 Interrupt Test Register */
.set SSDR_3, 0x41900010 	/* (Write / Read) SSP 3 Data Write Register/SSP Data Read Register */

.set SSTO_3, 0x41900028 	/* SSP 3 Time-Out Register */
.set SSPSP_3, 0x4190002C 	/* SSP 3 Programmable Serial Protocol*/
.set SSTSA_3, 0x41900030 	/* SSP 3 TX Timeslot Active Register */
.set SSRSA_3, 0x41900034 	/* SSP 3 RX Timeslot Active Register */
.set SSTSS_3, 0x41900038 	/* SSP 3 Timeslot Status Register */
.set SSACD_3, 0x4190003C 	/* SSP 3 Audio Clock Divider Register */


/*
 * MultiMediaCard (MMC) controller
 */

.set MMC_STRPCL, 0x41100000 /* Control to start and stop MMC clock*/
.set MMC_STAT, 0x41100004 	/* MMC Status Register (read only)*/
.set MMC_CLKRT, 0x41100008 	/* MMC clock rate*/
.set MMC_SPI, 0x4110000c 	/* SPI mode control bits*/
.set MMC_CMDAT, 0x41100010 	/* Command/response/data sequence control*/
.set MMC_RESTO, 0x41100014 	/* Expected response time out*/
.set MMC_RDTO, 0x41100018 	/* Expected data read time out*/
.set MMC_BLKLEN, 0x4110001c /* Block length of data transaction*/
.set MMC_NOB, 0x41100020 	/* Number of blocks, for block mode*/
.set MMC_PRTBUF, 0x41100024 /* Partial MMC_TXFIFO FIFO written*/
.set MMC_I_MASK, 0x41100028 /* Interrupt Mask*/
.set MMC_I_REG, 0x4110002c 	/* Interrupt Register (read only)*/
.set MMC_CMD, 0x41100030 	/* Index of current command*/
.set MMC_ARGH, 0x41100034 	/* MSW part of the current command argument*/
.set MMC_ARGL, 0x41100038 	/* LSW part of the current command argument*/
.set MMC_RES, 0x4110003c 	/* Response FIFO (read only)*/
.set MMC_RXFIFO, 0x41100040 /* Receive FIFO (read only)*/
.set MMC_TXFIFO, 0x41100044 /* Transmit FIFO (write only)*/


/*
 * Core Clock
 */

.set CCCR, 0x41300000 		/* Core Clock Configuration Register */
.set CKEN, 0x41300004 		/* Clock Enable Register */
.set OSCC, 0x41300008 		/* Oscillator Configuration Register */

.set CCCR_N_MASK,	0x0380	/* Run Mode Frequency to Turbo Mode Frequency Multiplier */
.set CCCR_M_MASK,	0x0060	/* Memory Frequency to Run Mode Frequency Multiplier */
.set CCCR_L_MASK,	0x001f	/* Crystal Frequency to Memory Frequency Multiplier */

/*
 * LCD
 */

.set LCCR0, 0x44000000 		/* LCD Controller Control Register 0*/
.set LCCR1, 0x44000004 		/* LCD Controller Control Register 1*/
.set LCCR2, 0x44000008 		/* LCD Controller Control Register 2*/
.set LCCR3, 0x4400000C 		/* LCD Controller Control Register 3*/
.set DFBR0, 0x44000020 		/* DMA Channel 0 Frame Branch Register */
.set DFBR1, 0x44000024 		/* DMA Channel 1 Frame Branch Register */
.set LCSR0, 0x44000038 		/* LCD Controller Status Register */
.set LCSR1  , 0x44000034	/* LCD Controller Status Register */
.set LIIDR, 0x4400003C 		/* LCD Controller Interrupt ID Register */
.set TMEDRGBR, 0x44000040 	/* TMED RGB Seed Register */
.set TMEDCR, 0x44000044 	/* TMED Control Register */

.set FDADR0, 0x44000200 	/* DMA Channel 0 Frame Descriptor Address Register */
.set FSADR0, 0x44000204 	/* DMA Channel 0 Frame Source Address Register */
.set FIDR0, 0x44000208 		/* DMA Channel 0 Frame ID Register */
.set LDCMD0, 0x4400020C 	/* DMA Channel 0 Command Register */
.set FDADR1, 0x44000210 	/* DMA Channel 1 Frame Descriptor Address Register */
.set FSADR1, 0x44000214 	/* DMA Channel 1 Frame Source Address Register */
.set FIDR1, 0x44000218 		/* DMA Channel 1 Frame ID Register */
.set LDCMD1, 0x4400021C 	/* DMA Channel 1 Command Register */

/*
 * Memory controller
 */

.set MEMC_BASE, 0x48000000   /* Base of Memory Controller */
.set MDCNFG_OFFSET,   0x0
.set MDREFR_OFFSET,   0x4
.set MSC0_OFFSET,     0x8
.set MSC1_OFFSET,     0xC
.set MSC2_OFFSET,     0x10
.set MECR_OFFSET,     0x14
.set SXLCR_OFFSET,    0x18
.set SXCNFG_OFFSET,   0x1C
.set FLYCNFG_OFFSET,  0x20
.set SXMRS_OFFSET,    0x24
.set MCMEM0_OFFSET,   0x28
.set MCMEM1_OFFSET,   0x2C
.set MCATT0_OFFSET,   0x30
.set MCATT1_OFFSET,   0x34
.set MCIO0_OFFSET,    0x38
.set MCIO1_OFFSET,    0x3C
.set MDMRS_OFFSET,    0x40

.set MDCNFG, 0x48000000 	/* SDRAM Configuration Register 0*/
.set MDCNFG_DE0,	0x00000001
.set MDCNFG_DE1,	0x00000002
.set MDCNFG_DE2,	0x00010000
.set MDCNFG_DE3,	0x00020000
.set MDCNFG_DWID0,	0x00000004

.set MDREFR, 0x48000004 	/* SDRAM Refresh Control Register */
.set MSC0, 0x48000008 		/* Static Memory Control Register 0*/
.set MSC1, 0x4800000C 		/* Static Memory Control Register 1*/
.set MSC2, 0x48000010 		/* Static Memory Control Register 2*/
.set MECR, 0x48000014 		/* Expansion Memory (PCMCIA/Compact Flash) Bus Configuration*/
.set SXLCR, 0x48000018		/* LCR value to be written to SDRAM-Timing Synchronous Flash*/
.set SXCNFG, 0x4800001C 	/* Synchronous Static Memory Control Register */
.set FLYCNFG, 0x48000020 	/* DMA Fly-By Configuration Register */
.set SXMRS, 0x48000024 		/* MRS value to be written to Synchronous Flash or SMROM*/
.set MCMEM0, 0x48000028 	/* Card interface Common Memory Space Socket 0 Timing*/
.set MCMEM1, 0x4800002C 	/* Card interface Common Memory Space Socket 1 Timing*/
.set MCATT0, 0x48000030 	/* Card interface Attribute Space Socket 0 Timing Configuration*/
.set MCATT1, 0x48000034 	/* Card interface Attribute Space Socket 1 Timing Configuration*/
.set MCIO0, 0x48000038 		/* Card interface I/O Space Socket 0 Timing Configuration*/
.set MCIO1, 0x4800003C 		/* Card interface I/O Space Socket 1 Timing Configuration*/
.set MDMRS, 0x48000040 		/* MRS value to be written to SDRAM*/
.set BOOT_DEF, 0x48000044 	/* Read-Only Boot-Time Register. Contains BOOT_SEL and PKG_SEL*/
.set BSCNTR0, 0x4800004C 	/* System Memory Buffer Strength Control Register 0*/
.set BSCNTR1, 0x48000050 	/* System Memory Buffer Strength Control Register 1*/
.set BSCNTR2, 0x4800005C 	/* System Memory Buffer Strength Control Register 2*/
.set BSCNTR3, 0x48000060 	/* System Memory Buffer Strength Control Register 3*/



.set ARB_CNTRL, 0x48000048 /* Arbiter Control Register */

.set BSCNTR0_OFFSET,    0x4c
.set BSCNTR1_OFFSET,    0x50
.set BSCNTR2_OFFSET,    0x5c
.set BSCNTR3_OFFSET,    0x60

/* Interrupt Controller*/

.set ICIP2, 0x40D0009C 		/* Interrupt Controller IRQ Pending Register 2*/
.set ICMR2, 0x40D000A0 		/* Interrupt Controller Mask Register 2*/
.set ICLR2, 0x40D000A4 		/* Interrupt Controller Level Register 2*/
.set ICFP2, 0x40D000A8 		/* Interrupt Controller FIQ Pending Register 2*/
.set ICPR2, 0x40D000AC 		/* Interrupt Controller Pending Register 2 */

/* General Purpose I/O */

.set GAFR3_L, 0x40E0006C 	/* GPIO Alternate Function Select Register GPIO<111:96> */
.set GAFR3_U, 0x40E00070 	/* GPIO Alternate Function Select Register GPIO<127:112> */
.set GPLR3, 0x40E00100 		/* GPIO Pin-Level Register GPIO<127:96> */
.set GPDR3, 0x40E0010C 		/* GPIO Pin Direction Register GPIO<127:96> */
.set GPSR3, 0x40E00118 		/* GPIO Pin Output Set Register GPIO<127:96> */
.set GPCR3, 0x40E00124 		/* GPIO Pin Output Clear Register GPIO <127:96> */
.set GRER3, 0x40E00130 		/* GPIO Rising-Edge Detect Register GPIO<127:96> */
.set GFER3, 0x40E0013C 		/* GPIO Falling-Edge Detect Register GPIO<31:0> */
.set GEDR3, 0x40E00148 		/* GPIO Edge Detect Status Register GPIO<127:96> */

/* Core Clock */

.set CCSR, 0x4130000C 		/* Core Clock Status Register */

/* LCD Registers */
.set LCCR4, 0x44000010 		/* LCD Controller Control Register 4 */
.set LCCR5, 0x44000014 		/* LCD Controller Control Register 5 */
.set FBR0, 0x44000020 		/* DMA Channel 0 Frame Branch Register */
.set FBR1, 0x44000024 		/* DMA Channel 1 Frame Branch Register */
.set FBR2, 0x44000028 		/* DMA Channel 2 Frame Branch Register */
.set FBR3, 0x4400002C 		/* DMA Channel 3 Frame Branch Register */
.set FBR4, 0x44000030 		/* DMA Channel 4 Frame Branch Register */
.set FDADR2, 0x44000220	 	/* DMA Channel 2 Frame Descriptor Address Register */
.set FSADR2, 0x44000224 	/* DMA Channel 2 Frame Source Address Register */
.set FIDR2, 0x44000228 		/* DMA Channel 2 Frame ID Register */
.set LDCMD2, 0x4400022C		/* DMA Channel 2 Command Register */
.set FDADR3, 0x44000230 	/* DMA Channel 3 Frame Descriptor Address Register */
.set FSADR3, 0x44000234 	/* DMA Channel 3 Frame Source Address Register */
.set FIDR3, 0x44000238 		/* DMA Channel 3 Frame ID Register */
.set LDCMD3, 0x4400023C 	/* DMA Channel 3 Command Register */
.set FDADR4, 0x44000240 	/* DMA Channel 4 Frame Descriptor Address Register */
.set FSADR4, 0x44000244 	/* DMA Channel 4 Frame Source Address Register */
.set FIDR4, 0x44000248 		/* DMA Channel 4 Frame ID Register */
.set LDCMD4, 0x4400024C		/* DMA Channel 4 Command Register */
.set FDADR5, 0x44000250 	/* DMA Channel 5 Frame Descriptor Address Register */
.set FSADR5, 0x44000254 	/* DMA Channel 5 Frame Source Address Register */
.set FIDR5, 0x44000258 		/* DMA Channel 5 Frame ID Register */
.set LDCMD5, 0x4400025C 	/* DMA Channel 5 Command Register */

.set OVL1C1, 0x44000050 	/* Overlay 1 Control Register 1 */
.set OVL1C2, 0x44000060 	/* Overlay 1 Control Register 2 */
.set OVL2C1, 0x44000070 	/* Overlay 2 Control Register 1 */
.set OVL2C2, 0x44000080 	/* Overlay 2 Control Register 2 */
.set CCR	, 0x44000090 	/* Cursor Control Register */

.set FBR5, 0x44000110 		/* DMA Channel 5 Frame Branch Register */
.set FBR6, 0x44000114 		/* DMA Channel 6 Frame Branch Register */


/* Keypad controller*/

.set KPC, 0x41500000 	/* Keypad Interface Control Register */
.set KPDK, 0x41500008 		/* Keypad Interface Direct Key Register */
.set KPREC, 0x41500010 		/* Keypad Intefcace Rotary Encoder Register */
.set KPMK, 0x41500018 		/* Keypad Intefcace Matrix Key Register */
.set KPAS, 0x41500020 		/* Keypad Interface Automatic Scan Register */
.set KPASMKP0, 0x41500028 	/* Keypad Interface Automatic Scan Multiple Key Presser register 0 */
.set KPASMKP1, 0x41500030 	/* Keypad Interface Automatic Scan Multiple Key Presser register 1 */
.set KPASMKP2, 0x41500038 	/* Keypad Interface Automatic Scan Multiple Key Presser register 2 */
.set KPASMKP3, 0x41500040 	/* Keypad Interface Automatic Scan Multiple Key Presser register 3 */
.set KPKDI, 0x41500048 		/* Keypad Interface Key Debounce Interval Register */

.set PSLR, 0x40F00034
.set PSTR, 0x40F00038 	/* Power Manager Standby Configuration Reg */
.set PSNR, 0x40F0003C 	/* Power Manager Sense Configuration Reg */
.set PVCR, 0x40F00040 	/* Power Manager Voltage Change Control Reg */
.set PKWR, 0x40F00050 	/* Power Manager KB Wake-Up Enable Reg */
.set PKSR, 0x40F00054 	/* Power Manager KB Level-Detect Status Reg */

.endif
