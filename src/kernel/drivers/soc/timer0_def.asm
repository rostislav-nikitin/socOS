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
;.include "kernel/drivers/soc/timer_base_def.asm"

;.include "kernel/kernel_cseg.asm"
;.include "kernel/drivers/device_cseg.asm"
;.include "kernel/drivers/soc/timer_base_cseg.asm"

; st_timer0 size
.equ SZ_ST_TIMER0 						= SZ_ST_TIMER_BASE
; st_timer0:st_timer_base
.equ ST_TIMER0_COUNTER_CONTROL_REGISTER_ADDRESS_OFFSET		= ST_TIMER_BASE_COUNTER_CONTROL_REGISTER_ADDRESS_OFFSET
.equ ST_TIMER0_DIVIDER_BIT_MASK_OFFSET				= ST_TIMER_BASE_DIVIDER_BIT_MASK_OFFSET
.equ ST_TIMER0_INTERRUPT_BIT_MASK_OFFSET			= ST_TIMER_BASE_OVERFLOW_INTERRUPT_BIT_MASK_OFFSET
.equ ST_TIMER0_OVERFLOW_HANDLER_OFFSET				= ST_TIMER_BASE_OVERFLOW_HANDLER_OFFSET
