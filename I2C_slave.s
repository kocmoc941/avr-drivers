.include "m8def.inc"

i2c_init_sl:
    out TWAR, r16
    ldi r16, (1<<TWIE)|(1<<TWEA)|(1<<TWINT)|(1<<TWEN)
    out TWCR, r16
    ret

i2c_stop_sl:
    in r16, TWCR
    andi r16, ~(1<<TWEA)|(1<<TWEN)
    out TWCR, r16
    ret
