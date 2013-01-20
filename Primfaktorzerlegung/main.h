/************************************************************************
*
* Projekt      : Primfaktorzerlegung
*
*************************************************************************
* Modul        : Main
* File-Name    : main.h
* Version      : 1.0
* Datum        : Januar 2013
* Authoren     : J. Haldemann, N. Käser
* -----------------------------------------------------------------------
* Beschreibung : Main Header für die Primfaktorzerlegung
************************************************************************/

#ifndef MACROS_H_
#define MACROS_H_


/************************************************************************
# Allgemein
************************************************************************/

// Carme Registers
#define LEDS        *((volatile unsigned long *)0x0C003000)

// Allgemeine Makros
#define EVER        ;;                // for(;;) = forever-loop
#define TRUE        1
#define FALSE       0


/************************************************************************
# Projekt
************************************************************************/

// Makros
#define START_MSG    "Geben Sie eine Zahl zwischen 1 und 4294967294 ein."
#define ERROR_MSG    "Ungueltige Eingabe"

// Interne Variablen
unsigned int input_zahl;
unsigned int output_array[INTARRAYLENGTH];
char output_string[OUTPUTSTRINGLENGTH];


/************************************************************************
# UART
************************************************************************/

// Prototypen für Assembler-Subroutinen
extern void UART_init(void);
extern void UART_irq_init(void);
extern void UART_write(char *stringptr);

// Externe Flags
extern int UART_read_enabled;
extern int String_ready;

// Externe Variablen
extern char String_buffer[];


/************************************************************************
# Primfaktorzerlegung
************************************************************************/

// Prototypen für Assembler-Subroutinen
extern unsigned int string_to_int(char *stringptr);
extern void primfaktorzerlegung(unsigned int zahl, unsigned int *primarrayptr);
extern void intarray_to_string(unsigned int *primarrayptr, char *outputstringptr);


#endif /* MACROS_H_ */
