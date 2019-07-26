#ifndef __EXT_INT__ASM
#define __EXT_INT__ASM

.equ FRONT_OFF_INT0     = 0<<ISC01 | 0<<ISC00
.equ FRONT_ANY_INT0     = 0<<ISC01 | 1<<ISC00
.equ FRONT_FAILING_INT0 = 1<<ISC01 | 0<<ISC00
.equ FRONT_RAISING_INT0 = 1<<ISC01 | 1<<ISC00
.equ FRONT_OFF_INT1     = 0<<ISC11 | 0<<ISC10
.equ FRONT_ANY_INT1     = 0<<ISC11 | 1<<ISC10
.equ FRONT_FAILING_INT1 = 1<<ISC11 | 0<<ISC10
.equ FRONT_RAISING_INT1 = 1<<ISC11 | 1<<ISC10

.macro EXT_SET_FRONT
    push r16
    in r16, MCUCR
    ori r16, (@0)
    out MCUCR, r16
    pop r16
.endm

.macro EXT_ENABLE
    push r16
    in r16, GICR
    ori r16, (1<<@0)
    out GICR, r16
    pop r16
.endm

.macro EXT_DISABLE
    push r16
    in r16, GICR
    cbr r16, (1<<@0)
    out GICR, r16
    pop r16
.endm

#endif ;__EXT_INT__ASM
