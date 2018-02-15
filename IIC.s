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

wait_sending:
    wait_:
    in r16, TWCR
    sbrs r16, TWINT
    rjmp wait_
    ret

ERROR:
    ret

i2c_send:
    ldi r16, (1<<TWINT)|(1<<TWSTA)|(1<<TWEN)
    out TWCR, r16
    rcall wait_sending

    in r16, TWSR
    andi r16, 0xF8
    cpi r16, 0x08 ;START
    brne ERROR

    ldi r16, 0x13; SLA_W
    out TWDR, r16
    ldi r16, (1<<TWINT)|(1<<TWEN)
    out TWCR, r16
    rcall wait_sending

    in r16, TWSR
    andi r16, 0xF8
    cpi r16, 0x18 ;MT_SLA_ACK
    brne ERROR

    ldi r16, 0x11; DATA
    out TWDR, r16
    ldi r16, (1<<TWINT)|(1<<TWEN)
    out TWCR, r16
    rcall wait_sending

    in r16, TWSR
    andi r16, 0xF8
    cpi r16, 0x28; MT_DATA_ACK
    brne ERROR

    ldi r16, (1<<TWINT)|(1<<TWEN)|(1<<TWSTO)
    out TWCR, r16
    ret

reset:
    ldi r16, low(RAMEND)
    out spl, r16
    ldi r16, high(RAMEND)
    out sph, r16

    ; i2c init
    clr r16
    out TWBR, r16
    ldi r16, (1<<TWPS0)|(1<<TWPS1)
    out TWSR, r16

    main:
        rcall i2c_send 
        ldi r16, 0xFF 
        next_loop1: dec r16
        brne next_loop1
        rcall i2c_send
        ldi r16, 0xFF
        next_loop2: dec r16
        brne next_loop2
    rjmp main
