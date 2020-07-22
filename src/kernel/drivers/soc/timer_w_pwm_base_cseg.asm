;.include "m8def.inc"
.macro m_timer_w_pwm_base_init
	; parameters:
	;	@0	[st_timer]
	;	@1	[TCCRx]			timer counter control register
	;	@2	[TCNTx]			timer counter register
	;	@3	[OCRx]			compare control register
	;	@4	timer_divider	timer divider
	;	@5	byte			interrupt_bit_mask
	;	@6	word			overflow handler
	;	@7	word			PWM_[DDRx]
	;	@8	byte			PWM_bit_mask
	;	@9	byte			mode
	;	@10	byte			compare threshold
	;	@11	byte			compare interrupt bit mask
	;	@12	word			compare handler
	m_save_r21_r22_r23_X_Y_Z_registers

	m_timer_base_init @0, @1, @2, @4, @5, @6

	ldi ZL, low(@0)
	ldi ZH, high(@0)
	ldi YL, low(@3 + IO_PORTS_OFFSET)
	ldi YH, high(@3 + IO_PORTS_OFFSET)
	ldi r24, low(@7 + IO_PORTS_OFFSET)
	ldi r25, high(@7 + IO_PORTS_OFFSET)
	ldi r20, @8
	ldi r23, @9
	ldi r22, @10
	ldi r21, @11
	ldi XL, low(@12)
	ldi XH, high(@12)

	rcall timer_w_pwm_base_init
	;
	m_restore_r21_r22_r23_X_Y_Z_registers
.endm

timer_w_pwm_base_init:
	m_save_r22_r23_Y_registers

	push r22
	mov r22, r23
	ldi r23, ST_TIMER_W_PWM_BASE_MODE_OFFSET
	rcall set_struct_byte
	pop r22

	ldi r23, ST_TIMER_W_PWM_BASE_COMPARE_CONTROL_REGISTER_ADDRESS_OFFSET
	rcall set_struct_word

	ldi r23, ST_TIMER_W_PWM_BASE_COMPARE_THRESHOLD_OFFSET
	rcall set_struct_byte

	mov r22, r21
	ldi r23, ST_TIMER_W_PWM_BASE_COMPARE_INTERRUPT_BIT_MASK_OFFSET
	rcall set_struct_byte

	mov r22, r20
	ldi r23, ST_TIMER_W_PWM_BASE_DDRX_BIT_MASK_OFFSET
	rcall set_struct_byte

	mov YL, r24
	mov YH, r25
	ldi r23, ST_TIMER_W_PWM_BASE_DDRX_ADDRESS_OFFSET
	rcall set_struct_word

	mov YL, XL
	mov YH, XH
	ldi r23, ST_TIMER_W_PWM_BASE_COMPARE_HANDLER_OFFSET
	rcall set_struct_word

	rcall timer_w_pwm_base_init_ports_ocr
	rcall timer_w_pwm_base_init_ports_ddrx

	m_restore_r22_r23_Y_registers

	ret

timer_w_pwm_base_init_ports_ocr:
	rcall timer_w_pwm_base_compare_control_register_set_compare_threshold

	ret

.macro m_timer_w_pwm_base_compare_threshold_set
	; parameters:
	;	@0	[st_timer]
	;	@1	byte		compare threshold
	m_save_r23_Z_regisrers

	ldi ZL, low(@0)
	ldi ZH, high(@0)
	ldi r23, @1

	rcall timer_w_pwm_base_compare_threshold_set
        	
	m_restore_r23_Z_registers
.endm
timer_w_pwm_base_compare_threshold_set:
	m_save_r22_r23_registers

	mov r22, r23
	ldi r23, ST_TIMER_W_PWM_BASE_COMPARE_THRESHOLD_OFFSET
	rcall set_struct_byte

	;mov r23, r22
	;rcall timer_w_pwm_base_compare_register_set

	m_restore_r22_r23_registers

	ret

.macro m_timer_w_pwm_base_compare_control_register_set_compare_threshold
	; parameters:
	;	@0	[st_timer]
	m_save_Z_regisrers

	ldi ZL, low(@0)
	ldi ZH, high(@0)

	rcall timer_w_pwm_base_compare_control_register_set_compare_threshold
        	
	m_restore_Z_registers
