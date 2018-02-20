.nolist

.eseg
    test: .db 1,2,3,0
.dseg
    buffer: .byte $50
.cseg
    ;interrupt vectors
    .org 0x00 rjmp reset

.org 0x13 
.include "USART.s"
.include "SPI.s"
.list
error_str: .db "data:", $0

reset:
.equ F_CPU = 8000000
.equ BAUD = 1200
.equ EEPROM_ADDRESS = 0b0110000
    ldi r17, high(F_CPU/(BAUD*16) - 1)
    ldi r16, low (F_CPU/(BAUD*16) - 1)
    rcall usart_init

    rcall spi_init_sl
    main:
        rcall spi_receive
        rcall usart_send
        rcall spi_send
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
