.nolist

.eseg
    test: .db 1,2,3,0
.dseg
    buffer: .byte $50
.cseg
    ;interrupt vectors
    .org 0x00 rjmp reset
    .org 0x0B rjmp usart_rx_int
    .org 0x0C rjmp usart_datae_int
    .org 0x0D rjmp usart_tx_int

.org 0x13 
.include "USART.s"
.list
error_str: .db "data:", $0

reset:
.equ F_CPU = 8000000
.equ BAUD = 38400
    ldi r17, high(F_CPU/(BAUD*16) - 1)
    ldi r16, low (F_CPU/(BAUD*16) - 1)
    rcall usart_init

clr x
main:
    ldi r16, xl
    inc xl
    rcall usart_send
rjmp main

usart_rx_int:
reti

usart_datae_int:
reti

usart_tx_int:
reti

