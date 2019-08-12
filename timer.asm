#ifndef __TIMER__H
#define __TIMER__H

.equ TIMER0_STOP      = 0x0
.equ TIMER0_NO_PRES   = 0x1
.equ TIMER0_PRES_8    = 0x2
.equ TIMER0_PRES_64   = 0x3
.equ TIMER0_PRES_256  = 0x4
.equ TIMER0_PRES_1024 = 0x5
.equ TIMER0_PRES_EXT_T0_FALLING = 0x6
.equ TIMER0_PRES_EXT_T0_RAISING = 0x7

.macro TIMER0_SET_CLK
    ldi r16, (@0)
    out TCCR0, r16
.endm

.macro TIMER0_ENABLE
    in r16, TIMSK
    sbr r16, 1<<TOIE0
    out TIMSK, r16
.endm

.equ TIMER2_WGM_NORMAL = 0x0
.equ TIMER2_WGM_PWM = 0x1
.equ TIMER2_WGM_CTC = 0x2
.equ TIMER2_WGM_FAST_PWM = 0x3

.equ TIMER2_STOP      = 0x0
.equ TIMER2_NO_PRES   = 0x1
.equ TIMER2_PRES_8    = 0x2
.equ TIMER2_PRES_32   = 0x3
.equ TIMER2_PRES_64  = 0x4
.equ TIMER2_PRES_128 = 0x5
.equ TIMER2_PRES_256 = 0x6
.equ TIMER2_PRES_1024 = 0x7


; non pwm mode
.equ TIMER2_COM_OC2_DISCONNECTED = 0x0
.equ TIMER2_COM_OC2_TOGGLE = 0x1
.equ TIMER2_COM_OC2_CLEAR = 0x2
.equ TIMER2_COM_OC2_SET = 0x3

; fast pwm mode
;.equ TIMER2_COM_OC2_DISCONNECTED = 0x0
.equ TIMER2_COM_OC2_RESERVED = 0x1
.equ TIMER2_COM_OC2_CLR_CMP_SET_ON_BTM = 0x2
.equ TIMER2_COM_OC2_SET_CMP_LR_ON_BTM = 0x3

; phase correct pwm mode
;.equ TIMER2_COM_OC2_DISCONNECTED = 0x0
;.equ TIMER2_COM_OC2_RESERVED = 0x1
.equ TIMER2_COM_OC2_CLR_UP_SET_ON_DWN = 0x2
.equ TIMER2_COM_OC2_SET_UP_CLR_ON_DWN = 0x3

.macro TIMER2_SET_WGM
    in r16, TCCR2
    cbr r16, 1<<FOC2
    ori r16, @0 << WGM20
    out TCCR2, r16
.endm

.macro TIMER2_SET_COM
    in r16, TCCR2
    ori r16, @0 << COM20
    out TCCR2, r16
.endm

.macro TIMER2_SET_OCR2
    ldi r16, @0
    out OCR2, r16
.endm

.macro TIMER2_SET_CLK
    in r16, TCCR2
    sbr r16, (@0)
    out TCCR2, r16
.endm

;enable int
.macro TIMER2_ENABLE
    sbi DDRB, PORTB3
    in r16, TIMSK
    sbr r16, 1<<TOIE2
    out TIMSK, r16
.endm


; 16 bit timer/counter

; non pwm mode
.equ TIMER1_COM_OC1AB_DISCONNECTED = 0x0
.equ TIMER1_COM_OC1AB_TOGGLE = 0x1
.equ TIMER1_COM_OC1AB_CLEAR = 0x2
.equ TIMER1_COM_OC1AB_SET = 0x3

; fast pwm mode
;.equ TIMER1_COM_OC1AB_DISCONNECTED = 0x0
.equ TIMER1_COM_OC1A_CMP_ON_MATCH_F = 0x1 ; for WGM13:0 = 15 OC1B - disconnected   For all other WGM1 settings, normal port operation, OC1A/OC1B disconnected
.equ TIMER1_COM_OC1AB_CLR_CMP_SET_ON_BTM = 0x2
.equ TIMER1_COM_OC1AB_SET_CMP_CLR_ON_BTM = 0x3

; phase correct pwm mode
;.equ TIMER1_COM_OC1AB_DISCONNECTED = 0x0
.equ TIMER1_COM_OC1A_CMP_ON_MATCH_C = 0x1 ; for WGM13:0 = 9 or 14 OC1B - disconnected   For all other WGM1 settings, normal port operation, OC1A/OC1B disconnected
.equ TIMER1_COM_OC1AB_CLR_UP_SET_ON_DWN = 0x2
.equ TIMER1_COM_OC1AB_SET_UP_CLR_ON_DWN = 0x3

                                ; TOP UPDATE OCR1x TOV1flseton
