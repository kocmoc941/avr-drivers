.include "startup.asm"
.include "ext_int.asm"
.include "spi.asm"
.include "wdt.asm"
.include "usart.asm"

.cseg

main:
        ldi r16, high(RAMEND)
        out sph, r16
        ldi r16, low(RAMEND)
        out spl, r16

m_init_vtor VEC_TIM0_OVF, TIM0_OVF
m_init_vtor VEC_TIM1_OVF, $FF
m_init_vtor VEC_SPI_STC, SPI_STC
m_init_vtor VEC_INT0, INT0__
m_init_vtor VEC_INT1, INT1_

WDT_SET_TIM WDT_OC_2048K
WDT_ENABLE

SPI_SET_MODE SPI_MSTR
SPI_SET_CLK_RATE SPI_DIV_128
SPI_ENABLE

;USART_SET_BAUD_RATE 9600
;USART_ENABLE

;ldi r16, (1<<CS01 | 0<<CS00)
;out TCCR0, r16
;ldi r16, (1<<TOIE0)
;out TIMSK, r16
;ldi r16, $10
;out TCNT0, r16

;EXT_SET_FRONT FRONT_ANY_INT1
;EXT_ENABLE INT0
;
;EXT_ENABLE INT1

sbi DDRB, PORTB0

init_debug
sei

WDR




main_loop:
;WDR
SPI_SEND_BYTE '\10'
;for_debug
spi_wt:
    sbis SPSR, SPIF
    rjmp spi_wt
rjmp main_loop

    TIM0_OVF: 
    ;for_debug
    reti

INT0__:
for_debug
reti

INT1_:
for_debug
reti

SPI_STC:
for_debug
reti
