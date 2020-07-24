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

;.include "kernel/kernel_cseg.asm"
;.include "kernel/drivers/device_cseg.asm"

.macro m_timer_base_init
	; parameters:
	;	@0	[st_timer]
	;	@1	[TCCRx]		timer counter control register
	;	@2	[TCNTx]		timer counter register
	;	@3	timer_divider	TIMER_DIVIDER
	;	@4	byte		interrupt_bit_mask
	;	@5	word		[on_overflow_handler]
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
	; parameters
	;	Z	[st_timer_base]
	;	Y	[TCCRx]
	;	X	[TCNTx]
	;	r23	TIMER_DIVIDER
	;	r22	interrupt bit mask
	;	r24,r25	[on_overflow_handler]
	rcall device_init

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
	; parameters
	;	Z	[st_timer_base]
	rcall timer_base_counter_set_divider

	ret

timer_base_counter_set_divider:
	; parameters
	;	Z	[st_timer_base]
	m_save_r23_registers

	ldi r23, ST_TIMER_BASE_DIVIDER_BIT_MASK_OFFSET
	rcall get_struct_byte

	rcall timer_base_counter_set

	m_restore_r23_registers

	ret

timer_base_counter_set_disabled:
	; parameters
	;	Z	[st_timer_base]
	m_save_r23_registers

	ldi r23, TIMER_DIVIDER_CLOCK_DISABLED

	rcall timer_base_counter_set

	m_restore_r23_registers

	ret

timer_base_counter_set:
	; parameters
	;	Z	[st_timer_base]
	;	r23	TIMER_DIVIDER_CLOCK
	m_save_r23_Z_registers

	push r23

	ldi r23, ST_TIMER_BASE_COUNTER_CONTROL_REGISTER_ADDRESS_OFFSET
	rcall get_struct_word

	pop r23

	st Z, r23

	m_restore_r23_Z_registers

	ret


.macro m_timer_base_interrupts_enable
	; parameters:
	;	@0	[st_timer_base]
	m_timer_base_interrupt_overflow_enable @0
.endm

timer_base_interrupts_enable:
	; parameters
	;	Z	[st_timer_base]
	rcall timer_base_interrupt_overflow_enable

	ret

.macro m_timer_base_interrupts_disable
	; parameters:
	;	@0	[st_timer_base]
	m_timer_base_interrupt_overflow_disable @0
.endm

timer_base_interrupts_disable:
	; parameters
	;	Z	[st_timer_base]
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
	; parameters
	;	Z	[st_timer_base]
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
	;	@0	[st_timer_base]
	m_save_Z_registers

	ldi ZL, low(@0)
	ldi ZH, high(@0)

	rcall timer_base_interrupt_overflow_disable

	m_restore_Z_registers
.endm

timer_base_interrupt_overflow_disable:
	; parameters
	;	Z	[st_timer_base]
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
	;	@0	[st_timer_base]
	; returns
	;	@1	reg		register with current counter value
	m_save_r23_Z_registers

	ldi ZL, low(@0)
	ldi ZH, high(@0)

	rcall timer_base_counter_get_value

	mov @1, r23

	m_restore_r23_Z_registers
.endm

timer_base_counter_get_value:
	; parameters:
	;	Z	word	[st_timer_base]
	; returns:
	;	r23	byte	counter value
	m_save_Z_registers

	ldi r23, ST_TIMER_BASE_COUNTER_REGISTER_ADDRESS_OFFSET
	rcall get_struct_word

	ld r23, Z

	m_restore_Z_registers

	ret