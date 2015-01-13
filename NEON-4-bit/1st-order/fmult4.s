        PUBLIC fmult4
   
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