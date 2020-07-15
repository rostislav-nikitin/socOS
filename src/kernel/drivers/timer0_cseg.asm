;.include "m8def.inc"
.macro m_timer0_init
	; parameters:
	;	@0	timer_divider	timer divider
	;	@1	word		overflow handler
	m_timer_base_init timer0_static_instance, TCCR0, TCNT0, @0, (1 << TOIE0), @1
	rcall timer0_init
.endm

timer0_init:
	ret

.macro m_timer0_interrupts_enable
	; parameters:
	;	@0	[st_timer]
	m_timer_base_interrupts_enable timer0_static_instance
.endm

timer0_interrupts_enable:
	rcall timer_base_interrupts_enable

	ret

.macro m_timer0_interrupts_disable
	; parameters:
	;	@0	[st_timer]
	m_timer_base_interrupts_disable timer0_static_instance
.endm

timer0_interrupts_disable:
	rcall timer_base_interrupts_disable

	ret

.macro m_timer0_interrupt_overflow_enable
	; parameters:
	;	@0	[st_timer]
	m_timer_base_interrupt_overflow_enable timer0_static_instance
.endm

timer0_interrupt_overflow_enable:
	rcall timer_base_interrupt_overflow_enable

	ret

.macro m_timer0_interrupt_overflow_disable
	; parameters:
	;	@0	[st_timer]
	m_timer_base_interrupt_overflow_disable timer0_static_instance
.endm

timer0_interrupt_overflow_disable:
	rcall timer_base_interrupt_overflow_disable

	ret


.macro m_timer0_counter_get_value
	; returns:
	;	@0	register	register with current counter value
	m_timer_base_counter_get_value timer0_static_instance, @0
.endm

timer0_counter_get_value:
	rcall timer_base_counter_get_value

	ret

timer0_ovf_handler:
	m_save_r23_Y_Z_SREG_registers

	ldi ZL, low(timer0_static_instance)
	ldi ZH, high(timer0_static_instance)
	ldi r23, ST_TIMER0_OVERFLOW_HANDLER_OFFSET
	rcall get_struct_word
	m_set_Y_to_null_pointer
	rcall cpw
	breq timer0_ovf_handler_end
	icall

	timer0_ovf_handler_end:

	m_restore_r23_Y_Z_SREG_registers

	reti
