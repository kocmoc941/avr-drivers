.include "m8adef.inc"

.ifndef F_CPU
.equ F_CPU = 1000000 ; 1 MHz
.endif

.cseg
.org $0 rjmp reset
.org $013

reset:
        ldi r16, high(RAMEND)
        out sph, r16
        ldi r16, low(RAMEND)
        out spl, r16

gpio_init:
	ser r16
	out DDRC, r16
        clr r16
        sbr r16, (1<<PINB6)
        sbr r16, (1<<PINB7)
        out DDRB, r16
        cbi PORTB, PINB7 ; pulldown (ground)
main_loop:
	sbi PORTC, PINC0
        cbi PORTB, PINB6
	rcall delay_ms
        sbi PORTB, PINB6
	cbi PORTC, PINC0
	rcall delay_ms
	rjmp main_loop

delay_ms:
        .equ loop_time = 6
        .equ d_time = (F_CPU / loop_time)
        ldi XL, ((d_time & $FF) >> 0) + 1
        ldi XH, ((d_time & $FF00) >> 8) + 1
        ldi YL, ((d_time & $FF0000) >> 16) + 1
        ldi YH, ((d_time & $FF000000) >> 24) + 1
        delay_1_sec_loop:
                dec XL
                brne delay_1_sec_loop
                dec XH
                brne delay_1_sec_loop
                dec YL
                brne delay_1_sec_loop
                dec YH
                brne delay_1_sec_loop
                ret
