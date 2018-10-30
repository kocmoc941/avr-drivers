.list

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
.include "USART.s"
.include "I2c_master.s"
error_str: .db "data: ", $0

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

print:
    lpm r16, Z+
    rcall usart_send
    cpi r16, 0
    brne print
    ret
    
reset:
.equ F_CPU = 8000000
.equ BAUD = 1200
.equ EEPROM_ADDRESS = 0b0110000
    ldi r17, high(F_CPU/(BAUD*16) - 1)
    ldi r16, low (F_CPU/(BAUD*16) - 1)
    rcall usart_init
    ldi ZH, high(error_str*2)
    ldi ZL, low(error_str*2)
    rcall print

    clr r16
    rcall i2c_init
    main:
    ; write EEPROM
    rcall i2c_start
    ldi r16, EEPROM_ADDRESS
    lsl r16
    ori r16, 0
    rcall i2c_send_byte
    rcall i2c_get_status
    rcall usart_send
    rcall delay
    ldi r16, $11
    rcall i2c_send_byte
    rcall i2c_get_status
    rcall usart_send
    rcall delay
    ldi r16, $F0
    rcall i2c_send_byte
    rcall i2c_get_status
    rcall usart_send
    rcall i2c_stop
    rcall delay
    ldi r16, $4
    rcall usart_send
    
    rjmp main


    delay:
        ldi r16, $FF
        loop:
        ldi r17, $FF
        inner17:
                ldi r18, $6
                inner18:
                dec r18
                tst r18
                brne inner18
            dec r17
            tst r17
            brne inner17
        dec r16
        tst r16
        brne loop
        ret
