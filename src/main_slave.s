.nolist

.eseg
    test: .db 1,2,3,0
.dseg
    ;buffer: .byte '1'
    buffer: .db "test",0
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
.equ BAUD = 4800
    ldi r30, low(RAMEND)
    out SPL, r30
    ldi r30, high(RAMEND)
    out SPH, r30

    ldi r17, high(F_CPU/(BAUD*16) - 1)
    ldi r16, low (F_CPU/(BAUD*16) - 1)
    rcall usart_init

ldi ZL, low(buffer)
ldi ZH, high(buffer)
ldi r20, 0
main:
    ldi r16, 200
    rcall delay_ms
    ;add ZL, r20
    ld r16, Z
    cpi r16, 0
    brne skip
    ldi ZL, low(buffer)
    clr r20
    ld r16, Z
    skip:
    inc r20
    ldi r16, '0'
    rcall usart_send
rjmp main

delay_ms:
    .equ operation = 1600
    ldi yl, high(operation)
    mul yl, r16
    mov yl, r0
    _delay_ms:
        dec yl
        ldi yh, low(operation)
        mul yh, r16
        mov yh, r0
        __delay_ms:
            dec yh
            brne __delay_ms
    cpi yl, $0
    brne _delay_ms
ret

usart_rx_int:
reti

usart_datae_int:
reti

usart_tx_int:
reti

