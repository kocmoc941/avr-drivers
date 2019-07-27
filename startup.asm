.ifndef __STARTUP__ASM
.equ __STARTUP__ASM = 1

.equ F_CPU = 8000000 ; 8 MHz

; enum devices
.equ m8a = 1
.equ m16a = 2

.equ device = m8a

; It's startup file (for m8 device)
.message "Compiling Atmega8A device"

.macro init_debug
	ldi r16, $1
	ldi ZH, high(DEBUG)
	ldi ZL, low(DEBUG)
	st Z+, r16
	st Z, r16
.endm

.macro for_debug
	ldi ZH, high(DEBUG)
	ldi ZL, low(DEBUG)
	ld r16, Z+
	ld r17, Z
	eor r16, r17
	st -Z, r16
	out PORTB, r16
	;ldi r16, $20
	;_delay_:
	;dec r16
	;brne _delay_
.endm

.macro __GO_VTOR__ ; one parameter is number of VTOR
	ldi YL, LOW(VTOR)
	ldi YH, HIGH(VTOR)
	ldd ZL, Y+@0*2
	ldd ZH, Y+@0*2+1
	cpi ZL, $FF
	brne jump_to_usr_int
	cpi ZH, $FF
	brne jump_to_usr_int
	reti

	jump_to_usr_int:
	ijmp

.endm

/*	Parms:  1) VTOR num;
		2) value;
*/
.macro m_init_vtor
	ldi r16, low(@1)
	ldi r17, high(@1)
	ldi ZL, LOW(VTOR)
	ldi ZH, HIGH(VTOR)
	std Z+@0*2, r16
	std Z+@0*2 + 1, r17
.endm

.if device == m8a
	.include "m8adef.inc"

	.equ VEC_RESET	 	= $00
	.equ VEC_INT0 		= $01
	.equ VEC_INT1 		= $02
	.equ VEC_TIM2_COMP 	= $03
	.equ VEC_TIM2_OVF 	= $04
	.equ VEC_TIM1_CAPT 	= $05
	.equ VEC_TIM1_COMPA	= $06
	.equ VEC_TIM1_COMPB	= $07
	.equ VEC_TIM1_OVF 	= $08
	.equ VEC_TIM0_OVF 	= $09
	.equ VEC_SPI_STC 	= $0A
	.equ VEC_USART_RXC 	= $0B
	.equ VEC_USART_UDRE	= $0C
	.equ VEC_USART_TXC 	= $0D
	.equ VEC_ADC 		= $0E
	.equ VEC_EE_RDY 	= $0F
	.equ VEC_ANA_COMP 	= $10
	.equ VEC_TWI 		= $11
	.equ VEC_SPM_RDY 	= $12

	.dseg
		VTOR: .byte $12 * $2
		DEBUG: .byte $2
	.cseg
		.org $00 rjmp __RESET__
		.org $01 rjmp __INT0__
		.org $02 rjmp __INT1__
		.org $03 rjmp __TIM2_COMP__
		.org $04 rjmp __TIM2_OVF__
		.org $05 rjmp __TIM1_CAPT__
		.org $06 rjmp __TIM1_COMPA__
		.org $07 rjmp __TIM1_COMPB__
		.org $08 rjmp __TIM1_OVF__
		.org $09 rjmp __TIM0_OVF__
		.org $0A rjmp __SPI_STC__
		.org $0B rjmp __USART_RXC__
		.org $0C rjmp __USART_UDRE__
		.org $0D rjmp __USART_TXC__
		.org $0E rjmp __ADC__
		.org $0F rjmp __EE_RDY__
		.org $10 rjmp __ANA_COMP__
		.org $11 rjmp __TWI__
		.org $12 rjmp __SPM_RDY__

		__RESET__:
			rjmp main
		__INT0__:
			__GO_VTOR__ $VEC_INT0
		__INT1__:
			__GO_VTOR__ $VEC_INT1
		__TIM2_COMP__:
			__GO_VTOR__ $VEC_TIM2_COMP
		__TIM2_OVF__:
			__GO_VTOR__ $VEC_TIM2_OVF
		__TIM1_CAPT__:
			__GO_VTOR__ $VEC_TIM1_CAPT
		__TIM1_COMPA__:
			__GO_VTOR__ $VEC_TIM1_COMPA
		__TIM1_COMPB__:
			__GO_VTOR__ $VEC_TIM1_COMPB
		__TIM1_OVF__:
			__GO_VTOR__ $VEC_TIM1_OVF
		__TIM0_OVF__:
			__GO_VTOR__ $VEC_TIM0_OVF
		__SPI_STC__:
			__GO_VTOR__ $VEC_SPI_STC
		__USART_RXC__:
			__GO_VTOR__ $VEC_USART_RXC
		__USART_UDRE__:
			__GO_VTOR__ $VEC_USART_UDRE
		__USART_TXC__:
			__GO_VTOR__ $VEC_USART_TXC
		__ADC__:
			__GO_VTOR__ $VEC_ADC
		__EE_RDY__:
			__GO_VTOR__ $VEC_EE_RDY
		__ANA_COMP__:
			__GO_VTOR__ $VEC_ANA_COMP
		__TWI__:
			__GO_VTOR__ $VEC_TWI
		__SPM_RDY__:
			__GO_VTOR__ $VEC_SPM_RDY

.endif ; m8a
.else
.warning "File:" __FILE__" already included"
.endif
