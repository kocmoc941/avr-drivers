.list
.org $00 rjmp reset
.org $01 rjmp int0_int
.org $11 rjmp i2c_int
.org $13
.include "I2C_slave.s"
.include "USART.s"

reset:
    ldi r16, 0b0110000
    lsl r16
    rcall i2c_init_sl

    .equ F_CPU = 8000000
    .equ BAUD = 1200
    ldi r17, high(F_CPU/(BAUD*16)-1)
    ldi r16, low(F_CPU/(BAUD*16)-1)
    rcall usart_init

    ldi r16, (ISC10<<0) ; rising
    out MCUCR, r16
    ldi r16, (1<<INT0) ; INT0
    out GICR, r16

    cbi DDRD, DDD2
    sbi PORTD, PORTD2 ; pull-up on

    sei
    main:
    rjmp main

int0_int: 
    cli
        ldi r16, 1
        rcall usart_send
    reti

i2c_int:
    cli
        ldi r16, TWSR
        andi r16, $F8
        rcall usart_send
    reti
