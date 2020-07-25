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

;.include "kernel/kernel_cseg.asm"
;.include "kernel/drivers/device_cseg.asm"
;.include "kernel/drivers/soc/timer_base_cseg.asm"
;.include "kernel/drivers/soc/timer_w_pwm_base_cseg.asm"

; PWM at PINB[3]
.macro m_timer2_init
	m_save_Z_registers
	; parameters:
	;	@0	timer_divider	TIMER_DIVIDER
	;	@1	word		[on_overflow_handler]
	;	@2	byte		TIMER_W_PWM_MODE
	;	@3	byte		compare threshold
	;	@4	word		[on_compare_handler]

	m_timer_w_pwm_base_init timer2_static_instance, TCCR2, TCNT2, OCR2, @0, (1 << TOIE2), @1, DDRB, (1 << BIT3), @2, @3, (1 << OCIE2), @4

	ldi ZL, low(timer2_static_instance)
	ldi ZH, high(timer2_static_instance)

	rcall timer2_init

	m_restore_Z_registers
.endm
timer2_init:
	rcall timer2_init_ports_mode

	ret

timer2_init_ports_mode:
	rcall timer2_counter_control_register_set_mode

	ret

.macro m_timer2_compare_threshold_set
	; parameters:
	;	@0	byte	compare threshlod
	m_timer_w_pwm_base_compare_threshold_set timer2_static_instance, @0
	
.endm
timer2_compare_threshold_set:
	; parameters:
	;	r23	byte	compare threshlod
	m_save_Z_registers

	ldi ZL, low(timer2_static_instance)
	ldi ZH, high(timer2_static_instance)

	rcall timer_w_pwm_base_compare_threshold_set

	m_restore_Z_registers

	ret

.macro m_timer2_compare_control_register_set_compare_threshold
	m_timer_w_pwm_base_compare_control_register_set_compare_threshold timer2_static_instance
.endm
timer2_compare_control_register_set_compare_threshold:
	ldi ZL, low(timer2_static_instance)
	ldi ZH, high(timer2_static_instance)

	rcall timer_w_pwm_base_compare_control_register_set_compare_threshold
	ret

.macro m_timer2_counter_control_register_set_mode
	rcall timer2_counter_control_register_set_mode
.endm
timer2_counter_control_register_set_mode:
	m_save_r23_Z_registers

	ldi ZL, low(timer2_static_instance)
	ldi ZH, high(timer2_static_instance)

	ldi r23, ST_TIMER2_MODE_OFFSET
	rcall get_struct_byte

	rcall timer2_counter_control_register_set

	m_restore_r23_Z_registers

	ret

.macro m_timer2_counter_control_register_set_mode_off
	rcall timer2_counter_control_register_set_mode_off
.endm
timer2_counter_control_register_set_mode_off:
	m_save_r23_registers

	ldi r23, TIMER_W_PWM_MODE_OFF

	rcall timer2_counter_control_register_set

	m_restore_r23_registers

	ret

.macro m_timer2_counter_control_register_set
	; parameters:
	;	@0	byte	TIMER_W_PWM_MODE
	m_save_r23_registers

	ldi r23, @0

	rcall timer2_counter_control_register_set

	m_resore_r23_registers
