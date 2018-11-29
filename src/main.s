.nolist

;traces
#define PRINT_RAW
#undef PRINT_RAW

.equ F_CPU = 8000000
.equ BAUD = 38400

.eseg
    test: .byte 124
.dseg
    var: .byte 3
    error_status: .byte 1
    usart_data: .byte 128
    usart_ptr: .byte 1
.cseg
    ;interrupt vectors
    .org 0x00 rjmp reset
    .org 0x0B rjmp usart_rx_int
    .org 0x0C rjmp usart_datae_int
    .org 0x0D rjmp usart_tx_int

.org 0x13 
.include "USART.s"
.include "utils.s"
.include "defines.inc"

.list
msg_data: .db "data:", $0
msg_error: .db "error:", $0, $0
msg_address: .db "big-endian:", $0
msg_init: .db "initialize...", $0
msg_before: .db "first:", 0, 0
msg_after: .db "second:", 0
msg_wdt_reset: .db "watchdog reset", 0, 0


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

    ldi ZL, low(usart_ptr)
    ldi ZH, high(usart_ptr)
    clr r16
    st Z, r16

in r16, MCUCSR
cpi r16, 1<<WDRF
brne _init
PRINTS msg_wdt_reset
rjmp _def
    _init:
    PRINTS msg_init
    _def:
    PRINTEOL

    ;START_WDT 4

    ldi r16, usart_data
    ldi ZL, low(usart_ptr)
    ldi ZH, low(usart_ptr)
    st Z, r16

_main:
;wdr
    DELAY $18630B
    PRINTS msg_data

    PRINTS msg_address

    PRINTV var, 3

    PRINTEOL

    EEPROM_R 0

    cpi r20, 8
        brne _n1
        PRINTB '1'
        rjmp def
    _n1:
        mov r16, r20
        rcall to_str_hex
        PRINTR r20
        PRINTR r21
        EEPROM_W 0, 8
    def:
    PRINTEOL
rjmp _main

usart_rx_int:
    in r17, UDR
    clr ZH
    ldi ZL, usart_ptr
    ld r16, Z

    cpi r16, 128
    brcc _norm
        clr r16
        st Z, r16
    _norm:

    ldi r18, usart_data
    add r18, r16
    mov ZL, r18
    st Z+, r17
    ldi r16, 0
    st Z, r16

    ldi ZL, usart_ptr
    inc r16
    st Z, r16

    mov r16, r17

reti

usart_datae_int:
reti

usart_tx_int:
reti

