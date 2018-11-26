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

in r16, MCUCSR
cpi r16, 1<<WDRF
brne _init
PRINTD msg_wdt_reset
rjmp _def
    _init:
    PRINTD msg_init
    _def:
    rcall print_eol

    ;START_WDT 4

_main:
;wdr
    DELAY 11, 99, 24
    PRINTD msg_data

    PRINTD msg_address

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
    rcall print_eol
rjmp _main

usart_rx_int:
reti

usart_datae_int:
reti

usart_tx_int:
reti

