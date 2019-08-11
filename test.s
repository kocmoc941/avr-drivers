.include "startup.asm"
.include "ext_int.asm"
.include "spi.asm"
.include "wdt.asm"
.include "usart.asm"
.include "timer.asm"

.cseg

main:
    ldi r16, high(RAMEND)
    out sph, r16
    ldi r16, low(RAMEND)
    out spl, r16

m_init_vtor VEC_TIM0_OVF, TIM0_OVF
m_init_vtor VEC_TIM1_OVF, $FF
m_init_vtor VEC_TIM2_OVF, TIM2_OVF
m_init_vtor VEC_TIM2_COMP, TIM2_COMP
m_init_vtor VEC_SPI_STC, SPI_STC
m_init_vtor VEC_INT0, INT0__
m_init_vtor VEC_INT1, INT1_
m_init_vtor VEC_USART_RXC, 	USART_RXC
m_init_vtor VEC_USART_UDRE,	USART_UDRE
m_init_vtor VEC_USART_TXC, 	USART_TXC

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

TIMER2_SET_CLK TIMER2_PRES_8
TIMER2_SET_COM TIMER2_COM_OC2_CLR_UP_SET_ON_DWN
TIMER2_SET_WGM TIMER2_WGM_PWM

TIMER2_SET_OCR2 $7F
TIMER2_ENABLE




TIMER0_SET_CLK TIMER0_PRES_256
;TIMER0_ENABLE

sbi DDRB, PORTB3
sbi PORTB, PORTB3

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

TIM0_OVF: 
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

