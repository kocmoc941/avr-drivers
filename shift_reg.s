.cseg .org $0 rjmp reset

.org $13
.include "m8def.inc"

    reset:
        ldi r16, high(RAMEND)
        out SPH, r16
        ldi r16, low(RAMEND)
        out SPL, r16

        ldi r16, $3F
        sts DDRC+$20, r16
        cbi DDRC, DDC5
        clr r16
        out PORTC, r16

        ; shift init
        sbi PORTC, PORTC3
        cbi PORTC, PORTC4
        cbi PORTC, PINC5

        ldi r16, $1
        ldi r17, $80
        main:
            rcall flash_led
            rol r16
            tst r16
            brne main

            mov r16, r17
            ;rjmp skip_backward
            back_loop:
                rcall flash_led
                ror r16
                tst r16
                brne back_loop
            skip_backward:
            ldi r16, $1
            ldi r17, $80
        rjmp main

flash_led:
    push r16
    push r17
    mov r17, r16
    clr r16
    next_bit:
        sbrc r17, PORTC0
        sbi PORTC, PORTC0
        sbrs r17, PORTC0
        cbi PORTC, PORTC0
        lsr r17
        rcall clk
        inc r16
        cpi r16, $8
        brne next_bit
        rcall latch
        rcall delay
        pop r17
        pop r16
        ret

delay:
    ldi XL, $1
    ldi XH, $AF
    loop_next:
        sbiw X, $1
        brne loop_next
        ret

clk:
    sbi PORTC, PORTC1
    cbi PORTC, PORTC1
    ret

latch:
    sbi PORTC, PORTC2
    cbi PORTC, PORTC2
    ret
