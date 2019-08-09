#ifndef __SPI__ASM
#define __SPI__ASM

.equ SPI_DATA = SPDR

.equ SPI_MSB = $0
.equ SPI_LSB = $1

.equ SPI_SLV  = $0
.equ SPI_MSTR = $1

.equ SPI_CPOL_RISING  = $0
.equ SPI_CPOL_FALLING = $1

.equ SPI_CPHA_SAMPLE = $0
.equ SPI_CPHA_SETUP  = $1

.equ SPI_DIV_4   = (0<<SPR1 | 0<<SPR0)
.equ SPI_DIV_16  = (0<<SPR1 | 1<<SPR0)
.equ SPI_DIV_64  = (1<<SPR1 | 0<<SPR0)
.equ SPI_DIV_128 = (1<<SPR1 | 1<<SPR0)

.macro SPI_ENABLE
    sbi DDRB, PORTB3
    sbi DDRB, PORTB5
    cbi DDRB, PORTB4
    in r16, SPCR
    ori r16, (1<<SPIE | 1<<SPE)
    out SPCR, r16
.endm

/* Parms: 1) SPI_MSB or SPI_LSB
*/
.macro SPI_DATA_ORDER
    in r16, SPCR
    cbr r16, (1<<DORD)
    ori r16, (@0<<DORD)
    out SPCR,  r16
.endm

.macro SPI_SET_MODE
    in r16, SPCR
    cbr r16, (1<<MSTR)
    ori r16, (@0<<MSTR)
    out SPCR,  r16
.endm

.macro SPI_SET_CPOL_CPHA
    in r16, SPCR
    cbr r16, (1<<CPOL | 1<<CPHA)
    ori r16, (@0<<CPOL)
    ori r16, (@1<<CPHA)
    out SPCR,  r16
.endm

.macro SPI_SET_CLK_RATE
    in r16, SPCR
    cbr r16, (1<<SPR1 | 1<<SPR0)
    ori r16, (@0)
    out SPCR,  r16
.endm

.macro SPI_SET_DOUBLE_SPEED
    in r16, SPSR
    cbr r16, (1<<SPI2X)
    ori r16, (@0)
    out SPSR,  r16
.endm

.macro SPI_SEND_BYTE
    ldi r16, @0
    out SPDR, r16
.endm
#endif ;__SPI__ASM
