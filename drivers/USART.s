#ifndef _USART_S_
#define _USART_S_

.include "m8def.inc"

usart_init:
    out UBRRH, r17
    out UBRRL, r16
    ldi r16, (1<<RXEN)|(1<<TXEN)
    out UCSRB, r16
    ldi r16, (1<<URSEL)|(0<<USBS)|(3<<UCSZ0)
    out UCSRC, r16
    ret

usart_send:
    sbis UCSRA, UDRE
    rjmp usart_send
    out UDR, r16
    ret

usart_receive:
    sbis UCSRA, RXC
    rjmp usart_receive
    in r16, UDR
    ret

#endif ; _USART_S_
