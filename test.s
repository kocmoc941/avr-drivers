.include "startup.asm"
.include "ext_int.asm"
.include "spi.asm"
.include "wdt.asm"
.include "usart.asm"
.include "timer.asm"
.include "adc.asm"

.cseg

main:
    ldi r16, high(RAMEND)
    out sph, r16
    ldi r16, low(RAMEND)
    out spl, r16

m_init_vtor VEC_TIM0_OVF, TIM0_OVF
m_init_vtor VEC_TIM1_OVF, TIM1_OVF
m_init_vtor VEC_TIM1_CAPT, TIM1_CAPT
m_init_vtor VEC_TIM1_COMPA, TIM1_COMPA
m_init_vtor VEC_TIM1_COMPB, TIM1_COMPB
m_init_vtor VEC_TIM2_OVF, TIM2_OVF
m_init_vtor VEC_TIM2_COMP, TIM2_COMP
m_init_vtor VEC_SPI_STC, SPI_STC
m_init_vtor VEC_INT0, INT0__
m_init_vtor VEC_INT1, INT1_
m_init_vtor VEC_USART_RXC, 	USART_RXC
m_init_vtor VEC_USART_UDRE,	USART_UDRE
m_init_vtor VEC_USART_TXC, 	USART_TXC
m_init_vtor VEC_ADC, ADC_COMPLETE

;WDT_SET_TIM WDT_OC_16K
;WDT_ENABLE


;SPI_SET_MODE SPI_MSTR
;SPI_SET_CLK_RATE SPI_DIV_128
;SPI_ENABLE

USART_SET_BAUD_RATE 9600
USART_ENABLE

;ldi r16, (1<<CS01 | 0<<CS00)
;out TCCR0, r16
;ldi r16, (1<<TOIE0)
;out TIMSK, r16

;EXT_SET_FRONT FRONT_ANY_INT1
;EXT_ENABLE INT0
;
;EXT_ENABLE INT1

sbi DDRB, PORTB0

init_debug
sei

ldi r20, $0

sbi UCSRB, TXEN
;sbi UCSRB, UDRIE
ldi r23, 'A'
ldi r24, 'F'

;TIMER2_SET_CLK TIMER2_PRES_8
;TIMER2_SET_COM TIMER2_COM_OC2_CLR_UP_SET_ON_DWN
;TIMER2_SET_WGM TIMER2_WGM_PWM
;
;TIMER2_SET_OCR2 $7F
;TIMER2_ENABLE
;
;TIMER1_SET_CLK TIMER1_PRES_8
;TIMER1_SET_WGM TIMER1_WGM_PHASE_CORR_8
;TIMER1_SET_COM1A0 TIMER1_COM_OC1AB_SET_UP_CLR_ON_DWN
;TIMER1_SET_COM1B0 TIMER1_COM_OC1AB_SET_UP_CLR_ON_DWN
;TIMER1_SET_OCR1A 0x7F7F
;TIMER1_SET_OCR1B 0x7F7F
;TIMER1_ENABLE

;TIMER0_SET_CLK TIMER0_PRES_256
;TIMER0_ENABLE

ADC_VOLTAGE_SELECT ADC_VOLTAGE_INTERNAL_2_56_EXT_CAP_AT_AREF
ADC_SELECT_CHANNEL ADC0
ADC_SET_CLK ADC_PRES_2
ADC_ENABLE ADC_LEFT_ADJ_ENABLE
ADC_START_CONV ADC_LEFT_ADJ_ENABLE

ADC_FREE_RUNNING_SELECT ADC_LEFT_ADJ_DISABLE

cbi DDRC, PORTC0
ldi r17, 1
ldi r18, 1
main_loop:

rjmp main_loop

delay_:
    push ZL
    push ZH
    ldi ZL, $FF
    ldi ZH, $FF
    delay__:
    sbiw Z, $1
    brne delay__
    pop ZH
    pop ZL
    ret

ADC_COMPLETE:
for_debug
in YL, ADCL
in YH, ADCH
ADC_START_CONV ADC_LEFT_ADJ_ENABLE
reti

TIM0_OVF: 
for_debug
;out UDR, r23
reti

TIM1_OVF: 
for_debug
;out UDR, r23
reti

TIM1_CAPT: 
for_debug
;out UDR, r23
reti

TIM1_COMPA: 
for_debug
;out UDR, r23
reti

TIM1_COMPB: 
for_debug
;out UDR, r23
reti

TIM2_OVF: 
for_debug
;out UDR, r24
reti

TIM2_COMP: 
for_debug
;out UDR, r24
reti

INT0__:
;for_debug
reti

INT1_:
;for_debug
reti

SPI_STC:
;for_debug
clr r20
reti

USART_RXC:
;for_debug
clr r20
reti

USART_UDRE:
;for_debug

inc r23
clr r20
reti

USART_TXC:
;for_debug
clr r20
reti

