
.cseg
.org $0 rjmp reset

.org $13
.include "spi.s"
.include "usart.s"
.include "I2C_master.s"

reset:
.equ BAUD = 38400
.equ F_CPU = 8000000
.equ SPEED = (F_CPU/(BAUD*16)-1)
    ldi r17, high(SPEED)
    ldi r16, low(SPEED)
    rcall usart_init
    ldi r16, 0
    rcall usart_send

    sbi DDRB, DDB1
    sbi PORTB, PORTB1
    rcall spi_init
    ldi r17, (1<<SPE)|(1<<MSTR)|(1<<SPR0)|(1<<SPR1)
    out SPCR, r17

    sbi DDRB, SS
    cbi PORTB, SS

    rcall i2c_init
    main:
    ldi r16, $A
    rcall spi_send
    rcall usart_send
    rcall i2c_start
    ldi r16, 0b01100000
    rcall i2c_send_byte
    ldi r16, $0F
    rcall i2c_send_byte
    rcall i2c_stop
    clr r16
    rcall spi_receive
    tst r16
    breq main
    rcall usart_send
    rjmp main
