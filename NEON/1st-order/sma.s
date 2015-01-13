;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; shift rows, mixcloumns and addroundkey ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        PUBLIC sr_ark
        PUBLIC sr_mc_ark

        SECTION `.bss`:DATA:REORDER:NOROOT(3)
tb_shiftrows:                  ;; uint8x16_t tbl_shift_rows;
        DATA
        DC32 0x03020100, 0x04070605, 0x09080B0A, 0x0e0d0c0f

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
sr_mc_ark:                      ;; uint8x16_t sr_mc_ark(uint8x16_t x, uint8x16_t rk)
//// shiftrows                                            -- Q0: x, Q1: rk   
        LDR.N    R0,DataTable     
        VLDM     R0,{D4-D5}                             ;;-- Q3: tbl_shift_rows
        VTBL.8   D1,{D0-D1},D5  ;; t.val[1] = vtbl2_u8(t, vget_high_u8(tbl_shift_rows));
        VTBL.8   D0,{D0},D4     ;; t.val[0] = vtbl2_u8(t, vget_low_u8(tbl_shift_rows));
//// mixcolumns                                         ;;-- Q0: x, Q1: rk
        VMOV.I8  Q3,#+27        ;; m = vdupq_n_u8(0x1B)   -- Q0: x, Q1: rk, Q3: m = 0x1B1B...1B         
        VSHR.S8  Q2,Q0,#+7      ;; y = vshrq_n_s8(x, 7);  -- Q0: x, Q1: rk, Q2: y, Q3: m           
        VAND     Q2,Q2,Q3       ;; y = vandq_u8(y, m);    -- Q0: x, Q1: rk, Q2: y
        VSHL.U8  Q3,Q0,#+1      ;; z = vshlq_n_u8(x, 1);  -- Q0: x, Q1: rk, Q2: y, Q3: z
        VEOR     Q2,Q3,Q2       ;; z = veorq_u8(z, y);    -- Q0: x, Q1: rk, Q2: z   
//
        VEXT.8   Q3,Q2,Q2,#+4   ;; z' = vextq_u8(z, z, 4);
        VEOR     Q2,Q2,Q3       ;; z = veorq_u8(z, z');   -- Q0: x, Q1: rk, Q2: z
        
        VEXT.8   Q0,Q0,Q0,#+4   ;; x' = vextq_u8(x, x, 4);
        VEOR     Q2,Q0,Q2       ;; z = veorq_u8(x', z);   -- Q0: x', Q1: rk, Q2: z      
        VEXT.8   Q0,Q0,Q0,#+4   ;; x'' = vextq_u8(x', x', 4);
        VEOR     Q2,Q0,Q2       ;; z = veorq_u8(x'', z);  -- Q0: x'', Q1: rk, Q2: z  
        VEXT.8   Q0,Q0,Q0,#+4   ;; x''' = vextq_u8(x'', x'', 4);
        VEOR     Q0,Q0,Q2       ;; x = veorq_u8(x''', z); -- Q0: x, Q1: rk
//// addroundkey
        VEOR     Q0,Q0,Q1       ;; x = veorq_u8(x, rk);
//// return x;
        BX       LR             ;; return
        

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//      uint8x16_t sr_ark(uint8x16_t x, uint8x16_t rk)
sr_ark:
//// shiftrows                                            -- Q0: x, Q1: rk   
        LDR.N    R0,DataTable         
        VLDM     R0,{D4-D5}                             ;;-- Q3: tbl_shiftrows
        VTBL.8   D1,{D0-D1},D5  ;; t.val[1] = vtbl2_u8(t, vget_high_u8(tbl_shiftrows));
        VTBL.8   D0,{D0},D4     ;; t.val[0] = vtbl2_u8(t, vget_low_u8(tbl_shiftrows));
//// addroundkey
        VEOR     Q0,Q0,Q1       ;; x = veorq_u8(x, rk);
//// return x;
        BX       LR             ;; return
        
        SECTION `.text`:CODE:NOROOT(2)
        DATA
DataTable:
        DC32     tb_shiftrows

        END
