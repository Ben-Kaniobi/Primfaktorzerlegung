/************************************************************************
*
* Projekt      : Primfaktorzerlegung
*
*************************************************************************
* Modul        : Primfaktorzerlegung
* File-Name    : Primfaktorzerlegung.s
* Version      : 2.0
* Datum        : Januar 2013
* Authoren     : J. Haldemann, S. Plattner
* -----------------------------------------------------------------------
* Beschreibung : Zerlegung eines gültigen Inputs in Primfaktoren
* -----------------------------------------------------------------------
* Inhalt       : primfaktorzerlegung, root2, division
************************************************************************/

.ifndef _PRIM_S_
.set _PRIM_S_, 1


/************************************************************************
* Includes
************************************************************************/

.include "../startup/pxa270.s" @ include PXA270 register definitions


/************************************************************************
* Export
************************************************************************/

.global primfaktorzerlegung     @ Um Zugriff von Primfaktorzerlegung6.0.c zu gewährleisten


/************************************************************************
* Code
************************************************************************/
.text                           @ section text (executable code)
.arm                            @ generate ARM-Code


/************************************************************************
* Funktion     : primfaktorzerlegung
* Authoren     : J. Haldemann, S. Plattner
* Datum        : Januar 2013
* Version      : 5.0
* Beschreibung : Zerlegt eine Zahl in ihre Primfaktoren
* -----------------------------------------------------------------------
* Input        : *primarrayptr:    Zeiger aufs erste Element eines uint32
*                                  Arrays, in welchem die Primfaktoren
*                                  (aufsteigend) aufgelistet wurden
*************************************************************************
* Höhere Register werden benutzt für:
* r4    Input
* r5    Primarray
* r6    Primfaktorvariable
* r7    Radix
************************************************************************/

@ Wert von Input wird beim Aufrufen der Funktion ins Register r0 geschrieben
@ Adr. des Primarrays wird beim Aufrufen der Funktion ins Register r1 geschrieben

primfaktorzerlegung:
MOV r4, r0                      @ Input in ein höheres Register (r4) speichern
MOV r5, r1                      @ Adr. des Primarrays in ein höheres Register (r5) schreiben

STR lr, [sp], #-4               @ Rücksprungadr. in den Stack speichern (danach den Stackpointer dekrementieren)

@ Zahlen kleiner 4 haben nur einen Primfaktor
if:     CMP r4, #4              @ Vergleich Input (r4) < 4
        BCS endif               @ (CS: >= )

