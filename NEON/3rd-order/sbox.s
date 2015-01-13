        EXTERN fmult
        EXTERN fsqur
        EXTERN fpow4
        EXTERN sec_h
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
        VPUSH    {D8-D23}
        VPUSH    {D24-D31}
        MOVS     R4,R0          ;; R4: c
        MOVS     R5,R1          ;; R5: a
        MOVS     R6,R2          ;; R6: b
        VLDM     R6,{D16-D23}
        VLDM     R5,{D8-D15}
// i = 0, j = 1
//      c[1] = s = vxorshf96();
        BL       vxorshf96
        VMOV     Q13,Q0
//      c[0] = fmult(a[0], b[0]);
        VMOV     Q0,Q4
        VMOV     Q1,Q8
        BL       fmult
//      c[0] ^= s;
        VEOR     Q12,Q0,Q13
//      c[1] ^= fmult(b[1], a[1]);
        VMOV     Q0,Q5
        VMOV     Q1,Q9
        BL       fmult
        VEOR     Q13,Q0,Q13
//      c[1] ^= fmult(a[0], b[1]);
        VMOV     Q0,Q4
        VMOV     Q1,Q9
        BL       fmult
        VEOR     Q13,Q0,Q13
//      c[1] ^= fmult(a[1], b[0]);
        VMOV     Q0,Q5
        VMOV     Q1,Q8
        BL       fmult
        VEOR     Q13,Q0,Q13
// i = 0, j = 2
//      c[2] = s = vxorshf96();
        BL       vxorshf96
        VEOR     Q12,Q12,Q0
        VMOV     Q14,Q0
//      c[2] = fmult(a[2], b[2]);
        VMOV     Q0,Q6
        VMOV     Q1,Q10
        BL       fmult
        VEOR     Q14,Q0,Q14
//      c[2] ^= fmult(a[0], b[2]);
        VMOV     Q0,Q4
        VMOV     Q1,Q10
        BL       fmult
        VEOR     Q14,Q0,Q14
//      c[1] ^= fmult(a[2], b[0]);
        VMOV     Q0,Q6
        VMOV     Q1,Q8
        BL       fmult
        VEOR     Q14,Q0,Q14
// i = 0, j = 3
//      c[3] = s = vxorshf96();
        BL       vxorshf96
        VEOR     Q12,Q12,Q0
        VMOV     Q15,Q0
//      c[3] = fmult(a[3], b[3]);
        VMOV     Q0,Q7
        VMOV     Q1,Q11
        BL       fmult
        VEOR     Q15,Q0,Q15
//      c[3] ^= fmult(a[0], b[3]);
        VMOV     Q0,Q4
        VMOV     Q1,Q11
        BL       fmult
        VEOR     Q15,Q0,Q15
//      c[3] ^= fmult(a[3], b[0]);
        VMOV     Q0,Q7
        VMOV     Q1,Q8
        BL       fmult
        VEOR     Q15,Q0,Q15
// i = 1, j = 2
//      s = vxorshf96();
        BL       vxorshf96
        VEOR     Q13,Q13,Q0
        VEOR     Q14,Q14,Q0
//      c[2] ^= fmult(a[1], b[2]);
        VMOV     Q0,Q5
        VMOV     Q1,Q10
        BL       fmult
        VEOR     Q14,Q0,Q14
//      c[2] ^= fmult(a[2], b[1]);
        VMOV     Q0,Q6
        VMOV     Q1,Q9
        BL       fmult
        VEOR     Q14,Q0,Q14
// i = 1, j = 3
//      s = vxorshf96();
        BL       vxorshf96
        VEOR     Q13,Q13,Q0
        VEOR     Q15,Q15,Q0
//      c[3] ^= fmult(a[1], b[3]);
        VMOV     Q0,Q5
        VMOV     Q1,Q11
        BL       fmult
        VEOR     Q15,Q0,Q15
//      c[3] ^= fmult(a[3], b[1]);
        VMOV     Q0,Q7
        VMOV     Q1,Q9
        BL       fmult
        VEOR     Q15,Q0,Q15       
// i = 2, j = 3
//      s = vxorshf96();
        BL       vxorshf96
        VEOR     Q14,Q14,Q0
        VEOR     Q15,Q15,Q0
//      c[3] ^= fmult(a[2], b[3]);
        VMOV     Q0,Q6
        VMOV     Q1,Q11
        BL       fmult
        VEOR     Q15,Q0,Q15
//      c[3] ^= fmult(a[3], b[2]);
        VMOV     Q0,Q7
        VMOV     Q1,Q10
        BL       fmult
        VEOR     Q15,Q0,Q15
//
        VSTM     R4,{D24-D31}
        VPOP     {D24-D31}
        VPOP     {D8-D23}
        POP      {R4-R6,PC}       ;; return

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//      void sec_squr(uint8x16_t dest[], uint8x16_t src[])
sec_squr:
        PUSH     {R3-R5,LR}
        VPUSH    {D8-D17}
        MOVS     R4,R0          ;; R4: dest
        MOVS     R5,R1          ;; R5: src   
        VLDM     R5,{D8-D15}    ;; Q4-Q5: src
