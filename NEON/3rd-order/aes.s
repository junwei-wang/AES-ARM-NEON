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
        VPUSH    {D8-D23}
        VPUSH    {D24-D25}
        MOV      R4,R0          ;; R4: x
        MOV      R5,R1          ;; R5: rk
        SUB      SP,SP,#+196    ;; 196 = 16*4*3 + 4
// round 0
        LDR      R0,[R5, #+0]
        VLDM     R4,{D0-D7}
        VLDM     R0,{D8-D15}
        VEOR     Q0,Q4,Q0
        VEOR     Q1,Q5,Q1
        VEOR     Q2,Q6,Q2
        VEOR     Q3,Q7,Q3
        VSTM     R4,{D0-D7}
//
        VMOV.I8  Q4,#+99        ;; t = 0x63 x 16;
// round 1 
        ADD      R3,SP,#+0
        ADD      R2,SP,#+64
        ADD      R1,SP,#+128   
        MOV      R0,R4
        BL       sec_exp254     ;; sec_exp254(x, y, z, w);
        VLDM     R4,{D10-D17}
        LDR      R0,[R5, #+4]
        VLDM     R0,{D18-D25}
        VMOV     Q0,Q5          ;; x[0]
        BL       rotatebytes    ;; x[0] = rotatebytes(x[0]);
        VEOR     Q0,Q0,Q4       ;; x[0] = veorq_u8(x[0], t);
        VMOV     Q1,Q9
        BL       sr_mc_ark      ;; x[0] = sr_mc_ark(x[0], rk[1][0]);
        VMOV     Q5,Q0
        VMOV     Q0,Q6          ;; x[1]
        BL       rotatebytes
        VMOV     Q1,Q10
        BL       sr_mc_ark
        VMOV     Q6,Q0
        VMOV     Q0,Q7          ;; x[2]
        BL       rotatebytes
        VMOV     Q1,Q11
        BL       sr_mc_ark
        VMOV     Q7,Q0
        VMOV     Q0,Q8          ;; x[1]
        BL       rotatebytes
        VMOV     Q1,Q12
        BL       sr_mc_ark
        VMOV     Q8,Q0
        VSTM     R4,{D10-D17}
// round 2
        ADD      R3,SP,#+0
        ADD      R2,SP,#+64
        ADD      R1,SP,#+128   
        MOV      R0,R4
        BL       sec_exp254     ;; sec_exp254(x, y, z, w);
        VLDM     R4,{D10-D17}
        LDR      R0,[R5, #+8]
        VLDM     R0,{D18-D25}
        VMOV     Q0,Q5          ;; x[0]
        BL       rotatebytes    ;; x[0] = rotatebytes(x[0]);
        VEOR     Q0,Q0,Q4       ;; x[0] = veorq_u8(x[0], t);
        VMOV     Q1,Q9
        BL       sr_mc_ark      ;; x[0] = sr_mc_ark(x[0], rk[2][0]);
        VMOV     Q5,Q0
        VMOV     Q0,Q6          ;; x[1]
        BL       rotatebytes
        VMOV     Q1,Q10
        BL       sr_mc_ark
        VMOV     Q6,Q0
        VMOV     Q0,Q7          ;; x[2]
        BL       rotatebytes
        VMOV     Q1,Q11
        BL       sr_mc_ark
        VMOV     Q7,Q0
        VMOV     Q0,Q8          ;; x[1]
        BL       rotatebytes
        VMOV     Q1,Q12
        BL       sr_mc_ark
        VMOV     Q8,Q0
        VSTM     R4,{D10-D17}
// round 3
        ADD      R3,SP,#+0
        ADD      R2,SP,#+64
        ADD      R1,SP,#+128   
        MOV      R0,R4
        BL       sec_exp254     ;; sec_exp254(x, y, z, w);
        VLDM     R4,{D10-D17}
        LDR      R0,[R5, #+12]
        VLDM     R0,{D18-D25}
        VMOV     Q0,Q5          ;; x[0]
        BL       rotatebytes    ;; x[0] = rotatebytes(x[0]);
        VEOR     Q0,Q0,Q4       ;; x[0] = veorq_u8(x[0], t);
        VMOV     Q1,Q9
        BL       sr_mc_ark      ;; x[0] = sr_mc_ark(x[0], rk[3][0]);
        VMOV     Q5,Q0
        VMOV     Q0,Q6          ;; x[1]
        BL       rotatebytes
        VMOV     Q1,Q10
        BL       sr_mc_ark
        VMOV     Q6,Q0
        VMOV     Q0,Q7          ;; x[2]
        BL       rotatebytes
        VMOV     Q1,Q11
        BL       sr_mc_ark
        VMOV     Q7,Q0
        VMOV     Q0,Q8          ;; x[1]
        BL       rotatebytes
        VMOV     Q1,Q12
        BL       sr_mc_ark
        VMOV     Q8,Q0
        VSTM     R4,{D10-D17}
// round 4
        ADD      R3,SP,#+0
        ADD      R2,SP,#+64
        ADD      R1,SP,#+128   
        MOV      R0,R4
        BL       sec_exp254     ;; sec_exp254(x, y, z, w);
        VLDM     R4,{D10-D17}
        LDR      R0,[R5, #+16]
        VLDM     R0,{D18-D25}
        VMOV     Q0,Q5          ;; x[0]
        BL       rotatebytes    ;; x[0] = rotatebytes(x[0]);
        VEOR     Q0,Q0,Q4       ;; x[0] = veorq_u8(x[0], t);
        VMOV     Q1,Q9
        BL       sr_mc_ark      ;; x[0] = sr_mc_ark(x[0], rk[4][0]);
        VMOV     Q5,Q0
        VMOV     Q0,Q6          ;; x[1]
        BL       rotatebytes
        VMOV     Q1,Q10
        BL       sr_mc_ark
        VMOV     Q6,Q0
        VMOV     Q0,Q7          ;; x[2]
        BL       rotatebytes
        VMOV     Q1,Q11
        BL       sr_mc_ark
        VMOV     Q7,Q0
        VMOV     Q0,Q8          ;; x[1]
        BL       rotatebytes
        VMOV     Q1,Q12
        BL       sr_mc_ark
        VMOV     Q8,Q0
        VSTM     R4,{D10-D17}
// round 5
        ADD      R3,SP,#+0
        ADD      R2,SP,#+64
        ADD      R1,SP,#+128   
        MOV      R0,R4
        BL       sec_exp254     ;; sec_exp254(x, y, z, w);
        VLDM     R4,{D10-D17}
        LDR      R0,[R5, #+20]
        VLDM     R0,{D18-D25}
        VMOV     Q0,Q5          ;; x[0]
        BL       rotatebytes    ;; x[0] = rotatebytes(x[0]);
        VEOR     Q0,Q0,Q4       ;; x[0] = veorq_u8(x[0], t);
        VMOV     Q1,Q9
        BL       sr_mc_ark      ;; x[0] = sr_mc_ark(x[0], rk[5][0]);
        VMOV     Q5,Q0
        VMOV     Q0,Q6          ;; x[1]
        BL       rotatebytes
        VMOV     Q1,Q10
        BL       sr_mc_ark
        VMOV     Q6,Q0
        VMOV     Q0,Q7          ;; x[2]
        BL       rotatebytes
        VMOV     Q1,Q11
        BL       sr_mc_ark
        VMOV     Q7,Q0
        VMOV     Q0,Q8          ;; x[1]
        BL       rotatebytes
        VMOV     Q1,Q12
        BL       sr_mc_ark
        VMOV     Q8,Q0
        VSTM     R4,{D10-D17}
// round 6
        ADD      R3,SP,#+0
        ADD      R2,SP,#+64
        ADD      R1,SP,#+128   
        MOV      R0,R4
        BL       sec_exp254     ;; sec_exp254(x, y, z, w);
        VLDM     R4,{D10-D17}
        LDR      R0,[R5, #+24]
        VLDM     R0,{D18-D25}
        VMOV     Q0,Q5          ;; x[0]
        BL       rotatebytes    ;; x[0] = rotatebytes(x[0]);
        VEOR     Q0,Q0,Q4       ;; x[0] = veorq_u8(x[0], t);
        VMOV     Q1,Q9
        BL       sr_mc_ark      ;; x[0] = sr_mc_ark(x[0], rk[6][0]);
        VMOV     Q5,Q0
        VMOV     Q0,Q6          ;; x[1]
        BL       rotatebytes
        VMOV     Q1,Q10
        BL       sr_mc_ark
        VMOV     Q6,Q0
        VMOV     Q0,Q7          ;; x[2]
        BL       rotatebytes
        VMOV     Q1,Q11
        BL       sr_mc_ark
        VMOV     Q7,Q0
        VMOV     Q0,Q8          ;; x[1]
        BL       rotatebytes
        VMOV     Q1,Q12
        BL       sr_mc_ark
        VMOV     Q8,Q0
        VSTM     R4,{D10-D17}
// round 7
        ADD      R3,SP,#+0
        ADD      R2,SP,#+64
        ADD      R1,SP,#+128   
        MOV      R0,R4
        BL       sec_exp254     ;; sec_exp254(x, y, z, w);
        VLDM     R4,{D10-D17}
        LDR      R0,[R5, #+28]
        VLDM     R0,{D18-D25}
        VMOV     Q0,Q5          ;; x[0]
        BL       rotatebytes    ;; x[0] = rotatebytes(x[0]);
        VEOR     Q0,Q0,Q4       ;; x[0] = veorq_u8(x[0], t);
        VMOV     Q1,Q9
        BL       sr_mc_ark      ;; x[0] = sr_mc_ark(x[0], rk[7][0]);
        VMOV     Q5,Q0
        VMOV     Q0,Q6          ;; x[1]
        BL       rotatebytes
        VMOV     Q1,Q10
        BL       sr_mc_ark
        VMOV     Q6,Q0
        VMOV     Q0,Q7          ;; x[2]
        BL       rotatebytes
        VMOV     Q1,Q11
        BL       sr_mc_ark
        VMOV     Q7,Q0
        VMOV     Q0,Q8          ;; x[1]
        BL       rotatebytes
        VMOV     Q1,Q12
        BL       sr_mc_ark
        VMOV     Q8,Q0
        VSTM     R4,{D10-D17}
// round 8
        ADD      R3,SP,#+0
        ADD      R2,SP,#+64
        ADD      R1,SP,#+128   
        MOV      R0,R4
        BL       sec_exp254     ;; sec_exp254(x, y, z, w);
        VLDM     R4,{D10-D17}
        LDR      R0,[R5, #+32]
        VLDM     R0,{D18-D25}
        VMOV     Q0,Q5          ;; x[0]
        BL       rotatebytes    ;; x[0] = rotatebytes(x[0]);
        VEOR     Q0,Q0,Q4       ;; x[0] = veorq_u8(x[0], t);
        VMOV     Q1,Q9
        BL       sr_mc_ark      ;; x[0] = sr_mc_ark(x[0], rk[8][0]);
        VMOV     Q5,Q0
        VMOV     Q0,Q6          ;; x[1]
        BL       rotatebytes
        VMOV     Q1,Q10
        BL       sr_mc_ark
        VMOV     Q6,Q0
        VMOV     Q0,Q7          ;; x[2]
        BL       rotatebytes
        VMOV     Q1,Q11
        BL       sr_mc_ark
        VMOV     Q7,Q0
        VMOV     Q0,Q8          ;; x[1]
        BL       rotatebytes
        VMOV     Q1,Q12
        BL       sr_mc_ark
        VMOV     Q8,Q0
        VSTM     R4,{D10-D17}
// round 9
        ADD      R3,SP,#+0
        ADD      R2,SP,#+64
        ADD      R1,SP,#+128   
        MOV      R0,R4
        BL       sec_exp254     ;; sec_exp254(x, y, z, w);
        VLDM     R4,{D10-D17}
        LDR      R0,[R5, #+36]
        VLDM     R0,{D18-D25}
        VMOV     Q0,Q5          ;; x[0]
        BL       rotatebytes    ;; x[0] = rotatebytes(x[0]);
        VEOR     Q0,Q0,Q4       ;; x[0] = veorq_u8(x[0], t);
        VMOV     Q1,Q9
        BL       sr_mc_ark      ;; x[0] = sr_mc_ark(x[0], rk[9][0]);
        VMOV     Q5,Q0
        VMOV     Q0,Q6          ;; x[1]
        BL       rotatebytes
        VMOV     Q1,Q10
        BL       sr_mc_ark
        VMOV     Q6,Q0
        VMOV     Q0,Q7          ;; x[2]
        BL       rotatebytes
        VMOV     Q1,Q11
        BL       sr_mc_ark
        VMOV     Q7,Q0
        VMOV     Q0,Q8          ;; x[1]
        BL       rotatebytes
        VMOV     Q1,Q12
        BL       sr_mc_ark
        VMOV     Q8,Q0
        VSTM     R4,{D10-D17}
// round 10
        ADD      R3,SP,#+0
        ADD      R2,SP,#+64
        ADD      R1,SP,#+128   
        MOV      R0,R4
        BL       sec_exp254     ;; sec_exp254(x, y, z, w);
        VLDM     R4,{D10-D17}
        LDR      R0,[R5, #+40]
        VLDM     R0,{D18-D25}
        VMOV     Q0,Q5          ;; x[0]
        BL       rotatebytes    ;; x[0] = rotatebytes(x[0]);
        VEOR     Q0,Q0,Q4       ;; x[0] = veorq_u8(x[0], t);
        VMOV     Q1,Q9
        BL       sr_ark      ;; x[0] = sr_ark(x[0], rk[10][0]);
        VMOV     Q5,Q0
        VMOV     Q0,Q6          ;; x[1]
        BL       rotatebytes
        VMOV     Q1,Q10
        BL       sr_ark
        VMOV     Q6,Q0
        VMOV     Q0,Q7          ;; x[2]
        BL       rotatebytes
        VMOV     Q1,Q11
        BL       sr_ark
        VMOV     Q7,Q0
        VMOV     Q0,Q8          ;; x[1]
        BL       rotatebytes
        VMOV     Q1,Q12
        BL       sr_ark
        VMOV     Q8,Q0
        VSTM     R4,{D10-D17}
//
        ADD      SP,SP,#+196
        VPOP     {D24-D25}
        VPOP     {D8-D23}
        POP      {R4,R5,PC}       ;; return

        END