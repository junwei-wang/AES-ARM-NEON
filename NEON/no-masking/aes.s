        EXTERN at_sr_ark
        EXTERN at_sr_mc_ark
        EXTERN exp254

        PUBLIC aes

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//      uint8x16_t aes(uint8x16_t plain, uint8x16_t w[])
aes:
        PUSH     {R4,LR}
        MOVS     R4,R0
// round 0
        VLDM     R4,{D8-D15}
        VEOR     Q0,Q0,Q4       ;; x = veorq_u8(plain, w[0]);
// round 1
        BL       exp254         ;; x = exp254(x);
        VMOV     Q1,Q5
        BL       at_sr_mc_ark   ;;x = at_sr_mc_ark(x, w[1]);
// round 2
        BL       exp254         ;; x = exp254(x);
        VMOV     Q1,Q6
        BL       at_sr_mc_ark   ;; x = at_sr_mc_ark(x, w[2]);
// round 3
        BL       exp254         ;; x = exp254(x);
        VMOV     Q1,Q7
        BL       at_sr_mc_ark   ;; x = at_sr_mc_ark(x, w[3]);
// round 4
        BL       exp254         ;; x = exp254(x); 
        ADDS     R0,R4,#+64
        VLDM     R0,{D8-D15}
        VMOV     Q1,Q4
        BL       at_sr_mc_ark   ;; x = at_sr_mc_ark(x, w[4]);
// round 5
        BL       exp254         ;; x = exp254(x);
        VMOV     Q1,Q5
        BL       at_sr_mc_ark   ;; x = at_sr_mc_ark(x, w[5]);
// round 6
        BL       exp254         ;; x = exp254(x);
        VMOV     Q1,Q6
        BL       at_sr_mc_ark   ;; x = at_sr_mc_ark(x, w[6]);
// round 7
        BL       exp254         ;; x = exp254(x);
        VMOV     Q1,Q7
        BL       at_sr_mc_ark   ;; x = at_sr_mc_ark(x, w[7]);
// round 8
        BL       exp254         ;; x = exp254(x);
        ADDS     R0,R4,#+128
        VLDM     R0,{D8-D13}
        VMOV     Q1,Q4
        BL       at_sr_mc_ark   ;; x = at_sr_mc_ark(x, w[8]);
// round 9
        BL       exp254         ;; x = exp254(x);
        VMOV     Q1,Q5
        BL       at_sr_mc_ark   ;; x = at_sr_mc_ark(x, w[9]);
// round 10
        BL       exp254         ;; x = exp254(x); 
        VMOV     Q1,Q6
        BL       at_sr_ark
//
        POP      {R4,PC}        ;; return

        END