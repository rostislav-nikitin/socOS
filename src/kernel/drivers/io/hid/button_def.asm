;=======================================================================================================================
;                                                                                                                      ;
; Name:	socOS (System On Chip Operation System)                                                                        ;
; 	Year: 		2020                                                                                           ;
; 	License:	MIT License                                                                                    ;
;                                                                                                                      ;
;=======================================================================================================================

; Require:
;.include "m8def.inc"

;.include "kernel/kernel_def.asm"
;.include "kernel/drivers/device_def.asm"
;.include "kernel/drivers/io/device_io_def.asm"
;.include "kernel/drivers/io/in_bit_def.asm"

; st_button size
.equ SZ_ST_BUTTON				= SZ_ST_IN_BIT + 0x07
; st_button:st_device_io inherited members
.equ ST_BUTTON_DDRX_ADDRESS_OFFSET		= ST_IN_BIT_DDRX_ADDRESS_OFFSET
.equ ST_BUTTON_PINX_ADDRESS_OFFSET 		= ST_IN_BIT_PINX_ADDRESS_OFFSET
.equ ST_BUTTON_PORTX_ADDRESS_OFFSET 		= ST_IN_BIT_PORTX_ADDRESS_OFFSET
.equ ST_BUTTON_USED_BIT_MASK_OFFSET		= ST_IN_BIT_USED_BIT_MASK_OFFSET
.equ ST_BUTTON_TYPE_BIT_MASK_OFFSET		= ST_IN_BIT_TYPE_BIT_MASK_OFFSET
; st_button new members
.equ ST_BUTTON_STATE				= SZ_ST_IN_BIT
.equ ST_BUTTON_ON_BUTTON_DOWN_HANDLER		= SZ_ST_IN_BIT + 0x01
.equ ST_BUTTON_ON_BUTTON_UP_HANDLER		= SZ_ST_IN_BIT + 0x03
.equ ST_BUTTON_ON_BUTTON_PRESSED_HANDLER	= SZ_ST_IN_BIT + 0x05

; enum BUTTON_STATE
.equ BUTTON_STATE_DOWN				= IN_BIT_STATE_OFF
.equ BUTTON_STATE_UP				= IN_BIT_STATE_ON
.equ BUTTON_STATE_DEFAULT			= BUTTON_STATE_UP