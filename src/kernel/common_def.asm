; constants
.equ NULL									= 0x00
.equ NULL_POINTER								= 0x0000
.equ NULL_POINTER_L								= low(NULL_POINTER)
.equ NULL_POINTER_H								= high(NULL_POINTER)
; bool
.equ FALSE									= 0x00
.equ TRUE									= 0x01
; bits
.equ BIT0									= 0x00
.equ BIT1									= 0x01
.equ BIT2									= 0x02
.equ BIT3									= 0x03
.equ BIT4									= 0x04
.equ BIT5									= 0x05
.equ BIT6									= 0x06
.equ BIT7									= 0x07

; address
.equ SZ_ADDRESS									= 0x02

; stack
.equ SZ_RET_ADDRESS 								= SZ_ADDRESS
.equ SZ_STACK_PREVIOUS_OFFSET 							= 0x01


; ports
.equ IO_PORTS_OFFSET								= 0x20

; save & restore registers: number of registers to save/restore + 1 for SREG
.equ SZ_R16_X_REGISTERS					= 0x04
.equ SZ_R16_R17_X_REGISTERS				= 0x05
.equ SZ_R16_X_Z_REGISTERS				= 0x06
.equ SZ_R16_R17_X_Y_REGISTERS				= 0x07
.equ SZ_R16_R17_X_Z_REGISTERS				= 0x07
.equ SZ_R16_X_Y_Z_REGISTERS				= 0x08
.equ SZ_R16_R17_R18_X_Y_REGISTERS			= 0x08
.equ SZ_R16_R17_X_Y_Z_REGISTERS				= 0x09
.equ SZ_R16_R17_R18_X_Y_Z_REGISTERS 			= 0x0A
.equ SZ_R16_R17_R18_R19_X_Y_Z_REGISTERS 		= 0x0B

; enumerations
; DIRECTION
.equ DIRECTION_THREAD_CCW				= 0x00
.equ DIRECTION_THREAD_CW				= 0x01

;
; ST_TETRADE_MASK
.equ TETRADE_MASK_LOW					= 0b00001111
.equ TETRADE_MASK_HIGH					= 0b11110000