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

; st_timer_base size
.equ SZ_ST_TIMER_BASE 						= SZ_ST_DEVICE + 0x08
; st_timer_base:st_device
.equ ST_TIMER_BASE_COUNTER_CONTROL_REGISTER_ADDRESS_OFFSET	= SZ_ST_DEVICE + 0x00
.equ ST_TIMER_BASE_COUNTER_REGISTER_ADDRESS_OFFSET		= SZ_ST_DEVICE + 0x02
.equ ST_TIMER_BASE_DIVIDER_BIT_MASK_OFFSET			= SZ_ST_DEVICE + 0x04
.equ ST_TIMER_BASE_OVERFLOW_INTERRUPT_BIT_MASK_OFFSET		= SZ_ST_DEVICE + 0x05
.equ ST_TIMER_BASE_OVERFLOW_HANDLER_OFFSET			= SZ_ST_DEVICE + 0x06

; enum TIMER_DIVIDER
.equ TIMER_DIVIDER_CLOCK_DISABLED		= 0x00
.equ TIMER_DIVIDER_1X				= 0x01
.equ TIMER_DIVIDER_8X				= 0x02
.equ TIMER_DIVIDER_64X				= 0x03
.equ TIMER_DIVIDER_256X				= 0x04
.equ TIMER_DIVIDER_1024X			= 0x05
.equ TIMER_DIVIDER_EXTERNAL_FALLING		= 0x06
.equ TIMER_DIVIDER_EXTERNAL_RAISING		= 0x07