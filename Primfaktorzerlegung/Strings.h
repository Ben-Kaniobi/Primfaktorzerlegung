/************************************************************************
*
* Projekt      : Primfaktorzerlegung
*
*************************************************************************
* Modul        : Primfaktorzerlegung
* File-Name    : Strings.h
* Version      : 1.0
* Datum        : Januar 2013
* Authoren     : J. Haldemann, N. Käser
* -----------------------------------------------------------------------
* Beschreibung : Header für die Stringumwandlungs-Funktionen
************************************************************************/

#ifndef STRINGS_H_
#define STRINGS_H_


#define INTARRAYLENGTH      32          // Definition der gewünschten Integer-Arraylänge (max 32)
#define INPUTSTRINGLENGTH   10          // Definition der gewünschten maximalen Anzahl Stellen (min. Input-Stringlänge (2^32-1 hat 10 Stellen))
#define OUTPUTSTRINGLENGTH  121         // Definition der gewünschten Output-Stringlänge (Ausgabe von 2^31 (grösst mögliche Anzahl chars) braucht 1+4*30=121 Stellen)
#define ERROR               0xFFFFFFFF  // 2^32-1


#endif /* STRINGS_H_ */
