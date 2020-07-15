;.include "m8def.inc"
.macro m_timer2_base_init
	; parameters:
	;	@3	timer_divider	timer divider
	;	@4	byte		interrupt_overflow_bit_mask
	;	@5	word		overflow handler
	;	@6	byte		mode
	;	@7	byte		compare threshold
	;	@8	byte		compare_interrupt_bit_mask
	;	@9	word		compare handler
	m_timer_w_pwm_base_init timer2_static_instance, TCCR2, OCR2, @0, (1 << TOIE2), @5, @6, @7, (1 << OCIE2), @9
	;
	m_restore_r22_r23_X_Y_Z_registers
.endm

timer2_base_init:
	push r23
	ldi r23, ST_TIMER_W_PWM_BASE_COMPARE_CONTROL_REGISTER_ADDRESS_OFFSET
	rcall set_struct_word
	pop r23

	push r22
	mov r22, r23
	ldi r23, ST_TIMER_W_PWM_BASE_MODE_OFFSET
	rcall set_struct_byte
	pop r22

	ldi r23, ST_TIMER_W_PWM_BASE_COMPARE_THRESHOLD_OFFSET
	rcall set_struct_byte

	push r22
	mov r22, r23
	ldi r23, ST_TIMER_W_PWM_BASE_MODE_OFFSET
	rcall set_struct_byte
	pop r22

	push YL
	push YH
	mov YL, XL
	mov YH, XH
	ldi r23, ST_TIMER_W_PWM_BASE_COMPARE_HANDLER_OFFSET
	rcall set_struct_word
	pop YH
	pop YL

	rcall timer_w_pwm_base_init_ports

	ret

timer2_base_init_ports:
	; init divider

	rcall timer_w_pwm_base_init_ports_ocr
	; rcall timer2_base_init_ports_mode
	ret

timer2_base_init_ports_ocr:
	m_save_r23_Z_SREG_registers

	ldi r23, ST_TIMER_W_PWM_BASE_COMPARE_THRESHOLD_OFFSET
	rcall get_struct_byte

	push r23

	ldi r23, ST_TIMER_W_PWM_BASE_COMPARE_CONTROL_REGISTER_ADDRESS_OFFSET
	rcall get_struct_word

	pop r23

	st Z, r23

	m_restore_r23_Z_SREG_registers

	ret

;timer2_base_init_ports_mode:
;	ret

.macro timer2_base_interrupts_enable
	m_timer_w_pwm_base_interrupts_enable timer2_static_instance
.endm

timer2_base_interrupts_enable:
	rcall timer_w_pwm_base_interrupts_enable

	ret

.macro timer2_base_interrupts_disable
	m_timer_w_pwm_base_interrupts_disable timer2_static_instance
.endm

timer2_base_interrupts_disable:
	rcall timer_w_pwm_base_interrupts_disable

	ret

 .macro m_timer2_base_interrupt_overflow_enable
	m_timer_base_interrupt_overflow_enable timer2_static_instance
.endm

timer2_base_interrupt_overflow_enable:
	rcall timer_base_interrupt_overflow_enable	

	ret

.macro m_timer2_base_interrupt_overflow_disable
	m_timer_w_pwm_base_interrupt_overflow_disable timer2_static_instance
.endm

timer2_base_interrupt_overflow_disable:
	rcall timer_w_pwm_base_interrupt_overflow_disable
	
	ret

timer2_comp_handler:
	reti

timer2_ovf_handler:
	reti