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
;.include "kernel/drivers/soc/timer_w_pwm_base_def.asm"

; st_timer2 size
.equ SZ_ST_TIMER2						= SZ_ST_TIMER_W_PWM_BASE
; st_timer2:st_timer_pwm_base inherited fields
.equ ST_TIMER2_COUNTER_CONTROL_REGISTER_ADDRESS_OFFSET		= ST_TIMER_W_PWM_BASE_COUNTER_CONTROL_REGISTER_ADDRESS_OFFSET
.equ ST_TIMER2_COUNTER_REGISTER_ADDRESS_OFFSET			= ST_TIMER_W_PWM_BASE_COUNTER_REGISTER_ADDRESS_OFFSET
.equ ST_TIMER2_DIVIDER_BIT_MASK_OFFSET				= ST_TIMER_W_PWM_BASE_DIVIDER_BIT_MASK_OFFSET
.equ ST_TIMER2_OVERFLOW_INTERRUPT_BIT_MASK_OFFSET		= ST_TIMER_W_PWM_BASE_OVERFLOW_INTERRUPT_BIT_MASK_OFFSET
.equ ST_TIMER2_OVERFLOW_HANDLER_OFFSET				= ST_TIMER_W_PWM_BASE_OVERFLOW_HANDLER_OFFSET
; st_timer2 new fields
.equ ST_TIMER2_COMPARE_CONTROL_REGISTER_ADDRESS_OFFSET		= ST_TIMER_W_PWM_BASE_COMPARE_CONTROL_REGISTER_ADDRESS_OFFSET
.equ ST_TIMER2_DDRX_ADDRESS_OFFSET				= ST_TIMER_W_PWM_BASE_DDRX_ADDRESS_OFFSET
.equ ST_TIMER2_DDRX_BIT_MASK_OFFSET				= ST_TIMER_W_PWM_BASE_DDRX_ADDRESS_OFFSET
.equ ST_TIMER2_MODE_OFFSET					= ST_TIMER_W_PWM_BASE_MODE_OFFSET
.equ ST_TIMER2_COMPARE_THRESHOLD_OFFSET				= ST_TIMER_W_PWM_BASE_COMPARE_THRESHOLD_OFFSET
.equ ST_TIMER2_COMPARE_INTERRUPT_BIT_MASK_OFFSET		= ST_TIMER_W_PWM_BASE_COMPARE_INTERRUPT_BIT_MASK_OFFSET
.equ ST_TIMER2_COMPARE_HANDLER_OFFSET				= ST_TIMER_W_PWM_BASE_COMPARE_HANDLER_OFFSET