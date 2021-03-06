;******************************************************************************
;   MSP-FET430P430 Demo - OA1, Inverting PGA Mode
;
;   Description: Configure OA1 for Inverting PGA mode. In this mode, the
;   "+" terminal must be supplied with an offset, since the OA is a
;   single-supply opamp, and the input must be positive. If an offset is
;   not supplied, the opamp will try to drive its output negative, which
;   cannot be done. In this example, the offset is provided by DAC120
;   and is 1.5V. The "-" terminal is connected to the R ladder tap and
;   the OAFBRx bits select the gain. The input signal should be AC coupled.
;   ACLK = n/a, MCLK = SMCLK = default DCO
;
;                    MSP430FG439
;                 -------------------
;             /|\|                XIN|-
;              | |                   |
;              --|RST            XOUT|-
;                |                   |
;     "-" --||-->|P6.4/OA1I0         |
;                |                   |
;                |          P6.3/OA1O|-->  OA1 Output
;                |                   |     Gain is -7
;
;   M. Mitchell / M. Mitchell
;   Texas Instruments Inc.
;   May 2005
;   Built with Code Composer Essentials Version: 1.0
;******************************************************************************
 .cdecls C,LIST,  "msp430xG43x.h"

;------------------------------------------------------------------------------
            .text                  ; Program Start
;------------------------------------------------------------------------------
RESET       mov.w   #0A00h,SP               ; Initialize stack pointer
StopWDT     mov.w   #WDTPW+WDTHOLD,&WDTCTL  ; Stop WDT
                                            ;
REFOn       mov.w   #REFON+REF2_5V,&ADC12CTL0
                                            ; 2.5V reference for DAC12
DAC12_0     mov.w   #DAC12IR+DAC12AMP_2+DAC12ENC,&DAC12_0CTL
                                            ; 1x input range, enable DAC120,
                                            ; low speed/current
            mov.w   #099Ah,&DAC12_0DAT      ; Set DAC120 to output 1.5V
                                            ;

SetupOA     mov.b   #OAP_2+OAPM_1+OAADC1,&OA1CTL0
                                            ; "+" connected to DAC120,
                                            ; slow slew rate,
                                            ; output connected to A3
            mov.b   #OAFC_6+OAFBR_6+OARRIP,&OA1CTL1
                                            ; Inverting PGA mode, no r-to-r input
                                            ; amplifier gain is -7,
                                            ;						
Mainloop    bis.w   #LPM3,SR                ; Exit LPM3
            nop                             ; Required only for debug
                                            ;
;------------------------------------------------------------------------------
;           Interrupt Vectors
;------------------------------------------------------------------------------
            .sect   ".reset"                ; RESET Vector
            .short  RESET                   ;
            .end