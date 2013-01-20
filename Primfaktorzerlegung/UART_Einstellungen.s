/************************************************************************
*
* Projekt      : Primfaktorzerlegung
*
*************************************************************************
* Modul        : UART
* File-Name    : UART_Einstellungen.s
* Version      : 1.0
* Datum        : Januar 2013
* Authoren     : N. K�ser
* -----------------------------------------------------------------------
* Beschreibung : Einstellungen der seriellen Schnittstelle
************************************************************************/

.ifndef _UART_SETTINGS_S_
.set _UART_SETTINGS_S_, 1


/************************************************************************
* Info
*************************************************************************

Folgende Soubrutinen und Variablen sind vorhanden und k�nnen mit
Assembler oder C gebraucht werden:

    Subroutinen
    -----------
    void UART_init(void)
    void UART_irq_init(void)
    void UART_write(char* string)

    Interrupt-Handler
    -----------------
    void UART_read_irq(void)
    (Nicht vergessen in Vektortabelle einzutragen!)

    Flags (Wert entweder 1 oder 0)
    ------------------------------
    int UART_read_enabled
    int String_ready

    Variablen
    ---------
    char String_buffer[]
    (Gr�sse wird unten mit BUFFER_SIZE bestimmt)


/************************************************************************
* Einstellungen die ge�ndert werden k�nnen
************************************************************************/

.set DIVISOR,       96          @ F�r die �bertragungsgeschwindikeit, Divisor = 921600/Baudrate
.set P_ENABLE,      0           @ Parit�t ein-/ausschalten - 0: No parity, 1: Parity
.set P_EVEN,        0           @ Parit�t einstellen - 0: Ungerade Parit�t, 1: Gerade Parit�t
.set S_BITS,        0           @ Stop-Bits - 0: 1 Stop-Bit, 1: 2 Stop-Bits (oder 1.5 Stop-Bits bei 5 Data-Bits)
.set D_BITS,        3           @ Daten-Bits - 0: 5 Daten-Bits, 1: 6 Daten-Bits, 2: 7 Daten-Bits, 3: 8 Daten-Bits
.set BUFFER_SIZE,   50          @ Gr�sse vom String-Buffer der vom UART Modul verwendet wird

/************************************************************************
* Ende der �nderbaren Einstellungen
************************************************************************/


.endif @ _UART_SETTINGS_S_
