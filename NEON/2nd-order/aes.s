        EXTERN rotatebytes
        EXTERN sec_exp254
        EXTERN at_sr_ark
        EXTERN at_sr_mc_ark

        PUBLIC sec_aes

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//      void sec_aes(uint8x16_t x[], uint8x16_t *rk[])
sec_aes:
        PUSH     {R4,R5,LR}
        ;;SUB      SP,SP,#+4
        VPUSH    {D8-D19}
        MOV      R4,R0          ;; R4: x
        MOV      R5,R1          ;; R5: rk
        SUB      SP,SP,#+148
// round 0
        LDR      R0,[R5, #+0]
        VLDM     R4,{D0-D5}
        VLDM     R0,{D6-D11}
        VEOR     Q0,Q3,Q0
        VEOR     Q1,Q4,Q1
        VEOR     Q2,Q5,Q2
        VSTM     R4,{D0-D5}
// round 1 
        ADD      R3,SP,#+0
        ADD      R2,SP,#+48
        ADD      R1,SP,#+96   
        MOV      R0,R4
        BL       sec_exp254     ;; sec_exp254(x, y, z, w);
        VLDM     R4,{D8-D13}
        LDR      R0,[R5, #+4]
        VLDM     R0,{D14-D19}
        VMOV     Q0,Q4
        VMOV     Q1,Q7
        BL       at_sr_mc_ark      ;; x[0] = sr_mc_ark(x[0], rk[1][0]);
        VMOV     Q4,Q0
        VMOV     Q0,Q5
        VMOV     Q1,Q8
        BL       at_sr_mc_ark      ;; x[1] = sr_mc_ark(x[1], rk[1][1]);
        VMOV     Q5,Q0
        VMOV     Q0,Q6
        VMOV     Q1,Q9
        BL       at_sr_mc_ark      ;; x[2] = sr_mc_ark(x[2], rk[1][2]);
        VMOV     Q6,Q0
        VSTM     R4,{D8-D13}
// round 2
        ADD      R3,SP,#+0
        ADD      R2,SP,#+48
        ADD      R1,SP,#+96   
        MOV      R0,R4
        BL       sec_exp254     ;; sec_exp254(x, y, z, w);
        VLDM     R4,{D8-D13}
        LDR      R0,[R5, #+8]
        VLDM     R0,{D14-D19}
        VMOV     Q0,Q4
        VMOV     Q1,Q7
        BL       at_sr_mc_ark      ;; x[0] = sr_mc_ark(x[0], rk[2][0]);
        VMOV     Q4,Q0
        VMOV     Q0,Q5
        VMOV     Q1,Q8
        BL       at_sr_mc_ark      ;; x[1] = sr_mc_ark(x[1], rk[2][1]);
        VMOV     Q5,Q0
        VMOV     Q0,Q6
        VMOV     Q1,Q9
        BL       at_sr_mc_ark      ;; x[2] = sr_mc_ark(x[2], rk[2][2]);
        VMOV     Q6,Q0
        VSTM     R4,{D8-D13}
// round 3
        ADD      R3,SP,#+0
        ADD      R2,SP,#+48
        ADD      R1,SP,#+96   
        MOV      R0,R4
        BL       sec_exp254     ;; sec_exp254(x, y, z, w);
        VLDM     R4,{D8-D13}
        LDR      R0,[R5, #+12]
        VLDM     R0,{D14-D19}
        VMOV     Q0,Q4
        VMOV     Q1,Q7
        BL       at_sr_mc_ark      ;; x[0] = sr_mc_ark(x[0], rk[3][0]);
        VMOV     Q4,Q0
        VMOV     Q0,Q5
        VMOV     Q1,Q8
        BL       at_sr_mc_ark      ;; x[1] = sr_mc_ark(x[1], rk[3][1]);
        VMOV     Q5,Q0
        VMOV     Q0,Q6
        VMOV     Q1,Q9
        BL       at_sr_mc_ark      ;; x[2] = sr_mc_ark(x[2], rk[3][2]);
        VMOV     Q6,Q0
        VSTM     R4,{D8-D13}
// round 4
        ADD      R3,SP,#+0
        ADD      R2,SP,#+48
        ADD      R1,SP,#+96   
        MOV      R0,R4
        BL       sec_exp254     ;; sec_exp254(x, y, z, w);
        VLDM     R4,{D8-D13}
        LDR      R0,[R5, #+16]
        VLDM     R0,{D14-D19}
        VMOV     Q0,Q4
        VMOV     Q1,Q7
        BL       at_sr_mc_ark      ;; x[0] = sr_mc_ark(x[0], rk[4][0]);
        VMOV     Q4,Q0
        VMOV     Q0,Q5
        VMOV     Q1,Q8
        BL       at_sr_mc_ark      ;; x[1] = sr_mc_ark(x[1], rk[4][1]);
        VMOV     Q5,Q0
        VMOV     Q0,Q6
        VMOV     Q1,Q9
        BL       at_sr_mc_ark      ;; x[2] = sr_mc_ark(x[2], rk[4][2]);
        VMOV     Q6,Q0
        VSTM     R4,{D8-D13}
// round 5
        ADD      R3,SP,#+0
        ADD      R2,SP,#+48
        ADD      R1,SP,#+96   
        MOV      R0,R4
        BL       sec_exp254     ;; sec_exp254(x, y, z, w);
        VLDM     R4,{D8-D13}
        LDR      R0,[R5, #+20]
        VLDM     R0,{D14-D19}
        VMOV     Q0,Q4
        VMOV     Q1,Q7
        BL       at_sr_mc_ark      ;; x[0] = sr_mc_ark(x[0], rk[5][0]);
        VMOV     Q4,Q0
        VMOV     Q0,Q5
        VMOV     Q1,Q8
        BL       at_sr_mc_ark      ;; x[1] = sr_mc_ark(x[1], rk[5][1]);
        VMOV     Q5,Q0
        VMOV     Q0,Q6
        VMOV     Q1,Q9
        BL       at_sr_mc_ark      ;; x[2] = sr_mc_ark(x[2], rk[5][2]);
        VMOV     Q6,Q0
        VSTM     R4,{D8-D13}
// round 6
        ADD      R3,SP,#+0
        ADD      R2,SP,#+48
        ADD      R1,SP,#+96   
        MOV      R0,R4
        BL       sec_exp254     ;; sec_exp254(x, y, z, w);
        VLDM     R4,{D8-D13}
        LDR      R0,[R5, #+24]
        VLDM     R0,{D14-D19}
        VMOV     Q0,Q4
        VMOV     Q1,Q7
        BL       at_sr_mc_ark      ;; x[0] = sr_mc_ark(x[0], rk[6][0]);
        VMOV     Q4,Q0
        VMOV     Q0,Q5
        VMOV     Q1,Q8
        BL       at_sr_mc_ark      ;; x[1] = sr_mc_ark(x[1], rk[6][1]);
        VMOV     Q5,Q0
        VMOV     Q0,Q6
        VMOV     Q1,Q9
        BL       at_sr_mc_ark      ;; x[2] = sr_mc_ark(x[2], rk[6][2]);
        VMOV     Q6,Q0
        VSTM     R4,{D8-D13}
// round 7
        ADD      R3,SP,#+0
        ADD      R2,SP,#+48
        ADD      R1,SP,#+96   
        MOV      R0,R4
        BL       sec_exp254     ;; sec_exp254(x, y, z, w);
        VLDM     R4,{D8-D13}
        LDR      R0,[R5, #+28]
        VLDM     R0,{D14-D19}
        VMOV     Q0,Q4
        VMOV     Q1,Q7
        BL       at_sr_mc_ark      ;; x[0] = sr_mc_ark(x[0], rk[7][0]);
        VMOV     Q4,Q0
        VMOV     Q0,Q5
        VMOV     Q1,Q8
        BL       at_sr_mc_ark      ;; x[1] = sr_mc_ark(x[1], rk[7][1]);
        VMOV     Q5,Q0
        VMOV     Q0,Q6
        VMOV     Q1,Q9
        BL       at_sr_mc_ark      ;; x[2] = sr_mc_ark(x[2], rk[7][2]);
        VMOV     Q6,Q0
        VSTM     R4,{D8-D13}
// round 8
        ADD      R3,SP,#+0
        ADD      R2,SP,#+48
        ADD      R1,SP,#+96   
        MOV      R0,R4
        BL       sec_exp254     ;; sec_exp254(x, y, z, w);
        VLDM     R4,{D8-D13}
        LDR      R0,[R5, #+32]
        VLDM     R0,{D14-D19}
        VMOV     Q0,Q4
        VMOV     Q1,Q7
        BL       at_sr_mc_ark      ;; x[0] = sr_mc_ark(x[0], rk[8][0]);
        VMOV     Q4,Q0
        VMOV     Q0,Q5
        VMOV     Q1,Q8
        BL       at_sr_mc_ark      ;; x[1] = sr_mc_ark(x[1], rk[8][1]);
        VMOV     Q5,Q0
        VMOV     Q0,Q6
        VMOV     Q1,Q9
        BL       at_sr_mc_ark      ;; x[2] = sr_mc_ark(x[2], rk[8][2]);
        VMOV     Q6,Q0
        VSTM     R4,{D8-D13}
// round 9
        ADD      R3,SP,#+0
        ADD      R2,SP,#+48
        ADD      R1,SP,#+96   
        MOV      R0,R4
        BL       sec_exp254     ;; sec_exp254(x, y, z, w);
        VLDM     R4,{D8-D13}
        LDR      R0,[R5, #+36]
        VLDM     R0,{D14-D19}
        VMOV     Q0,Q4
        VMOV     Q1,Q7
        BL       at_sr_mc_ark      ;; x[0] = sr_mc_ark(x[0], rk[9][0]);
        VMOV     Q4,Q0
        VMOV     Q0,Q5
        VMOV     Q1,Q8
        BL       at_sr_mc_ark      ;; x[1] = sr_mc_ark(x[1], rk[9][1]);
        VMOV     Q5,Q0
        VMOV     Q0,Q6
        VMOV     Q1,Q9
        BL       at_sr_mc_ark      ;; x[2] = sr_mc_ark(x[2], rk[9][2]);
        VMOV     Q6,Q0
        VSTM     R4,{D8-D13}
// round 10
        ADD      R3,SP,#+0
        ADD      R2,SP,#+48
        ADD      R1,SP,#+96   
        MOV      R0,R4
        BL       sec_exp254     ;; sec_exp254(x, y, z, w);
        VLDM     R4,{D8-D13}
        LDR      R0,[R5, #+40]
        VLDM     R0,{D14-D19}
        VMOV     Q0,Q4
        VMOV     Q1,Q7
        BL       at_sr_ark      ;; x[0] = sr_mc_ark(x[0], rk[10][0]);
        VMOV     Q4,Q0
        VMOV     Q0,Q5
        VMOV     Q1,Q8
        BL       at_sr_ark      ;; x[1] = sr_mc_ark(x[1], rk[10][1]);
        VMOV     Q5,Q0
        VMOV     Q0,Q6
        VMOV     Q1,Q9
        BL       at_sr_ark      ;; x[2] = sr_mc_ark(x[2], rk[10][2]);
        VMOV     Q6,Q0
        VSTM     R4,{D8-D13}
//
        ADD      SP,SP,#+148
        VPOP     {D8-D19}
        ;;ADD      SP,SP,#+4
        POP      {R4,R5,PC}       ;; return

        END