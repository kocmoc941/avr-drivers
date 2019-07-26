#ifndef __EXT_INT__ASM
#define __EXT_INT__ASM

.equ FRONT_OFF     = 0<<ISC01 | 0<<ISC00
.equ FRONT_ANY     = 0<<ISC01 | 1<<ISC00
.equ FRONT_FAILING = 1<<ISC01 | 0<<ISC00
.equ FRONT_RAISING = 1<<ISC01 | 1<<ISC00

.macro EXT_SET_FRONT
    push r16
    in r16, MCUCR
    ori r16, (@0)
    out MCUCR, r16
    pop r16
.endm

.macro EXT_ENABLE
    push r16
    in r16, MCUCR
    ori r16, (1<<@0)
    out GICR, r16
    pop r16
.endm

.macro EXT_DISABLE
    push r16
    in r16, MCUCR
    cbr r16, (@0)
    out GICR, r16
    pop r16
.endm

#endif ;__EXT_INT__ASM
