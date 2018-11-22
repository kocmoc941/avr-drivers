.nolist

.eseg
    test: .byte 124
.dseg
    .org 1011
    var: .byte 12
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


print_data:
	lpm r16, Z+
	rcall usart_send
	tst r16
	brne print_data

	ret

print_var:
	ld r16, z+
	rcall usart_send
	tst r16
	brne print_var

	ret

reset:
.equ F_CPU = 8000000
.equ BAUD = 38400
    ldi r30, low(RAMEND)
    out SPL, r30
    ldi r30, high(RAMEND)
    out SPH, r30

    ldi r17, high(F_CPU/(BAUD*16) - 1)
    ldi r16, low (F_CPU/(BAUD*16) - 1)
    rcall usart_init

	; save var
	ldi zl, low(var)
	ldi zh, high(var)
	ldi xl, 10
	ldi r17, '0'
	next_load:
		st z+, r17
		inc r17
		dec xl
		tst xl
		brne next_load
	; add eol and zero
	ldi r17, $0A
	st z+, r17
	ldi r17, $0D
	st z+, r17
	ldi r17, $0
	st z+, r17
sei

main:
    ldi r16, 200
    rcall delay_ms
	ldi ZL, low(error_str * 2)
	ldi ZH, high(error_str * 2)
sbi UCSRB, TXCIE
    rcall print_data
cbi UCSRB, TXCIE

	ldi ZL, low(var)
	ldi ZH, high(var)
	rcall print_var

rjmp main

delay_ms:
	.equ nst0 = 11
	.equ nst1 = 99
    ldi r20, nst0
    ldi r21, nst1
    ldi r22, 100 ; 100 ms
    _delay_ms:
	dec r20
	brne _delay_ms
	ldi r20, nst0
	    dec r21
            brne _delay_ms
	    ldi r21, nst1
		dec r22
		brne _delay_ms
ret

usart_rx_int:
reti

usart_datae_int:
reti

usart_tx_int:
	push r16
	ldi r16, '-'
	rcall usart_send
	pop r16
reti

