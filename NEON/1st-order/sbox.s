        EXTERN fmult
        EXTERN fsqur
        EXTERN fpow4
        EXTERN vxorshf96

        PUBLIC rotatebytes
        PUBLIC refresh_masks
        PUBLIC sec_exp254
        PUBLIC sec_mult
        PUBLIC sec_pow16        ;; combined with refresh_masks()
        PUBLIC sec_pow4         ;; combined with refresh_masks()
        PUBLIC sec_squr         ;; combined with refresh_masks()

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//      void sec_mult(uint8x16_t c[], uint8x16_t a[], uint8x16_t b[])
sec_mult:
        PUSH     {R4-R6,LR}
        VPUSH    {D8-D19}
        MOVS     R4,R0          ;; R4: c
        MOVS     R5,R1          ;; R5: a
        MOVS     R6,R2          ;; R6: b
        VLDM     R6,{D12-D15}
        VLDM     R5,{D8-D11}
//      c[1] = s = vxorshf96();
        BL       vxorshf96
        VMOV     Q9,Q0        
//      c[0] = fmult(a[0], b[0]);
        VMOV     Q0,Q4
        VMOV     Q1,Q6
        BL       fmult
//      c[0] ^= s;
        VEOR     Q8,Q0,Q9
//      c[1] ^= fmult(b[1], a[1]);
        VMOV     Q0,Q5
        VMOV     Q1,Q7
        BL       fmult
        VEOR     Q9,Q0,Q9
//      c[1] ^= fmult(a[0], b[1]);
        VMOV     Q0,Q4
        VMOV     Q1,Q7
        BL       fmult
        VEOR     Q9,Q0,Q9
//      c[1] ^= fmult(a[1], b[0]);
        VMOV     Q0,Q5
        VMOV     Q1,Q6
        BL       fmult
        VEOR     Q9,Q0,Q9
//
        VSTM     R4,{D16-D19}
        VPOP     {D8-D19}
        POP      {R4-R6,PC}       ;; return
        
        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//      void sec_h(uint8x16_t y[], uint8x16_t x[], uint8x16_t gx[],
//                 uint8x16_t (*g_call)(uint8x16_t))
sec_h:
        PUSH     {R3-R7,LR}
        VPUSH    {D8-D23}
        SUB      SP,SP,#+16
        MOVS     R4,R0
        MOVS     R5,R1
        MOVS     R6,R2
        MOVS     R7,R3
//      gx[0,1] = g_call(x[0,1]);
//      y[0,1] = fmult(x[0,1], gx[0,1]);
        VLDM     R5,{D8-D11}
        VMOV     Q0,Q4
        BLX      R7
        VMOV     Q6,Q0  ; gx[0]
        VMOV     Q1,Q4  ; x[0]
        BL       fmult
        VMOV     Q8,Q0  ; y[0]
        VMOV     Q0,Q5
        BLX      R7
        VMOV     Q7,Q0  ; gx[1]
        VMOV     Q1,Q5  ; x[1]
        BL       fmult
        VMOV     Q9,Q0  ; y[1]
        VSTM     R6,{D12-D15}    // corret here
//      r00 = vxorshf96();
        BL       vxorshf96  ; r00
        VMOV     Q10,Q0
//      r01 = vxorshf96();
        BL       vxorshf96
        VMOV     Q11,Q0
//      y[0] = veorq_u8(y[0], r00);
        VEOR     Q8,Q10,Q8
//      t = g_call(r01);
        BLX      R7
//      t = fmult(x[0], t);
        VMOV     Q1,Q4
        BL       fmult
//      r1 = veorq_u8(r00, t);
        VEOR     Q10,Q10,Q0
//      t = fmult(r01, gx[0]);
        VMOV     Q0,Q11
        VMOV     Q1,Q6
        BL       fmult
//      r1 = veorq_u8(r1, t);
        VEOR     Q10,Q10,Q0
//      s = veorq_u8(x[1], r01);
        VEOR     Q11,Q11,Q5
//      t = g_call(s);
        VMOV     Q0,Q11
        BLX      R7
//      t = fmult(x[0], t);
        VMOV     Q1,Q4
        BL       fmult
//      r1 = veorq_u8(t, r1);
        VEOR     Q10,Q10,Q0
