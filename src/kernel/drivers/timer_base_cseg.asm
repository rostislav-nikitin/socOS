;.include "m8def.inc"
.macro m_timer_base_init
	; parameters:
	;	@0	[st_timer]
	;	@1	[TCCRx]		timer counter control register
	;	@2	[TCNTx]		timer counter register
	;	@3	timer_divider	timer divider
	;	@4	byte		interrupt_bit_mask
	;	@5	word		overflow handler
	m_save_r22_r23_r24_r25_X_Y_Z_registers

	ldi ZL, low(@0)
	ldi ZH, high(@0)
	ldi YL, low(@1 + IO_PORTS_OFFSET)
	ldi YH, high(@1 + IO_PORTS_OFFSET)
	ldi XL, low(@2 + IO_PORTS_OFFSET)
	ldi XH, high(@2 + IO_PORTS_OFFSET)
	ldi r23, @3
	ldi r22, @4
	ldi r24, low(@5)
	ldi r25, high(@5)

	rcall timer_base_init
	;
	m_restore_r22_r23_r24_r25_X_Y_Z_registers
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

	ldi r23, ST_TIMER_BASE_OVERFLOW_INTERRUPT_BIT_MASK_OFFSET
	rcall set_struct_byte

	push YL
	push YH
	mov YL, XL
	mov YH, XH
	ldi r23, ST_TIMER_BASE_COUNTER_REGISTER_ADDRESS_OFFSET
	rcall set_struct_word
	pop YH
	pop YL

	push YL
	push YH
	mov YL, r24
	mov YH, r25
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
	m_timer_base_interrupt_overflow_enable @0
.endm

timer_base_interrupts_enable:
	rcall timer_base_interrupt_overflow_enable

	ret

.macro m_timer_base_interrupts_disable
	; parameters:
	;	@0	[st_timer]
	m_timer_base_interrupt_overflow_disable @0
.endm

timer_base_interrupts_disable:
	rcall timer_base_interrupt_overflow_disable

	ret

.macro m_timer_base_interrupt_overflow_enable
	; parameters:
	;	@0	[st_timer]
	m_save_Z_registers

	ldi ZL, low(@0)
	ldi ZH, high(@0)

	rcall timer_base_interrupt_overflow_enable

	m_restore_Z_registers
.endm

timer_base_interrupt_overflow_enable:
	m_save_r16_r23_SREG_registers

	ldi r23, ST_TIMER_BASE_OVERFLOW_INTERRUPT_BIT_MASK_OFFSET
	rcall get_struct_byte

	in r16, TIMSK
	or r16, r23
	out TIMSK, r16

	m_restore_r16_r23_SREG_registers	
	
	ret

.macro m_timer_base_interrupt_overflow_disable
	; parameters:
	;	@0	[st_timer]
	m_save_Z_registers

	ldi ZL, low(@0)
	ldi ZH, high(@0)

	rcall timer_base_interrupt_overflow_disable

	m_restore_Z_registers
.endm

timer_base_interrupt_overflow_disable:
	m_save_r16_r23_SREG_registers

	ldi r23, ST_TIMER_BASE_OVERFLOW_INTERRUPT_BIT_MASK_OFFSET
	rcall get_struct_byte

	com r23
	in r16, TIMSK
	and r16, r23
	out TIMSK, r16

	m_restore_r16_r23_SREG_registers	
	
	ret

.macro m_timer_base_counter_get_value
	; parameters:
	;	@0	[st_timer]
	; returns
	;	@1	register	register with current counter value
	m_save_r23_Z_registers

	ldi ZL, low(@0)
	ldi ZH, high(@0)

	rcall timer_base_counter_get_value

	mov @1, r23

	m_restore_r23_Z_registers
.endm

timer_base_counter_get_value:
	m_save_Z_registers

	ldi r23, ST_TIMER_BASE_COUNTER_REGISTER_ADDRESS_OFFSET
	rcall get_struct_word

	ld r23, Z

	m_restore_Z_registers

	ret