true:   STR r4, [r5]            @ Dieser Primfaktor ist Lösung -> Input ins primarray speichern
        ADD r5, r5, #4          @ Nächste Stelle im Primarray

        @ Fertig
        MOV r1, #0
        STR r1, [r5]            @ Array Ende: 0 einfügen
        LDR pc, [sp, #4]!       @ return
endif:

@ Auf Primfaktor 2 prüfen
@ MOV r0, r4                    @ Dividend = Input (dies ist bereits der Fall)
while_2:    MOV r1, #2          @ Divisor = 2
            BL division         @ Subroutinenaufruf division -> r0 = r0 / r1 und r1 = r0 % r1
            CMP r1, #0          @ Solange Rest (r1) == 0 (also durch 2 teilbar ohne Rest)...
            BNE endwhile_2      @ (NE: != )

            @ ...Schleifenkörper ausführen
            MOV r4, r0          @ Resultat der Division ins r4 speichern -> Input /= 2
            MOV r1, #2
            STR r1, [r5]        @ Primfaktor 2 ins primarray speichern
            ADD r5, r5, #4      @ Nächste Stelle im Primarray

            B while_2
endwhile_2:

@ Auf Primfaktoren ausser 2 prüfen
while_not2: CMP r4, #1                  @ Solange Input != 1...
            BEQ endwhile_not2           @ (EQ: == )

            @ ...Schleifenkörper ausführen
            MOV r0, r4                  @ Radikant = Input
            BL root2                    @ Subroutinenaufruf root2 -> r0 ~ sqrt(r0)
            MOV r7, r0                  @ Erhaltene Radix in ein höheres Register (r7) speichern

            for:        MOV r6, #3      @ Primfaktorvariable r6 -> Startwert = 3
            for_loop:   CMP r6, r4      @ Solange Primfaktorvariable <= Input...
                        BHI endfor      @ (HI: > )

                        @ ...for-Schleifenkörper ausführen
                        MOV r0, r4                  @ Dividend = Input
                        MOV r1, r6                  @ Divisor = Primfaktorvariable
                        BL division                 @ Subroutinenaufruf division -> r0 = r0 / r1 und r1 = r0 % r1
                        if2:    CMP r1, #0          @ Vergleich Rest (r1) == 0 (also durch Primfaktorvariable teilbar ohne Rest)
                                BNE endif2          @ (NE: != )

                        true2:  MOV r4, r0          @ Resultat der Division ins r4 speichern -> Input /= Divisor
                                STR r6, [r5]        @ Primfaktor r6 ins primarray speichern
                                ADD r5, r5, #4      @ Nächste Stelle im Primarray

                                B endfor            @ break
                        endif2:

                        @ Falls Primfaktorvariable (r6) grösser als die aufgerundete Wurzel der Zahl (r7), ist die Zahl eine Primzahl
                        if3:    CMP r6, r7          @ Vergleich Primfaktorvariable (r6) > Radix (r7)
                                BLS endif3          @ (LS: <= )

                        true3:  STR r4, [r5]        @ Input ins Primarray speichern
                                ADD r5, r5, #4      @ Nächste Stelle im Primarray

                                @ Fertig
                                MOV r1, #0
                                STR r1, [r5]        @ Array Ende: 0 einfügen
                                LDR pc, [sp, #4]!   @ return
                        endif3:

                        ADD r6, r6, #2      @ Primfaktorvariable um 2 inkrementieren, da (ohne 2) nur ungerade Zahlen mögliche Primzahlen
                        B for_loop
            endfor:

            B while_not2
endwhile_not2:

@ Fertig
MOV r1, #0
STR r1, [r5]        @ Array Ende: 0 einfügen
LDR pc, [sp, #4]!   @ return


/************************************************************************
* Funktion     : root2
* Authoren     : J. Haldemann, S. Plattner
* Datum        : Januar 2013
* Version      : 1.0
* Beschreibung : Berechnet die Quadratwurzel einer Zahl, aufgerundet auf
*                die nächst grössere Zahl aus der Reihe 2^n
* -----------------------------------------------------------------------
* Benötigt     : string.h, ipow()
* -----------------------------------------------------------------------
* Input        : r0: Radikant
* Output         r0: Auf die nächst grössere Zahl der Reihe 2^n
*                    gerundeter Radix
************************************************************************/
root2:                          @ r0 ~ sqrt(r0)
MOV r2, #1                      @ Verschiebevariable k mit 1 initialisieren
SUB r0, r0, #1                  @ Input-- (Effizienzsteigerung)

@ Anzahl signifikanter stellen bestimmen
while_root2:    CMP r0, #1      @ Solange Input != 1...
                BEQ endwhile_root2 @ (EQ: == )

                @ ...Schleifenkörper ausführen
                LSR r0, #1
                ADD r2, r2, #1  @ Verschiebevariable inkrementieren

                B while_root2
endwhile_root2:

@ return (1 << (k / 2 + 1))     @ Anwenden der Rechenregel für logarithmisches Radizieren
LSR r2, #1                      @ (k >> 1) = (k/2)
ADD r1, r2, #1                  @ (k/2 + 1)

@ MOV r0, #1                    @ Konstante 1 (dies ist bereits der Fall)
LSL r0, r1                      @ (1 << (k/2 + 1))

MOV pc, lr                      @ return


/************************************************************************
* Funktion     : division
* Authoren     : J. Haldemann, S. Plattner
* Datum        : Januar 2013
* Version      : 2.0
* Beschreibung : Berechnet den Quotienten und den Rest einer Zahl
* -----------------------------------------------------------------------
* Input        : r0: Dividend (a)
*                r1: Divisor (b)
* Output         r0: Resultat der Division
*                r1: Rest der Division
*************************************************************************
* Höhere Register werden benutzt für:
* r4    for-counter k
* r5    zum Schieben einer 1
* r6    Maskierung
* r7    Zwischenresultat
* r8    Zwischenresultat
************************************************************************/
division:                       @ r0 = r0 / r1 und r1 = r0 % r1
STMFD sp!, {r4, r5, r6, r7, r8} @ Register retten (in den Stack schieben)

MOV r2, #0                      @ r2 mit 0 initialisieren für Resultat (q)
MOV r3, #0                      @ r3 mit 0 initialisieren für Rest (r)

@ Konstante
MOV r5, #1                      @ r5 mit 1 initialisieren für Konstante und geschobene 1
MOV r6, #0xFFFFFFFE             @ r6 mit ~1 initialisieren für Maskierung

@ 32bit Division:
@ for (k = 32; k > 0; k--)
for_division:       MOV r4, #32                 @ for-counter (k) mit Startwert 32
for_division_loop:  CMP r4, #0                  @ Solange k > 0...
                    BLS endfor_division         @ (LS: <= )

                    @ ...Schleifenkörper ausführen
                    SUB r4, r4, #1              @ (k - 1) -> counter dekrementieren

                    AND r7, r6, r3, LSL #1      @ r7 = (~1 & (r << 1))
                    AND r8, r5, r0, LSR r4      @ r8 = (1 & (a >> (k - 1))
                    ORR r3, r7, r8              @ r = r7|r8 = ((r << 1) & ~1) | (1 & (a >> (k - 1)))

                    if_division:    CMP r3, r1                  @ Vergleich Rest >= Divisor
                                    BCC    endif_division       @ (CC: < )

                    true_division:  SUB r3, r3, r1              @ r -= b

                                    ORR r2, r2, r5, LSL r4      @ q |= 1 << (k - 1)
                    endif_division:
                    B for_division_loop
endfor_division:

MOV r0, r2                      @ Resultat für Rückgabe ins r0 speichern
MOV r1, r3                      @ Rest für Rückgabe ins r1 speichern

LDMFD sp!, {r4, r5, r6, r7, r8} @ Register wieder herstellen (Stackptr. zeigt wieder auf Ursprungsstelle)
MOV pc, lr                      @ return



.endif @ _UART_S_
