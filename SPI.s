.include "m8def.inc"

.equ SS = DDB2
.equ MOSI = DDB3
.equ MISO = DDB4
.equ SCK = DDB5
.equ DDR_SPI = PORTB

spi_wait:
    sbis SPSR, SPIF
    rjmp spi_wait
    ret
    
    ;master
spi_init:
    ldi r17, (1<<MOSI)|(1<<SCK)
    out DDR_SPI, r17
    
    ldi r17, (1<<SPE)|(1<<MSTR)|(1<<SPR0)
    out SPCR, r17
    ret

spi_send:
    out SPDR, r16
    rcall spi_wait
    ret

    ;slave
spi_init_sl:
    sbi DDR_SPI, MISO
    sbi SPCR, SPE
    ret

spi_receive:
    rcall spi_wait
    in r16, SPDR
    ret

