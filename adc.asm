#ifndef __ADC_ASM
#define __ADC_ASM

.equ ADC_VOLTAGE_VREF_INTERNAL_OFF = $0
.equ ADC_VOLTAGE_AVCC_EXT_CAP_AT_AREF = $1
.equ ADC_VOLTAGE_RESERVED = $2
.equ ADC_VOLTAGE_INTERNAL_2_56_EXT_CAP_AT_AREF = $3
.equ ADC_LEFT_ADJ_DISABLE = $0
.equ ADC_LEFT_ADJ_ENABLE = $1

.equ ADC0 = 0000
.equ ADC1 = 0001
.equ ADC2 = 0010
.equ ADC3 = 0011
.equ ADC4 = 0100
.equ ADC5 = 0101
.equ ADC6 = 0110
.equ ADC7 = 0111
;.equ            1000
;.equ            1001
;.equ            1010
;.equ            1011
;.equ            1100
;.equ            1101
.equ ADC_1_30V_VBG = 1110
.equ ADC_0V_GND = 1111


;.equ ADC_PRES_2 = $0
.equ ADC_PRES_2 = $1
.equ ADC_PRES_4 = $2
.equ ADC_PRES_8 = $3
.equ ADC_PRES_16 = $4
.equ ADC_PRES_32 = $5
.equ ADC_PRES_64 = $6
.equ ADC_PRES_128 = $7

.macro ADC_VOLTAGE_SELECT
    in r16, ADMUX
    ori r16, @0 << REFS0
    out ADMUX, r16
.endm

.macro ADC_LEFT_ADJUST_RES
    in r16, ADMUX
    ori r16, @0 << ADLAR
    out ADMUX, r16
.endm

.macro ADC_SELECT_CHANNEL
    in r16, ADMUX
    ori r16, @0
    out ADMUX, r16
.endm

.macro ADC_ENABLE
    in r16, ADCSRA
    ori r16, @0 << ADEN | @0 << ADIE
    out ADCSRA, r16
.endm

.macro ADC_START_CONV
    in r16, ADCSRA
    ori r16, @0 << ADSC
    out ADCSRA, r16
.endm

.macro ADC_FREE_RUNNING_SELECT
    in r16, ADCSRA
    ori r16, @0 << ADFR
    out ADCSRA, r16
.endm

.macro ADC_SET_CLK
    in r16, ADCSRA
    ori r16, @0
    out ADCSRA, r16
.endm


#endif ;__ADC_ASM
