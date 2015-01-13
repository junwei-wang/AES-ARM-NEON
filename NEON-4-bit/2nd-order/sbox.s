        EXTERN fmult4
        EXTERN vxorshf96
        EXTERN delta
        EXTERN delta_inv
        
        PUBLIC sec_fmult4
        PUBLIC sec_fcubic4
        PUBLIC sec_sbox
        
        SECTION `.bss`:DATA:REORDER:NOROOT(3)
//      uint8x16_t l[2], h[2], w[2], t[2];
l:
        DS8 48
h:
        DS8 48
w:
        DS8 48
t:
        DS8 48
        
        SECTION `.bss`:DATA:REORDER:NOROOT(3)
tb_cubic:
        DC32 0x0f080100, 0x01010a0c, 0x0c0f0f0a, 0x0c080a08
        DC32 0x0f0f0f0f, 0x0f0f0f0f, 0x0f0f0f0f, 0x0f0f0f0f
        
        SECTION `.bss`:DATA:REORDER:NOROOT(3)
tb_quar:
        DC32 0x02030100, 0x07060405, 0x0d0c0e0f, 0x08090b0a
        
        SECTION `.bss`:DATA:REORDER:NOROOT(3)
tb_squr:
        DC32 0x05040100, 0x06070203, 0x09080d0c, 0x0a0b0e0f


        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//      void sec_mult(uint8x16_t c[], uint8x16_t a[], uint8x16_t b[])
sec_fmult4:
        PUSH     {R4-R6,LR}
        VPUSH    {D8-D23}
        VPUSH    {D24-D25}
        MOVS     R4,R0          ;; R4: c
        MOVS     R5,R1          ;; R5: a
        MOVS     R6,R2          ;; R6: b
        VLDM     R6,{D14-D19}   ;; Q7-Q9: b
        VLDM     R5,{D8-D13}    ;; Q4-Q6: a
//      c[1] = s = vxorshf96();
        BL       vxorshf96
        VSHR.U8  Q11,Q0,#4
        VMOV.U8  Q12,#0x0f
        VAND.U8  Q12,Q12,Q0   
//      c[0] = fmult(a[0], b[0]);
        VMOV     Q0,Q4
        VMOV     Q1,Q7
        BL       fmult4
//      c[0] ^= s;
        VEOR     Q10,Q0,Q11
//      c[1] ^= fmult(b[1], a[1]);
        VMOV     Q0,Q5
        VMOV     Q1,Q8
        BL       fmult4
        VEOR     Q11,Q0,Q11
//      c[1] ^= fmult(a[0], b[1]);
        VMOV     Q0,Q4
        VMOV     Q1,Q8
        BL       fmult4
        VEOR     Q11,Q0,Q11
//      c[1] ^= fmult(a[1], b[0]);
        VMOV     Q0,Q5
        VMOV     Q1,Q7
        BL       fmult4
        VEOR     Q11,Q0,Q11
//      c[2] = s = vxorshf96();
//      c[0] ^= s;
        VEOR     Q10,Q10,Q12
//      c[2] ^= fmult(b[2], a[2]);
        VMOV     Q0,Q6
        VMOV     Q1,Q9
        BL       fmult4
        VEOR     Q12,Q0,Q12
//      c[2] ^= fmult(a[0], b[2]);
        VMOV     Q0,Q4
        VMOV     Q1,Q9
        BL       fmult4
        VEOR     Q12,Q0,Q12
//      c[1] ^= fmult(a[2], b[0]);
        VMOV     Q0,Q6
        VMOV     Q1,Q7
        BL       fmult4
        VEOR     Q12,Q0,Q12
//      s = vxorshf96();
        BL       vxorshf96
        VSHR.U8  Q0,Q0,#4
//      c[1] ^= s;
        VEOR     Q11,Q0,Q11
//      c[2] ^= s;
        VEOR     Q12,Q0,Q12
