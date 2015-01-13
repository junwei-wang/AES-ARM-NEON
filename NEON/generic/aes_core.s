        #define SHT_PROGBITS 0x1
        
        EXTERN rand_uint8x16

        PUBLIC fmult
        PUBLIC fsqur
        PUBLIC fpow4
        PUBLIC sec_fpow16
        PUBLIC at_sr_mc_ark
        PUBLIC at_sr_mc_ark0
        PUBLIC affine_trans
        PUBLIC shiftrows

        
        SECTION `.bss`:DATA:REORDER:NOROOT(3)
tb_shiftrows:
        DATA
        DC32 0x03020100, 0x04070605, 0x09080B0A, 0x0e0d0c0f
        
////////////////////////////////////////////////////////////////////////////////
        SECTION `.text`:CODE:NOROOT(2)
        THUMB
;;      field multiplication (Barrett's method)
;;      uint8x16_t fmult(uint8x16_t a, uint8x16_t b)
fmult:
;;      1. u(x) = a(x)*b(x), deg(u) <= 14
        VMULL.P8  Q2,D1,D3                      ;; Q2: u(x) high
        VMULL.P8  Q1,D0,D2                      ;; Q1: u(x) low       
;;      2. t(x) = u(x)/(x^8), deg(t) <= 6
        VMOVN.I16 D0,Q1                         ;; Q0: u(x)
        VMOVN.I16 D1,Q2
        VSHRN.U16 D2,Q1,#+8                     ;; Q1: t(x) = u(x) >> 8
        VSHRN.U16 D3,Q2,#+8
;;      3. s(x) = t(x)*r(x), deg(r) = 6  ->  deg(s) <= 12 
;;      4. q(x) = s(x)/(x^6), deg(q) <= 6
        VMOV.U8   D7,#+70                       ;; D7: rx = 0x46 = +70
        VMULL.P8  Q2,D2,D7                      ;; Q2: s(x) low
        VSHRN.U16 D2,Q2,#+6                     ;; Q1(D2): q(x) = s(x) >> 6;
        VMULL.P8  Q2,D3,D7                      ;; Q3: s(x) high       
        VSHRN.U16 D3,Q2,#+6                     ;; Q1(D3): q(x) = s(x) >> 6;
;;      5. v(x) = q(x)*n(x), deg(n) = 6
        VMOV.U8   Q2,#+27                       ;; Q2: nx = 0x[1]1B = +27
        VMUL.P8   Q1,Q2,Q1
;;      6. z(x) = u(x)+v(x)
        VEOR     Q0,Q1,Q0
        BX       LR                             ;; return

////////////////////////////////////////////////////////////////////////////////
        SECTION `.text`:CODE:NOROOT(2)
        THUMB
fsqur:
        VMULL.P8  Q2,D1,D1
        VMULL.P8  Q1,D0,D0 
        VMOVN.I16 D0,Q1
        VMOVN.I16 D1,Q2
        VSHRN.U16 D2,Q1,#+8 
        VSHRN.U16 D3,Q2,#+8
        VMOV.U8   D7,#+70
        VMULL.P8  Q2,D2,D7
        VSHRN.U16 D2,Q2,#+6
        VMULL.P8  Q2,D3,D7 
        VSHRN.U16 D3,Q2,#+6
        VMOV.U8   Q2,#+27
        VMUL.P8   Q1,Q2,Q1
        VEOR      Q0,Q1,Q0
        BX        LR
        
////////////////////////////////////////////////////////////////////////////////
        SECTION `.text`:CODE:NOROOT(2)
        THUMB
fpow4:
        PUSH     {R7,LR}
        BL       fsqur
        BL       fsqur
        POP      {R0,PC}

////////////////////////////////////////////////////////////////////////////////
        SECTION `.text`:CODE:NOROOT(1)
        THUMB
;;      void sec_pow16_shares(uint8x16_t a[], int n)
sec_fpow16:
        PUSH     {R4-R6,LR}
        MOVS     R4,R0
        MOVS     R5,R1
        MOVS     R6,#+0
        B.N      ??sec_pow16_shares_0
??sec_pow16_shares_1:
        ADDS     R0,R4,R6, LSL #+4
        VLDM     R0,{D0-D1}
        BL       fsqur
        BL       fsqur
        BL       fsqur
        BL       fsqur
        ADDS     R0,R4,R6, LSL #+4
        VSTM     R0,{D0-D1}
        ADDS     R6,R6,#+1
??sec_pow16_shares_0:
        CMP      R6,R5
        BLT.N    ??sec_pow16_shares_1
        POP      {R4-R6,PC}             ;; return

///////////////////////////////////////////////////////////////////////////////
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

///////////////////////////////////////////////////////////////////////////////
        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//      uint8x16_t at_sr_mc_ark(uint8x16_t x, uint8x16_t rk)
at_sr_mc_ark:
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

///////////////////////////////////////////////////////////////////////////////
        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//      uint8x16_t at_sr_mc_ark(uint8x16_t x, uint8x16_t rk)
at_sr_mc_ark0:
//// affine_trans                                         -- Q0: x, Q1: rk
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
        VEOR     Q0,Q0,Q3       ;; x = x ^ a;             -- Q0: x, Q1: rk
//// shiftrows
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
        
        SECTION `.text`:CODE:NOROOT(2)
        THUMB
shiftrows:
        LDR.N    R0,DataTable
        VLDM     R0,{D2-D3}
        VTBL.8   D1,{D0-D1},D3 
        VTBL.8   D0,{D0},D2 
        BX       LR 

        SECTION `.text`:CODE:NOROOT(2)
        DATA
DataTable:
        DC32     tb_shiftrows


///////////////////////////////////////////////////////////////////////////////
        SECTION `.iar_vfe_header`:DATA:NOALLOC:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
        DC32 0

        SECTION __DLIB_PERTHREAD:DATA:REORDER:NOROOT(0)
        SECTION_TYPE SHT_PROGBITS, 0

        SECTION __DLIB_PERTHREAD_init:DATA:REORDER:NOROOT(0)
        SECTION_TYPE SHT_PROGBITS, 0

        END
