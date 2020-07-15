;.include "m8def.inc"
.macro m_timer_w_pwm_base_init
	; parameters:
	;	@0	[st_timer]
	;	@1	[TCCRx]		timer counter control register
	;	@2	[OCRx]		compare control register
	;	@3	timer_divider	timer divider
	;	@4	byte		interrupt_bit_mask
	;	@5	word		overflow handler
	;	@6	byte		mode
	;	@7	byte		compare threshold
	;	@8	byte		compare interrupt bit mask
	;	@9	word		compare handler
	m_save_r21_r22_r23_X_Y_Z_registers

	m_timer_base_init @0, @1, @3, @4, @5

	ldi ZL, low(@0)
	ldi ZH, high(@0)
	ldi YL, low(@2 + IO_PORTS_OFFSET)
	ldi YH, high(@2 + IO_PORTS_OFFSET)
	ldi r23, @6
	ldi r22, @7
	ldi r21, @8
	ldi XL, low(@9)
	ldi XH, high(@9)

	rcall timer_w_pwm_base_init
	;
	m_restore_r21_r22_r23_X_Y_Z_registers
.endm

timer_w_pwm_base_init:
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
	mov r22, r21
	ldi r23, ST_TIMER_W_PWM_BASE_COMPARE_INTERRUPT_BIT_MASK_OFFSET
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

timer_w_pwm_base_init_ports:
	; init divider

	rcall timer_w_pwm_base_init_ports_ocr
	; rcall timer_w_pwm_base_init_ports_mode
	ret

timer_w_pwm_base_init_ports_ocr:
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

;timer_w_pwm_base_init_ports_mode:
;	ret

.macro timer_w_pwm_base_interrupts_enable
	; parameters:
	;	@0	[st_timer]
	m_timer_base_interrupts_enable @0
	m_timer_w_pwm_base_interrupt_compare_enable @0
.endm

timer_w_pwm_base_interrupts_enable:
	rcall timer_base_interrupts_enable
	rcall timer_w_pwm_base_interrupt_compare_enable

	ret

.macro timer_w_pwm_base_interrupts_disable
	; parameters:
	;	@0	[st_timer]
	m_timer_base_interrupts_disable @0
	m_timer_w_pwm_base_interrupt_compare_disable @0
.endm

timer_w_pwm_base_interrupts_disable:
	rcall timer_base_interrupts_disable
	rcall timer_w_pwm_base_interrupt_compare_disable

	ret

.macro timer_w_pwm_base_interrupt_overflow_enable
	; parameters:
	;	@0	[st_timer]
	m_timer_base_interrupt_overflow_enable @0
.endm

.macro m_timer_w_pwm_base_interrupt_overflow_enable
	; parameters:
	;	@0	[st_timer]
	m_timer_base_interrupt_overflow_enable @0
.endm

timer_w_pwm_base_interrupt_overflow_enable:
	rcall timer_base_interrupt_overflow_enable	

	ret

.macro m_timer_w_pwm_base_interrupt_overflow_disable
	; parameters:
	;	@0	[st_timer]
	m_timer_base_interrupt_overflow_disable @0
.endm

timer_w_pwm_base_interrupt_compare_disable:
	rcall timer_base_interrupt_compare_disable
	
	ret
.macro m_timer_w_pwm_base_interrupt_compare_enable
	; parameters:
	;	@0	[st_timer]
	m_timer_base_interrupt_compare_enable @0
.endm

timer_w_pwm_base_interrupt_compare_enable:
	rcall timer_base_interrupt_compare_enable	

	ret

.macro m_timer_w_pwm_base_interrupt_compare_disable
	; parameters:
	;	@0	[st_timer]
	m_timer_base_interrupt_compare_disable @0
.endm

timer_w_pwm_base_interrupt_compare_disable:
	rcall timer_base_interrupt_compare_disable
	
	ret
