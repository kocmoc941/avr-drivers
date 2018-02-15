.include "m8def.inc"

.cseg
    ;interrupt vectors
    .org 0x00 rjmp reset
    .org 0x01 rjmp int0_int
    .org 0x02 rjmp int1_int
    .org 0x03 rjmp timer2_comp
    .org 0x04 rjmp timer2_ovf
    .org 0x05 rjmp timer1_capt
    .org 0x06 rjmp timer1_compa
    .org 0x07 rjmp timer1_compb
    .org 0x08 rjmp timer1_ovf
    .org 0x09 rjmp timer0_ovf
    .org 0x0A rjmp spi_stc_complete
    .org 0x0B rjmp usart_rxc_complete
    .org 0x0C rjmp usart_udre_empty
    .org 0x0D rjmp usart_tx_complete
    .org 0x0E rjmp adc_conversion_complete
    .org 0x0F rjmp eeprom_ready
    .org 0x10 rjmp analog_comparator
    .org 0x11 rjmp i2c
    .org 0x12 rjmp spm_ready

.org 0x13 

int0_int:
int1_int:
timer2_comp:
timer2_ovf:
timer1_capt:
timer1_compa:
timer1_compb:
timer1_ovf:
timer0_ovf:
spi_stc_complete:
usart_rxc_complete:
usart_udre_empty:
usart_tx_complete:
adc_conversion_complete:
eeprom_ready:
analog_comparator:
i2c:
spm_ready:


reset:
    ldi r16, low(RAMEND)
    out spl, r16
    ldi r16, high(RAMEND)
    out sph, r16

    ser r16
    out DDRC, r16
    main:
        sbi PORTC, PINC0
        ldi r16, 0xF0 
        next_loop1: dec r16
        brne next_loop1
        cbi PORTC, PINC0
        ldi r16, 0xF0
        next_loop2: dec r16
        brne next_loop2
    rjmp main
