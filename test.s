.include "startup.asm"
.include "wdt.asm"
.include "usart.asm"
.include "adc.asm"

.cseg

adc_str: .db "ADC:"
adc_data: .dw 0x3132
.db '\r','\n'
.equ adc_str_len = (pc - adc_str) * 2

main:
    ldi r16, high(RAMEND)
    out sph, r16
    ldi r16, low(RAMEND)
    out spl, r16

m_init_vtor VEC_USART_RXC, 	USART_RXC
m_init_vtor VEC_USART_UDRE,	USART_UDRE
m_init_vtor VEC_USART_TXC, 	USART_TXC
m_init_vtor VEC_ADC, ADC_COMPLETE

;WDT_SET_TIM WDT_OC_16K
;WDT_ENABLE

USART_SET_BAUD_RATE 9600
USART_ENABLE

sbi DDRB, PORTB0

init_debug
sei

sbi UCSRB, TXEN
;sbi UCSRB, UDRIE

ADC_VOLTAGE_SELECT ADC_VOLTAGE_AVCC_EXT_CAP_AT_AREF
ADC_SELECT_CHANNEL ADC0
ADC_SET_CLK ADC_PRES_2
ADC_ENABLE ADC_LEFT_ADJ_ENABLE
ADC_START_CONV ADC_LEFT_ADJ_ENABLE

ADC_FREE_RUNNING_SELECT ADC_LEFT_ADJ_ENABLE

cbi DDRC, PORTC0

.def usart_busy = r20
.def adc_success = r21
.def adc1_data = r24
.def adc2_data = r25

clr r17
clr usart_busy
main_loop:
rcall delay_
rcall delay_
tst adc_success
breq main_loop

ADC_FREE_RUNNING_SELECT ADC_LEFT_ADJ_DISABLE
tst usart_busy
brne main_loop

ldi usart_busy, 1
ldi ZH, high(adc_str * 2)
ldi ZL, low(adc_str * 2)
add ZL, r17
lpm r16, Z
out UDR, r16
inc r17
cpi r17, adc_str_len
brne main_loop
clr r17
clr adc_success
ADC_FREE_RUNNING_SELECT ADC_LEFT_ADJ_ENABLE
rjmp main_loop

delay_:
    push ZL
    push ZH
    ldi ZL, $FF
    ldi ZH, $FF
    delay__s:
    dec ZL
    brne delay__s
    dec ZH
    brne delay__s
    pop ZH
    pop ZL
    ret

ADC_COMPLETE:
for_debug
;in adc1_data, ADCL
;in adc2_data, ADCH
ldi adc_success, 1
reti

USART_RXC:
reti

USART_UDRE:
reti

USART_TXC:
for_debug
clr usart_busy
reti