// refresh random
        BL       vxorshf96      ;; r = vxorshf96
        VMOV     Q8,Q0
//      
        VMOV     Q0,Q4          ;; dest[0] = fsqur(src[0]) ^ r;
        BL       fsqur          
        VEOR     Q4,Q0,Q8
        VMOV     Q0,Q5          ;; dest[1] = fsqur(src[1]) ^ r;
        BL       fsqur
        VEOR     Q5,Q0,Q8
        VMOV     Q0,Q6
        BL       fsqur
        VMOV     Q6,Q0
        BL       vxorshf96
        VEOR     Q4,Q4,Q0
        VEOR     Q6,Q6,Q0
        VMOV     Q0,Q7
        BL       fsqur
        VMOV     Q7,Q0
        BL       vxorshf96
        VEOR     Q4,Q4,Q0
        VEOR     Q7,Q7,Q0
//
        VSTM     R4,{D8-D15}    ;; Q4-Q5: dest
        VPOP     {D8-D17}
        POP      {R0,R4,R5,PC}  ;; return

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//      void sec_pow4(uint8x16_t dest[], uint8x16_t src[])
sec_pow4:
        PUSH     {R3-R5,LR}
        VPUSH    {D8-D17}
        MOVS     R4,R0          ;; R4: dest
        MOVS     R5,R1          ;; R5: src   
        VLDM     R5,{D8-D15}    ;; Q4-Q5: src
// refresh random
        BL       vxorshf96      ;; r = vxorshf96
        VMOV     Q8,Q0
//      
        VMOV     Q0,Q4          ;; dest[0] = pow4(src[0]) ^ r;
        BL       fsqur
        BL       fsqur
        VEOR     Q4,Q0,Q8
        VMOV     Q0,Q5          ;; dest[1] = pow4(src[1]) ^ r;
        BL       fsqur
        BL       fsqur
        VEOR     Q5,Q0,Q8
        VMOV     Q0,Q6
        BL       fsqur
        BL       fsqur
        VMOV     Q6,Q0
        BL       vxorshf96
        VEOR     Q4,Q4,Q0
        VEOR     Q6,Q6,Q0
        VMOV     Q0,Q7
        BL       fsqur
        BL       fsqur
        VMOV     Q7,Q0
        BL       vxorshf96
        VEOR     Q4,Q4,Q0
        VEOR     Q7,Q7,Q0
//
        VSTM     R4,{D8-D15}    ;; Q4-Q5: dest
        VPOP     {D8-D17}
        POP      {R0,R4,R5,PC}  ;; return

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//      void sec_pow16(uint8x16_t x[])
sec_pow16:
        PUSH     {R4,LR}
        VPUSH    {D8-D17}
        MOVS     R4,R0          ;; R4: x
        VLDM     R4,{D8-D15}    ;; Q4-Q5: src
// refresh random
        BL       vxorshf96      ;; r = vxorshf96
        VMOV     Q8,Q0
//      
        VMOV     Q0,Q4          ;; dest[0] = pow4(src[0]) ^ r;
        BL       fsqur
        BL       fsqur
        BL       fsqur
        BL       fsqur
        VEOR     Q4,Q0,Q8
        VMOV     Q0,Q5          ;; dest[1] = pow4(src[1]) ^ r;
        BL       fsqur
        BL       fsqur
        BL       fsqur
        BL       fsqur
        VEOR     Q5,Q0,Q8
        VMOV     Q0,Q6
        BL       fsqur
        BL       fsqur
        BL       fsqur
        BL       fsqur
        VMOV     Q6,Q0
        BL       vxorshf96
        VEOR     Q4,Q4,Q0
        VEOR     Q6,Q6,Q0
        VMOV     Q0,Q7
        BL       fsqur
        BL       fsqur
        BL       fsqur
        BL       fsqur
        VMOV     Q7,Q0
        BL       vxorshf96
        VEOR     Q4,Q4,Q0
        VEOR     Q7,Q7,Q0
//
        VSTM     R4,{D8-D15}
        VPOP     {D8-D17}
        POP      {R4,PC}        ;; return

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//      void refresh_masks(uint8x16_t x[])
refresh_masks:
        PUSH     {R4,LR}
        VPUSH    {D8-D15}
        MOVS     R4,R0
        VLDM     R4,{D8-D15}
//
        BL       vxorshf96      ;; t = vxorshf96();
        VEOR     Q4,Q4,Q0       ;; x[0] ^= t;
        VEOR     Q5,Q5,Q0       ;; x[1] ^= t;
        BL       vxorshf96      ;; t = vxorshf96();
        VEOR     Q4,Q4,Q0       ;; x[0] ^= t;
        VEOR     Q6,Q6,Q0       ;; x[2] ^= t;
        BL       vxorshf96      ;; t = vxorshf96();
        VEOR     Q4,Q4,Q0       ;; x[0] ^= t;
        VEOR     Q7,Q7,Q0       ;; x[3] ^= t;
        VSTM     R4,{D8-D15}
//
        VPOP     {D8-D15}
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