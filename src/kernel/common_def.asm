; constants
; bits
.equ BIT0									= 0x00
.equ BIT1									= 0x01
.equ BIT2									= 0x02
.equ BIT3									= 0x03
.equ BIT4									= 0x04
.equ BIT5									= 0x05
.equ BIT6									= 0x06
.equ BIT7									= 0x07

; stack
.equ SZ_RET_ADDRESS 						= 0x02
.equ SZ_STACK_PREVIOUS_OFFSET 				= 0x01

; ports
.equ IO_PORTS_OFFSET						= 0x20

; save & restore registers: number of registers to save/restore + 1 for SREG
.equ SZ_R16_X_REGISTERS						= 0x04
.equ SZ_R16_R17_X_Y_REGISTERS				= 0x07
.equ SZ_R16_X_Y_Z_REGISTERS					= 0x08
.equ SZ_R16_R17_R18_X_Y_REGISTERS			= 0x08
.equ SZ_R16_R17_X_Y_Z_REGISTERS				= 0x09
.equ SZ_R16_R17_R18_X_Y_Z_REGISTERS 		= 0x0A
.equ SZ_R16_R17_R18_R19_X_Y_Z_REGISTERS 	= 0x0B