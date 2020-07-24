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

.macro m_timer0_init
	; parameters:
	;	@0	byte	TIMER_DIVIDER
	;	@1	word	[on_overflow_handler]
	m_timer_base_init timer0_static_instance, TCCR0, TCNT0, @0, (1 << TOIE0), @1
	rcall timer0_init
.endm

timer0_init:
	ret

.macro m_timer0_interrupts_enable
	m_timer_base_interrupts_enable timer0_static_instance
.endm

timer0_interrupts_enable:
	rcall timer_base_interrupts_enable

	ret

.macro m_timer0_interrupts_disable
	m_timer_base_interrupts_disable timer0_static_instance
.endm

timer0_interrupts_disable:
	rcall timer_base_interrupts_disable

	ret

.macro m_timer0_interrupt_overflow_enable
	m_timer_base_interrupt_overflow_enable timer0_static_instance
.endm

timer0_interrupt_overflow_enable:
	rcall timer_base_interrupt_overflow_enable

	ret

.macro m_timer0_interrupt_overflow_disable
	m_timer_base_interrupt_overflow_disable timer0_static_instance
.endm

timer0_interrupt_overflow_disable:
	rcall timer_base_interrupt_overflow_disable

	ret


.macro m_timer0_counter_get_value
	; returns:
	;	@0	reg	register with current counter value
	m_timer_base_counter_get_value timer0_static_instance, @0
.endm

timer0_counter_get_value:
	m_save_Z_registers
	; returns:
	;	r23	byte	counter value
	ldi ZL, low(timer0_static_instance)
	ldi ZH, high(timer0_static_instance)

	rcall timer_base_counter_get_value

	m_restore_Z_registers

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