//      c[2] ^= fmult(a[1], b[2]);
        VMOV     Q0,Q5
        VMOV     Q1,Q9
        BL       fmult4
        VEOR     Q12,Q0,Q12
//      c[2] ^= fmult(a[2], b[1]);
        VMOV     Q0,Q6
        VMOV     Q1,Q8
        BL       fmult4
        VEOR     Q12,Q0,Q12
//
        VSTM     R4,{D20-D25}
        VPOP     {D24-D25}
        VPOP     {D8-D23}
        POP      {R4-R6,PC}       ;; return
        
        SECTION `.text`:CODE:NOROOT(2)
        THUMB
//      void sec_fcubic4(uint8x16_t y[], uint8x16_t x[])
sec_fcubic4:
        PUSH     {R3-R5,LR}
        VPUSH    {D8-D23}
        MOV      R4,R0
        MOV      R5,R1    
        LDR.N    R2,CubicTable
        VLDM     R2,{D20-D23}     ;; Q10: table of cubic, Q11: 0x0f
//      i = 0, j = 1
        BL       vxorshf96
        VSHR.U8  Q1,Q0,#+4        ;; Q1: r'              
        VAND     Q0,Q0,Q11        ;; Q0: r
        VLDM     R5,{D8-D13}      ;; Q4-Q6: x
        VTBL.8   D14,{D20-D21},D8
        VTBL.8   D15,{D20-D21},D9
        VTBL.8   D16,{D20-D21},D10
        VTBL.8   D17,{D20-D21},D11
        VTBL.8   D18,{D20-D21},D12
        VTBL.8   D19,{D20-D21},D13  ;; Q7-Q9: y
        VEOR     Q7,Q7,Q0         ;; Q7: y0
        VEOR     Q2,Q4,Q1         ;; Q2: x0^r'
        VEOR     Q3,Q2,Q5         ;; Q3: x0^r'^x1
        
        VTBL.8   D4,{D20-D21},D4
        VTBL.8   D5,{D20-D21},D5
        VEOR     Q2,Q2,Q0         ;; Q2: r^h(x0^r')
        VEOR     Q0,Q3,Q4         ;; Q0: x1^r'
        VTBL.8   D0,{D20-D21},D0
        VTBL.8   D1,{D20-D21},D1
        VEOR     Q0,Q0,Q2         ;; Q3: r^h(x0^r')^h(x1^r')
        VTBL.8   D6,{D20-D21},D6
        VTBL.8   D7,{D20-D21},D7
        VEOR     Q3,Q3,Q0         ;; Q3: r^h(x0^r')^h(x1^r')^h(x0^r'^x1)
        VTBL.8   D2,{D20-D21},D2
        VTBL.8   D3,{D20-D21},D3    ;; Q1: h(r')
        VEOR     Q1,Q1,Q3         ;; Q1: r_1,0
        VEOR     Q8,Q8,Q1         ;; Q8: y1
//      i = 0, j = 2
        BL       vxorshf96
        VSHR.U8  Q1,Q0,#+4        ;; Q1: r'        
        VAND     Q0,Q0,Q11        ;; Q0: r
        VEOR     Q7,Q7,Q0         ;; Q7: y0
        VEOR     Q2,Q4,Q1         ;; Q2: x0^r'
        VEOR     Q3,Q2,Q6         ;; Q3: x0^r'^x2
        
        VTBL.8   D4,{D20-D21},D4
        VTBL.8   D5,{D20-D21},D5
        VEOR     Q2,Q2,Q0         ;; Q2: r^h(x0^r')
        VEOR     Q0,Q3,Q4         ;; Q0: x2^r'
        VTBL.8   D0,{D20-D21},D0
        VTBL.8   D1,{D20-D21},D1
        VEOR     Q0,Q0,Q2         ;; Q3: r^h(x0^r')^h(x2^r')
        VTBL.8   D6,{D20-D21},D6
        VTBL.8   D7,{D20-D21},D7
        VEOR     Q3,Q3,Q0         ;; Q3: r^h(x0^r')^h(x2^r')^h(x0^r'^x2)
        VTBL.8   D2,{D20-D21},D2
        VTBL.8   D3,{D20-D21},D3  ;; Q1: h(r')
        VEOR     Q1,Q1,Q3         ;; Q1: r_1,0
        VEOR     Q9,Q9,Q1         ;; Q9: y2
//      i = 1, j = 2
        BL       vxorshf96
        VSHR.U8  Q1,Q0,#+4        ;; Q1: r'        
        VAND     Q0,Q0,Q11        ;; Q0: r
        VEOR     Q8,Q8,Q0         ;; Q8: y0
        VEOR     Q2,Q5,Q1         ;; Q2: x1^r'
        VEOR     Q3,Q2,Q6         ;; Q3: x1^r'^x2
        
        VTBL.8   D4,{D20-D21},D4
        VTBL.8   D5,{D20-D21},D5
        VEOR     Q2,Q2,Q0         ;; Q2: r^h(x1^r')
        VEOR     Q0,Q3,Q5         ;; Q0: x2^r'
        VTBL.8   D0,{D20-D21},D0
        VTBL.8   D1,{D20-D21},D1
        VEOR     Q0,Q0,Q2         ;; Q3: r^h(x1^r')^h(x2^r')
        VTBL.8   D6,{D20-D21},D6
        VTBL.8   D7,{D20-D21},D7
        VEOR     Q3,Q3,Q0         ;; Q3: r^h(x1^r')^h(x2^r')^h(x1^r'^x2)
        VTBL.8   D2,{D20-D21},D2
        VTBL.8   D3,{D20-D21},D3    ;; Q1: h(r')
        VEOR     Q1,Q1,Q3         ;; Q1: r_1,0
        VEOR     Q9,Q9,Q1         ;; Q9: y2
//////        
        VSTM     R4,{D14-D19}

        VPOP     {D8-D23}
        POP      {R0,R4,R5,PC}    ;; return
        Nop
        DATA
CubicTable:
        DC32     tb_cubic

        SECTION `.text`:CODE:NOROOT(2)
        THUMB
//      void sec_sbox(uint8x16_t x[])
sec_sbox:
        PUSH     {R3-R5,LR}
        VPUSH    {D8-D23}
        VPUSH    {D24-D31}
        MOV      R4,R0
//      s = delta(x[0]);
        VLDM     R4,{D8-D13}     ;; Q0-Q2: x0-x2
        VMOV     Q0,Q4          ;; Q5: x[1];
        BL       delta
//      l[0] = s.val[0];
//      h[0] = s.val[1];
//      w[0] = s.val[2];
//      t[0] = s.val[3];
        VMOV     Q4,Q0
        VMOV     Q7,Q1
        VMOV     Q10,Q2
        VMOV     Q13,Q3
//      s = delta(x[1]);
        VMOV     Q0,Q5
        BL       delta
//      l[1] = s.val[0];
//      h[1] = s.val[1];
//      w[1] = s.val[2];
//      t[1] = s.val[3];
        VMOV     Q5,Q0
        VMOV     Q8,Q1
        VMOV     Q11,Q2
        VMOV     Q14,Q3
//      s = delta(x[2]);
        VMOV     Q0,Q6
        BL       delta
//      l[2] = s.val[0];
//      h[2] = s.val[1];
//      w[2] = s.val[2];
//      t[2] = s.val[3];
        VMOV     Q6,Q0
        VMOV     Q9,Q1
        VMOV     Q12,Q2
        VMOV     Q15,Q3
  
        LDR.N    R5,ArrayTable
        VSTM     R5,{D8-D19}
        ADD      R0,R5,#+0x60
        VSTM     R0,{D20-D31}      
//      sec_fmult4(x, t, l);
        MOV      R2,R5
        ADD      R1,R5,#+0x90
        MOV      R0,R4
        BL       sec_fmult4
//      w[0] = veorq_u8(w[0], x[0]);
        ADD      R1,R5,#+0x60
        VLDM     R4,{D0-D5}
        VLDM     R1,{D6-D11}
        VEOR     Q0,Q3,Q0
        VEOR     Q1,Q4,Q1
        VEOR     Q2,Q5,Q2
        VSTM     R1,{D0-D5}
        
//      secure inversion
//      sec_fcubic4(x, w)
        MOV      R0,R4
        BL       sec_fcubic4
//      x[0] = fquar4(x[0]);
//      x[1] = fquar4(x[1]);
//      x[2] = fquar4(x[2]);
        VLDM     R4,{D0-D5}
        LDR.N    R0,QuarTable
        VLDM     R0,{D6-D7}
        VTBL.8   D0,{D6-D7},D0
        VTBL.8   D1,{D6-D7},D1
        VTBL.8   D2,{D6-D7},D2
        VTBL.8   D3,{D6-D7},D3
        VTBL.8   D4,{D6-D7},D4
        VTBL.8   D5,{D6-D7},D5
        VSTM     R4,{D0-D5}
//      l[0] = fsqur4(w[0]);
//      l[1] = fsqur4(w[1]);
//      l[1] = fsqur4(w[2]);
        ADD      R0,R5,#+0x60
        VLDM     R0,{D0-D5}
        LDR.N    R0,SqurTable
        VLDM     R0,{D6-D7}
        VTBL.8   D0,{D6-D7},D0
        VTBL.8   D1,{D6-D7},D1
        VTBL.8   D2,{D6-D7},D2
        VTBL.8   D3,{D6-D7},D3
        VTBL.8   D4,{D6-D7},D4
        VTBL.8   D5,{D6-D7},D5
        VSTM     R5,{D0-D5}
//      sec_fmult4(w, x, l);
        MOV      R2,R5
        MOV      R1,R4
        ADD      R0,R5,#+0x60
        BL       sec_fmult4
//      sec_fmult4(x, w, h); // x: the high part
        ADD      R2,R5,#+0x30
        ADD      R1,R5,#+0x60
        MOV      R0,R4
        BL       sec_fmult4
//      sec_fmult4(l, w, t); // l: the low part
        ADD      R2,R5,#+0x90
        ADD      R1,R5,#+0x60
        MOV      R0,R5
        BL       sec_fmult4
//      x[0] = delta_inv(l[0], x[0]);
//      x[1] = delta_inv(l[1], x[1]);
//      x[2] = delta_inv(l[2], x[2]);
        VLDM     R4,{D14-D19}
        VLDM     R5,{D8-D13}
        VMOV     Q0,Q4
        VMOV     Q1,Q7
        BL       delta_inv
        VMOV     Q4,Q0          ;; Q4: x0
        VMOV     Q0,Q5
        VMOV     Q1,Q8
        BL       delta_inv
        VMOV     Q5,Q0          ;; Q4: x1
        VMOV     Q0,Q6
        VMOV     Q1,Q9
        BL       delta_inv
        VMOV     Q6,Q0          ;; Q4: x1
//
        VSTM     R4,{D8-D13}
        VPOP     {D24-D31}
        VPOP     {D8-D23}
        POP      {R0,R4,R5,PC}    ;; return
 
        SECTION `.text`:CODE:NOROOT(2)
        DATA        
QuarTable:
        DC32     tb_quar
        
        SECTION `.text`:CODE:NOROOT(2)
        DATA
SqurTable:
        DC32     tb_squr

        SECTION `.text`:CODE:NOROOT(2)
        DATA
ArrayTable:
        DC32     l
        DC32     l+0x10
        DC32     l+0x20
        DC32     l+0x30
        DC32     l+0x40
        DC32     l+0x50
        DC32     l+0x60
        DC32     l+0x70
        DC32     l+0x80
        DC32     l+0x90
        DC32     l+0xa0
        DC32     l+0xb0

        END