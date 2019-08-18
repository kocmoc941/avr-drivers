.include "startup.asm"
.include "wdt.asm"
.include "usart.asm"
.include "adc.asm"

.dseg
adc_data: .byte 2

.cseg
adc_str: .db "TRACE__WARNING: successfully", '\r', 0

main:
    ldi r16, high(RAMEND)
    out sph, r16
    ldi r16, low(RAMEND)
    out spl, r16

m_init_vtor VEC_USART_RXC, 	USART_RXC
m_init_vtor VEC_USART_UDRE,	USART_UDRE
;m_init_vtor VEC_USART_TXC, 	USART_TXC
m_init_vtor VEC_ADC, ADC_COMPLETE

;WDT_SET_TIM WDT_OC_16K
;WDT_ENABLE

USART_SET_BAUD_RATE 9600
USART_ENABLE

sbi DDRB, PORTB0

init_debug
sei

;sbi UCSRB, TXEN
;sbi UCSRB, UDRIE

;ADC_VOLTAGE_SELECT ADC_VOLTAGE_AVCC_EXT_CAP_AT_AREF
;ADC_SELECT_CHANNEL ADC0
;ADC_SET_CLK ADC_PRES_2
;ADC_ENABLE ADC_LEFT_ADJ_ENABLE
;ADC_START_CONV ADC_LEFT_ADJ_ENABLE

;ADC_FREE_RUNNING_SELECT ADC_LEFT_ADJ_DISABLE

cbi DDRC, PORTC0

.def adc_success = r21
.def adc1_data = r24
.def adc2_data = r25

USART_SEND_STR adc_str
main_loop:

rcall delay_
;ADC_FREE_RUNNING_SELECT ADC_LEFT_ADJ_DISABLE
rcall task_usart_handler
;clr adc_success
;ADC_FREE_RUNNING_SELECT ADC_LEFT_ADJ_ENABLE

rjmp main_loop

delay_:
    push ZL
    push ZH
    ldi ZL, $1F
    ldi ZH, $F
    delay__s:
    dec ZL
    brne delay__s
    dec ZH
    brne delay__s
    pop ZH
    pop ZL
    ret

ADC_COMPLETE:
;for_debug
reti

USART_RXC:
reti

USART_UDRE:
reti

USART_TXC:
;for_debug
reti

