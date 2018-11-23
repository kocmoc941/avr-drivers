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

.list
msg_data: .db "data:", $0
msg_error: .db "error:", $0, $0
msg_address: .db "big-endian:", $0

print_data:
    lpm r16, Z+
    rcall usart_send
    tst r16
    brne print_data

    ret

print_byte:
    ld r16, Z+
#ifndef PRINT_RAW
    rcall to_str_hex
    mov r16, r21
    rcall usart_send
    mov r16, r20
    ldi r20, $2
    mul r17, r20
#endif
    rcall usart_send
    dec r17
    tst r17
    brne print_byte

    ret

print_eol:
    ldi r16, $A
    rcall usart_send
    ldi r16, $D
    rcall usart_send

    ret

hex_data: .db '0', '1', '2', '3', '4', '5', '6', '7', '8', '9' \
                , 'A', 'B', 'C', 'D', 'E', 'F'

to_str_hex:
    push r17
    push ZL
    push ZH

    mov r20, r16
    andi r20, $0F
    mov r21, r16
    andi r21, $F0
    ldi r17, $4
    _4:
    lsr r21
    dec r17
    brne _4

    ;convert to hex
    ldi ZL, low(hex_data * 2)
    ldi ZH, high(hex_data * 2)
    add ZL, r20
    lpm r20, Z
    ldi ZL, low(hex_data * 2)
    ldi ZH, high(hex_data * 2)
    add ZL, r21
    lpm r21, Z

    pop ZH
    pop ZL
    pop r17

    ret

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

