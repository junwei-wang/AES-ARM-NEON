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
        VPUSH    {D24-D31}
        SUB      SP,SP,#+16
        MOVS     R4,R0
        MOVS     R5,R1
        MOVS     R6,R2
        MOVS     R7,R3
//      gx[0,1,2,3] = g_call(x[0,1,2,3]);
//      y[0,1,2,3] = fmult(x[0,1,2,3], gx[0,1,2,3]);
        VLDM     R5,{D8-D13}
        VMOV     Q0,Q4
        BLX      R7
        VMOV     Q12,Q0  ; gx[0]
        VMOV     Q1,Q4  ; x[0]
        BL       fmult
        VMOV     Q8,Q0  ; y[0]
        VMOV     Q0,Q5
        BLX      R7
        VMOV     Q13,Q0  ; gx[1]
        VMOV     Q1,Q5  ; x[1]
        BL       fmult
        VMOV     Q9,Q0  ; y[1]
        VMOV     Q0,Q6
        BLX      R7
        VMOV     Q14,Q0  ; gx[2]
        VMOV     Q1,Q6  ; x[2]
        BL       fmult
        VMOV     Q10,Q0  ; y[2]
        VMOV     Q0,Q7
        BLX      R7
        VMOV     Q15,Q0  ; gx[3]
        VMOV     Q1,Q7  ; x[3]
        BL       fmult
        VMOV     Q11,Q0  ; y[3]
        VSTM     R6,{D24-D31}    // corret here
        VPUSH    {D28-D29}       // push from Q12,Q13 
////////////////////////////////////// x[0], y[1]        
//      r00 = vxorshf96();
        BL       vxorshf96  ; r00
        VMOV     Q14,Q0
//      r01 = vxorshf96();
        BL       vxorshf96
        VMOV     Q15,Q0
//      y[0] = veorq_u8(y[0], r00);
        VEOR     Q8,Q14,Q8
//      t = g_call(r01);
        BLX      R7
//      t = fmult(x[0], t);
        VMOV     Q1,Q4
        BL       fmult
//      r1 = veorq_u8(r00, t);
        VEOR     Q14,Q14,Q0
//      t = fmult(r01, gx[0]);
        VMOV     Q0,Q15
        VMOV     Q1,Q12
        BL       fmult
//      r1 = veorq_u8(r1, t);
        VEOR     Q14,Q14,Q0
//      s = veorq_u8(x[1], r01);
        VEOR     Q15,Q15,Q5
//      t = g_call(s);
        VMOV     Q0,Q15
        BLX      R7
//      t = fmult(x[0], t);
        VMOV     Q1,Q4
        BL       fmult
//      r1 = veorq_u8(t, r1);
        VEOR     Q14,Q14,Q0
//      t = fmult(gx[0], s);
        VMOV     Q1,Q12
        VMOV     Q0,Q15
        BL       fmult
//      r1 = veorq_u8(t, r1);
        VEOR     Q0,Q0,Q14
//      y[1] = veorq_u8(y[1], r1);
        VEOR     Q9,Q0,Q9
////////////////////////// x[0], y[2]  
//      r00 = vxorshf96();
        BL       vxorshf96  ; r00
        VMOV     Q14,Q0
//      r01 = vxorshf96();
        BL       vxorshf96
        VMOV     Q15,Q0
//      y[0] = veorq_u8(y[0], r00);
        VEOR     Q8,Q14,Q8
//      t = g_call(r01);
        BLX      R7
//      t = fmult(x[0], t);
        VMOV     Q1,Q4
        BL       fmult
//      r1 = veorq_u8(r00, t);
        VEOR     Q14,Q14,Q0
//      t = fmult(r01, gx[0]);
        VMOV     Q0,Q15
        VMOV     Q1,Q12
        BL       fmult
//      r1 = veorq_u8(r1, t);
        VEOR     Q14,Q14,Q0
//      s = veorq_u8(x[1], r01);
        VEOR     Q15,Q15,Q6
//      t = g_call(s);
        VMOV     Q0,Q15
        BLX      R7
//      t = fmult(x[0], t);
        VMOV     Q1,Q4
        BL       fmult
//      r1 = veorq_u8(t, r1);
        VEOR     Q14,Q14,Q0
//      t = fmult(gx[0], s);
        VMOV     Q1,Q12
        VMOV     Q0,Q15
        BL       fmult
//      r1 = veorq_u8(t, r1);
        VEOR     Q0,Q0,Q14
//      y[1] = veorq_u8(y[1], r1);
        VEOR     Q10,Q0,Q10
////////////////////////// x[0], y[3]  
//      r00 = vxorshf96();
        BL       vxorshf96  ; r00
        VMOV     Q14,Q0
//      r01 = vxorshf96();
        BL       vxorshf96
        VMOV     Q15,Q0
//      y[0] = veorq_u8(y[0], r00);
        VEOR     Q8,Q14,Q8
//      t = g_call(r01);
        BLX      R7
//      t = fmult(x[0], t);
        VMOV     Q1,Q4
        BL       fmult
//      r1 = veorq_u8(r00, t);
        VEOR     Q14,Q14,Q0
//      t = fmult(r01, gx[0]);
        VMOV     Q0,Q15
        VMOV     Q1,Q12
        BL       fmult
//      r1 = veorq_u8(r1, t);
        VEOR     Q14,Q14,Q0
//      s = veorq_u8(x[1], r01);
        VEOR     Q15,Q15,Q7
