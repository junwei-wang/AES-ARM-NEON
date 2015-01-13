;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; affine transformation, shift rows, mixcloumns and addroundkey ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        PUBLIC at_sr_ark
        PUBLIC at_sr_mc_ark
        PUBLIC tbl_shiftrows

        SECTION `.bss`:DATA:REORDER:NOROOT(3)
tbl_shiftrows:                  ;; uint8x16_t tbl_shift_rows;
        DATA
        DC8 0, 1, 2, 3, 5, 6, 7, 4, 10, 11, 8, 9, 15, 12, 13, 14

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
at_sr_mc_ark:                   ;; uint8x16_t at_sr_mc_ark(uint8x16_t x, uint8x16_t rk)
//// affine_trans                                         -- Q0: x, Q1: rk
//      BL       affine_trans
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
//// shiftrows                                            -- Q0: x, Q1: rk   
        LDR.N    R0,??DataTable1        
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
//      uint8x16_t at_sr_ark(uint8x16_t x, uint8x16_t rk)
at_sr_ark:
//// affine_trans                                         -- Q0: x, Q1: rk
//      BL       affine_trans
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
//// shiftrows                                            -- Q0: x, Q1: rk   
        LDR.N    R0,??DataTable1        
        VLDM     R0,{D4-D5}                             ;;-- Q3: tbl_shiftrows
        VTBL.8   D1,{D0-D1},D5  ;; t.val[1] = vtbl2_u8(t, vget_high_u8(tbl_shiftrows));
        VTBL.8   D0,{D0},D4     ;; t.val[0] = vtbl2_u8(t, vget_low_u8(tbl_shiftrows));
//// addroundkey
        VEOR     Q0,Q0,Q1       ;; x = veorq_u8(x, rk);
//// return x;
        BX       LR             ;; return

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable1:
        DC32     tbl_shiftrows

        END
