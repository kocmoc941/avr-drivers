
#if defined(ATmega8A)
	#message "already exist"
#endif
.include "startup.asm"
.include "ext_int.asm"

.cseg

main:
        ldi r16, high(RAMEND)
        out sph, r16
        ldi r16, low(RAMEND)
        out spl, r16

m_init_vtor VEC_TIM0_OVF, TIM0_OVF
m_init_vtor VEC_TIM1_OVF, $FF
m_init_vtor VEC_SPI_STC, $FF
m_init_vtor VEC_INT0, INT0__
m_init_vtor VEC_INT1, INT1_

;ldi r16, (1<<CS01 | 0<<CS00)
;out TCCR0, r16
;ldi r16, (1<<TOIE0)
;out TIMSK, r16
;ldi r16, $10
;out TCNT0, r16

EXT_SET_FRONT FRONT_ANY
EXT_ENABLE INT0

EXT_DISABLE INT1


sbi DDRB, PORTB0

;rjmp next_ramp
;.db "qwdqwdwqd",0
;next_ramp:

init_debug
sei

main_loop:
;for_debug
rjmp main_loop

	TIM0_OVF: 
	;for_debug
	reti

INT0__:
for_debug
reti

INT1_:
;for_debug
ldi r16, (1<<INT0)
out GICR, r16

in r16, MCUCR
ori r16, (1<<ISC00)
out MCUCR, r16
reti
