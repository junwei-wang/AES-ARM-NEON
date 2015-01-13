        PUBLIC fmult4
        PUBLIC fsqur4
        PUBLIC fcubic4
        PUBLIC fquar4
        PUBLIC tb_cubic

        SECTION `.bss`:DATA:REORDER:NOROOT(3)
tb_squr:
        DC32 0x05040100, 0x06070203, 0x09080d0c, 0x0a0b0e0f
        
        SECTION `.bss`:DATA:REORDER:NOROOT(3)
tb_cubic:
        DC32 0x0f080100, 0x01010a0c, 0x0c0f0f0a, 0x0c080a08

        SECTION `.bss`:DATA:REORDER:NOROOT(3)
tb_quar:
        DC32 0x02030100, 0x07060405, 0x0d0c0e0f, 0x08090b0a

        SECTION `.text`:CODE:NOROOT(2)
        THUMB
fsqur4:
        LDR.N    R0,SqurTable
        VLDM     R0,{D2-D3}
        VTBL.8   D0,{D2-D3},D0
        VTBL.8   D1,{D2-D3},D1
        BX       LR               ;; return
        DATA
SqurTable:
        DC32     tb_squr
        
        SECTION `.text`:CODE:NOROOT(2)
        THUMB
fcubic4:
        LDR.N    R0,CubicTable
        VLDM     R0,{D2-D3}
        VTBL.8   D0,{D2-D3},D0
        VTBL.8   D1,{D2-D3},D1
        BX       LR               ;; return
        DATA
CubicTable:
        DC32     tb_cubic

        SECTION `.text`:CODE:NOROOT(2)
        THUMB
fquar4:
        LDR.N    R0,QuarTable
        VLDM     R0,{D2-D3}
        VTBL.8   D0,{D2-D3},D0
        VTBL.8   D1,{D2-D3},D1
        BX       LR               ;; return
        DATA
QuarTable:
        DC32     tb_quar

        SECTION `.text`:CODE:NOROOT(2)
        THUMB
;;      field multiplication (Barrett's method)
;;      uint8x16_t fmult4(uint8x16_t a, uint8x16_t b)
fmult4:
;;      1. u(x) = a(x)*b(x), deg(u) <= 6
        VMUL.P8   Q0,Q0,Q1                      ;; Q0: u(x)    
;;      2. t(x) = u(x)/(x^4), deg(t) <= 2
        VSHR.U8   Q1,Q0,#+4                     ;; Q1: t(x) = u(x) >> 4
;;      3. s(x) = t(x)*r(x),  r(x) = x^2 
;;      4. q(x) = s(x)/(x^2), => q(x) = t(x)    ;; Q1: q(x)
;;      5. v(x) = q(x)*n(x), deg(n) = 6
        VMOV.U8   Q2,#0x13                      ;; Q2: n(x) = 0x13
        VMUL.P8   Q1,Q2,Q1                      ;; Q1: v(x)
;;      6. z(x) = u(x)+v(x)
        VEOR     Q0,Q1,Q0
        BX       LR                             ;; return

        END