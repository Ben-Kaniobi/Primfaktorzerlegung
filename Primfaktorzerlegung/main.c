/************************************************************************
*
* Projekt      : Primfaktorzerlegung
*
*************************************************************************
* Modul        : Main
* File-Name    : main.c
* Version      : 1.0
* Datum        : Januar 2013
* Author       : J. Haldemann, N. K�ser
* -----------------------------------------------------------------------
* Beschreibung : Main f�r die Primfaktorzerlegung
* -----------------------------------------------------------------------
* Inhalt       : main
************************************************************************/

#include <stdio.h>
#include <string.h>
#include "Strings.h"
#include "main.h"
#include "interrupts.h"

/************************************************************************
* Funktion     : main
* Authoren     : J. Haldemann, N. K�ser
* Datum        : Januar 2013
* Version      : 1.0
* Beschreibung : Main
* -----------------------------------------------------------------------
* Ben�tigt     : main.h, interrupts.h, Primfaktorzerlegung.s, Strings.c,
*                Strings.h, UART_Einstellungen.s, UART.s
************************************************************************/
int main(int argc, char *argv[])
{
    // LEDs ausschalten
    LEDS = 0x0;
    // UART und UART Interrupt initialisieren
    UART_init();
    UART_irq_init();
    // Interrupts einschalten
    _ENABLE_IRQ();

    // Flag setzen, um UART Empfang einzuschalten
    UART_read_enabled = TRUE;
    // Flag l�schen, um String-Buffer von Anfang an zu f�llen
    String_ready = FALSE;

    // Startnachricht ausgeben
    UART_write(START_MSG "\n");

    for(EVER)
    {
        // Warten bis String-Buffer komplette �bertragung enth�lt
        if(String_ready == TRUE)
        {
            // UART Empfang ausschalten
            UART_read_enabled = FALSE;

            // Empfangene Nachricht zu Integer konvertieren
            input_zahl = string_to_int(String_buffer);
            // �berpr�fen ob Konvertierung fehlgeschlagen (Die Nachricht war eine ung�ltige Zahl)
            if(input_zahl == ERROR)
            {
                // Fehlernachricht in Output-String kopieren
                strcpy(output_string, ERROR_MSG);
            }
            else // Zahl g�ltig
            {
                // Primfaktorzerlegung durchf�hren, Ergebnis wird ins Array geschrieben
                primfaktorzerlegung(input_zahl, output_array);
                // Primfaktoren im Array zu Integer konvertieren und im Output-String abspeichern
                intarray_to_string(output_array, output_string);
            }

            // Eingegebener String mit " = " erweitern und �ber UART ausgeben
            strcat(String_buffer, " = ");
            UART_write(String_buffer);
            // Output-String ausgeben plus Newline
            UART_write(output_string);
            UART_write("\n");

            // Flag wieder l�schen, um String-Buffer wieder von Anfang an zu �berschreiben
            String_ready = FALSE;
            // Flag setzen um UART Empfang wieder einzuschalten
            UART_read_enabled = TRUE;
        }
    }

    /* Errorcode, just for fun, will be ignored anyway... */
    return 0;
}
