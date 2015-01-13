        PUBLIC delta
        PUBLIC delta_inv
        
        SECTION `.bss`:DATA:REORDER:NOROOT(3)
tb_delta:
        DATA
        DC32 0x0f0f0f0f, 0x0f0f0f0f, 0x0f0f0f0f, 0x0f0f0f0f ;; mask low 4-bit
        DC32 0x27260100, 0x6d6c4b4a, 0x67664140, 0x2d2c0b0a ;; low 4-bit delta
        DC32 0xe8d13900, 0xd9e00831, 0x0c35dde4, 0x3d04ecd5 ;; high 4-bit delta
      ;;DC32 0x05040100, 0x06070203, 0x09080d0c, 0x0a0b0e0f ;; square
        DC32 0x030d0e00, 0x020c0f01, 0x07090a04, 0x06080b05 ;; lambda*square
        
        SECTION `.bss`:DATA:REORDER:NOROOT(3)
tb_delta_inv:
        DATA
        DC32 0xadb21f00, 0x0619b4ab, 0x9b842936, 0x302f829d ;; low 4-bit delta
      ;;DC32 0xd827ff00, 0x20df07f8, 0x23dc04fb, 0xdb24fc03 ;; high 4-bit delta
        DC32 0xbb449c63, 0x43bc649b, 0x40bf6798, 0xb8479f60 ;; high 4-bit delta ^ 0x63
        
        SECTION `.text`:CODE:NOROOT(2)
        THUMB
//      uint8x16x4_t delta(uint8x16_t a)
//      Q0: L, Q1: H, Q2: w, Q3: t
delta:                             ;; Q0: a
        VPUSH    {D8-D11}
        VSHR.U8  Q1,Q0,#+4         ;; Q1: high 4-bit
        LDR.N    R0,DataTable
        VLDM     R0,{D4-D11}
        VAND     Q0,Q0,Q2          ;; Q0: low 4-bit
        
        VTBL.8   D0,{D6-D7},D0
        VTBL.8   D1,{D6-D7},D1
        VTBL.8   D2,{D8-D9},D2
        VTBL.8   D3,{D8-D9},D3
        VEOR     Q0,Q0,Q1
        
        VSHR.U8  Q1,Q0,#+4         ;; Q1: high 4-bit
        VAND     Q0,Q0,Q2          ;; Q0: low 4-bit
        
        VTBL.8   D4,{D10-D11},D2
        VTBL.8   D5,{D10-D11},D3   ;; Q2: w
        
        VEOR     Q3,Q0,Q1          ;; Q3: t
               
        VPOP     {D8-D11}
        BX       LR
        DATA
DataTable:
        DC32     tb_delta
        
        SECTION `.text`:CODE:NOROOT(2)
        THUMB
//      uint8x16_t delta_inv(uint8x16_t low, uint8x16_t high)
//      delta inversion and affine transformation
delta_inv:
        LDR.N    R0,DataTable1
        VLDM     R0,{D4-D7}
        
        VTBL.8   D0,{D4-D5},D0
        VTBL.8   D1,{D4-D5},D1
        VTBL.8   D2,{D6-D7},D2
        VTBL.8   D3,{D6-D7},D3
        
        VEOR     Q0,Q0,Q1
        ;;VMOV.U8  Q1,#0x63
        ;;VEOR     Q0,Q0,Q1
        BX       LR
        DATA
DataTable1:
        DC32     tb_delta_inv

        END