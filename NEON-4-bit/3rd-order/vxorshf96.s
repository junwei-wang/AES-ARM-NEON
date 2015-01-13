        PUBLIC vxorshf96
        PUBLIC vxorshf96_4
        PUBLIC seeds

        SECTION `.bss`:DATA:REORDER:NOROOT(3)
seeds:
        DS8 48

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
;;      uint8x16_t vxorshf96()
vxorshf96:
        LDR.N    R0,SeedsTable
        VLDM     R0,{D0-D5}       ; Q0: x, Q1: y, Q2: z, Q3: t
        VSHL.U32 Q3,Q0,#+16       ; t = x << 16;
        VEOR     Q0,Q3,Q0         ; x = x ^  t;
        VSHR.U32 Q3,Q0,#+5        ; t = x >> 5;
        VEOR     Q0,Q3,Q0         ; x = x ^  t;
        VSHL.U32 Q3,Q0,#+1        ; t = x << 1;
        VEOR     Q3,Q3,Q0         ; x = x ^  t;
                                  ; t = x;
                                  ; x = y;
                                  ; y = z;
                                  ; Q0:? , Q1: x, Q2: y, Q3: t
        VEOR     Q0,Q1,Q3         ; z = t ^ x ^ y;
        VEOR     Q0,Q2,Q0
        VMOV     Q3,Q0            ; Q0:z, Q1: x, Q2: y, Q3: z                                  
        LDR.N    R0,SeedsTable
        VSTM     R0,{D2-D7}
        BX       LR               ; return
        
        SECTION `.text`:CODE:NOROOT(1)
        THUMB
;;      uint8x16_t vxorshf96_4()
vxorshf96_4:
        PUSH     {R7,LR}
        BL       vxorshf96
        //VMOV.U8  Q1,#0x0f
        VSHR.U8   Q0,Q0,#4
        POP      {R0,PC}
        
        SECTION `.text`:CODE:NOROOT(2)
        DATA
SeedsTable:
        DC32     seeds
        DC32     seeds+0x10
        DC32     seeds+0x20

        END