.endm
timer_w_pwm_base_compare_control_register_set_compare_threshold:
	m_save_r23_registers

	ldi r23, ST_TIMER_W_PWM_BASE_COMPARE_THRESHOLD_OFFSET
	rcall get_struct_byte

	rcall timer_w_pwm_base_compare_control_register_set

	m_restore_r23_registers

	ret

timer_w_pwm_base_compare_control_register_set:
	m_save_r23_Z_registers

	push r23

	ldi r23, ST_TIMER_W_PWM_BASE_COMPARE_CONTROL_REGISTER_ADDRESS_OFFSET
	rcall get_struct_word

	pop r23

	st Z, r23

	m_restore_r23_Z_registers

	ret

timer_w_pwm_base_init_ports_ddrx:
	m_save_r16_r23_Z_SREG_registers

	ldi r23, ST_TIMER_W_PWM_BASE_DDRX_BIT_MASK_OFFSET
	rcall get_struct_byte
	mov r16, r23

	ldi r23, ST_TIMER_W_PWM_BASE_DDRX_ADDRESS_OFFSET
	rcall get_struct_word
	ld r23, Z
	or r23, r16
	st Z, r23

	m_restore_r16_r23_Z_SREG_registers

	ret

.macro m_timer_w_pwm_base_interrupts_enable
	; parameters:
	;	@0	[st_timer]
	m_timer_base_interrupts_enable @0
	m_timer_w_pwm_base_interrupt_compare_enable @0
.endm

timer_w_pwm_base_interrupts_enable:
	rcall timer_base_interrupts_enable
	rcall timer_w_pwm_base_interrupt_compare_enable

	ret

.macro m_timer_w_pwm_base_interrupts_disable
	; parameters:
	;	@0	[st_timer]
	m_timer_base_interrupts_disable @0
	m_timer_w_pwm_base_interrupt_compare_disable @0
.endm

timer_w_pwm_base_interrupts_disable:
	rcall timer_base_interrupts_disable
	rcall timer_w_pwm_base_interrupt_compare_disable

	ret

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

timer_w_pwm_base_interrupt_overflow_disable:
	rcall timer_base_interrupt_overflow_disable
	
	ret
.macro m_timer_w_pwm_base_interrupt_compare_enable
	; parameters:
	;	@0	[st_timer]
	m_save_Z_registers

	ldi ZL, low(@0)
	ldi ZH, high(@0)

	rcall timer_w_pwm_base_interrupt_compare_enable

	m_restore_Z_registers
.endm

timer_w_pwm_base_interrupt_compare_enable:
	m_save_r16_r23_Z_SREG_registers

	ldi r23, ST_TIMER_W_PWM_BASE_COMPARE_INTERRUPT_BIT_MASK_OFFSET
	rcall get_struct_byte

	in r16, TIMSK
	or r16, r23
	out TIMSK, r16

	m_restore_r16_r23_Z_SREG_registers

	ret

.macro m_timer_w_pwm_base_interrupt_compare_disable
	; parameters:
	;	@0	[st_timer]
		m_save_Z_registers

	ldi ZL, low(@0)
	ldi ZH, high(@0)

	rcall timer_w_pwm_base_interrupt_compare_disable

	m_restore_Z_registers
.endm

timer_w_pwm_base_interrupt_compare_disable:
	m_save_r16_r23_Z_SREG_registers

	ldi r23, ST_TIMER_W_PWM_BASE_COMPARE_INTERRUPT_BIT_MASK_OFFSET
	rcall get_struct_byte
	com r23

	in r16, TIMSK
	and r16, r23
	out TIMSK, r16

	m_restore_r16_r23_Z_SREG_registers
	
	ret

.macro m_timer_w_pwm_base_counter_get_value
	; parameters
	;	@0	[st_timer_w_pwm_base]
	; returns:
	;	@1	register	register with current counter value
	m_timer_base_counter_get_value @0, @1
.endm

timer_w_pwm_base_counter_get_value:
	m_save_Z_registers
	; parameters:
	;	Z	word	[st_timer_w_pwm_base]
	; returns:
	;	r23	counter value

	rcall timer_base_counter_get_value

	m_restore_Z_registers

	ret
