.nolist

;traces
#define PRINT_RAW
#undef PRINT_RAW

.equ F_CPU = 8000000
.equ BAUD = 38400

.eseg
    test: .byte 124
.dseg
    .org 1010
    var: .byte 3
    error_status: .byte 1
.cseg
    ;interrupt vectors
    .org 0x00 rjmp reset
    .org 0x0B rjmp usart_rx_int
    .org 0x0C rjmp usart_datae_int
    .org 0x0D rjmp usart_tx_int

.org 0x13 
.include "USART.s"
.include "utils.s"

.list
msg_data: .db "data:", $0
msg_error: .db "error:", $0, $0
msg_address: .db "big-endian:", $0

reset:
    ldi r16, low(RAMEND)
    out SPL, r16
    ldi r16, high(RAMEND)
    out SPH, r16

    ldi r17, high(F_CPU/(BAUD*16) - 1)
    ldi r16, low (F_CPU/(BAUD*16) - 1)
    rcall usart_init

    ; save var
    ldi ZL, low(var)
    ldi ZH, high(var)
    ldi r16, $39
    st Z+, r16
    inc r16
    st Z+, r16
    ldi r16, 255
    st Z+, r16

main:
    ldi r16, 200
    rcall delay_ms
    ldi ZL, low(msg_data * 2)
    ldi ZH, high(msg_data * 2)
    rcall print_data

    ldi ZL, low(msg_address * 2)
    ldi ZH, high(msg_address * 2)
    rcall print_data

    ldi r17, 3 ; size of var
    ldi ZL, low(var)
    ldi ZH, high(var)
    rcall print_byte

    rcall print_eol

rjmp main

delay_ms:
    ldi r20, 5
    ldi r21, 15
    ldi r22, 242 ; 100 ms
    _delay_ms:
        dec r22
        brne _delay_ms
        dec r21
        brne _delay_ms
        dec r20
        brne _delay_ms
ret

usart_rx_int:
reti

usart_datae_int:
reti

usart_tx_int:
reti

