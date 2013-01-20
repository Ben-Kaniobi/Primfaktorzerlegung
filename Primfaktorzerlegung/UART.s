/************************************************************************
*
* Projekt      : Primfaktorzerlegung
*
*************************************************************************
* Modul        : UART
* File-Name    : UART.s
* Version      : 1.0
* Datum        : Januar 2013
* Authoren     : N. Käser
* -----------------------------------------------------------------------
* Beschreibung : Funktionen für die serielle Schnittstelle
* -----------------------------------------------------------------------
* Inhalt       : UART_init, UART_irq_init, UART_read_irq, UART_write
************************************************************************/

.ifndef _UART_S_
.set _UART_S_, 1


/************************************************************************
* Includes
************************************************************************/

.include "../startup/pxa270.s"  @ include PXA270 register definitions
.include "../UART_Einstellungen.s"


/************************************************************************
* Export
************************************************************************/

@ Subroutinen
.global UART_read_irq @ Interrupt-Handler!
.global UART_init
.global UART_irq_init
.global UART_write

@ Flags
.global UART_read_enabled
.global String_ready

@ Variablen
.global String_buffer


/************************************************************************
* Konstanten
************************************************************************/
@@ .section myconst               @ Wird in ldscript_ram in .text gelegt

@ Ertänzung von pxa270.s, andere verwendeten Register sind dort definiert
.set FFABR, 0x40100028            @ Auto-baud Control register

@ Hilfskonstante
.set BUFFER_SIZE_1, BUFFER_SIZE+1 @ Verwendet, da Buffer eigentlich 2 grösser ist (zur Kontrolle von CRLF)


/************************************************************************
* Nicht initialisierte Variablen, section bss
************************************************************************/
@@ .bss
@@ .align


/************************************************************************
* Initialisierte Variablen, section data
************************************************************************/
.data
.align

@ Flags
UART_read_enabled:  .word 0x0   @ Um das Lesen vom UART ein-/auszuschalten
String_ready:       .word 0x0   @ Wird gesetzt sobald nach einem CR-LF der ganze String bereit ist

@ Variablen
buffer_i:           .word 0x0   @ Buffer-Index
String_buffer:      .space BUFFER_SIZE+2, 0x00 @ Eindimensionales Array der Grösse BUFFER_SIZE Bytes, initialisiert mit 0x00 ('\0')


/************************************************************************
* Code
************************************************************************/
@@ .section mycode,"x"          @ Wird in ldscript_ram in .mycode gelegt
.text                           @ section text (executable code)
.arm                            @ generate ARM-Code


