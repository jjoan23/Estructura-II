*-----------------------------------------------------------------------------
* SISTEMA
*-----------------------------------------------------------------------------
 
 
SYSINIT
; INICIAR SISTEMA
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ----------------------------------------------------------------------------
            RTS
 

MTZINIT
; INICIAR MATRIZ
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ----------------------------------------------------------------------------
            
            LEA ESTDCLDS, A0       ; Apunta al inicio de ESTDCLDS
            MOVE.W #TCELDAS, D0    ; Número total de celdas

CLNCLDS:
            CLR.B (A0)+            ; Coloca 0 en cada celda (vacío)
            SUBI.W #1, D0          ; Decrementa el contador de celdas
            BNE CLNCLDS            ; Repite hasta que todas las celdas estén vacías

            RTS                    ; Retorna de la subrutina

*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
