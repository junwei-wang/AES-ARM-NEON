        EXTERN delta
        EXTERN delta_inv
        EXTERN fmult4
        EXTERN fsqur4
        EXTERN fquar4
        
        PUBLIC sbox
        
        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//      uint8x16_t sbox(uint8x16_t x)
sbox:
        PUSH     {R7,LR}
        VPUSH    {D8-D15}
//
        BL       delta          ;; Q0: l, Q1: h, Q2: lambda*h^2, Q3: l+h
        VPUSH    {D0-D7}
        VPOP     {D8-D15}       ;; Q4: l, Q5: h, Q6: lambda*h^2, Q7: l+h
        
        VMOV     Q1,Q7
        BL       fmult4         ;; Q0: l(h+l)
        VEOR     Q0,Q0,Q6       ;; Q0: d = lambda*h^2 + l(h+l)
        VMOV     Q4,Q0          ;; Q4: d
        BL       fsqur4         ;; Q0: d^2
        VMOV     Q1,Q4
        VMOV     Q4,Q0          ;; Q4: d^2
        BL       fmult4         ;; Q0: d^3
        BL       fquar4         ;; Q0: d^12
        VMOV     Q1,Q4
        BL       fmult4
        VMOV     Q4,Q0          ;; Q4: d' = d^(-1) = d^14
        VMOV     Q1,Q5
        BL       fmult4
        VMOV     Q5,Q0          ;; Q5: h*d'
        VMOV     Q0,Q4
        VMOV     Q1,Q7
        BL       fmult4         ;; Q0: (h+l)*d'
        VMOV     Q1,Q5          ;; Q5: h*d'
        BL       delta_inv
//
        VPOP     {D8-D15}
        POP      {R0,PC}          ;; return
        
        END