/************************************************************************
* Funktion     : UART_init
* Authoren     : N. Käser
* Datum        : Januar 2013
* Version      : 1.0
* Beschreibung : Initialisiert die serielle Schnittstelle
*                (ohne Interrupt)
* -----------------------------------------------------------------------
* Benötigt     : UART_Einstellungen,
*                pxa270.s oder manuelle Registerdefinitionen
************************************************************************/
UART_init:
    STR lr, [sp, #-4]!          @ push lr on the stack

    @======================================
    @ Takt für das UART Modul freischalten
    @======================================
    @ C: CKEN |= 0x40; //Bit 6 (FFUART Unit Clock Enable) von CKEN 1 setzen
    LDR r0, =CKEN               @ Adresse von CKEN nach r0 laden
    LDR r1, [r0]                @ Wert von CKEN nach r1 laden
    ORR r1, r1, #0x40           @ Bit 6 setzen
    STR r1, [r0]                @ Neuer Wert speichern

    @===================
    @ UART ausschalten:
    @===================
    @ C: FFLCR &= ~0x80; //Bit 7 (DLAB) auf 0
    LDR r0, =FFLCR              @ Adresse nach r0 laden
    LDR r1, [r0]                @ Wert nach r1 laden
    BIC r1, r1, #0x80           @ Bit 7 löschen
    STR r1, [r0]                @ Neuer Wert speichern
    @ C: FFIER &= ~0x40; //Bit 6 (UUE) auf 0
    LDR r0, =FFIER              @ Adresse nach r0 laden
    LDR r1, [r0]                @ Wert nach r1 laden
    BIC r1, r1, #0x40           @ Bit 6 löschen
    STR r1, [r0]                @ Neuer Wert speichern

    @=========================
    @ GPIO-Pins konfigurieren
    @=========================
    LDR r0, =GAFR1_L            @ Adresse nach r0 laden
    LDR r1, [r0]                @ Wert nach r1 laden
    @-------------------------------------------
    @ Bit 5 und 4 (AF34) auf 0b01 -> Funktion 1
    @-------------------------------------------
    @ C: GAFR1_L |= 0x10; //Bit 4 auf 1
    ORR r1, r1, #0x10           @ Bit 4 setzen
    @ C: GAFR1_L &= ~0x20; //Bit 5 auf 0
    BIC r1, r1, #0x20           @ Bit 5 löschen
    @---------------------------------------------
    @ Bit 15 und 14 (AF39) auf 0b10 -> Funktion 1
    @---------------------------------------------
    @ C: GAFR1_L |= 0x8000; //Bit 15 auf 1
    ORR r1, r1, #0x8000         @ Bit 15 setzen
    @ GAFR1_L &= ~0x4000; //Bit 14 auf 0
    BIC r1, r1, #0x4000         @ Bit 14 löschen
    @ Erst jetzt zurück speichern
    STR r1, [r0]                @ Neuer Wert speichern

    @ C: GPDR1 &= ~0x4; //Bit 2 (PD34) auf 0 (Input)
    LDR r0, =GPDR1              @ Adresse nach r0 laden
    LDR r1, [r0]                @ Wert nach r1 laden
    BIC r1, r1, #0x4            @ Bit 2 löschen
    @ C: GPDR1 |= 0x80; //Bit 7 (PD39) auf 1 (Output)
    ORR r1, r1, #0x80           @ Bit 7 setzen
    STR r1, [r0]                @ Neuer Wert speichern

    @=====================
    @ Diverse ausschalten
    @=====================
    LDR r1, =0x0                @ Wert 0x0 nach r1 laden
    @ C: FFFCR = 0x0; //FIFO Control
    LDR r0, =FFFCR              @ Adresse nach r0 laden
    STR r1, [r0]                @ Wert speichern
    @ C: FFMCR = 0x0; //Modem Control
    LDR r0, =FFMCR              @ Adresse nach r0 laden
    STR r1, [r0]                @ Wert speichern
    @ C: FFISR = 0x0; //Infrared Selection
    LDR r0, =FFISR              @ Adresse nach r0 laden
    STR r1, [r0]                @ Wert speichern
    @ C: FFABR = 0x0; //Auto Baudrate
    LDR r0, =FFABR              @ Adresse nach r0 laden
    STR r1, [r0]                @ Wert speichern

    @======================================
    @ Baudrate mit Wert von DIVISOR setzen
    @======================================
    @ C: FFLCR |= 0x80; //Bit 7 (DLAB) auf 1
    LDR r0, =FFLCR              @ Adresse nach r0 laden
    LDR r1, [r0]                @ Wert nach r1 laden
    ORR r1, r1, #0x80           @ Bit 7 setzen
    STR r1, [r0]                @ Neuer Wert speichern
    @ C: FFDLH = DIVISOR>>8; //Hightbyte vom Divisor setzen
    LDR r0, =FFDLH              @ Adresse nach r0 laden
    LDR r1, =DIVISOR            @ Wert nach r1 laden
    MOV r1,r1, LSR #8           @ Wert um 8 nach rechts schieben
    STR r1, [r0]                @ Neuer Wert speichern
    @ C: FFDLL = DIVISOR&0xFF; //Lowbyte vom Divisor setzen
    LDR r0, =FFDLL              @ Adresse nach r0 laden
    LDR r1, =DIVISOR            @ Wert nach r1 laden
    AND r1, r1, #0xFF           @ Nur das Lowbyte vom Wert
    STR r1, [r0]                @ Neuer Wert speichern

    @================================================================
    @ FFLCR Laden, wird bei Parität, Stopbits und Databis gebraucht!
    @================================================================
    LDR r0, =FFLCR              @ Adresse nach r0 laden
    LDR r1, [r0]                @ Wert nach r1 laden

    @================
    @ Parität setzen
    @================
    @--------------------------
    @ Parität ein-/ausschalten
    @--------------------------
    @ C: FFLCR &= ~0x8; //Bit 3 (PEN) ersmal löschen
    BIC r1, r1, #0x8            @ Bit 3 löschen
    @ C: FFLCR |= P_ENABLE<<3; //Wenn P_ENABLE 1, dann wird Bit 3 gesetzt
    MOV r2, #P_ENABLE           @ P_ENABLE nach r2 laden
    ORR r1, r1, r2, LSL #3      @ Bit 3 auf P_ENABLE setzen
    @-------------------------
    @ Parität Even/Odd setzen
    @-------------------------
    @ C: FFLCR &= ~0x10; //Bit 4 (EPS) ersmal löschen
    BIC r1, r1, #0x10           @ Bit 4 löschen
    @ C: FFLCR |= P_EVEN<<4; //Wenn P_EVEN 1, dann wird Bit 4 gesetzt
    MOV r2, #P_EVEN             @ P_EVEN nach r2 laden
    ORR r1, r1, r2, LSL #4      @ Bit 4 auf P_ENABLE setzen

    @==================
    @ Stoppbits setzen
    @==================
    @ C: FFLCR &= ~0x4; //Bit 2 (STB) erstmal löschen
    BIC r1, r1, #0x4            @ Bit 2 löschen
    @ C: FFLCR |= S_BITS<<2; //Wenn S_BITS 1, dann wird Bit 2 gesetzt
    MOV r2, #S_BITS             @ S_BITS nach r2 laden
    ORR r1, r1, r2, LSL #2      @ Bit 2 auf S_BITS setzen

    @=================
    @ Databits setzen
    @=================
    @ C: FFLCR |= 0x3; //Bits 0,1 (WLS) erstmal löschen
    BIC r1, r1, #0x3            @ Bits 0 und 1 löschen
    @ C: FFLCR |= D_BITS; //Wert von D_BITS nach FFLCR speichern
    ORR r1, r1, #D_BITS         @ Bit 0 und 1 auf D_BITS setzen

    @==========================================
    @ r1 erst jetzt zurück auf FFLCR speichern
    @==========================================
    STR r1, [r0]                @ Neuer Wert speichern

    @==================
    @ UART einschalten
    @==================
    @ C: FFLCR &= ~0x80; //Bit 7 (DLAB) auf 0
    LDR r0, =FFLCR              @ Adresse nach r0 laden
    LDR r1, [r0]                @ Wert nach r1 laden
    BIC r1, r1, #0x80           @ Bit 7 löschen
    STR r1, [r0]                @ Neuer Wert speichern
    @ C: FFIER |= 0x40; //Bit 6 (UUE) von FFIER 1 setzen
    LDR r0, =FFIER              @ Adresse nach r0 laden
    LDR r1, [r0]                @ Wert nach r1 laden
    ORR r1, r1, #0x40           @ Bit 6 setzen
    STR r1, [r0]                @ Neuer Wert speichern

    LDR pc, [sp], #4            @ return
@ end UART_init


/************************************************************************
* Funktion     : UART_irq_init
* Authoren     : N. Käser
* Datum        : Januar 2013
* Version      : 1.0
* Beschreibung : Definiert die serielle Schnittstelle als Interruptquelle
* -----------------------------------------------------------------------
* Benötigt     : UART_Einstellungen,
*                pxa270.s oder manuelle Registerdefinitionen
************************************************************************/
UART_irq_init:
    STR lr, [sp, #-4]!          @ push lr on the stack

    @=================
    @ UART-spezifisch
    @=================
    @ C: FFMCR |= 0x8; //Bit 3 (OUT2) setzen um IRQ für UART einzuschalten
    LDR r0, =FFMCR              @ Adresse nach r0 laden
    LDR r1, [r0]                @ Wert nach r1 laden
    ORR r1, r1, #0x8            @ Bit 3 setzen
    STR r1, [r0]                @ Neuer Wert speichern
    @ C: FFLCR &= ~0x80; //Bit 7 (DLAB) auf 0
    LDR r0, =FFLCR              @ Adresse nach r0 laden
    LDR r1, [r0]                @ Wert nach r1 laden
    BIC r1, r1, #0x80           @ Bit 7 löschen
    STR r1, [r0]                @ Neuer Wert speichern
    @ C: FFIER &= ~0x1F; // Alle Interrupt-Quellen ausschalten
    LDR r0, =FFIER              @ Adresse nach r0 laden
    LDR r1, [r0]                @ Wert nach r1 laden
    BIC r1, r1, #0x1F           @ Bits 0-4 löschen
    STR r1, [r0]                @ Neuer Wert speichern
    @ C: FFIER |= 0x1; //Receiver Data Available Interrupt Enable (RAVIE)
    LDR r0, =FFIER              @ Adresse nach r0 laden
    LDR r1, [r0]                @ Wert nach r1 laden
    ORR r1, r1, #0x1            @ Bit 0 setzen
    STR r1, [r0]                @ Neuer Wert speichern

    @===========================================================
    @ Interrupt-spezifisch
    @ Interrupt für UART (besitzt ID 22 also Bit 22) einstellen
    @===========================================================
    @ C: ICMR |= 0x400000; //Interruptquelle
    LDR r0, =ICMR               @ Adresse nach r0 laden
    LDR r1, [r0]                @ Wert nach r1 laden
    ORR r1, r1, #0x400000       @ Bit 22 setzen
    STR r1, [r0]                @ Neuer Wert speichern
    @ C: ICLR &= ~0x400000; //Bit löschen für IRQ (setzen wäre FIRQ)
    LDR r0, =ICLR               @ Adresse nach r0 laden
    LDR r1, [r0]                @ Wert nach r1 laden
    BIC r1, r1, #0x400000       @ Bit 22 löschen
    STR r1, [r0]                @ Neuer Wert speichern
    @ C: IPR1 = 22; //Priorität 1 (2. Höchste)
    LDR r0, =IPR1               @ Adresse nach r0 laden
    LDR r1, =22                 @ Wert nach r1 laden
    STR r1, [r0]                @ Neuer Wert speichern
    @ C: IPR1 |= 0x80000000; //Bit 31 setzten damit gültig (1 valid, 0 invalid)
    LDR r0, =IPR1               @ Adresse nach r0 laden
    LDR r1, [r0]                @ Wert nach r1 laden
    ORR r1, r1, #0x80000000     @ Bit 31 setzen
    STR r1, [r0]                @ Neuer Wert speichern

    LDR pc, [sp], #4            @ return
@ end UART_irq_init


/************************************************************************
* Funktion     : UART_read_irq
* Authoren     : N. Käser
* Datum        : Januar 2013
* Version      : 1.0
* Beschreibung : Interrupt Handler für die serielle Schnittstelle,
*                füllt String_buffer mit den empfangenen Zeichen und
*                und setzt nach einem CR-LF das Flag String_ready
* -----------------------------------------------------------------------
* Benötigt     : UART_Einstellungen,
*                pxa270.s oder manuelle Registerdefinitionen,
*                muss in die Vektortabelle eingetragen werden
************************************************************************/
UART_read_irq:
    STMFD sp!, {r0-r3, r12, lr} @ Kontext speichern (Auch r0-r3 und r12, da Interrupt-Handler)

    @ C: if(!UART_read_enabled) return;
    LDR r0, =UART_read_enabled  @ Adresse nach r0 laden
    LDR r1, [r0]                @ Wert nach r1 laden
    TEQ r1, #1                  @ Vergleich ob Flag = 1
    BNE return_UART_read_irq    @ Sprung nach return wenn ungleich
    @ C: if((FFIIR&0x6) != 0x4) return; //Kein data recieved interrupt (FFIIR[1:2] != 0b10)
    LDR r0, =FFIIR              @ Adresse nach r0 laden
    LDR r1, [r0]                @ Wert nach r1 laden
    AND r1, r1, #0x6            @ Bit 1-2 maskieren
    TEQ r1, #0x4                @ Vergleich
    BNE return_UART_read_irq    @ Sprung nach return wenn ungleich

    @ C: FFLCR &= ~0x80; //Bit 7 (DLAB) auf 0 für Zugriff auf Rx-Register FFRBR
    LDR r0, =FFLCR              @ Adresse nach r0 laden
    LDR r1, [r0]                @ Wert nach r1 laden
    BIC r1, r1, #0x80           @ Bit 7 löschen
    STR r1, [r0]                @ Neuer Wert speichern
    @ C: String_buffer[buffer_i] = FFRBR; //Aktuelles Zeichen in Buffer schreiben
    LDR r0, =FFRBR              @ Adresse nach r0 laden
    LDRB r1, [r0]               @ Wert nach r1 laden (Byte -> Char)
    LDR r0, =buffer_i           @ Adresse nach r0 laden
    LDR r2, [r0]                @ Index nach r2 laden
    LDR r0, =String_buffer      @ Basisadresse nach r0 laden
    STRB r1, [r0, r2]           @ Wert speichern nach [Basis + Index *1] (Skalierungsfaktor = 1, da Byte)

    @=======================
    @ Buffergrösse beachten
    @=======================
    /*
    Buffergrösse ist max. Anzahl Zeichen die vom User erhalten werden können (weitere werden verworfen)
    Buffer[Buffergrösse] und Buffer[Buffergrösse+1] nur für CR & LF reserviert (Buffer ist in Wahrheit um 2 grösser als Buffergrösse)
    Möglichkeiten bei Buffergrösse=50:
      i: 49.50.51
    1.   xx|xx|   -> i-1, damit nächstes mal wieder i=50
    2.   xx|LF|   -> i-1, "
    3.   CR|LF|   -> ok, nichts unternehmen
    4.   xx|CR|xx -> i-2, damit nächstes mal wieder i=50
    5.   xx|CR|LF -> ok, nichts unternehmen

    if((buffer_i == 50) && (String_buffer[buffer_i] != '\r')) // Möglichkeit 1,2,3 (if_buffer_50a)
    {
        if(String_buffer[buffer_i] != '\n' || String_buffer[buffer_i-1] != '\r') // Möglichkeit 1,2 (if_buffer_50b)
        {
            buffer_i -= 1;
        }
    }
    if((buffer_i >= 51) && (String_buffer[buffer_i] != '\n')) // Möglichkeit 4 (if_buffer_51)
    {
        buffer_i -= 2;
    }
    */
    if_buffer_50a: @ (
    LDR r0, =buffer_i           @ Adresse nach r0 laden
    LDR r1, [r0]                @ Wert nach r1 laden
    CMP r1, #BUFFER_SIZE        @ Vergleich
    BNE endif_buffer_50a        @ Sprung nach endif wenn ungleich
    @ &&
    LDR r0, =buffer_i           @ Adresse nach r0 laden
    LDR r1, [r0]                @ Index nach r1 laden
    LDR r0, =String_buffer      @ Basisaddresse nach r0 laden
    LDRB r1, [r0, r1]           @ Wert nach r1 laden (Byte -> Char); r1 = [Basis + Index *1] (Skalierungsfaktor = 1, da Byte)
    TEQ r1, #0x0D               @ Vergleich ob Wert = 0x0D (CR)
    BEQ endif_buffer_50a @ )    @ Sprung nach endif wenn diese Bedingung erfüllt
    @ {
        if_buffer_50b: @ (
        LDR r0, =buffer_i           @ Adresse nach r0 laden
        LDR r1, [r0]                @ Index nach r1 laden
        LDR r0, =String_buffer      @ Basisaddresse nach r0 laden
        LDRB r1, [r0, r1]           @ Wert nach r1 laden (Byte -> Char); r1 = [Basis + Index *1] (Skalierungsfaktor = 1, da Byte)
        TEQ r1, #0x0A               @ Vergleich ob Wert = 0x0A (LF)
        BNE if_buffer_50b_true @ )  @ Sprung nach true wenn diese Bedingung nicht erfüllt
        @ ||
        LDR r0, =buffer_i           @ Adresse nach r0 laden
        LDR r1, [r0]                @ Index nach r1 laden
        SUB r1, r1, #1              @ Wert dekrementieren
        LDR r0, =String_buffer      @ Basisaddresse nach r0 laden
        LDRB r1, [r0, r1]           @ Wert nach r1 laden (Byte -> Char); r1 = [Basis + (Index-1) *1] (Skalierungsfaktor = 1, da Byte)
        TEQ r1, #0x0D               @ Vergleich ob Wert = 0x0D (CR)
        BEQ endif_buffer_50b @ )    @ Sprung nach endif wenn diese Bedingung erfüllt
        @ )
        if_buffer_50b_true:
        @ {
            @ C:  buffer_i -= 1; // Dekrementieren, um Zeichen zu verwerfen
            LDR r0, =buffer_i           @ Adresse nach r0 laden
            LDR r1, [r0]                @ Wert nach r1 laden
            SUB r1, r1, #0x1            @ Wert dekrementieren
            STR r1, [r0]                @ Neuer Wert speichern
        @ }
        endif_buffer_50b:
    @ }
    endif_buffer_50a:
    if_buffer_51: @ (
    LDR r0, =buffer_i           @ Adresse nach r0 laden
    LDR r1, [r0]                @ Wert nach r1 laden
    CMP r1, #BUFFER_SIZE_1      @ Vergleich
    BLT endif_buffer_51         @ Sprung nach endif wenn kleiner
    @ &&
    LDR r0, =buffer_i           @ Adresse nach r0 laden
    LDR r1, [r0]                @ Index nach r1 laden
    LDR r0, =String_buffer      @ Basisaddresse nach r0 laden
    LDRB r1, [r0, r1]           @ Wert nach r1 laden (Byte -> Char); r1 = [Basis + Index *1] (Skalierungsfaktor = 1, da Byte)
    TEQ r1, #0x0A               @ Vergleich ob Wert = 0x0A (LF)
    BEQ endif_buffer_51 @ )     @ Sprung nach endif wenn diese Bedingung erfüllt
    @ {
        @ C:   buffer_i -= 2; // Dekrementieren, um Zeichen und CR zu verwerfen
        LDR r0, =buffer_i           @ Adresse nach r0 laden
        LDR r1, [r0]                @ Wert nach r1 laden
        SUB r1, r1, #0x2            @ Wert dekrementieren
        STR r1, [r0]                @ Neuer Wert speichern
    @ }
    endif_buffer_51:

    @==================
    @ Auf CR-LF prüfen
    @==================
    @ C: if((buffer_i>0) && (String_buffer[buffer_i] == '\n') && (String_buffer[buffer_i-1] == '\r'))
    if_crlf: @ (
    LDR r0, =buffer_i           @ Adresse nach r0 laden
    LDR r1, [r0]                @ Wert nach r1 laden
    CMP r1, #0x0                @ Vergleich
    BLE else_crlf               @ Sprung nach else wenn kleiner oder gleich
    @ &&
    LDR r0, =buffer_i           @ Adresse nach r0 laden
    LDR r1, [r0]                @ Index nach r1 laden
    LDR r0, =String_buffer      @ Basisaddresse nach r0 laden
    LDRB r1, [r0, r1]           @ Wert nach r1 laden (Byte -> Char); r1 = [Basis + Index *1] (Skalierungsfaktor = 1, da Byte)
    TEQ r1, #0x0A               @ Vergleich ob Wert = 0x0A (LF)
    BNE else_crlf               @ Sprung nach else wenn diese Bedingung nicht erfüllt
    @ &&
    LDR r0, =buffer_i           @ Adresse nach r0 laden
    LDR r1, [r0]                @ Index nach r1 laden
    SUB r1, r1, #1              @ Wert dekrementieren
    LDR r0, =String_buffer      @ Basisaddresse nach r0 laden
    LDRB r1, [r0, r1]           @ Wert nach r1 laden (Byte -> Char); r1 = Basis + (Index-1) *1 (Skalierungsfaktor = 1, da Byte)
    TEQ r1, #0x0D               @ Vergleich ob Wert = 0x0D (CR)
    BNE else_crlf               @ Sprung nach else wenn diese Bedingung nicht erfüllt
    @ {
    @ C: String_buffer[buffer_i-1] = '\0'; //CR mit '\0' überschreiben um nachfolgendes zu ignorieren
    LDR r0, =buffer_i           @ Adresse nach r0 laden
    LDR r2, [r0]                @ Index nach r1 laden
    SUB r2, r2, #1              @ Index-Wert dekrementieren
    LDR r0, =String_buffer      @ Basisaddresse nach r0 laden
    LDR r1, =0x00               @ Wert nach r1 laden
    STRB r1, [r0, r2]           @ Neuer Wert speichern nach [Basis + (Index-1) *1] (Skalierungsfaktor = 1, da Byte)
    @ C: buffer_i = 0; //Zurücksetzen, für nächste Übertragung
    LDR r0, =buffer_i           @ Adresse nach r0 laden
    LDR r1, =0x0                @ Wert nach r1 laden
    STR r1, [r0]                @ Neuer Wert speichern
    @ C: String_ready = TRUE;
    LDR r0, =String_ready       @ Adresse nach r0 laden
    LDR r1, =0x1                @ Wert nach r1 laden
    STR r1, [r0]                @ Neuer Wert speichern
    @ }
    B endif_crlf
    else_crlf:
    @ {
    LDR r0, =buffer_i           @ Adresse nach r0 laden
    LDR r1, [r0]                @ Wert nach r1 laden
    ADD r1, #0x1                @ Wert inkrementieren
    STR r1, [r0]                @ Neuer Wert speichern
    @ }
    B endif_crlf
    endif_crlf:

    return_UART_read_irq:
    LDMFD sp!, {r0-r3, r12, pc}^@ Kontext wiederherstellen und return
@ end UART_read_irq


/************************************************************************
* Funktion     : UART_write
* Authoren     : N. Käser
* Datum        : Januar 2013
* Version      : 1.0
* Beschreibung : Gibt einen String auf die serielle Schnittstelle aus
* -----------------------------------------------------------------------
* Benötigt     : UART_Einstellungen,
*                pxa270.s oder manuelle Registerdefinitionen
* -----------------------------------------------------------------------
* Input        : *stringptr: Zeiger aufs 1. Element eines char Strings,
*                            der übertragen werden soll
************************************************************************/
UART_write:
    STR lr, [sp, #-4]!          @ push lr on the stack
    MOV r3, r0                  @ Eingabe-Parameter nach r3 laden

    @ C: FFLCR &= ~0x80; //Bit 7 (DLAB) auf 0
    LDR r0, =FFLCR              @ Adresse nach r0 laden
    LDR r1, [r0]                @ Wert nach r1 laden
    BIC r1, r1, #0x80           @ Bit 7 löschen
    STR r1, [r0]                @ Neuer Wert speichern

    @ C: while(string[i] != '\0')
    while_kein_stringende: @ (
    LDRB r1, [r3]               @ Wert nach r1 laden (Byte -> Char)
    TEQ r1, #0x00               @ Vergleich
    BEQ endwhile_kein_stringende @ )
    @ {
    @ C: while (!(FFLSR & 0x20)); //Warten bis Transmit-Buffer leer (Bit 5 = TDRQ)
    while_tx_nicht_bereit: @ (
    LDR r0, =FFLSR              @ Adresse nach r0 laden
    LDR r1, [r0]                @ Wert nach r1 laden
    AND r1, r1, #0x20           @ Bit 5
    TEQ r1, #0x20               @ Vergleich
    BEQ endwhile_tx_nicht_bereit @ )
    @ {}
    B while_tx_nicht_bereit
    endwhile_tx_nicht_bereit:

    @ C: FFTHR = string[i]; //Zeichen senden
    LDR r0, =FFTHR              @ Adresse nach r0 laden
    LDRB r1, [r3]               @ Wert nach r1 laden (Byte -> Char)
    STR r1, [r0]                @ Wert speichern/senden

    @ C: i++;
    ADD r3, r3, #1              @ Adresse (Pointer) um 1 erhöhen, für nächstes Element (Byte)
    @ }
    B while_kein_stringende
    endwhile_kein_stringende:

    LDR pc, [sp], #4            @ return
@ end UART_write


.endif @ _UART_S_
