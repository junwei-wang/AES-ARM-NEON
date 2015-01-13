        ;;EXTERN fmult
        ;;EXTERN fsqur

        PUBLIC affine_trans
        PUBLIC exp254
        PUBLIC fmult
        PUBLIC fsqur

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//      field multiplication (Barrett's method)
//      uint8x16_t fmult(poly8x16_t a, poly8x16_t b)
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
//      uint8x16_t fsqur(poly8x16_t a)
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
//      uint8x16_t exp254(uint8x16_t x)
exp254:
        PUSH     {R7,LR}
        VPUSH    {D8-D13}
        VMOV     Q4,Q0
        BL       fsqur  ;; z = fsqur(x); // z = x^2
        VMOV     Q5,Q0
        VMOV     Q1,Q4  
        BL       fmult  ;; y = fmult(z, x); // y = z * x = x^3
        VMOV     Q4,Q0
        BL       fsqur  ;; w = fsqur(y);  
        BL       fsqur  ;; w = fsqur(w); // w = y ^ 4 = x^12
        VMOV     Q6,Q0
        VMOV     Q1,Q4  
        BL       fmult  ;; y = fmult(y, w); // t = x^15  
        BL       fsqur  ;; y = fsqur(y);
        BL       fsqur  ;; y = fsqur(y);
        BL       fsqur  ;; y = fsqur(y);  
        BL       fsqur  ;; y = fsqur(y);
        VMOV     Q1,Q6
        BL       fmult  ;; y = fmult(y, w);
        VMOV     Q1,Q5
        BL       fmult  ;; y = fmult(y, z); 
 //
        VPOP     {D8-D13}
        POP      {R0,PC}          ;; return

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
affine_trans:                                           ;;-- Q0: x, Q1: rk
        VSHR.U8  Q2,Q0,#+7      ;; b = a >> 7; (a = x)           
        VSHL.U8  Q3,Q0,#+1      ;; a = a << 1;
        VORR     Q3,Q3,Q2       ;; a = a | b;
        VEOR     Q0,Q0,Q3       ;; x = x ^ a;             -- Q0: x, Q1: rk, Q2: b, Q3: a
// 
        VSHR.U8  Q2,Q3,#+7      ;; b = a >> 7;  
        VSHL.U8  Q3,Q3,#+1      ;; a = a << 1; 
        VORR     Q3,Q3,Q2       ;; a = a | b;
        VEOR     Q0,Q0,Q3       ;; x = x ^ a;             -- Q0: x, Q1: rk, Q2: b, Q3: a
//
        VSHR.U8  Q2,Q3,#+7      ;; b = a >> 7;          
        VSHL.U8  Q3,Q3,#+1      ;; a = a << 1;
        VORR     Q3,Q3,Q2       ;; a = a | b;
        VEOR     Q0,Q0,Q3       ;; x = x ^ a;             -- Q0: x, Q1: rk, Q2: b, Q3: a
// 
        VSHR.U8  Q2,Q3,#+7      ;; b = a >> 7;  
        VSHL.U8  Q3,Q3,#+1      ;; a = a << 1; 
        VORR     Q3,Q3,Q2       ;; a = a | b;
        VEOR     Q0,Q0,Q3       ;; x = x ^ a;             -- Q0: x, Q1: rk, Q2: b, Q3: a
//
        VMOV.I8  Q2,#+99        ;; y = vdupq_n_u8(0x63);
        VEOR     Q0,Q0,Q2       ;; x = x ^ y;
        BX       LR

        END