/************************************************************************
*
* Projekt      : Primfaktorzerlegung
*
*************************************************************************
* Modul        : Primfaktorzerlegung
* File-Name    : Strings.h
* Version      : 1.0
* Datum        : Januar 2013
* Authoren     : J. Haldemann, N. K�ser
* -----------------------------------------------------------------------
* Beschreibung : Header f�r die Stringumwandlungs-Funktionen
************************************************************************/

#ifndef STRINGS_H_
#define STRINGS_H_


#define INTARRAYLENGTH      32          // Definition der gew�nschten Integer-Arrayl�nge (max 32)
#define INPUTSTRINGLENGTH   10          // Definition der gew�nschten maximalen Anzahl Stellen (min. Input-Stringl�nge (2^32-1 hat 10 Stellen))
#define OUTPUTSTRINGLENGTH  121         // Definition der gew�nschten Output-Stringl�nge (Ausgabe von 2^31 (gr�sst m�gliche Anzahl chars) braucht 1+4*30=121 Stellen)
#define ERROR               0xFFFFFFFF  // 2^32-1


#endif /* STRINGS_H_ */
