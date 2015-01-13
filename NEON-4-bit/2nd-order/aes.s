        EXTERN sr_ark
        EXTERN sr_mc_ark
        EXTERN sec_sbox

        PUBLIC sec_aes

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//      void sec_aes(uint8x16_t x[], uint8x16_t *rk[])
sec_aes:
        PUSH     {R4,R5,LR}
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
        MOV      R0,R4
        BL       sec_sbox       ;; sec_sbox(x);
        VLDM     R4,{D8-D13}
        LDR      R0,[R5, #+4]
        VLDM     R0,{D14-D19}
        VMOV     Q0,Q4
        VMOV     Q1,Q7
        BL       sr_mc_ark      ;; x[0] = sr_mc_ark(x[0], rk[1][0]);
        VMOV     Q4,Q0
        VMOV     Q0,Q5
        VMOV     Q1,Q8
        BL       sr_mc_ark      ;; x[1] = sr_mc_ark(x[1], rk[1][1]);
        VMOV     Q5,Q0
        VMOV     Q0,Q6
        VMOV     Q1,Q9
        BL       sr_mc_ark      ;; x[2] = sr_mc_ark(x[2], rk[1][2]);
        VMOV     Q6,Q0
        VSTM     R4,{D8-D13}
// round 2
        MOV      R0,R4
        BL       sec_sbox
        VLDM     R4,{D8-D13}
        LDR      R0,[R5, #+8]
        VLDM     R0,{D14-D19}
        VMOV     Q0,Q4
        VMOV     Q1,Q7
        BL       sr_mc_ark
        VMOV     Q4,Q0
        VMOV     Q0,Q5
        VMOV     Q1,Q8
        BL       sr_mc_ark
        VMOV     Q5,Q0
        VMOV     Q0,Q6
        VMOV     Q1,Q9
        BL       sr_mc_ark
        VMOV     Q6,Q0
        VSTM     R4,{D8-D13}
// round 3
        MOV      R0,R4
        BL       sec_sbox
        VLDM     R4,{D8-D13}
        LDR      R0,[R5, #+12]
        VLDM     R0,{D14-D19}
        VMOV     Q0,Q4
        VMOV     Q1,Q7
        BL       sr_mc_ark
        VMOV     Q4,Q0
        VMOV     Q0,Q5
        VMOV     Q1,Q8
        BL       sr_mc_ark
        VMOV     Q5,Q0
        VMOV     Q0,Q6
        VMOV     Q1,Q9
        BL       sr_mc_ark
        VMOV     Q6,Q0
        VSTM     R4,{D8-D13}
// round 4
        MOV      R0,R4
        BL       sec_sbox
        VLDM     R4,{D8-D13}
        LDR      R0,[R5, #+16]
        VLDM     R0,{D14-D19}
        VMOV     Q0,Q4
        VMOV     Q1,Q7
        BL       sr_mc_ark
        VMOV     Q4,Q0
        VMOV     Q0,Q5
        VMOV     Q1,Q8
        BL       sr_mc_ark
        VMOV     Q5,Q0
        VMOV     Q0,Q6
        VMOV     Q1,Q9
        BL       sr_mc_ark
        VMOV     Q6,Q0
        VSTM     R4,{D8-D13}
// round 5
        MOV      R0,R4
        BL       sec_sbox
        VLDM     R4,{D8-D13}
        LDR      R0,[R5, #+20]
        VLDM     R0,{D14-D19}
        VMOV     Q0,Q4
        VMOV     Q1,Q7
        BL       sr_mc_ark
        VMOV     Q4,Q0
        VMOV     Q0,Q5
        VMOV     Q1,Q8
        BL       sr_mc_ark
        VMOV     Q5,Q0
        VMOV     Q0,Q6
        VMOV     Q1,Q9
        BL       sr_mc_ark
        VMOV     Q6,Q0
        VSTM     R4,{D8-D13}     
// round 6
        MOV      R0,R4
        BL       sec_sbox
        VLDM     R4,{D8-D13}
        LDR      R0,[R5, #+24]
        VLDM     R0,{D14-D19}
        VMOV     Q0,Q4
        VMOV     Q1,Q7
        BL       sr_mc_ark
        VMOV     Q4,Q0
        VMOV     Q0,Q5
        VMOV     Q1,Q8
        BL       sr_mc_ark
        VMOV     Q5,Q0
        VMOV     Q0,Q6
        VMOV     Q1,Q9
        BL       sr_mc_ark
        VMOV     Q6,Q0
        VSTM     R4,{D8-D13}    
// round 7
        MOV      R0,R4
        BL       sec_sbox
        VLDM     R4,{D8-D13}
        LDR      R0,[R5, #+28]
        VLDM     R0,{D14-D19}
        VMOV     Q0,Q4
        VMOV     Q1,Q7
        BL       sr_mc_ark
        VMOV     Q4,Q0
        VMOV     Q0,Q5
        VMOV     Q1,Q8
        BL       sr_mc_ark
        VMOV     Q5,Q0
        VMOV     Q0,Q6
        VMOV     Q1,Q9
        BL       sr_mc_ark
        VMOV     Q6,Q0
        VSTM     R4,{D8-D13}
// round 8
        MOV      R0,R4
        BL       sec_sbox
        VLDM     R4,{D8-D13}
        LDR      R0,[R5, #+32]
        VLDM     R0,{D14-D19}
        VMOV     Q0,Q4
        VMOV     Q1,Q7
        BL       sr_mc_ark
        VMOV     Q4,Q0
        VMOV     Q0,Q5
        VMOV     Q1,Q8
        BL       sr_mc_ark
        VMOV     Q5,Q0
        VMOV     Q0,Q6
        VMOV     Q1,Q9
        BL       sr_mc_ark
        VMOV     Q6,Q0
        VSTM     R4,{D8-D13}
// round 9
        MOV      R0,R4
        BL       sec_sbox
        VLDM     R4,{D8-D13}
        LDR      R0,[R5, #+36]
        VLDM     R0,{D14-D19}
        VMOV     Q0,Q4
        VMOV     Q1,Q7
        BL       sr_mc_ark
        VMOV     Q4,Q0
        VMOV     Q0,Q5
        VMOV     Q1,Q8
        BL       sr_mc_ark
        VMOV     Q5,Q0
        VMOV     Q0,Q6
        VMOV     Q1,Q9
        BL       sr_mc_ark
        VMOV     Q6,Q0
        VSTM     R4,{D8-D13}
// round 10
        MOV      R0,R4
        BL       sec_sbox
        VLDM     R4,{D8-D13}
        LDR      R0,[R5, #+40]
        VLDM     R0,{D14-D19}
        VMOV     Q0,Q4
        VMOV     Q1,Q7
        BL       sr_ark
        VMOV     Q4,Q0
        VMOV     Q0,Q5
        VMOV     Q1,Q8
        BL       sr_ark
        VMOV     Q5,Q0
        VMOV     Q0,Q6
        VMOV     Q1,Q9
        BL       sr_ark
        VMOV     Q6,Q0
        VSTM     R4,{D8-D13}
//
        ADD      SP,SP,#+148
        VPOP     {D8-D19}
        POP      {R4,R5,PC}       ;; return

        END