//      t = fmult(gx[0], s);
        VMOV     Q1,Q6
        VMOV     Q0,Q11
        BL       fmult
//      r1 = veorq_u8(t, r1);
        VEOR     Q0,Q0,Q10
//      y[1] = veorq_u8(y[1], r1);
        VEOR     Q9,Q0,Q9
        VSTM     R4,{D16-D23}
//
        ADD      SP,SP,#+16
        VPOP     {D8-D21}
        POP      {R0,R4-R7,PC}    ;; return

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//      void sec_squr(uint8x16_t dest[], uint8x16_t src[])
sec_squr:
        PUSH     {R3-R5,LR}
        VPUSH    {D8-D13}
        MOVS     R4,R0          ;; R4: dest
        MOVS     R5,R1          ;; R5: src   
        VLDM     R5,{D8-D11}    ;; Q4-Q5: src
// refresh random
        BL       vxorshf96      ;; r = vxorshf96
        VMOV     Q6,Q0
//      
        VMOV     Q0,Q4          ;; dest[0] = fsqur(src[0]) ^ r;
        BL       fsqur          
        VEOR     Q4,Q0,Q6
        VMOV     Q0,Q5          ;; dest[1] = fsqur(src[1]) ^ r;
        BL       fsqur
        VEOR     Q5,Q0,Q6
//
        VSTM     R4,{D8-D11}    ;; Q4-Q5: dest
        VPOP     {D8-D13}
        POP      {R0,R4,R5,PC}  ;; return

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//      void sec_pow4(uint8x16_t dest[], uint8x16_t src[])
sec_pow4:
        PUSH     {R3-R5,LR}
        VPUSH    {D8-D13}
        MOVS     R4,R0          ;; R4: dest
        MOVS     R5,R1          ;; R5: src   
        VLDM     R5,{D8-D11}    ;; Q4-Q5: src
// refresh random
        BL       vxorshf96      ;; r = vxorshf96
        VMOV     Q6,Q0
//      
        VMOV     Q0,Q4          ;; dest[0] = pow4(src[0]) ^ r;
        BL       fsqur
        BL       fsqur
        VEOR     Q4,Q0,Q6
        VMOV     Q0,Q5          ;; dest[1] = pow4(src[1]) ^ r;
        BL       fsqur
        BL       fsqur
        VEOR     Q5,Q0,Q6
//
        VSTM     R4,{D8-D11}    ;; Q4-Q5: dest
        VPOP     {D8-D13}
        POP      {R0,R4,R5,PC}  ;; return

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//      void sec_pow16(uint8x16_t x[])
sec_pow16:
        PUSH     {R4,LR}
        VPUSH    {D8-D13}
        MOVS     R4,R0          ;; R4: x
        VLDM     R4,{D8-D11}    ;; Q4-Q5: src
// refresh random
        BL       vxorshf96      ;; r = vxorshf96
        VMOV     Q6,Q0
//
        VMOV     Q0,Q4          ;; x[0] = pow16(x[0]) ^ r;
        BL       fsqur
        BL       fsqur
        BL       fsqur
        BL       fsqur
        VEOR     Q4,Q0,Q6
        VMOV     Q0,Q5          ;; x[1] = pow16(x[1]) ^ r;
        BL       fsqur
        BL       fsqur
        BL       fsqur
        BL       fsqur
        VEOR     Q5,Q0,Q6
//        
        VSTM     R4,{D8-D11}
        VPOP     {D8-D13}
        POP      {R4,PC}        ;; return

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//      void refresh_masks(uint8x16_t x[])
refresh_masks:
        PUSH     {R4,LR}
        MOVS     R4,R0
        BL       vxorshf96      ;; t = vxorshf96();
//
        VLDM     R4,{D2-D5}
        VEOR     Q1,Q1,Q0       ;; x[0] ^= t;
        VEOR     Q2,Q2,Q0       ;; x[1] ^= t;
        VSTM     R4,{D2-D5}
//
        POP      {R4,PC}        ;; return

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//      void sec_exp254(uint8x16_t x[], uint8x16_t y[], uint8x16_t z[], uint8x16_t w[])
sec_exp254_flaw:
        PUSH     {R3-R7,LR}
        MOVS     R4,R0          ;; R4: x
        MOVS     R5,R1          ;; R5: y
        MOVS     R6,R2          ;; R6: z
        MOVS     R7,R3          ;; R7: w
