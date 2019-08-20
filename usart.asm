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
    __usart_strs_end:
    .equ __usart_strs_len = (__usart_strs - __usart_strs_end) / 3
    __usart_current_str_id: .byte 1

.cseg

__usart_txc_callback:
    ;for_debug
    __set_busy 0
ret

.macro USART_SEND_STR
    push XL
    push XH
    push YL
    push YH
    push r16
    push r17
    ldi XH, high(@0 * 2)
    ldi XL, low(@0 * 2)
    ldi YH, high(__usart_strs)
    ldi YL, low(__usart_strs)

    ; PTR_LOW
    ldd r16, Y+1
    tst r16
    breq __usart_next_check
    rjmp __usart_is_progress

    __usart_next_check:
        ; PTR_HIGH
        ldd r16, Y+2
        tst r16
        breq __usart_init_str

    __usart_is_progress:
       ld r16, Y
       tst r16
       breq __usart_init_str
    
       ldd ZL, Y+1
       ldd ZH, Y+2
       lpm r16, Z
       tst r16
       rjmp __usart_init_str

       add YL, r17
       clr r17
       adc YH, r17
       ld r16, Y
       tst r16
       brne __usart_skip_print

    __usart_init_str:
    clr r16
    st Y+, r16 ; letter pointer
    st Y+, XL
    st Y, XH
    __usart_skip_print:
    pop r17
    pop r16
    pop YH
    pop YL
    pop XH
    pop XL
.endm

.def cnt = r16
.def tmp = r17
;#define __str_addr_low = XL
;#define __str_addr_high = XH
;#define __str_data_low = YL
;#define __str_data_high = YH

task_usart_handler:
    push ZL
    push ZH
    push YL
    push YH
    push XL
    push XH
    push tmp
    push cnt
    __get_busy
    tst r16
    brne __usart_skip

    ; select str
    rjmp __skip_select_str
    ldi XH, high(__usart_current_str_id)
    ldi XL, low(__usart_current_str_id)
    ld cnt, X
    ldi tmp, __usart_strs_len
    sub tmp, cnt
    brcs __usart_clr_str_id
    mov tmp, cnt
    ;inc cnt
    ;inc cnt
    ;inc cnt
    rjmp __usart_next_str
    __usart_clr_str_id:
    clr cnt
    __usart_next_str:
    ;st X, cnt

    __skip_select_str:
    ; handle selected str
    ldi YL, low(__usart_strs)
    ldi YH, high(__usart_strs)
    add YL, tmp
    clr tmp
    adc YH, tmp

    ldd tmp, Y+1
    tst tmp
    brne __usart_handle_str
    ldd tmp, Y+2
    tst tmp
    breq __usart_skip

    __usart_handle_str:

    ldd cnt, Y+0 ; load printed letter counter
    ldd ZL, Y+1
    ldd ZH, Y+2
    clr tmp
    add ZL, cnt
    adc ZH, tmp

    lpm tmp, Z
    tst tmp
    breq __usart_del_str
    out UDR, tmp
    inc cnt
    st Y, cnt
    __set_busy 1
    rjmp __usart_skip

    __usart_del_str:

    clr cnt
    clr tmp
    st X, cnt
    st Y, tmp
    std Y+1, tmp
    std Y+2, tmp
    
    __usart_skip:
    pop cnt
    pop tmp
    pop XH
    pop XL
    pop YH
    pop YL
    pop ZH
    pop ZL
ret
.undef cnt
.undef tmp

#endif ;__USART__ASM
