        #define SHT_PROGBITS 0x1

        EXTERN rotatebytes
        EXTERN sec_exp254
        EXTERN sr_ark
        EXTERN sr_mc_ark

        PUBLIC sec_aes

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//      void sec_aes(uint8x16_t x[], uint8x16_t *rk[])
sec_aes:
        PUSH     {R4,R5,LR}
        VPUSH    {D8-D17}
        MOV      R4,R0          ;; R4: x
        MOV      R5,R1          ;; R5: rk
        SUB      SP,SP,#+100
//
        VMOV.I8  Q4,#+99        ;; t = 0x63 x 16;
// round 0
        LDR      R0,[R5, #+0]
        VLDM     R4,{D0-D3}
        VLDM     R0,{D4-D7}
        VEOR     Q0,Q2,Q0
        VEOR     Q1,Q3,Q1
        VSTM     R4,{D0-D3}
// round 1 
        ADD      R3,SP,#+0
        ADD      R2,SP,#+32
        ADD      R1,SP,#+64   
        MOV      R0,R4
        BL       sec_exp254     ;; sec_exp254(x, y, z, w);
        VLDM     R4,{D10-D13}
        LDR      R0,[R5, #+4]
        VLDM     R0,{D14-D17}
        VMOV     Q0,Q5
        BL       rotatebytes    ;; x[0] = rotatebytes(x[0]);
        VMOV     Q1,Q7
        BL       sr_mc_ark      ;; x[0] = sr_mc_ark(x[0], rk[1][0]);
        VMOV     Q5,Q0
        VMOV     Q0,Q6
        BL       rotatebytes    ;; x[1] = rotatebytes(x[1]);
        VEOR     Q0,Q0,Q4       ;; x[1] = veorq_u8(x[1], t);
        VMOV     Q1,Q8
        BL       sr_mc_ark      ;; x[1] = sr_mc_ark(x[1], rk[1][1]);
        VMOV     Q6,Q0
        VSTM     R4,{D10-D13}
// round 2
        ADD      R3,SP,#+0
        ADD      R2,SP,#+32
        ADD      R1,SP,#+64   
        MOV      R0,R4
        BL       sec_exp254     ;; sec_exp254(x, y, z, w);
        VLDM     R4,{D10-D13}
        LDR      R0,[R5, #+8]
        VLDM     R0,{D14-D17}
        VMOV     Q0,Q5
        BL       rotatebytes    ;; x[0] = rotatebytes(x[0]);
        VMOV     Q1,Q7
        BL       sr_mc_ark      ;; x[0] = sr_mc_ark(x[0], rk[2][0]);
        VMOV     Q5,Q0
        VMOV     Q0,Q6
        BL       rotatebytes    ;; x[1] = rotatebytes(x[1]);
        VEOR     Q0,Q0,Q4       ;; x[1] = veorq_u8(x[1], t);
        VMOV     Q1,Q8
        BL       sr_mc_ark      ;; x[1] = sr_mc_ark(x[1], rk[2][1]);
        VMOV     Q6,Q0
        VSTM     R4,{D10-D13}
// round 3
        ADD      R3,SP,#+0
        ADD      R2,SP,#+32
        ADD      R1,SP,#+64   
        MOV      R0,R4
        BL       sec_exp254     ;; sec_exp254(x, y, z, w);
        VLDM     R4,{D10-D13}
        LDR      R0,[R5, #+12]
        VLDM     R0,{D14-D17}
        VMOV     Q0,Q5
        BL       rotatebytes    ;; x[0] = rotatebytes(x[0]);
        VMOV     Q1,Q7
        BL       sr_mc_ark      ;; x[0] = sr_mc_ark(x[0], rk[3][0]);
        VMOV     Q5,Q0
        VMOV     Q0,Q6
        BL       rotatebytes    ;; x[1] = rotatebytes(x[1]);
        VEOR     Q0,Q0,Q4       ;; x[1] = veorq_u8(x[1], t);
        VMOV     Q1,Q8
        BL       sr_mc_ark      ;; x[1] = sr_mc_ark(x[1], rk[3][1]);
        VMOV     Q6,Q0
        VSTM     R4,{D10-D13}
// round 4
        ADD      R3,SP,#+0
        ADD      R2,SP,#+32
        ADD      R1,SP,#+64   
        MOV      R0,R4
        BL       sec_exp254     ;; sec_exp254(x, y, z, w);
        VLDM     R4,{D10-D13}
        LDR      R0,[R5, #+16]
        VLDM     R0,{D14-D17}
        VMOV     Q0,Q5
        BL       rotatebytes    ;; x[0] = rotatebytes(x[0]);
        VMOV     Q1,Q7
        BL       sr_mc_ark      ;; x[0] = sr_mc_ark(x[0], rk[4][0]);
        VMOV     Q5,Q0
        VMOV     Q0,Q6
        BL       rotatebytes    ;; x[1] = rotatebytes(x[1]);
        VEOR     Q0,Q0,Q4       ;; x[1] = veorq_u8(x[1], t);
        VMOV     Q1,Q8
        BL       sr_mc_ark      ;; x[1] = sr_mc_ark(x[1], rk[4][1]);
        VMOV     Q6,Q0
        VSTM     R4,{D10-D13}
// round 5
        ADD      R3,SP,#+0
        ADD      R2,SP,#+32
        ADD      R1,SP,#+64   
        MOV      R0,R4
        BL       sec_exp254     ;; sec_exp254(x, y, z, w);
        VLDM     R4,{D10-D13}
        LDR      R0,[R5, #+20]
        VLDM     R0,{D14-D17}
        VMOV     Q0,Q5
        BL       rotatebytes    ;; x[0] = rotatebytes(x[0]);
        VMOV     Q1,Q7
        BL       sr_mc_ark      ;; x[0] = sr_mc_ark(x[0], rk[5][0]);
        VMOV     Q5,Q0
        VMOV     Q0,Q6
        BL       rotatebytes    ;; x[1] = rotatebytes(x[1]);
        VEOR     Q0,Q0,Q4       ;; x[1] = veorq_u8(x[1], t);
        VMOV     Q1,Q8
        BL       sr_mc_ark      ;; x[1] = sr_mc_ark(x[1], rk[5][1]);
        VMOV     Q6,Q0
        VSTM     R4,{D10-D13}
// round 6
        ADD      R3,SP,#+0
        ADD      R2,SP,#+32
        ADD      R1,SP,#+64   
        MOV      R0,R4
        BL       sec_exp254     ;; sec_exp254(x, y, z, w);
        VLDM     R4,{D10-D13}
        LDR      R0,[R5, #+24]
        VLDM     R0,{D14-D17}
        VMOV     Q0,Q5
        BL       rotatebytes    ;; x[0] = rotatebytes(x[0]);
        VMOV     Q1,Q7
        BL       sr_mc_ark      ;; x[0] = sr_mc_ark(x[0], rk[6][0]);
        VMOV     Q5,Q0
        VMOV     Q0,Q6
        BL       rotatebytes    ;; x[1] = rotatebytes(x[1]);
        VEOR     Q0,Q0,Q4       ;; x[1] = veorq_u8(x[1], t);
        VMOV     Q1,Q8
        BL       sr_mc_ark      ;; x[1] = sr_mc_ark(x[1], rk[6][1]);
        VMOV     Q6,Q0
        VSTM     R4,{D10-D13}
// round 7
        ADD      R3,SP,#+0
        ADD      R2,SP,#+32
        ADD      R1,SP,#+64   
        MOV      R0,R4
        BL       sec_exp254     ;; sec_exp254(x, y, z, w);
        VLDM     R4,{D10-D13}
        LDR      R0,[R5, #+28]
        VLDM     R0,{D14-D17}
        VMOV     Q0,Q5
        BL       rotatebytes    ;; x[0] = rotatebytes(x[0]);
        VMOV     Q1,Q7
        BL       sr_mc_ark      ;; x[0] = sr_mc_ark(x[0], rk[7][0]);
        VMOV     Q5,Q0
        VMOV     Q0,Q6
        BL       rotatebytes    ;; x[1] = rotatebytes(x[1]);
        VEOR     Q0,Q0,Q4       ;; x[1] = veorq_u8(x[1], t);
        VMOV     Q1,Q8
        BL       sr_mc_ark      ;; x[1] = sr_mc_ark(x[1], rk[7][1]);
        VMOV     Q6,Q0
        VSTM     R4,{D10-D13}
// round 8
        ADD      R3,SP,#+0
        ADD      R2,SP,#+32
        ADD      R1,SP,#+64   
        MOV      R0,R4
        BL       sec_exp254     ;; sec_exp254(x, y, z, w);
        VLDM     R4,{D10-D13}
        LDR      R0,[R5, #+32]
        VLDM     R0,{D14-D17}
        VMOV     Q0,Q5
        BL       rotatebytes    ;; x[0] = rotatebytes(x[0]);
        VMOV     Q1,Q7
        BL       sr_mc_ark      ;; x[0] = sr_mc_ark(x[0], rk[8][0]);
        VMOV     Q5,Q0
        VMOV     Q0,Q6
        BL       rotatebytes    ;; x[1] = rotatebytes(x[1]);
        VEOR     Q0,Q0,Q4       ;; x[1] = veorq_u8(x[1], t);
        VMOV     Q1,Q8
        BL       sr_mc_ark      ;; x[1] = sr_mc_ark(x[1], rk[8][1]);
        VMOV     Q6,Q0
        VSTM     R4,{D10-D13}
// round 9
        ADD      R3,SP,#+0
        ADD      R2,SP,#+32
        ADD      R1,SP,#+64   
        MOV      R0,R4
        BL       sec_exp254     ;; sec_exp254(x, y, z, w);
        VLDM     R4,{D10-D13}
        LDR      R0,[R5, #+36]
        VLDM     R0,{D14-D17}
        VMOV     Q0,Q5
        BL       rotatebytes    ;; x[0] = rotatebytes(x[0]);
        VMOV     Q1,Q7
        BL       sr_mc_ark      ;; x[0] = sr_mc_ark(x[0], rk[9][0]);
        VMOV     Q5,Q0
        VMOV     Q0,Q6
        BL       rotatebytes    ;; x[1] = rotatebytes(x[1]);
        VEOR     Q0,Q0,Q4       ;; x[1] = veorq_u8(x[1], t);
        VMOV     Q1,Q8
        BL       sr_mc_ark      ;; x[1] = sr_mc_ark(x[1], rk[9][1]);
        VMOV     Q6,Q0
        VSTM     R4,{D10-D13}
// round 10
        ADD      R3,SP,#+0
        ADD      R2,SP,#+32
        ADD      R1,SP,#+64   
        MOV      R0,R4
        BL       sec_exp254     ;; sec_exp254(x, y, z, w);
        VLDM     R4,{D10-D13}
        LDR      R0,[R5, #+40]
        VLDM     R0,{D14-D17}
        VMOV     Q0,Q5
        BL       rotatebytes    ;; x[0] = rotatebytes(x[0]);
        VMOV     Q1,Q7
        BL       sr_ark         ;; x[0] = sr_ark(x[0], rk[10][0]);
        VMOV     Q5,Q0
        VMOV     Q0,Q6
        BL       rotatebytes    ;; x[1] = rotatebytes(x[1]);
        VEOR     Q0,Q0,Q4       ;; x[1] = veorq_u8(x[1], t);
        VMOV     Q1,Q8
        BL       sr_ark         ;; x[1] = sr_ark(x[1], rk[10][1]);
        VMOV     Q6,Q0
        VSTM     R4,{D10-D13}
//
        ADD      SP,SP,#+100
        VPOP     {D8-D17}
        POP      {R4,R5,PC}       ;; return

        SECTION `.iar_vfe_header`:DATA:NOALLOC:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
        DC32 0

        SECTION __DLIB_PERTHREAD:DATA:REORDER:NOROOT(0)
        SECTION_TYPE SHT_PROGBITS, 0

        SECTION __DLIB_PERTHREAD_init:DATA:REORDER:NOROOT(0)
        SECTION_TYPE SHT_PROGBITS, 0

        END