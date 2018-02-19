
.cseg
.org $0 rjmp reset

.org $13
.include "spi.s"
.include "usart.s"

reset:
    rcall spi_init
.equ BAUD = 1200
.equ F_CPU = 8000000
.equ SPEED = (F_CPU/(BAUD*16)-1)
    ldi r17, high(SPEED)
    ldi r16, low(SPEED)
    rcall usart_init
    ldi r16, 0
    rcall usart_send
    main:
    ldi r16, $A
    rcall spi_send
    rcall usart_send
    rjmp main
