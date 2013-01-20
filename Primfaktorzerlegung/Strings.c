/************************************************************************
*
* Projekt      : Primfaktorzerlegung
*
*************************************************************************
* Modul        : Primfaktorzerlegung
* File-Name    : Strings.c
* Version      : 2.0
* Datum        : Januar 2013
* Authoren     : J. Haldemann, N. K�ser, S. Plattner
* -----------------------------------------------------------------------
* Beschreibung : String Umwandlungen f�r die Primfaktorzerlegung
* -----------------------------------------------------------------------
* Inhalt       : ipow, string_to_int, intarray_to_string
************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "strings.h"


/************************************************************************
* Funktion     : ipow
* Authoren     : J. Haldemann, N. K�ser
* Datum        : Januar 2013
* Version      : 1.0
* Beschreibung : Berechnet eine uint32 Potenz mit der �bergebenen Basis
*                und dem Exponent. Achtung! -> gibt bei einem �berlauf
*                den Maximalwert (2^32-1) zur�ck!
* -----------------------------------------------------------------------
* Input        : base:   Basis der Potenz
*                exp:    Exponent der Potenz
* Output       : result: �bergibt die berechnete Potenz
************************************************************************/
unsigned int ipow(int base, int exp)// result = base^exp
{
    unsigned int result = 1;            // Zur�ckzugebende Variable
    unsigned int result_bkp = 0;        // Backup der zur�ckzugebenden Variable

    while(exp>0)
    {
        result *= base;
        if(result < result_bkp)
        {
            return 0xFFFFFFFF;          // Bei einem �berlauf den Maximalwert zur�ckgeben
        }
        result_bkp = result;
        exp--;
    }

    return result;
}


/************************************************************************
* Funktion     : string_to_int
* Authoren     : J. Haldemann, N. K�ser, S. Plattner
* Datum        : Januar 2013
* Version      : 2.0
* Beschreibung : Umwandlung eines Strings in einen unsigned int, falls
*                Eingabe g�ltig
* -----------------------------------------------------------------------
* Ben�tigt     : string.h, ipow()
* -----------------------------------------------------------------------
* Input        : *stringptr: Zeiger aufs 1. Element eines char Strings,
*                            in welchem die Zeichen des Inputs stehen
************************************************************************/
unsigned int string_to_int(char *stringptr) // bekommt startadr. vom inputstring
{
    char *string_start_adr;         // pointer f�r (neue) startadr. des strings
    unsigned int integer = 0;       // Auszugebende Variable (unsigned int)
    int k = 0;                      // counter f�r g�ltige Stelle im Array
    int max = 1;                    // max-flag (gesetzt), wird gel�scht bei �berschreitung eines Maximalwerts
    int ziffer;                     // f�r jeweils aktuelle Ziffer
    int ziffer_max;                 // f�r jeweils das Maximum der aktuellen Ziffer
    int i;                          // for-counter

    // Erlaubte Maximalwert (2^32-2 = 0xFFFFFFFE = 4294967294)
    unsigned int max_wert = 0xFFFFFFFE;

    // Error, falls String leer ('\0' = 0)
    if(*stringptr == 0) return ERROR;

    // Alle vordran stehenden Nullen ignorieren, danach...
    while(*stringptr == '0') { stringptr++; }
    string_start_adr = stringptr;   // ...startadresse des strings setzten

    // Error, falls Eingabe gr�sser als definierte max. Anzahl Stellen
    if(strlen(string_start_adr) > INPUTSTRINGLENGTH) { return ERROR; } // strlen() gibt die benutzte Stringl�nge zur�ck

    // Jeden char �berpr�fen ob g�ltige Eingabe, bis zu einem 0 ('\0') oder...
    while(*stringptr != 0)
    {
        // ...Error, falls char kleiner als ASCII '0' oder gr�sser als ASCII '9'
        if(*stringptr < '0' || *stringptr > '9') { return ERROR; }

        // ...Error, falls Eingabe gr�sser als Maximalwert (2^32-2), aber kleiner als die erste Zahl mit 11 Stellen (10^10)
        if(strlen(string_start_adr) == INPUTSTRINGLENGTH) // �berpr�fen ob Eingabe genau 10 Stellen
        {
            ziffer = *stringptr - '0'; // aktuelle Ziffer als int speichern

            // jeweils das Maximum des aktuellen chars in ziffer_max speichern
            ziffer_max = ((unsigned int)(max_wert / (ipow(10,INPUTSTRINGLENGTH - 1 - k)))) % 10;
            // ziffer max = ((unsigned int)(4294967294 / 10^(9-k))) % 10
            // das gibt bei: k = 1 -> ziffer_max = 4
            //               k = 2 -> ziffer_max = 2
            //               k = 3 -> ziffer_max = 9  usw...

            if (max == 1)   // falls max-flag gesetzt...
            {
                if (ziffer > ziffer_max) { return ERROR; }  // ...�berpr�fen ob momentaner char > max -> ERROR
                if (ziffer < ziffer_max) { max = 0; }       // ...�berpr�fen ob momentaner char < max -> max-flag l�schen (Rest somit okay)
                // ziffer == ziffer_max -> max = 1; (ist aber bereits gesetzt)
            }
        }

        k++;    // k inkrementieren (jeweils +1 pro g�ltiger char)

        stringptr = string_start_adr + k;   // stringptr inkrementieren
    }

    // 0 zur�ckgeben, falls k immer noch 0 (Eingabe war '0')
    if(k == 0) { return 0; }

    // ->(integer hat jetzt sicher einen Wert zwischen 0 und 2^32-1)
    // Auszugebender int berechnen
    for(i = 0; i < k; i++)
    {
        // int-Berechnungsformel
        integer += (*(string_start_adr + i) - '0') * ipow(10,k-1-i);

/* Bsp. der Berechnungsformel mit string = {0, 1, 5, \0} -> k ist also 2 und integer sollte 15 werden:
    -> i = 0:   integer = 0  + ('1' - '0')  * 10^(2-1-0)
                        = 0  +      1       * 10^   1       = 10
    -> i = 1:   integer = 10 + ('5' - '0')  * 10^(2-1-1)
                        = 10 +      5       * 10^   0       = 15
    -> i = 2:   i nicht mehr < k -> endbedingung erf�llt -> integer = 15
*/
    }

    return integer;
}


