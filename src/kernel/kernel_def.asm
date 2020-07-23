; constants
; bool
.equ FALSE									= 0x00
.equ TRUE									= 0x01
; null
.equ NULL									= 0x00
; pointer
.equ POINTER_NULL								= 0x0000
.equ POINTER_NULL_LOW								= low(POINTER_NULL)
.equ POINTER_NULL_HIGH								= high(POINTER_NULL)
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

; enumerations
; DIRECTION
.equ DIRECTION_THREAD_CCW				= 0x00
.equ DIRECTION_THREAD_CW				= 0x01

; ST_TETRADE_MASK
.equ TETRADE_MASK_LOW					= 0b00001111
.equ TETRADE_MASK_HIGH					= 0b11110000