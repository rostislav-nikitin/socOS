;.include "m8def.inc"
.macro m_timer_base_init
	; parameters:
	;	@0	[st_timer]
	;	@1	[TCCRx]		timer counter control register
	;	@2	timer_divider	timer divider
	;	@3	byte		interrupt_bit_mask
	;	@4	word		overflow handler
	m_save_r22_r23_X_Y_Z_registers

	ldi ZL, low(@0)
	ldi ZH, high(@0)
	ldi YL, low(@1 + IO_PORTS_OFFSET)
	ldi YH, high(@1 + IO_PORTS_OFFSET)
	ldi r23, @2
	ldi r22, @3
	ldi XL, low(@4)
	ldi XH, high(@4)

	rcall timer_base_init
	;
	m_restore_r22_r23_X_Y_Z_registers
.endm

timer_base_init:
	push r23
	ldi r23, ST_TIMER_BASE_COUNTER_CONTROL_REGISTER_ADDRESS_OFFSET
	rcall set_struct_word
	pop r23

	push r22
	mov r22, r23
	ldi r23, ST_TIMER_BASE_DIVIDER_BIT_MASK_OFFSET
	rcall set_struct_byte
	pop r22

	ldi r23, ST_TIMER_BASE_INTERRUPT_BIT_MASK_OFFSET
	rcall set_struct_byte

	push YL
	push YH
	mov YL, XL
	mov YH, XH
	ldi r23, ST_TIMER_BASE_OVERFLOW_HANDLER_OFFSET
	rcall set_struct_word
	pop YH
	pop YL

	rcall timer_base_init_ports

	ret

timer_base_init_ports:
	; init divider
	m_save_r23_Z_SREG_registers

	ldi r23, ST_TIMER_BASE_DIVIDER_BIT_MASK_OFFSET
	rcall get_struct_byte

	push r23

	ldi r23, ST_TIMER_BASE_COUNTER_CONTROL_REGISTER_ADDRESS_OFFSET
	rcall get_struct_word

	pop r23

	st Z, r23

	m_restore_r23_Z_SREG_registers

	ret


.macro m_timer_base_interrupts_enable
	; parameters:
	;	@0	[st_timer]
	m_save_Z_registers

	ldi ZL, low(@0)
	ldi ZH, high(@0)

	rcall timer_base_interrupts_enable

	m_restore_Z_registers
.endm

timer_base_interrupts_enable:
	m_save_r16_r23_SREG_registers

	ldi r23, ST_TIMER_BASE_INTERRUPT_BIT_MASK_OFFSET
	rcall get_struct_byte

	in r16, TIMSK
	or r16, r23
	out TIMSK, r16

	m_restore_r16_r23_SREG_registers	
	
	ret

.macro m_timer_base_interrupts_disable
	; parameters:
	;	@0	[st_timer]
	m_save_Z_registers

	ldi ZL, low(@0)
	ldi ZH, high(@0)

	rcall timer_base_interrupts_disable

	m_restore_Z_registers
.endm

timer_base_interrupts_disable:
	m_save_r16_r23_SREG_registers

	ldi r23, ST_TIMER_BASE_INTERRUPT_BIT_MASK_OFFSET
	rcall get_struct_byte

	com r23
	in r16, TIMSK
	and r16, r23
	out TIMSK, r16

	m_restore_r16_r23_SREG_registers	
	
	ret
