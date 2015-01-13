        PUBLIC keyexp_core
        PUBLIC xor_rcon

        SECTION `.bss`:DATA:REORDER:NOROOT(3)
tb_mask:
        DATA
        DC32 0x0000FF00, 0x0000FF00, 0x0000FF00, 0x0000FF00

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
keyexp_core:
        LDR.N    R0,DataTable
        VLDM     R0,{D4-D5}    ; Q2: 0xFF00, 0xFF00, 0xFF00, 0xFF00 
        VSHL.U32 Q3,Q2,#8      ; Q3: 0xFF0000, 0xFF0000, 0xFF0000, 0xFF0000

        VEXT.8   Q0,Q0,Q0,#4  ; rotate bytes by 4 bytes
        VSHR.U32 Q0,Q0,#24
        VEOR     Q1,Q1,Q0
        
        VSHL.U32 Q0,Q1,#8
        VAND     Q0,Q0,Q2
        VEOR     Q1,Q1,Q0
        
        VAND     Q0,Q1,Q2
        VSHL.U32 Q0,Q0,#8
        VEOR     Q1,Q1,Q0
        
        VAND     Q0,Q1,Q3
        VSHL.U32 Q0,Q0,#8
        VEOR     Q0,Q1,Q0
        BX       LR            ; return
        
        SECTION `.text`:CODE:NOROOT(1)
        THUMB
xor_rcon:
        EOR      R1,R1,R1
        VEOR     Q1,Q1,Q1
        VMOV     D2,R0,R1
        VEOR     Q0,Q0,Q1
        BX       LR
        
        SECTION `.text`:CODE:NOROOT(2)
        DATA
DataTable:
        DC32     tb_mask

        END
