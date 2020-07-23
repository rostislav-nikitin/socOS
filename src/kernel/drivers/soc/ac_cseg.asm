;=======================================================================================================================
;                                                                                                                      ;
; Name:	socOS (System On Chip Operation System)                                                                        ;
; 	Year: 		2020                                                                                           ;
; 	License:	MIT License                                                                                    ;
;                                                                                                                      ;
;=======================================================================================================================

; Require:
;.include "m8def.inc"

;.include "kernel/device_def.asm"

;.include "kernel/device_cseg.asm"

.macro m_ac_init
	; parameters:
	;	@0	byte	AC_INPUT_NEGATIVE
	;	@1	byte	AC_INPUT_POSITIVE
	;	@2	byte	AC_INTERRPUT_MODE
	;	@3	word	[on_completed_handler]
	m_save_r21_r22_r23_Y_Z_registers
	m_device_init
	;
	ldi ZL, low(ac_static_instance)
	ldi ZH, high(ac_static_instance)
	ldi r23, @0
	ldi r22, @1
	ldi r21, @2	
	ldi YL, low(@3)
	ldi YH, high(@3)
	;
	rcall ac_init
	;
	m_restore_r21_r22_r23_Y_Z_registers
.endm

ac_init:
	; parameters:
	;	Z	word	[st_ac]
	;	Y	word	[on_completed_handler]
	;	r23	byte	AC_INPUT_NEGATIVE
	;	r22	byte	AC_INPUT_POSITIVE
	;	r21	byte	AC_INTERRPUT_MODE
	m_save_r22_r23_registers
	;
	push r23
	ldi r23, ST_AC_INPUT_POSITIVE
	rcall set_struct_byte
	pop r23

	mov r22, r23
	ldi r23, ST_AC_INPUT_NEGATIVE
	rcall set_struct_byte

	mov r22, r21
	ldi r23, ST_AC_INTERRPUT_MODE_ARISE
	rcall set_struct_byte

	ldi r23, ST_AC_ON_COMPLETED_HANDLER_OFFSET
	rcall set_struct_word

	rcall ac_init_ports
	;
	m_restore_r22_r23_registers

	ret

ac_init_ports:
	; parameters:
	;	Z	word	[st_ac]
	m_save_r16_SREG_registers

	ldi r23, ST_AC_INPUT_NEGATIVE
	rcall get_struct_byte

	ac_init_ports_input_negative_check:
		cpi r23, AC_INPUT_NEGATIVE_A_IN1
		brne ac_init_ports_input_negative_set_mux
		ac_init_ports_input_negative_set_a_in1:
			; set ACME
			in r16, SFIOR
			andi r16, ~(1<< ACME)
			out SFIOR, r16
			; set IN mode for the DDRD BIT7
			cbi DDRD, BIT7
			; unpull up PORTD7 from the Vcc
			cbi PORTD, BIT7
			rjmp ac_init_ports_input_positive_check
		ac_init_ports_input_negative_set_mux:
			; set ACME
			in r16, SFIOR
			ori r16, (1<< ACME)
			out SFIOR, r16
			; set ADMUX
			in r16, ADMUX
			; reset 0 bits
			andi r16, ~((1 << MUX2) | (1 << MUX1) | (1 << MUX0))
			; set 1 bits
			or r16, r23
			out ADMUX, r16
			; set DDRC
			rcall int_to_mask
			in r16, DDRC
			com r23
			and r16, r23
			out DDRC, r16
			;com r23
			in r16, PORTC
			;or r16, r23
			and r16, r23
			out PORTC, r16

	ac_init_ports_input_positive_check:
		ldi r23, ST_AC_INPUT_POSITIVE
		rcall get_struct_byte

		cpi r23, AC_INPUT_POSITIVE_A_IN0
		brne ac_init_ports_input_positive_vref_1_23_v
		ac_init_ports_input_positive_in0:
			in r16, ACSR 
			; reset ACBG
			andi r16, ~(1 << ACBG)
			out ACSR, r16
			; set DDRD to IN for BIT6
			cbi DDRD, BIT6
			; unpull-up PORTD BIT6 from the Vcc
			cbi PORTD, BIT6
			rjmp ac_init_ports_interrupt_mode_arise_check

		ac_init_ports_input_positive_vref_1_23_v:
			in r16, ACSR 
			; reset ACBG
			ori r16, (1 << ACBG)
			out ACSR, r16

	ac_init_ports_interrupt_mode_arise_check:
		ldi r23, ST_AC_INPUT_NEGATIVE
		rcall get_struct_byte

		in r16, ACSR
		andi r16, ~((1 << ACIS0) | (1 << ACIS1))
		or r16, r23
		out ACSR, r16
	
	m_restore_r16_SREG_registers
	ret

.macro m_ac_enable	
	rcall ac_enable
.endm
ac_enable:
	cbi ACSR, ACD
	cbi ADCSRA, ADEN

	ret

.macro m_ac_disable	
	rcall ac_disable
.endm
ac_disable:
	sbi ACSR, ACD

	ret

.macro m_ac_interrupts_enable	
	rcall ac_interrupts_enable
.endm
ac_interrupts_enable:
	sbi ACSR, ACIE

	ret

.macro m_ac_interrupts_disable	
	rcall ac_interrupts_disable
.endm
ac_interrupts_disable:
	cbi ACSR, ACIE

	ret
.macro m_ac_timer1_capture_enable	
	rcall ac_timer1_capture_enable
.endm
ac_timer1_capture_enable:
	sbi ACSR, ACIC

	ret

.macro m_ac_timer1_capture_disable	
	rcall ac_timer1_capture_disable
.endm
ac_timer1_capture_disable:
	cbi ACSR, ACIC

	ret

.macro m_ac_output_value_get	
	; returns:
	; 	@0	byte	comparator output value
	m_save_r23_registers
	rcall ac_output_value_get
	mov @0, r23
	m_restore_r23_registers
.endm
ac_output_value_get:
	; returns:
	; 	r23	byte	comparator output value
	sbis ACSR, ACO
	rjmp ac_output_value_get_false
	ac_output_value_get_true:
		ldi r23, AC_OUTPUT_VALUE_TRUE
		rjmp ac_output_value_get_end
	ac_output_value_get_false:
		ldi r23, AC_OUTPUT_VALUE_FALSE

	ac_output_value_get_end:

	ret

ac_completed_handler:
	; returns:
	; 	YL	byte	AC_OUTPUT_VALUE
	m_save_r23_Y_Z_registers

	; get current value
	rcall ac_output_value_get
	mov YL, r23

	; get [handler]
	ldi r23, ST_AC_ON_COMPLETED_HANDLER_OFFSET
	ldi ZL, low(ac_static_instance)
	ldi ZH, high(ac_static_instance)

	; raise event
	rcall device_raise_event
	;
	m_restore_r23_Y_Z_registers
	
	reti