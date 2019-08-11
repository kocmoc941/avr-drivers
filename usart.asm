#ifndef __USART__ASM
#define __USART__ASM

.ifndef F_CPU
    .error "F_CPU not defined"
.endif

.equ USART_DATA = UDR

.macro USART_SET_BAUD_RATE
    in r16, UCSRC
    cbr r16, (1<<URSEL)
    out UCSRC, r16
    ldi r17, high((F_CPU/(16*@0))-1)
    ldi r16, low((F_CPU/(16*@0))-1)
    out UBRRH, r17
    out UBRRL, r16
.endm

.macro USART_SET_DATA_LEN
    in r16, UCSRC
    sbr r16, (1<<URSEL)
    ldi r16, (1<<UCSZ1 | 1<<UCSZ0)
    out UCSRC, r16
.endm

.macro USART_ENABLE
    ;RXCIE/TXCIE/UDRIE/RXEN/TXEN/UCSZ2/RXB8/TXB8
    ldi r16, 0b11010000
    ;ldi r16, 0b00001000
    out UCSRB, r16
.endm

#endif ;__USART__ASM
