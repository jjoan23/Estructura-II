*-----------------------------------------------------------------------------
* SISTEMA
*-----------------------------------------------------------------------------
 
 
SYSINIT
; INICIA EL  SISTEMA
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ----------------------------------------------------------------------------
            JSR     SCRINIT
            
            MOVE.L  #SCRPLOT,($80)
            
            MOVE.W  SR,-(A7)
            ANDI.W  #$DFFF,(A7)
            RTE
            
; ------------------------------------------------------------------------------
SCRINIT
; INIT SCREEN. SET SCREEN RESOLUTION, SET WINDOWED MODE, CLEAR SCREEN,
; ENABLE DOUBLE BUFFER.
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------

            MOVEM.L D0-D1,-(A7)

            ; SET SCREEN RESOLUTION
            MOVE.B  #33,D0
            MOVE.L  #PANWIDTH<<16|PANHEIGH,D1
            TRAP    #15
            
            ; SET WINDOWED MODE
            MOVE.L  #1,D1
            TRAP    #15
            
            ; CLEAR SCREEN
            MOVE.B  #11,D0
            MOVE.W  #$FF00,D1
            TRAP    #15
            
            ; ENABLE DOUBLE BUFFER
            MOVE.B  #92,D0
            MOVE.B  #17,D1
            TRAP    #15
            
            MOVEM.L (A7)+,D0-D1
            
            RTS    

; ------------------------------------------------------------------------------
SCRPLOT
; UPDATES DOUBLE BUFFER
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            MOVEM.W D0-D1,-(A7)
            ; SWITCH BUFFERS
            MOVE.B  #94,D0
            TRAP    #15
            
            ; CLEAR HIDDEN BUFFER
            MOVE.B  #11,D0
            MOVE.W  #$FF00,D1
            TRAP    #15
            MOVEM.W (A7)+,D0-D1
            RTE
        

 
;-----------------------------------------------------------------------------
MTZINIT
; INICIALIZA LA MATRIZ, AL PRINCIPIO ESTÁ VACÍA
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : Variable ESTCLDS que contiene el estado de las celdas
; ----------------------------------------------------------------------------
            
            LEA ESTDCLDS, A0       ; Apunta al inicio de ESTDCLDS
            MOVE.W #TCELDAS, D0    ; Número total de celdas

CLNCLDS:
            CLR.B (A0)+            ; Coloca 0 en cada celda
            SUBI.W #1, D0          ; Decrementa el contador de celdas
            BNE CLNCLDS            ; Repite hasta que esten vacías

            RTS


;-----------------------------------------------------------------------------
CINDMTRZ
; CALCULA EL ÍNDICE DE UNA CELDA
; INPUT    : D1 = coordenada X pantalla, D2 = coordenada Y pantalla
; OUTPUT   : D0 = índice de la celda en ESTDCLDS
; MODIFIES : NONE
; ----------------------------------------------------------------------------

            DIVU #TCELDAS, D1       ; X/TCELDAS: D1 = columna de la celda
            DIVU #TCELDAS, D2       ; Y/TCELDAS: D2 = fila de la celda

            MOVE.W D2, D0           ; D0 = Y_CELDA
            MULU #NUMCLMNS, D0      ; D0 = Y_CELDA * NUMCLMNS
            ADD.W D1, D0            ; D0 = Y_CELDA * NUMCLMNS + X_CELDA

            RTS
            
;------------------------------------------------------------------------------            
MCLDOCPD
; MARCA UNA CELDA COMO OCUPADA
; INPUT    : D0 = índice de la celda en ESTDCLDS
; OUTPUT   : NONE
; MODIFIES : Estado de la celda en la variable ESTDCLDS
; -----------------------------------------------------------------------------

            LEA ESTDCLDS, A0                ; Carga la dirección de la matriz en A0
            MOVE.B #1, (A0, D0.W)           ; Marca la celda correspondientes como vacía
            
            RTS
            
;------------------------------------------------------------------------------            
MCLDVCIA
; MARCA UNA CELDA COMO VACÍA
; INPUT    : D0 = índice de la celda en ESTDCLDS
; OUTPUT   : NONE
; MODIFIES : Estado de la celda en la variable ESTDCLDS
; ----------------------------------------------------------------------------

            LEA ESTDCLDS, A0                ; Carga la direccion de la matriz en A0
            MOVE.B #0, (A0, D0.W)           ; Marca la celda como vacía
            
            RTS









*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
