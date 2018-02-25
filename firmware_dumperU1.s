
.equ F_CPU = 8000000
.equ BAUD = 9600

.dseg 
    sram_hello: .db "hello world\0"

.cseg
.org $0 rjmp reset
.org $2A
    .include "m16def.inc"

reset:
    ;ldi r16, high(RAMEND)
    ;out SPH, r16
    ;ldi r16, low(RAMEND)
    ;out SPH, r16
    ldi r17, high(F_CPU/(BAUD * 16) - 1)
    ldi r16, low(F_CPU/(BAUD * 16) - 1)
    rcall usart_init
    rcall spi_init

    clr r16
    dec r16
    main:
        ;rcall spi_receive
        rcall usart_send
        rcall usart_receive
        ;inc r16
        ;rcall spi_send
        ;rcall delay
        rjmp main
delay:
    push r24
    push r25
    ldi r25, $FF
    ldi r24, $FF
    delay_loop_:
    dec r25
    brne delay_loop_
    dec r24
    brne delay_loop_
    pop r25
    pop r24
    ret

hello_str: .db "hello", 0

spi_init:
    sbi DDRB, DDB6
    sbi SPCR, SPE
    ret

spi_send:
    out SPDR, r16
    wait_spi_send:
    sbis SPSR, SPIF
    rjmp wait_spi_send
    ret

spi_receive:
    sbis SPSR, SPIF
    rjmp spi_receive
    in r16, SPDR
    ret

usart_init:
    out UBRRH, r17
    out UBRRL, r16
    ldi r16, (1<<RXEN)|(1<<TXEN)
    out UCSRB, r16
    ldi r16, (1<<URSEL)|(1<<USBS)|(3<<UCSZ0)
    out UCSRC, r16
    ret

usart_send:
    sbis UCSRA, UDRE
    rjmp usart_send
    out UDR, r16
    ret

usart_receive:
    sbis UCSRA, RXC
    rjmp usart_send
    in r16, UDR
    ret
