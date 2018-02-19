.cseg
.org $0 rjmp reset
.org $13
.include "USART.s"
reset:
    clr r16
    out DDRC, r16
    sbi DDRC, PINC4
    sbi DDRC, PINC5
    ser r16
    out DDRB, r16
    clr r16
    sbi DDRD, PIND7
    sbi DDRD, PIND2
.equ F_CPU = 8000000
.equ BAUD = 1200
    ldi r17, high(F_CPU/(BAUD*16) - 1)
    ldi r16, low (F_CPU/(BAUD*16) - 1)
    clr ZH
    ldi ZL, usart_init
    icall
    clr r16
    out PORTC, r16
    cbi PORTD, PIND2
        cbi PORTC, PINC4
        cbi PORTC, PINC5
        cbi PORTD, PIND2
    main:
        rcall usart_receive
        cpi r16, $4
        brne next4
            sbi PORTC, PINC5
            rjmp next_break
        next4: cpi r16, $4
        brne default
            sbi PORTC, PINC4
            rjmp next_break
        default:
            sbi PORTD, PIND2
        next_break:
        rjmp main
