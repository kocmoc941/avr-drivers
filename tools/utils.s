#ifndef _UTILS_S_
#define _UTILS_S_

.include "USART.s"

in_eeprom_write:
    _in_eeww:
        sbic EECR, EEWE
        rcall _in_eeww
    out EEARL, ZL
    out EEARH, ZH
    out EEDR, r16
    sbi EECR, EEMWE
    sbi EECR, EEWE

    ret

in_eeprom_read:
    _in_eerw:
        sbic EECR, EEWE
        rcall _in_eerw
    out EEARL, ZL
    out EEARH, ZH
    sbi EECR, EERE
    in r20, EEDR

    ret

print_data:
    lpm r16, Z+
    rcall usart_send
    tst r16
    brne print_data

    ret

print_byte:
    ld r16, Z+
#ifndef PRINT_RAW
    rcall to_str_hex
    mov r16, r21
    rcall usart_send
    mov r16, r20
    ldi r20, $2
    mul r17, r20
#endif
    rcall usart_send
    dec r17
    tst r17
    brne print_byte

    ret

hex_data: .db '0', '1', '2', '3', '4', '5', '6', '7', '8', '9' \
                , 'A', 'B', 'C', 'D', 'E', 'F'

to_str_hex:
    push r17
    push ZL
    push ZH

    mov r20, r16
    andi r20, $0F
    mov r21, r16
    andi r21, $F0
    ldi r17, $4
    _4:
    lsr r21
    dec r17
    brne _4

    ;convert to hex
    ldi ZL, low(hex_data * 2)
    ldi ZH, high(hex_data * 2)
    add ZL, r20
    lpm r20, Z
    ldi ZL, low(hex_data * 2)
    ldi ZH, high(hex_data * 2)
    add ZL, r21
    lpm r21, Z

    pop ZH
    pop ZL
    pop r17

    ret

#endif ;_UTILS_S_    
