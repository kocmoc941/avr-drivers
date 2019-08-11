
syn match reg "r\d\d\?"

syn case ignore
syn keyword mnem ADD
syn keyword mnem ADC
syn keyword mnem ADIW
syn keyword mnem SUB
syn keyword mnem SUBI
syn keyword mnem SBC
syn keyword mnem SBCI
syn keyword mnem SBIW
syn keyword mnem AND
syn keyword mnem ANDI
syn keyword mnem OR
syn keyword mnem ORI
syn keyword mnem EOR
syn keyword mnem COM
syn keyword mnem NEG
syn keyword mnem SBR
syn keyword mnem CBR
syn keyword mnem INC
syn keyword mnem DEC
syn keyword mnem TST
syn keyword mnem CLR
syn keyword mnem SER
syn keyword mnem MUL
syn keyword mnem MULS
syn keyword mnem MULSU
syn keyword mnem FMUL
syn keyword mnem FMULS
syn keyword mnem FMULSU
syn keyword mnem BRANCH
syn keyword mnem RJMP
syn keyword mnem IJMP
syn keyword mnem RCALL
syn keyword mnem ICALL
syn keyword mnem RET
syn keyword mnem RETI
syn keyword mnem CPSE
syn keyword mnem CP
syn keyword mnem CPC
syn keyword mnem CPI
syn keyword mnem SBRC
syn keyword mnem SBRS
syn keyword mnem SBIC
syn keyword mnem SBIS
syn keyword mnem BRBS
syn keyword mnem BRBC
syn keyword mnem BREQ
syn keyword mnem BRNE
syn keyword mnem BRCS
syn keyword mnem BRCC
syn keyword mnem BRSH
syn keyword mnem BRLO
syn keyword mnem BRMI
syn keyword mnem BRPL
syn keyword mnem BRGE
syn keyword mnem BRLT
syn keyword mnem BRHS
syn keyword mnem BRHC
syn keyword mnem BRTS
syn keyword mnem BRTC
syn keyword mnem BRVS
syn keyword mnem BRVC
syn keyword mnem BRIE
syn keyword mnem BRID
syn keyword mnem DATA
syn keyword mnem MOV
syn keyword mnem MOVW
syn keyword mnem LDI
syn keyword mnem LD
syn keyword mnem LD
syn keyword mnem LD
syn keyword mnem LD
syn keyword mnem LD
syn keyword mnem LD
syn keyword mnem LDD
syn keyword mnem LD
syn keyword mnem LD
syn keyword mnem LD
syn keyword mnem LDD
syn keyword mnem LDS
syn keyword mnem ST
syn keyword mnem ST
syn keyword mnem ST
syn keyword mnem ST
syn keyword mnem ST
syn keyword mnem ST
syn keyword mnem STD
syn keyword mnem ST
syn keyword mnem ST
syn keyword mnem ST
syn keyword mnem STD
syn keyword mnem STS
syn keyword mnem LPM
syn keyword mnem LPM
syn keyword mnem LPM
syn keyword mnem SPM
syn keyword mnem IN
syn keyword mnem OUT
syn keyword mnem PUSH
syn keyword mnem POP
syn keyword mnem BIT
syn keyword mnem SBI
syn keyword mnem CBI
syn keyword mnem LSL
syn keyword mnem LSR
syn keyword mnem ROL
syn keyword mnem ROR
syn keyword mnem ASR
syn keyword mnem SWAP
syn keyword mnem BSET
syn keyword mnem BCLR
syn keyword mnem BST
syn keyword mnem BLD
syn keyword mnem SEC
syn keyword mnem CLC
syn keyword mnem SEN
syn keyword mnem CLN
syn keyword mnem SEZ
syn keyword mnem CLZ
syn keyword mnem SEI
syn keyword mnem CLI
syn keyword mnem SES
syn keyword mnem CLS
syn keyword mnem SEV
syn keyword mnem CLV
syn keyword mnem SET
syn keyword mnem CLT
syn keyword mnem SEH
syn keyword mnem CLH
syn keyword mnem MCU
syn keyword mnem NOP
syn keyword mnem SLEEP
syn keyword mnem WDR

syn match prep "#include"
syn match prep "#define"
syn match prep "#ifdef"
syn match prep "#ifndef"
syn match prep "#endif"
syn match prec "\.include"
syn match prec "\.\<def\>"
syn match prec "\.\<ifdef\>"
syn match prec "\.\<ifndef\>"
syn match prec "\.\<endif\>"
syn match prec "\.\<equ\>"
syn match prec "\.\<set\>"
syn match prec "\.\<macro\>"
syn match prec "\.\<endm\>"

syn match comm ";.*$"
syn match comm "//.*$"

syn region comm start='/\*' end='\*/' fold

syn match val "\<\d\+\>"
syn match val "\<0b[0-1]\+\>"
syn match val "\<0x[0-F]\+\>"
syn match val "\$\<[0-F]\+\>"

syn match lab "\<[_a-zA-Z][_-a-zA-Z0-9]*\>:"
hi def link mnem Statement
hi def link comm Comment
hi def link reg Type
hi def link lab Label
hi def link val Constant
hi def link prec Statement
hi def link prep Preproc

