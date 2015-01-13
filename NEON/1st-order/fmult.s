        PUBLIC fmult
        PUBLIC fsqur

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//      field multiplication (Barrett's method)
//      uint8x16_t fmult(uint8x16_t a, uint8x16_t b)
//      registers: Q0-Q3
fmult:
//      1. u(x) = a(x)*b(x), deg(u) <= 14
        VMULL.P8  Q2,D1,D3                      ;; Q2: u(x) high
        VMULL.P8  Q1,D0,D2                      ;; Q1: u(x) low       
//      2. t(x) = u(x)/(x^8), deg(t) <= 6
        VMOVN.I16 D0,Q1                         ;; Q0: u(x)
        VMOVN.I16 D1,Q2
        VSHRN.U16 D2,Q1,#+8                     ;; Q1: t(x) = u(x) >> 8
        VSHRN.U16 D3,Q2,#+8
//      3. s(x) = t(x)*r(x), deg(r) = 6  ->  deg(s) <= 12 
//      4. q(x) = s(x)/(x^6), deg(q) <= 6
        VMOV.U8   D7,#+70                       ;; D7: rx = 0x46 = +70
        VMULL.P8  Q2,D2,D7                      ;; Q2: s(x) low
        VSHRN.U16 D2,Q2,#+6                     ;; Q1(D2): q(x) = s(x) >> 6;
        VMULL.P8  Q2,D3,D7                      ;; Q3: s(x) high       
        VSHRN.U16 D3,Q2,#+6                     ;; Q1(D3): q(x) = s(x) >> 6;
//      5. v(x) = q(x)*n(x), deg(n) = 6
        VMOV.U8   Q2,#+27                       ;; Q2: nx = 0x[1]1B = +27
        VMUL.P8   Q1,Q2,Q1
//      6. z(x) = u(x)+v(x)
        VEOR     Q0,Q1,Q0
        BX       LR                             ;; return

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//      field multiplication (Barrett's method)
//      uint8x16_t fsqur(uint8x16_t a)
//      registers: Q0-Q3
fsqur:
//      1. u(x) = a(x)*a(x), deg(u) <= 14
        VMULL.P8  Q2,D1,D1                      ;; Q2: u(x) high
        VMULL.P8  Q1,D0,D0                      ;; Q1: u(x) low       
//      2. t(x) = u(x)/(x^8), deg(t) <= 6
        VMOVN.I16 D0,Q1                         ;; Q0: u(x)
        VMOVN.I16 D1,Q2
        VSHRN.U16 D2,Q1,#+8                     ;; Q1: t(x) = u(x) >> 8
        VSHRN.U16 D3,Q2,#+8
//      3. s(x) = t(x)*r(x), deg(r) = 6  ->  deg(s) <= 12 
//      4. q(x) = s(x)/(x^6), deg(q) <= 6
        VMOV.U8   D7,#+70                       ;; D7: rx = 0x46 = +70
        VMULL.P8  Q2,D2,D7                      ;; Q2: s(x) low
        VSHRN.U16 D2,Q2,#+6                     ;; Q1(D2): q(x) = s(x) >> 6;
        VMULL.P8  Q2,D3,D7                      ;; Q3: s(x) high       
        VSHRN.U16 D3,Q2,#+6                     ;; Q1(D3): q(x) = s(x) >> 6;
//      5. v(x) = q(x)*n(x), deg(n) = 6
        VMOV.U8   Q2,#+27                       ;; Q2: nx = 0x[1]1B = +27
        VMUL.P8   Q1,Q2,Q1
//      6. z(x) = u(x)+v(x)
        VEOR     Q0,Q1,Q0
        BX       LR                             ;; return
        
        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//      uint8x16_t fpow4(uint8x16_t a) {
fpow4:
        PUSH     {R7,LR}
        BL       fsqur
        BL       fsqur
        POP      {R0,PC}          ;; return

        END
