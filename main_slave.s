.nolist

.eseg
    test: .db 1,2,3,0
.dseg
    buffer: .byte $50
.cseg
    ;interrupt vectors
    .org 0x00 rjmp reset
    .org 0x11 rjmp i2c

.org 0x13 
.include "USART.s"
.include "SPI.s"
.list
.include "I2C_slave.s"
error_str: .db "data:", $0

reset:
.equ F_CPU = 8000000
.equ BAUD = 38400
    ldi r17, high(F_CPU/(BAUD*16) - 1)
    ldi r16, low (F_CPU/(BAUD*16) - 1)
    rcall usart_init

    ldi r16, 0b01100000
    rcall spi_init_sl
    rcall i2c_init_sl
    ldi r16, (1<<SREG_I)
    sts SREG+$20, r16
    main:
        rcall spi_receive
        rcall usart_send
	inc r16
        rcall spi_send
        rcall usart_send
    rjmp main


i2c:
	cli
	ldi r16, TWSR
	andi r16, $F8
	rcall usart_send
	reti

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
