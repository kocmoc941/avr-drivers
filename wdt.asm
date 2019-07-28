#ifndef __WDT__ASM
#define __WDT__ASM

.equ WDT_OC_16K =   $0
.equ WDT_OC_32K =   $1
.equ WDT_OC_64K =   $2
.equ WDT_OC_128K =  $3
.equ WDT_OC_256K =  $4
.equ WDT_OC_512K =  $5
.equ WDT_OC_1024K = $6
.equ WDT_OC_2048K = $7

.macro WDT_ENABLE
    ldi r16, (1<<WDE)
    out WDTCR, r16
.endm

.macro WDT_DISABLE
    in r16, WDTCR
    sbr r16, (1<<WDCE | 1<<WDE)
    out WDTCR, r16
    cbr r16, (1<<WDCE | 1<<WDE)
    out WDTCR, r16
.endm

.macro WDT_SET_TIM
    in r16, WDTCR
    sbr r16, (1<<WDCE | 1<<WDE)
    out WDTCR, r16
    ldi r16, @0
    out WDTCR, r16
.endm
#endif ; __WDT__ASM