;.equ TIMER1_WGM_NORMAL = $0      ; 0xFFFF imm max
.equ TIMER1_WGM_PHASE_CORR_8 = $1 ; 0x00FF top bottom
.equ TIMER1_WGM_PHASE_CORR_9 = $2 ; 0x01FF top bottom
.equ TIMER1_WGM_PHASE_CORR_10 = $3; 0x03FF top bottom
.equ TIMER1_WGM_CTC_OCR1A = $4    ; OCR1A  imm max
.equ TIMER1_WGM_FAST_PWM_8 = $5   ; 0x00FF bottom top
.equ TIMER1_WGM_FAST_PWM_9 = $6   ; 0x01FF bottom top
.equ TIMER1_WGM_FAST_PWM_10 = $7  ; 0x03FF bottom top
.equ TIMER1_WGM_PHASE_FREQ_CORR_ICR1 = $8 ; ICR1 bottom bottom
.equ TIMER1_WGM_PHASE_FREQ_CORR_OCR1A = $9; OCR1A bottom bottom
.equ TIMER1_WGM_PHASE_CORR_ICR1 = $10   ; ICR1  top bottom
.equ TIMER1_WGM_PHASE_CORR_OCR1A = $11  ; OCR1A top bottom
.equ TIMER1_WGM_CTC_ICR1 = $12          ; ICR1 imm max
.equ TIMER1_WGM_RESERVED = $13          ; - - -
.equ TIMER1_WGM_FAST_PWM_ICR1 = $14     ; ICR1 bottom top
.equ TIMER1_WGM_FAST_PWM_OCR1A = $15    ; OCR1A bottom top

.equ TIMER1_NOISE_CANCELER_DISABLE = $0
.equ TIMER1_NOISE_CANCELER_ENABLE = $1

.equ TIMER1_ICP1_EDGE_FALLING = $0
.equ TIMER1_ICP1_EDGE_RAISING = $1

.equ TIMER1_STOP      = 0x0
.equ TIMER1_NO_PRES   = 0x1
.equ TIMER1_PRES_8    = 0x2
.equ TIMER1_PRES_64   = 0x3
.equ TIMER1_PRES_256  = 0x4
.equ TIMER1_PRES_1024 = 0x5
.equ TIMER1_PRES_EXT_T1_FALLING = 0x6
.equ TIMER1_PRES_EXT_T1_RAISING = 0x7

.macro TIMER1_SET_WGM
    in r16, TCCR1A
    cbr r16, 1<<FOC1A | 1 <<FOC1B
    ori r16, (@0 & 0b11) << WGM10
    out TCCR1A, r16

    in r16, TCCR1B
    ori r16, (@0 & 0b1100) << WGM12
    out TCCR1B, r16
.endm

.macro TIMER1_SET_COM1A0
    in r16, TCCR1A
    ori r16, @0 << COM1A0
    out TCCR1A, r16
.endm

.macro TIMER1_SET_COM1B0
    in r16, TCCR1A
    ori r16, @0 << COM1B0
    out TCCR1A, r16
.endm

.macro TIMER1_NOISE_CANCELER
    in r16, TCCR1B
    cbr r16, 1<<ICNC1
    ori r16, @0<<ICNC1
    out TCCR1B, r16
.endm

.macro TIMER1_ICP1_EDGE_SELECT
    in r16, TCCR1B
    cbr r16, 1<<ICES1
    ori r16, @0<<ICES1
    out TCCR1B, r16
.endm

.macro TIMER1_SET_CLK
    in r16, TCCR1B
    sbr r16, (@0) << CS10
    out TCCR1B, r16
.endm


.macro TIMER1_SET_OCR1A
    ldi r16, LOW(@0)
    ldi r17, HIGH(@0)
    out OCR1AL, r16
    out OCR1AH, r17
.endm

.macro TIMER1_SET_OCR1B
    ldi r16, LOW(@0)
    ldi r17, HIGH(@0)
    out OCR1BL, r16
    out OCR1BH, r17
.endm


.macro TIMER1_SET_ICR1
    ldi r16, LOW(@0)
    ldi r17, HIGH(@0)
    out ICR1L, r16
    out ICR1H, r17
.endm

;enable int
.macro TIMER1_ENABLE
    sbi DDRB, PORTB1
    sbi DDRB, PORTB2
    cbi DDRB, PORTB0
    in r16, TIMSK
    sbr r16, 1<<TOIE1 | 1<<TICIE1 | 1<<OCIE1A | 1<<OCIE1B
    out TIMSK, r16
.endm

#endif ;__TIMER__H
