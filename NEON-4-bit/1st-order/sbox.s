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
        DS8 32
h:
        DS8 32
w:
        DS8 32
t:
        DS8 32
        
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
        PUSH     {R3-R6,LR}
        VPUSH    {D8-D19}
        MOVS     R4,R0          ;; R4: c
        MOVS     R5,R1          ;; R5: a
        MOVS     R6,R2          ;; R6: b
        VLDM     R6,{D12-D15}
        VLDM     R5,{D8-D11}
//      c[1] = s = vxorshf96();
        BL       vxorshf96
        VSHR.U8  Q9,Q0,#4        
//      c[0] = fmult(a[0], b[0]);
        VMOV     Q0,Q4
        VMOV     Q1,Q6
        BL       fmult4
//      c[0] ^= s;
        VEOR     Q8,Q0,Q9
//      c[1] ^= fmult(b[1], a[1]);
        VMOV     Q0,Q5
        VMOV     Q1,Q7
        BL       fmult4
        VEOR     Q9,Q0,Q9
//      c[1] ^= fmult(a[0], b[1]);
        VMOV     Q0,Q4
        VMOV     Q1,Q7
        BL       fmult4
        VEOR     Q9,Q0,Q9
//      c[1] ^= fmult(a[1], b[0]);
        VMOV     Q0,Q5
        VMOV     Q1,Q6
        BL       fmult4
        VEOR     Q9,Q0,Q9
//
        VSTM     R4,{D16-D19}
        VPOP     {D8-D19}
        POP      {R0,R4,R5,R6,PC}       ;; return
        
        SECTION `.text`:CODE:NOROOT(2)
        THUMB
//      void sec_fcubic4(uint8x16_t y[], uint8x16_t x[])
sec_fcubic4:
        PUSH     {R3-R5,LR}
        VPUSH    {D8-D15}
        MOV      R4,R0
        MOV      R5,R1
        
        BL       vxorshf96
        VSHR.U8  Q1,Q0,#+4      ;; Q1: r'        
        LDR.N    R2,CubicTable
        VLDM     R2,{D4-D7}     ;; Q2: table of cubic, Q3: 0x0f
        VAND     Q0,Q0,Q3       ;; Q0: r
        
        VLDM     R5,{D8-D11}      ;; Q4-Q5: x
        VTBL.8   D12,{D4-D5},D8
        VTBL.8   D13,{D4-D5},D9
        VTBL.8   D14,{D4-D5},D10
        VTBL.8   D15,{D4-D5},D11  ;; Q6-Q7: y
        
        VEOR     Q4,Q4,Q1         ;; Q4: x0^r'
        VEOR     Q3,Q4,Q5         ;; Q3: x0^r'^x1
        VEOR     Q5,Q5,Q1         ;; Q5: x1^r'
        
        VTBL.8   D8,{D4-D5},D8
        VTBL.8   D9,{D4-D5},D9
        VEOR     Q4,Q4,Q0         ;; Q4: r^h(x0^r')
        VTBL.8   D10,{D4-D5},D10
        VTBL.8   D11,{D4-D5},D11
        VEOR     Q5,Q5,Q4         ;; Q5: r^h(x0^r')^h(x1^r')
        VTBL.8   D6,{D4-D5},D6
        VTBL.8   D7,{D4-D5},D7
        VEOR     Q3,Q3,Q5         ;; Q3: r^h(x0^r')^h(x1^r')^h(x0^r'^x1)
        VTBL.8   D2,{D4-D5},D2
        VTBL.8   D3,{D4-D5},D3
        VEOR     Q1,Q1,Q3         ;; Q1: r_1,0
        VEOR     Q1,Q1,Q7         ;; Q1: y1
        VEOR     Q0,Q0,Q6         ;; Q0: y0
        
        VSTM     R4,{D0-D3}

        VPOP     {D8-D15}
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
        MOV      R4,R0
//      s = delta(x[0]);
        VLDM     R4,{D0-D3}     ;; Q0: x[0], Q1: x[1]
        VMOV     Q5,Q1          ;; Q5: x[1];
        BL       delta
//      l[0] = s.val[0];
//      h[0] = s.val[1];
//      w[0] = s.val[2];
//      t[0] = s.val[3];
        VMOV     Q4,Q0
        VMOV     Q6,Q1
        VMOV     Q8,Q2
        VMOV     Q10,Q3
//      s = delta(x[0]);
        VMOV     Q0,Q5
        BL       delta
//      l[1] = s.val[0];
//      h[1] = s.val[1];
//      w[1] = s.val[2];
//      t[1] = s.val[3];
        VMOV     Q5,Q0
        VMOV     Q7,Q1
        VMOV     Q9,Q2
        VMOV     Q11,Q3
        
        LDR.N    R5,ArrayTable
        VSTM     R5,{D8-D23}
        
//      sec_fmult4(x, t, l);
        MOV      R2,R5
        ADD      R1,R5,#+96
        MOV      R0,R4
        BL       sec_fmult4
//      w[0] = veorq_u8(w[0], x[0]);
        ADD      R1,R5,#+64
        VLDM     R4,{D0-D3}
        VLDM     R1,{D4-D7}
        VEOR     Q0,Q2,Q0
        VEOR     Q1,Q3,Q1
        VSTM     R1,{D0-D3}
        
//      secure inversion
//      sec_fcubic4(x, w)
        MOV      R0,R4
        BL       sec_fcubic4
//      x[0] = fquar4(x[0]);
//      x[1] = fquar4(x[1]);
        VLDM     R4,{D0-D3}
        LDR.N    R0,QuarTable
        VLDM     R0,{D4-D5}
        VTBL.8   D0,{D4-D5},D0
        VTBL.8   D1,{D4-D5},D1
        VTBL.8   D2,{D4-D5},D2
        VTBL.8   D3,{D4-D5},D3
        VSTM     R4,{D0-D3}
//      l[0] = fsqur4(w[0]);
//      l[1] = fsqur4(w[1]);
        ADD      R0,R5,#+64
        VLDM     R0,{D0-D3}
        LDR.N    R0,SqurTable
        VLDM     R0,{D4-D5}
        VTBL.8   D0,{D4-D5},D0
        VTBL.8   D1,{D4-D5},D1
        VTBL.8   D2,{D4-D5},D2
        VTBL.8   D3,{D4-D5},D3
        VSTM     R5,{D0-D3}
//      sec_fmult4(w, x, l);
        MOV      R2,R5
        MOV      R1,R4
        ADD      R0,R5,#+64
        BL       sec_fmult4
//      sec_fmult4(x, w, h); // x: the high part
        ADD      R2,R5,#32
        ADD      R1,R5,#+64
        MOV      R0,R4
        BL       sec_fmult4
//      sec_fmult4(l, w, t); // l: the low part
        ADD      R2,R5,#+96
        ADD      R1,R5,#+64
        MOV      R0,R5
        BL       sec_fmult4
//      x[0] = delta_inv(l[0], x[0]);
//      x[1] = delta_inv(l[1], x[1]);
        VLDM     R4,{D8-D11}
        VLDM     R5,{D0-D3}
        VMOV     Q6,Q1
        VMOV     Q1,Q4
        BL       delta_inv
        VMOV     Q4,Q0          ;; Q4: x0
        VMOV     Q0,Q6
        VMOV     Q1,Q5
        BL       delta_inv
        VMOV     Q5,Q0
//      m = vdupq_n_u8(0x63);
        VMOV.I8  Q0,#+99
//      x[0] = veorq_u8(x[0], m);
        VEOR     Q4,Q4,Q0
        VSTM     R4,{D8-D11}
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


        END