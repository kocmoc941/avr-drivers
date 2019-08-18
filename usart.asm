#ifndef __USART__ASM
#define __USART__ASM

.ifndef F_CPU
    .error "F_CPU not defined"
.endif

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
    ldi r16, 0b11011000
    ;ldi r16, 0b00001000
    out UCSRB, r16
.endm


.macro __set_busy
    push XL
    push XH
    push r16
    ldi XL, low(__usart_busy)
    ldi XH, high(__usart_busy)
    clr r16
    ori r16, @0
    st X, r16
    pop r16
    pop XH
    pop XL
.endm

.macro __get_busy
    push XL
    push XH
    ldi XL, low(__usart_busy)
    ldi XH, high(__usart_busy)
    ld r16, X
    pop XH
    pop XL
.endm

.dseg
    __usart_busy: .byte 1
    __usart_strs: .byte 3 * 64

.cseg

__usart_txc_callback:
    for_debug
    __set_busy 0
ret

.macro USART_SEND_STR
    push XL
    push XH
    push YL
    push YH
    push r16
    ldi XH, high(@0 * 2)
    ldi XL, low(@0 * 2)
    ldi YH, high(__usart_strs)
    ldi YL, low(__usart_strs)
    clr r16
    clr r17
    st Y+, r16 ; letter pointer
    st Y+, XL
    st Y, XH
    pop r16
    pop YH
    pop YL
    pop XH
    pop XL
.endm

task_usart_handler:
    push ZL
    push ZH
    push YL
    push YH
    push r17
    push r16
    __get_busy
    tst r16
    brne __usart_skip

    ldi YH, high(__usart_strs)
    ldi YL, low(__usart_strs)
    ld r16, Y+
    ld ZL, Y+
    ld ZH, Y
    clr r17
    add ZL, r16
    adc ZH, r17

    lpm r17, Z
    tst r17
    breq __usart_skip
    out UDR, r17
    inc r16
    sbiw Y, 2
    st Y, r16
    __set_busy 1
    rjmp __usart_next
    __usart_skip:
    clr r16
    sbiw Y, 2
    st Y, r16

    __usart_next:
    pop r16
    pop r17
    pop YH
    pop YL
    pop ZH
    pop ZL
ret

#endif ;__USART__ASM
