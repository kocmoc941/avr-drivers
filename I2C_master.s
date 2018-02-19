.include "m8def.inc"

wait_sending:
    in r16, TWCR
    sbrs r16, TWINT
    rjmp wait_sending
    ret

ERROR:
    ret

i2c_init:
    out TWBR, r16
    sbr r16, TWPS0
    sbr r16, TWPS1
    out TWSR, r16
    ret

i2c_start:
    ldi r16, (1<<TWINT)|(1<<TWSTA)|(1<<TWEN)
    out TWCR, r16
    rcall wait_sending

    ;cpi r16, 0x08 ;START
    ;brne ERROR
    ret

i2c_get_status:
    in r16, TWSR
    andi r16, $F8
    ret

i2c_send_byte:
    out TWDR, r16
    ldi r16, (1<<TWINT)|(1<<TWEN)
    out TWCR, r16
    rcall wait_sending

    ;cpi r16, 0x18 ;MT_SLA_ACK
    ;cpi r16, 0x28; MT_DATA_ACK
    ;brne ERROR
    ret

i2c_read_ack:
    ldi r16, (1<<TWINT)|(1<<TWEN)|(1<<TWEA)
    out TWCR, r16
    rcall wait_sending
    ret

i2c_read_nack:
    ldi r16, (1<<TWINT)|(1<<TWEN)
    out TWCR, r16
    rcall wait_sending
    ret

i2c_send_nack:
    ldi r16, (1<<TWEA)
    ser r17
    eor r16, r17
    out TWCR, r16
    ret

i2c_stop:
    ldi r16, (1<<TWINT)|(1<<TWSTO)|(1<<TWEN)
    out TWCR, r16
    ret
