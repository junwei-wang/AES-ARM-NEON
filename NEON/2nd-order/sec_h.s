        EXTERN fmult
        EXTERN vxorshf96

        PUBLIC sec_h

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//      void sec_h(uint8x16_t y[], uint8x16_t x[], uint8x16_t gx[],
//                 uint8x16_t (*g_call)(uint8x16_t))
sec_h:
        PUSH     {R3-R7,LR}
        VPUSH    {D8-D23}
        VPUSH    {D24-D29}
        SUB      SP,SP,#+16
        MOVS     R4,R0
        MOVS     R5,R1
        MOVS     R6,R2
        MOVS     R7,R3
//      gx[0,1,2] = g_call(x[0,1,2]);
//      y[0,1,2] = fmult(x[0,1,2], gx[0,1,2]);
        VLDM     R5,{D8-D13}
        VMOV     Q0,Q4
        BLX      R7
        VMOV     Q7,Q0  ; gx[0]
        VMOV     Q1,Q4  ; x[0]
        BL       fmult
        VMOV     Q10,Q0  ; y[0]
        VMOV     Q0,Q5
        BLX      R7
        VMOV     Q8,Q0  ; gx[1]
        VMOV     Q1,Q5  ; x[1]
        BL       fmult
        VMOV     Q11,Q0  ; y[1]
        VMOV     Q0,Q6
        BLX      R7
        VMOV     Q9,Q0  ; gx[2]
        VMOV     Q1,Q6  ; x[2]
        BL       fmult
        VMOV     Q12,Q0  ; y[1]
        VSTM     R6,{D14-D19}    // corret here
////////////////////////////////////// x[0], y[1]        
//      r00 = vxorshf96();
        BL       vxorshf96  ; r00
        VMOV     Q13,Q0
//      r01 = vxorshf96();
        BL       vxorshf96
        VMOV     Q14,Q0
//      y[0] = veorq_u8(y[0], r00);
        VEOR     Q10,Q13,Q10
//      t = g_call(r01);
        BLX      R7
//      t = fmult(x[0], t);
        VMOV     Q1,Q4
        BL       fmult
//      r1 = veorq_u8(r00, t);
        VEOR     Q13,Q13,Q0
//      t = fmult(r01, gx[0]);
        VMOV     Q0,Q14
        VMOV     Q1,Q7
        BL       fmult
//      r1 = veorq_u8(r1, t);
        VEOR     Q13,Q13,Q0
//      s = veorq_u8(x[1], r01);
        VEOR     Q14,Q14,Q5
//      t = g_call(s);
        VMOV     Q0,Q14
        BLX      R7
//      t = fmult(x[0], t);
        VMOV     Q1,Q4
        BL       fmult
//      r1 = veorq_u8(t, r1);
        VEOR     Q13,Q13,Q0
//      t = fmult(gx[0], s);
        VMOV     Q1,Q7
        VMOV     Q0,Q14
        BL       fmult
//      r1 = veorq_u8(t, r1);
        VEOR     Q0,Q0,Q13
//      y[1] = veorq_u8(y[1], r1);
        VEOR     Q11,Q0,Q11
////////////////////////// x[0], y[2]        
//      r00 = vxorshf96();
        BL       vxorshf96  ; r00
        VMOV     Q13,Q0
//      r01 = vxorshf96();
        BL       vxorshf96
        VMOV     Q14,Q0
//      y[0] = veorq_u8(y[0], r00);
        VEOR     Q10,Q13,Q10
//      t = g_call(r01);
        BLX      R7
//      t = fmult(x[0], t);
        VMOV     Q1,Q4
        BL       fmult
//      r1 = veorq_u8(r00, t);
        VEOR     Q13,Q13,Q0
//      t = fmult(r01, gx[0]);
        VMOV     Q0,Q14
        VMOV     Q1,Q7
        BL       fmult
//      r1 = veorq_u8(r1, t);
        VEOR     Q13,Q13,Q0
//      s = veorq_u8(x[1], r01);
        VEOR     Q14,Q14,Q6
//      t = g_call(s);
        VMOV     Q0,Q14
        BLX      R7
//      t = fmult(x[0], t);
        VMOV     Q1,Q4
        BL       fmult
//      r1 = veorq_u8(t, r1);
        VEOR     Q13,Q13,Q0
//      t = fmult(gx[0], s);
        VMOV     Q1,Q7
        VMOV     Q0,Q14
        BL       fmult
//      r1 = veorq_u8(t, r1);
        VEOR     Q0,Q0,Q13
//      y[1] = veorq_u8(y[1], r1);
        VEOR     Q12,Q0,Q12     
////////////////////////// x[1], y[2]        
//      r00 = vxorshf96();
        BL       vxorshf96  ; r00
        VMOV     Q13,Q0
//      r01 = vxorshf96();
        BL       vxorshf96
        VMOV     Q14,Q0
//      y[0] = veorq_u8(y[0], r00);
        VEOR     Q11,Q13,Q11
//      t = g_call(r01);
        BLX      R7
//      t = fmult(x[0], t);
        VMOV     Q1,Q5
        BL       fmult
//      r1 = veorq_u8(r00, t);
        VEOR     Q13,Q13,Q0
//      t = fmult(r01, gx[0]);
        VMOV     Q0,Q14
        VMOV     Q1,Q8
        BL       fmult
//      r1 = veorq_u8(r1, t);
        VEOR     Q13,Q13,Q0
//      s = veorq_u8(x[1], r01);
        VEOR     Q14,Q14,Q6
//      t = g_call(s);
        VMOV     Q0,Q14
        BLX      R7
//      t = fmult(x[0], t);
        VMOV     Q1,Q5
        BL       fmult
//      r1 = veorq_u8(t, r1);
        VEOR     Q13,Q13,Q0
//      t = fmult(gx[0], s);
        VMOV     Q1,Q8
        VMOV     Q0,Q14
        BL       fmult
//      r1 = veorq_u8(t, r1);
        VEOR     Q0,Q0,Q13
//      y[1] = veorq_u8(y[1], r1);
        VEOR     Q12,Q0,Q12        
//////////////////////////////////////       
//        
        VSTM     R4,{D20-D25}
//
        ADD      SP,SP,#+16
        VPOP     {D24-D29}
        VPOP     {D8-D23}
        POP      {R0,R4-R7,PC}    ;; return

        END