//      t = g_call(s);
        VMOV     Q0,Q15
        BLX      R7
//      t = fmult(x[0], t);
        VMOV     Q1,Q4
        BL       fmult
//      r1 = veorq_u8(t, r1);
        VEOR     Q14,Q14,Q0
//      t = fmult(gx[0], s);
        VMOV     Q1,Q12
        VMOV     Q0,Q15
        BL       fmult
//      r1 = veorq_u8(t, r1);
        VEOR     Q0,Q0,Q14
//      y[1] = veorq_u8(y[1], r1);
        VEOR     Q11,Q0,Q11
////////////////////////// x[1], y[2]  
//      r00 = vxorshf96();
        BL       vxorshf96  ; r00
        VMOV     Q14,Q0
//      r01 = vxorshf96();
        BL       vxorshf96
        VMOV     Q15,Q0
//      y[0] = veorq_u8(y[0], r00);
        VEOR     Q9,Q14,Q9
//      t = g_call(r01);
        BLX      R7
//      t = fmult(x[0], t);
        VMOV     Q1,Q5
        BL       fmult
//      r1 = veorq_u8(r00, t);
        VEOR     Q14,Q14,Q0
//      t = fmult(r01, gx[0]);
        VMOV     Q0,Q15
        VMOV     Q1,Q13
        BL       fmult
//      r1 = veorq_u8(r1, t);
        VEOR     Q14,Q14,Q0
//      s = veorq_u8(x[1], r01);
        VEOR     Q15,Q15,Q6
//      t = g_call(s);
        VMOV     Q0,Q15
        BLX      R7
//      t = fmult(x[0], t);
        VMOV     Q1,Q5
        BL       fmult
//      r1 = veorq_u8(t, r1);
        VEOR     Q14,Q14,Q0
//      t = fmult(gx[0], s);
        VMOV     Q1,Q13
        VMOV     Q0,Q15
        BL       fmult
//      r1 = veorq_u8(t, r1);
        VEOR     Q0,Q0,Q14
//      y[1] = veorq_u8(y[1], r1);
        VEOR     Q10,Q0,Q10
////////////////////////// x[1], y[3]  
//      r00 = vxorshf96();
        BL       vxorshf96  ; r00
        VMOV     Q14,Q0
//      r01 = vxorshf96();
        BL       vxorshf96
        VMOV     Q15,Q0
//      y[0] = veorq_u8(y[0], r00);
        VEOR     Q9,Q14,Q9
//      t = g_call(r01);
        BLX      R7
//      t = fmult(x[0], t);
        VMOV     Q1,Q5
        BL       fmult
//      r1 = veorq_u8(r00, t);
        VEOR     Q14,Q14,Q0
//      t = fmult(r01, gx[0]);
        VMOV     Q0,Q15
        VMOV     Q1,Q13
        BL       fmult
//      r1 = veorq_u8(r1, t);
        VEOR     Q14,Q14,Q0
//      s = veorq_u8(x[1], r01);
        VEOR     Q15,Q15,Q7
//      t = g_call(s);
        VMOV     Q0,Q15
        BLX      R7
//      t = fmult(x[0], t);
        VMOV     Q1,Q5
        BL       fmult
//      r1 = veorq_u8(t, r1);
        VEOR     Q14,Q14,Q0
//      t = fmult(gx[0], s);
        VMOV     Q1,Q13
        VMOV     Q0,Q15
        BL       fmult
//      r1 = veorq_u8(t, r1);
        VEOR     Q0,Q0,Q14
//      y[1] = veorq_u8(y[1], r1);
        VEOR     Q11,Q0,Q11
////////////////////////// x[2], y[3]
        VPOP     {D26-D27}       // pop to Q12 Q13 
//      r00 = vxorshf96();
        BL       vxorshf96  ; r00
        VMOV     Q14,Q0
//      r01 = vxorshf96();
        BL       vxorshf96
        VMOV     Q15,Q0
//      y[0] = veorq_u8(y[0], r00);
        VEOR     Q10,Q14,Q10
//      t = g_call(r01);
        BLX      R7
//      t = fmult(x[0], t);
        VMOV     Q1,Q6
        BL       fmult
//      r1 = veorq_u8(r00, t);
        VEOR     Q14,Q14,Q0
//      t = fmult(r01, gx[0]);
        VMOV     Q0,Q15
        VMOV     Q1,Q13
        BL       fmult
//      r1 = veorq_u8(r1, t);
        VEOR     Q14,Q14,Q0
//      s = veorq_u8(x[1], r01);
        VEOR     Q15,Q15,Q7
//      t = g_call(s);
        VMOV     Q0,Q15
        BLX      R7
//      t = fmult(x[0], t);
        VMOV     Q1,Q6
        BL       fmult
//      r1 = veorq_u8(t, r1);
        VEOR     Q14,Q14,Q0
//      t = fmult(gx[0], s);
        VMOV     Q1,Q13
        VMOV     Q0,Q15
        BL       fmult
//      r1 = veorq_u8(t, r1);
        VEOR     Q0,Q0,Q14
//      y[1] = veorq_u8(y[1], r1);
        VEOR     Q11,Q0,Q11
  
//        
        VSTM     R4,{D16-D23}
//
        ADD      SP,SP,#+16
        VPOP     {D24-D31}
        VPOP     {D8-D23}
        POP      {R0,R4-R7,PC}    ;; return

        END
