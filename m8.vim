
syn case ignore

syn match reg "\<r\d\d\?\>"
syn match reg "\<x[lh]\?\>"
syn match reg "\<y[lh]\?\>"
syn match reg "\<z[lh]\?\>"

syn keyword mnem add
syn keyword mnem adc
syn keyword mnem adiw
syn keyword mnem sub
syn keyword mnem subi
syn keyword mnem sbc
syn keyword mnem sbci
syn keyword mnem sbiw
syn keyword mnem and
syn keyword mnem andi
syn keyword mnem or
syn keyword mnem ori
syn keyword mnem eor
syn keyword mnem com
syn keyword mnem neg
syn keyword mnem sbr
syn keyword mnem cbr
syn keyword mnem inc
syn keyword mnem dec
syn keyword mnem tst
syn keyword mnem clr
syn keyword mnem ser
syn keyword mnem mul
syn keyword mnem muls
syn keyword mnem mulsu
syn keyword mnem fmul
syn keyword mnem fmuls
syn keyword mnem fmulsu
syn keyword mnem branch
syn keyword mnem rjmp
syn keyword mnem ijmp
syn keyword mnem rcall
syn keyword mnem icall
syn keyword mnem ret
syn keyword mnem reti
syn keyword mnem cpse
syn keyword mnem cp
syn keyword mnem cpc
syn keyword mnem cpi
syn keyword mnem sbrc
syn keyword mnem sbrs
syn keyword mnem sbic
syn keyword mnem sbis
syn keyword mnem brbs
syn keyword mnem brbc
syn keyword mnem breq
syn keyword mnem brne
syn keyword mnem brcs
syn keyword mnem brcc
syn keyword mnem brsh
syn keyword mnem brlo
syn keyword mnem brmi
syn keyword mnem brpl
syn keyword mnem brge
syn keyword mnem brlt
syn keyword mnem brhs
syn keyword mnem brhc
syn keyword mnem brts
syn keyword mnem brtc
syn keyword mnem brvs
syn keyword mnem brvc
syn keyword mnem brie
syn keyword mnem brid
syn keyword mnem data
syn keyword mnem mov
syn keyword mnem movw
syn keyword mnem ldi
syn keyword mnem ld
syn keyword mnem ld
syn keyword mnem ld
syn keyword mnem ld
syn keyword mnem ld
syn keyword mnem ld
syn keyword mnem ldd
syn keyword mnem ld
syn keyword mnem ld
syn keyword mnem ld
syn keyword mnem ldd
syn keyword mnem lds
syn keyword mnem st
syn keyword mnem st
syn keyword mnem st
syn keyword mnem st
syn keyword mnem st
syn keyword mnem st
syn keyword mnem std
syn keyword mnem st
syn keyword mnem st
syn keyword mnem st
syn keyword mnem std
syn keyword mnem sts
syn keyword mnem lpm
syn keyword mnem lpm
syn keyword mnem lpm
syn keyword mnem spm
syn keyword mnem in
syn keyword mnem out
syn keyword mnem push
syn keyword mnem pop
syn keyword mnem bit
syn keyword mnem sbi
syn keyword mnem cbi
syn keyword mnem lsl
syn keyword mnem lsr
syn keyword mnem rol
syn keyword mnem ror
syn keyword mnem asr
syn keyword mnem swap
syn keyword mnem bset
syn keyword mnem bclr
syn keyword mnem bst
syn keyword mnem bld
syn keyword mnem sec
syn keyword mnem clc
syn keyword mnem sen
syn keyword mnem cln
syn keyword mnem sez
syn keyword mnem clz
syn keyword mnem sei
syn keyword mnem cli
syn keyword mnem ses
syn keyword mnem cls
syn keyword mnem sev
syn keyword mnem clv
syn keyword mnem set
syn keyword mnem clt
syn keyword mnem seh
syn keyword mnem clh
syn keyword mnem mcu
syn keyword mnem nop
syn keyword mnem sleep
syn keyword mnem wdr

syn match prep "\<\#\>"
syn match prep "#\<define\>"
syn match prep "#\<elif\>"
syn match prep "#\<else\>"
syn match prep "#\<endif\>"
syn match prep "#\<error\>"
syn match prep "#\<if\>"
syn match prep "#\<ifdef\>"
syn match prep "#\<ifndef\>"
syn match prep "#\<include\>"
syn match prep "#\<line\>"
syn match prep "#\<pragma\>"
syn match prep "#\<undef\>"

syn match prec "\.\<cseg\>"
syn match prec "\.\<csegsize\>"
syn match prec "\.\<db\>"
syn match prec "\.\<def\>"
syn match prec "\.\<dseg\>"
syn match prec "\.\<dw\>"
syn match prec "\.\<endmacro\>"
syn match prec "\.\<endm\>"
syn match prec "\.\<equ\>"
syn match prec "\.\<eseg\>"
syn match prec "\.\<exit\>"
syn match prec "\.\<include\>"
syn match prec "\.\<list\>"
syn match prec "\.\<listmac\>"
syn match prec "\.\<macro\>"
syn match prec "\.\<nolist\>"
syn match prec "\.\<org\>"
syn match prec "\.\<set\>"
syn match prec "\.\<elif\>"
syn match prec "\.\<else\>"
syn match prec "\.\<endif\>"
syn match prec "\.\<error\>"
syn match prec "\.\<if\>"
syn match prec "\.\<ifdef\>"
syn match prec "\.\<ifndef\>"
syn match prec "\.\<message\>"
syn match prec "\.\<dd\>"
syn match prec "\.\<dq\>"
syn match prec "\.\<undef\>"
syn match prec "\.\<warning\>"
syn match prec "\.\<overlap\>"
syn match prec "\.\<nooverlap\>"

syn match comm ";.*$"
syn match comm "//.*$"

syn region comm start='/\*' end='\*/' fold

syn match val "\<\d\+\>"
syn match val "\<0b[0-1]\+\>"
syn match val "\<0x[0-F]\+\>"
syn match val "\$\<[0-F]\+\>"

syn match str "'.*'"
syn match str "\".*\""

syn match lab "\<[_a-zA-Z][_-a-zA-Z0-9]*\>:"

syn case match

hi def link err Warning

hi def link mnem Statement
hi def link seg Statement
hi def link comm Comment
hi def link reg Type
hi def link lab Label
hi def link val Constant
hi def link str Constant
hi def link prec Statement
hi def link prep Preproc

