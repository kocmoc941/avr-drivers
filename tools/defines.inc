#ifndef _DEFINES_INC_
#define _DEFINES_INC_

.include "USART.s"

; @0 - variable
.macro PRINTD
    ldi zl, low(@0 * 2)
    ldi zh, high(@0 * 2)
    rcall print_data
.endmacro

; @0 - variable
; @1 - size of variable
.macro PRINTV
    ldi r17, @1 ; size of var
    ldi ZL, low(@0)
    ldi ZH, high(@0)
    rcall print_byte
.endmacro

; @0 - wdt prescaler
.macro START_WDT
	in r16, WDTCR
	ori r16, (1<<WDCE) | (1<<WDE)
	out WDTCR, r16

	andi r16, ~(1<<WDCE)
	ori r16, (@0)
	out WDTCR, r16
.endmacro

.macro STOP_WDT
	in r16, WDTCR
	ori r16, (1<<WDCE) | (1<<WDE)
	out WDTCR, r16

	andi r16, ~(1<<WDCE | 1<<WDE)
	out WDTCR, r16
.endmacro

; @0 - first nested cycle
; @1 - middle nested cycle
; @2 - external cycle
.macro DELAY
    ldi r20, @0
    ldi r21, @1
    ldi r22, @2
    _delay_ms:
        dec r20
        brne _delay_ms
        dec r21
        brne _delay_ms
        dec r22
        brne _delay_ms
.endmacro

#endif ;_DEFINES_INC_
