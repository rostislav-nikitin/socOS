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

; st_timer_w_pwm_base size
.equ SZ_ST_TIMER_W_PWM_BASE 						= SZ_ST_TIMER_BASE + 0x0A
; st_timer_w_pwm_base:st_timer_base inherited fields
.equ ST_TIMER_W_PWM_BASE_COUNTER_CONTROL_REGISTER_ADDRESS_OFFSET	= ST_TIMER_BASE_COUNTER_CONTROL_REGISTER_ADDRESS_OFFSET
.equ ST_TIMER_W_PWM_BASE_COUNTER_REGISTER_ADDRESS_OFFSET		= ST_TIMER_BASE_COUNTER_REGISTER_ADDRESS_OFFSET
.equ ST_TIMER_W_PWM_BASE_DIVIDER_BIT_MASK_OFFSET			= ST_TIMER_BASE_DIVIDER_BIT_MASK_OFFSET
.equ ST_TIMER_W_PWM_BASE_OVERFLOW_INTERRUPT_BIT_MASK_OFFSET		= ST_TIMER_BASE_OVERFLOW_INTERRUPT_BIT_MASK_OFFSET
.equ ST_TIMER_W_PWM_BASE_OVERFLOW_HANDLER_OFFSET			= ST_TIMER_BASE_OVERFLOW_HANDLER_OFFSET
; st_timer_pwm_base new fields
.equ ST_TIMER_W_PWM_BASE_COMPARE_CONTROL_REGISTER_ADDRESS_OFFSET	= SZ_ST_TIMER_BASE
.equ ST_TIMER_W_PWM_BASE_DDRX_ADDRESS_OFFSET				= SZ_ST_TIMER_BASE + 0x02
.equ ST_TIMER_W_PWM_BASE_DDRX_BIT_MASK_OFFSET				= SZ_ST_TIMER_BASE + 0x04
.equ ST_TIMER_W_PWM_BASE_MODE_OFFSET					= SZ_ST_TIMER_BASE + 0x05
.equ ST_TIMER_W_PWM_BASE_COMPARE_THRESHOLD_OFFSET			= SZ_ST_TIMER_BASE + 0x06
.equ ST_TIMER_W_PWM_BASE_COMPARE_INTERRUPT_BIT_MASK_OFFSET		= SZ_ST_TIMER_BASE + 0x07
.equ ST_TIMER_W_PWM_BASE_COMPARE_HANDLER_OFFSET				= SZ_ST_TIMER_BASE + 0x08

; enum TIMER_W_PWM_DIVIDER
.equ TIMER_W_PWM_DIVIDER_CLOCK_DISABLED		= 0x00
.equ TIMER_W_PWM_DIVIDER_1X			= 0x01
.equ TIMER_W_PWM_DIVIDER_8X			= 0x02
.equ TIMER_W_PWM_DIVIDER_32X			= 0x03
.equ TIMER_W_PWM_DIVIDER_64X			= 0x04
.equ TIMER_W_PWM_DIVIDER_128X			= 0x05
.equ TIMER_W_PWM_DIVIDER_256X			= 0x06
.equ TIMER_W_PWM_DIVIDER_1024X			= 0x07

; enum TIMER_W_PWM_MODE
.equ TIMER_W_PWM_MODE_OFF			= 0x00
.equ TIMER_W_PWM_MODE_CTC			= 0x01
.equ TIMER_W_PWM_MODE_PHASE_CORRECTION		= 0x02
.equ TIMER_W_PWM_MODE_PHASE_CORRECTION_INVERTED	= 0x03
.equ TIMER_W_PWM_MODE_FAST			= 0x04
.equ TIMER_W_PWM_MODE_FAST_INVERTED		= 0x05

; enum TIMER_W_PWM_COMPARE_THRESHOLD
.equ TIMER_W_PWM_COMPARE_THRESHOLD_ZERO		= 0x00