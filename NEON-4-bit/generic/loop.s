        PUBLIC sec_fcubic4_loop
                
        EXTERN vxorshf96
        EXTERN tb_cubic
        
        SECTION `.text`:CODE:NOROOT(2)
        THUMB
//      uint8x16x2_t sec_cube4_loop(uint8x16_t xi, uint8x16_t xj,
//                                  uint8x16_t yi, uint8x16_t yj)
sec_fcubic4_loop:
        PUSH     {R7,LR}
        VPUSH    {D8-D15}
        VPUSH    {D0-D7}
        VPOP     {D8-D15}         ;; Q4: xi, Q5: xj, Q6: yi, Q7: yj
        
        BL       vxorshf96
        VSHR.U8  Q1,Q0,#+4        ;; Q1: r'

        LDR.N    R0,CubicTable
        VLDM     R0,{D4-D7}       ;; Q2: tb_squr
        ;;VMOV.U8  Q2,#0x0f
        VAND     Q0,Q0,Q3         ;; Q0: r
        
        VEOR     Q4,Q4,Q1         ;; Q4: xi^r'
        VEOR     Q3,Q4,Q5         ;; Q3: xi^r'^xj
        VEOR     Q5,Q5,Q1         ;; Q5: xj^r'
        
        VTBL.8   D8,{D4-D5},D8
        VTBL.8   D9,{D4-D5},D9
        VEOR     Q4,Q4,Q0         ;; Q4: r^h(xi^r')
        VTBL.8   D10,{D4-D5},D10
        VTBL.8   D11,{D4-D5},D11
        VEOR     Q5,Q5,Q4         ;; Q5: r^h(xi^r')^h(xj^r')
        VTBL.8   D6,{D4-D5},D6
        VTBL.8   D7,{D4-D5},D7
        VEOR     Q3,Q3,Q5         ;; Q3: r^h(xi^r')^h(xj^r')^h(xi^r'^xj)
        VTBL.8   D2,{D4-D5},D2
        VTBL.8   D3,{D4-D5},D3
        VEOR     Q1,Q1,Q3         ;; Q1: r_j,i
        VEOR     Q1,Q1,Q7         ;; Q1: yj
        VEOR     Q0,Q0,Q6         ;; Q0: yi

        VPOP     {D8-D15}
        POP      {R0,PC}
        Nop
        DATA
CubicTable:
        DC32     tb_cubic

        END