//      sec_squr(z, x);         ;; z = x^2
        MOVS     R1,R4
        MOVS     R0,R6
        BL       sec_squr
//      sec_mult(y, z, x);      ;; y = x^3
        MOVS     R2,R4
        MOVS     R1,R6
        MOVS     R0,R5
        BL       sec_mult
//      sec_pow4(w, y);         ;; w = y^4 = x^12
        MOVS     R1,R5
        MOVS     R0,R7
        BL       sec_pow4
//      sec_mult(x, y, w);      ;; x = x^15
        MOVS     R2,R7
        MOVS     R1,R5
        MOVS     R0,R4
        BL       sec_mult
//      sec_pow16(x);           ;; x = x^240
        MOVS     R0,R4
        BL       sec_pow16
//      sec_mult(y, x, w);
        MOVS     R2,R7
        MOVS     R1,R4
        MOVS     R0,R5
        BL       sec_mult
//      sec_mult(x, y, z);
        MOVS     R2,R6
        MOVS     R1,R5
        MOVS     R0,R4
        BL       sec_mult
//
        POP      {R0,R4-R7,PC}    ;; return 
        
        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//      void sec_exp254(uint8x16_t x[], uint8x16_t y[], uint8x16_t z[], uint8x16_t w[])
sec_exp254:
        PUSH     {R3-R7,LR}
        MOVS     R4,R0          ;; R4: x
        MOVS     R5,R1          ;; R5: y
        MOVS     R6,R2          ;; R6: z
        MOVS     R7,R3          ;; R7: w
//      sec_h(y, x, z, fsqur);      ;; y = x^3
        LDR.N    R3,DataTable0
        MOVS     R1,R4
        MOVS     R0,R5
        BL       sec_h
//      sec_pow4(w, y);         ;; w = y^4 = x^12
        LDR.N    R3,DataTable1
        MOVS     R2,R7
        MOVS     R1,R5
        MOVS     R0,R4
        BL       sec_h
//      sec_pow16(x);           ;; x = x^240
        MOVS     R0,R4
        BL       sec_pow16
//      sec_mult(y, x, w);
        MOVS     R2,R7
        MOVS     R1,R4
        MOVS     R0,R5
        BL       sec_mult
//      sec_mult(x, y, z);
        MOVS     R2,R6
        MOVS     R1,R5
        MOVS     R0,R4
        BL       sec_mult
//
        POP      {R0,R4-R7,PC}    ;; return 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
rotatebytes:                                            ;;-- Q0: x
        VSHR.U8  Q1,Q0,#+7      ;; b = a >> 7; (a = x)           
        VSHL.U8  Q2,Q0,#+1      ;; a = a << 1;
        VORR     Q2,Q2,Q1       ;; a = a | b;
        VEOR     Q0,Q0,Q2       ;; x = x ^ a;             -- Q0: x, Q1: b, Q2: a
// 
        VSHR.U8  Q1,Q2,#+7      ;; b = a >> 7;  
        VSHL.U8  Q2,Q2,#+1      ;; a = a << 1; 
        VORR     Q2,Q2,Q1       ;; a = a | b;
        VEOR     Q0,Q0,Q2       ;; x = x ^ a;
//
        VSHR.U8  Q1,Q2,#+7      ;; b = a >> 7;          
        VSHL.U8  Q2,Q2,#+1      ;; a = a << 1;
        VORR     Q2,Q2,Q1       ;; a = a | b;
        VEOR     Q0,Q0,Q2       ;; x = x ^ a;
// 
        VSHR.U8  Q1,Q2,#+7      ;; b = a >> 7;  
        VSHL.U8  Q2,Q2,#+1      ;; a = a << 1; 
        VORR     Q2,Q2,Q1       ;; a = a | b;
        VEOR     Q0,Q0,Q2       ;; x = x ^ a;
//
        BX       LR
        
        SECTION `.text`:CODE:NOROOT(2)
        DATA
DataTable0:
        DC32     fsqur

        SECTION `.text`:CODE:NOROOT(2)
        DATA
DataTable1:
        DC32     fpow4

        END