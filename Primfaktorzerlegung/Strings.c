/************************************************************************
*
* Projekt      : Primfaktorzerlegung
*
*************************************************************************
* Modul        : Primfaktorzerlegung
* File-Name    : Strings.c
* Version      : 2.0
* Datum        : Januar 2013
* Authoren     : J. Haldemann, N. Käser, S. Plattner
* -----------------------------------------------------------------------
* Beschreibung : String Umwandlungen für die Primfaktorzerlegung
* -----------------------------------------------------------------------
* Inhalt       : ipow, string_to_int, intarray_to_string
************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "strings.h"


/************************************************************************
* Funktion     : ipow
* Authoren     : J. Haldemann, N. Käser
* Datum        : Januar 2013
* Version      : 1.0
* Beschreibung : Berechnet eine uint32 Potenz mit der übergebenen Basis
*                und dem Exponent. Achtung! -> gibt bei einem Überlauf
*                den Maximalwert (2^32-1) zurück!
* -----------------------------------------------------------------------
* Input        : base:   Basis der Potenz
*                exp:    Exponent der Potenz
* Output       : result: übergibt die berechnete Potenz
************************************************************************/
unsigned int ipow(int base, int exp)// result = base^exp
{
    unsigned int result = 1;            // Zurückzugebende Variable
    unsigned int result_bkp = 0;        // Backup der zurückzugebenden Variable

    while(exp>0)
    {
        result *= base;
        if(result < result_bkp)
        {
            return 0xFFFFFFFF;          // Bei einem Überlauf den Maximalwert zurückgeben
        }
        result_bkp = result;
        exp--;
    }

    return result;
}


/************************************************************************
* Funktion     : string_to_int
* Authoren     : J. Haldemann, N. Käser, S. Plattner
* Datum        : Januar 2013
* Version      : 2.0
* Beschreibung : Umwandlung eines Strings in einen unsigned int, falls
*                Eingabe gültig
* -----------------------------------------------------------------------
* Benötigt     : string.h, ipow()
* -----------------------------------------------------------------------
* Input        : *stringptr: Zeiger aufs 1. Element eines char Strings,
*                            in welchem die Zeichen des Inputs stehen
************************************************************************/
unsigned int string_to_int(char *stringptr) // bekommt startadr. vom inputstring
{
    char *string_start_adr;         // pointer für (neue) startadr. des strings
    unsigned int integer = 0;       // Auszugebende Variable (unsigned int)
    int k = 0;                      // counter für gültige Stelle im Array
    int max = 1;                    // max-flag (gesetzt), wird gelöscht bei Überschreitung eines Maximalwerts
    int ziffer;                     // für jeweils aktuelle Ziffer
    int ziffer_max;                 // für jeweils das Maximum der aktuellen Ziffer
    int i;                          // for-counter

    // Erlaubte Maximalwert (2^32-2 = 0xFFFFFFFE = 4294967294)
    unsigned int max_wert = 0xFFFFFFFE;

    // Error, falls String leer ('\0' = 0)
    if(*stringptr == 0) return ERROR;

    // Alle vordran stehenden Nullen ignorieren, danach...
    while(*stringptr == '0') { stringptr++; }
    string_start_adr = stringptr;   // ...startadresse des strings setzten

    // Error, falls Eingabe grösser als definierte max. Anzahl Stellen
    if(strlen(string_start_adr) > INPUTSTRINGLENGTH) { return ERROR; } // strlen() gibt die benutzte Stringlänge zurück

    // Jeden char überprüfen ob gültige Eingabe, bis zu einem 0 ('\0') oder...
    while(*stringptr != 0)
    {
        // ...Error, falls char kleiner als ASCII '0' oder grösser als ASCII '9'
        if(*stringptr < '0' || *stringptr > '9') { return ERROR; }

        // ...Error, falls Eingabe grösser als Maximalwert (2^32-2), aber kleiner als die erste Zahl mit 11 Stellen (10^10)
        if(strlen(string_start_adr) == INPUTSTRINGLENGTH) // überprüfen ob Eingabe genau 10 Stellen
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
                if (ziffer > ziffer_max) { return ERROR; }  // ...überprüfen ob momentaner char > max -> ERROR
                if (ziffer < ziffer_max) { max = 0; }       // ...überprüfen ob momentaner char < max -> max-flag löschen (Rest somit okay)
                // ziffer == ziffer_max -> max = 1; (ist aber bereits gesetzt)
            }
        }

        k++;    // k inkrementieren (jeweils +1 pro gültiger char)

        stringptr = string_start_adr + k;   // stringptr inkrementieren
    }

    // 0 zurückgeben, falls k immer noch 0 (Eingabe war '0')
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
    -> i = 2:   i nicht mehr < k -> endbedingung erfüllt -> integer = 15
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
*                String mit Primzahlen, '*' und Leerschlägen
* -----------------------------------------------------------------------
* Benötigt     : string.h, stdio.h
* -----------------------------------------------------------------------
* Input        : *primarrayptr:    Zeiger aufs erste Element eines uint32
*                                  Arrays, in welchem die Primfaktoren
*                                  (aufsteigend) aufgelistet wurden
*                *outputstringptr: Zeiger auf ein Outputstring
************************************************************************/
void intarray_to_string(unsigned int *primarrayptr, char *outputstringptr)
{
    int n;      // for-counter für Outputstring-/Primarraystelle

    // erste Primzahl in den Outputstring speichern
    sprintf(outputstringptr, "%u", *primarrayptr);

    // weitere Primzahlen mit * und Leerschlägen in den Hilfsstring speichern bis erstes 0 im Primarray,
    // dann den Hilfsstring an den Outputstring anhängen mit strcat() aus string.h
    for(n = 1; (n < INTARRAYLENGTH) && ((*(primarrayptr + n)) != 0); n++)
    {
        // Hilfsstring jeweils mit 0 initialisieren / löschen
    	// Hilfsstring braucht max. 10 (Anzahl Stellen grösster Primahl) + 3 (ein '*' und 2 Leerschläge) + 1 (für ein '\0') = 14 Stellen
        char hilfsstring[INPUTSTRINGLENGTH + 4] = {};
        sprintf(hilfsstring, " * %u", *(primarrayptr + n));
        strcat(outputstringptr, hilfsstring);           // hängt den Hilfsstring an den Outputstring
    }

    return;
}