.endm
timer2_counter_control_register_set:
	; parameters:
	;	r23	byte	TIMER_W_PWM_MODE
	m_save_r16_r23_Z_SREG_registers

	ldi ZL, low(timer2_static_instance)
	ldi ZH, high(timer2_static_instance)

	push r23

	ldi r23, ST_TIMER2_COUNTER_CONTROL_REGISTER_ADDRESS_OFFSET
	rcall get_struct_word

	ld r16, Z

	; reset all WGM/COM bits
	ldi r23, (1 << WGM21) | (1 << WGM20) | (1 << COM21) | (1 << COM20)
	com r23
	and r16, r23

	pop r23

	timer2_mode_set_check_off:
		cpi r23, TIMER_W_PWM_MODE_OFF
		breq timer2_mode_set_end
	timer2_mode_set_check_phase_correction:	
		cpi r23, TIMER_W_PWM_MODE_PHASE_CORRECTION
		brne timer2_mode_set_check_phase_correction_inverted
		; set required
		ldi r23, (0 << WGM21) | (1 << WGM20) | (1 << COM21) | (0 << COM20)
		or r16, r23
		rjmp timer2_mode_set_end
	timer2_mode_set_check_phase_correction_inverted:
		cpi r23, TIMER_W_PWM_MODE_PHASE_CORRECTION_INVERTED
		brne timer2_mode_set_check_ctc
		; set required
		ldi r23, (0 << WGM21) | (1 << WGM20) | (1 << COM21) | (1 << COM20)
		or r16, r23		
		rjmp timer2_mode_set_end
	timer2_mode_set_check_ctc:
		cpi r23, TIMER_W_PWM_MODE_CTC
		brne timer2_mode_set_check_fast
		; set required
		ldi r23, (1 << WGM21) | (0 << WGM20) | (0 << COM21) | (1 << COM20)
		or r16, r23		
		rjmp timer2_mode_set_end
	timer2_mode_set_check_fast:
		cpi r23, TIMER_W_PWM_MODE_FAST
		brne timer2_mode_set_check_fast_inverted
		; set required
		ldi r23, (1 << WGM21) | (1 << WGM20) | (1 << COM21) | (0 << COM20)
		or r16, r23		
		rjmp timer2_mode_set_end
	timer2_mode_set_check_fast_inverted:
		cpi r23, TIMER_W_PWM_MODE_FAST_INVERTED
		brne timer2_mode_set_end
		;
		ldi r23, (1 << WGM21) | (1 << WGM20) | (1 << COM21) | (1 << COM20)
		or r16, r23
		rjmp timer2_mode_set_end

	timer2_mode_set_end:
		st Z, r16
	;
	m_restore_r16_r23_Z_SREG_registers

	ret

.macro m_timer2_interrupts_enable
	m_timer_w_pwm_base_interrupts_enable timer2_static_instance
.endm
timer2_interrupts_enable:
	m_save_Z_registers
	ldi ZL, low(timer2_static_instance)
	ldi ZH, high(timer2_static_instance)

	rcall timer_w_pwm_base_interrupts_enable

	m_restore_Z_registers

	ret

.macro m_timer2_interrupts_disable
	m_timer_w_pwm_base_interrupts_disable timer2_static_instance
.endm
timer2_interrupts_disable:
	m_save_Z_registers
	ldi ZL, low(timer2_static_instance)
	ldi ZH, high(timer2_static_instance)

	rcall timer_w_pwm_base_interrupts_disable

	m_restore_Z_registers

	ret

.macro m_timer2_interrupt_overflow_enable
	m_timer_w_pwm_base_interrupt_overflow_enable timer2_static_instance
.endm
timer2_interrupt_overflow_enable:
	m_save_Z_registers
	ldi ZL, low(timer2_static_instance)
	ldi ZH, high(timer2_static_instance)

	rcall timer_w_pwm_base_interrupt_overflow_enable	

	m_restore_Z_registers

	ret

.macro m_timer2_interrupt_overflow_disable
	m_timer_w_pwm_base_interrupt_overflow_disable timer2_static_instance
.endm
timer2_interrupt_overflow_disable:
	m_save_Z_registers
	ldi ZL, low(timer2_static_instance)
	ldi ZH, high(timer2_static_instance)

	rcall timer_w_pwm_base_interrupt_overflow_disable

	m_restore_Z_registers
	
	ret

.macro m_timer2_counter_get_value
	; returns:
	;	@0	reg	register with current counter value
	m_timer_w_pwm_base_counter_get_value timer2_static_instance, @0
.endm
timer2_counter_get_value:
	m_save_Z_registers
	; returns:
	;	r23	counter value
	ldi ZL, low(timer2_static_instance)
	ldi ZH, high(timer2_static_instance)

	rcall timer_w_pwm_base_counter_get_value

	m_restore_Z_registers

	ret

timer2_ovf_handler:
	m_save_r23_Y_Z_registers

	ldi ZL, low(timer2_static_instance)
	ldi ZH, high(timer2_static_instance)
	ldi r23, ST_TIMER2_OVERFLOW_HANDLER_OFFSET

	rcall device_raise_event

	m_restore_r23_Y_Z_registers

	reti

timer2_comp_handler:
	m_save_r23_Y_Z_registers

	ldi ZL, low(timer2_static_instance)
	ldi ZH, high(timer2_static_instance)
	ldi r23, ST_TIMER2_COMPARE_HANDLER_OFFSET

	rcall device_raise_event

	m_restore_r23_Y_Z_registers

	reti