/************************************************************************
* Funktion     : intarray_to_string
* Authoren     : J. Haldemann
* Datum        : Januar 2013
* Version      : 1.0
* Beschreibung : Umwandlung eines Arrays mit uint32 Zahlen in einen
*                String mit Primzahlen, '*' und Leerschl�gen
* -----------------------------------------------------------------------
* Ben�tigt     : string.h, stdio.h
* -----------------------------------------------------------------------
* Input        : *primarrayptr:    Zeiger aufs erste Element eines uint32
*                                  Arrays, in welchem die Primfaktoren
*                                  (aufsteigend) aufgelistet wurden
*                *outputstringptr: Zeiger auf ein Outputstring
************************************************************************/
void intarray_to_string(unsigned int *primarrayptr, char *outputstringptr)
{
    int n;      // for-counter f�r Outputstring-/Primarraystelle

    // erste Primzahl in den Outputstring speichern
    sprintf(outputstringptr, "%u", *primarrayptr);

    // weitere Primzahlen mit * und Leerschl�gen in den Hilfsstring speichern bis erstes 0 im Primarray,
    // dann den Hilfsstring an den Outputstring anh�ngen mit strcat() aus string.h
    for(n = 1; (n < INTARRAYLENGTH) && ((*(primarrayptr + n)) != 0); n++)
    {
        // Hilfsstring jeweils mit 0 initialisieren / l�schen
    	// Hilfsstring braucht max. 10 (Anzahl Stellen gr�sster Primahl) + 3 (ein '*' und 2 Leerschl�ge) + 1 (f�r ein '\0') = 14 Stellen
        char hilfsstring[INPUTSTRINGLENGTH + 4] = {};
        sprintf(hilfsstring, " * %u", *(primarrayptr + n));
        strcat(outputstringptr, hilfsstring);           // h�ngt den Hilfsstring an den Outputstring
    }

    return;
}
