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

;ADCSRA:
;	ADEN - enable/disable
;	ADFR - continuous measure
;	ADSC - start convertion (single measure)
;	ADIE - interrupt enable
;ADMUX

.macro m_adc_init
	; parameters:
	;	@0	byte	ADC_INPUT_NEGATIVE
	;	@1	byte	ADC_INPUT_POSITIVE
	;	@2	byte	ADC_FREQUENCY
	;	@3	byte	ADC_OUTPUT_VALUE_ORDER
	;	@4	byte	ADC_CONTINUOUS_MEASUREMENT
	;	@5	word	[adc_on_completed_handler]
	m_save_r20_r21_r22_r23_Y_Z_registers
	;
	m_device_init
	;
	ldi ZL, low(adc_static_instance)
	ldi ZH, high(adc_static_instance)
	ldi r23, @0
	ldi r22, @1
	ldi r21, @2
	ldi r20, @3
	ldi r19, @4
	ldi YL, low(@5)
	ldi YH, high(@5)
	;
	rcall adc_init
	;
	m_restore_r20_r21_r22_r23_Y_Z_registers
.endm

adc_init:
	; parameters:
	;	Z	word	[st_adc]
	;	r23	byte	ADC_INPUT_NEGATIVE
	;	r22	byte	ADC_INPUT_POSITIVE
	;	r21	byte	ADC_FREQUENCY
	;	r20	byte	ADC_OUTPUT_VALUE_ORDER
	;	r19	byte	ADC_CONTINUOUS_MEASUREMENT
	;	Y	word	[adc_on_completed_handler]
	m_save_r22_r23_registers
	;
	push r23
	ldi r23, ST_ADC_INPUT_POSITIVE
	rcall set_struct_byte
	pop r23

	mov r22, r23
	ldi r23, ST_ADC_INPUT_NEGATIVE
	rcall set_struct_byte

	mov r22, r21
	ldi r23, ST_ADC_FREQUENCY
	rcall set_struct_byte

	mov r22, r20
	ldi r23, ST_ADC_OUTPUT_VALUE_ORDER
	rcall set_struct_byte

	mov r22, r19
	ldi r23, ST_ADC_CONTINUOUS_MEASUREMENT
	rcall set_struct_byte

	ldi r23, ST_ADC_ON_COMPLETED_HANDLER_OFFSET
	rcall set_struct_word

	rcall adc_init_ports
	;
	m_restore_r22_r23_registers
            
	ret

adc_init_ports:
	; parameters:
	;	Z	word	[st_adc]
	m_save_r16_r22_r23_SREG_registers

	ldi r23, ST_ADC_INPUT_NEGATIVE
	rcall get_struct_byte

	adc_init_ports_input_negative_set_refs:
		; set ADMUX
		in r16, ADMUX
		; reset 0 bits
		andi r16, ~((1 << REFS1) | (1 << REFS0))
		; shift ST_ADC_INPUT_NEGATIVE value to the REFS0 positions
		ldi r22, REFS0
		rcall lshift
		; add shifted ST_ADC_INPUT_NEGATIVE value to the current ADMUX (value)
		or r16, r23
		; put it back to the [ADMUX]
		out ADMUX, r16

	ldi r23, ST_ADC_INPUT_POSITIVE
	rcall get_struct_byte

	adc_init_ports_input_positive_set_mux:
		in r16, ADMUX
		andi r16, ~((1 << MUX3) | (1 << MUX2) | (1 << MUX1) | (1 << MUX0))
		or r16, r23
		out ADMUX, r16
		; set DDRC corresponding input to IN mode
		rcall int_to_mask
		in r16, DDRC
		com r23
		and r16, r23
		out DDRC, r16
		; set PORTC corresponding input to unpull-up from the Vcc
		in r16, PORTC
		and r16, r23
		out PORTC, r16

	ldi r23, ST_ADC_FREQUENCY
	rcall get_struct_byte

	adc_init_ports_set_frequency:

		in r16, ADCSRA
		andi r16, ~((1 << ADPS2) | (1 << ADPS1) | (1 << ADPS0))
		or r16, r23
		out ADCSRA, r16

	ldi r23, ST_ADC_OUTPUT_VALUE_ORDER
	rcall get_struct_byte

	adc_init_ports_set_output_value_order:
		cpi r23, ADC_OUTPUT_VALUE_ORDER_HIGH_FULL
		breq adc_init_ports_set_output_value_order_high_full

		adc_init_ports_set_output_value_order_low_full:
			cbi ADMUX, ADLAR
			rjmp adc_init_ports_set_continuous_measurement
		adc_init_ports_set_output_value_order_high_full:
			sbi ADMUX, ADLAR
			rjmp adc_init_ports_set_continuous_measurement			

	ldi r23, ST_ADC_CONTINUOUS_MEASUREMENT
	rcall get_struct_byte

	adc_init_ports_set_continuous_measurement:
		cpi r23, ADC_CONTINUOUS_MEASUREMENT_FALSE
		breq adc_init_ports_set_continuous_measurement_false

		adc_init_ports_set_continuous_measurement_true:
			sbi ADCSRA, ADFR
			rjmp adc_init_ports_end
		adc_init_ports_set_continuous_measurement_false:
			cbi ADCSRA, ADFR
			rjmp adc_init_ports_end			

	adc_init_ports_end:
	; disable continuous measurement by default
	; rcall adc_continuous_measurement_disable
	
	m_restore_r16_r22_r23_SREG_registers

	ret

.macro m_adc_enable	
	rcall adc_enable
.endm
adc_enable:
	sbi ADCSRA, ADEN

	ret

.macro m_adc_disable	
	rcall adc_disable
.endm
adc_disable:
	cbi ADCSRA, ADEN

	ret

.macro m_adc_interrupts_enable	
	rcall adc_interrupts_enable
.endm
adc_interrupts_enable:
	sbi ADCSRA, ADIE

	ret

.macro m_adc_interrupts_disable	
	rcall adc_interrupts_disable
.endm
adc_interrupts_disable:
	cbi ADCSRA, ADIE

	ret
.macro m_adc_continuous_measurement_enable
	rcall adc_continuous_measurement_enable
.endm
adc_continuous_measurement_enable:
	m_save_r23_registers

	ldi r23, ADC_CONTINUOUS_MEASUREMENT_TRUE
	rcall adc_continuous_measurement_set

	m_restore_r23_registers

	ret

.macro m_adc_continuous_measurement_disable
	rcall adc_continuous_measurement_disable
.endm
adc_continuous_measurement_disable:
	m_save_r23_registers

	ldi r23, ADC_CONTINUOUS_MEASUREMENT_FALSE
	rcall adc_continuous_measurement_set

	m_restore_r23_registers

	ret

adc_continuous_measurement_get:
	; returns:
	;	r23	byte	ADC_CONTINUOUS_MEASUREMENT
	m_save_Z_registers

	ldi ZL, low(adc_static_instance)
	ldi ZH, high(adc_static_instance)
	ldi r23, ST_ADC_CONTINUOUS_MEASUREMENT

	rcall get_struct_byte

	m_restore_Z_registers

	ret


adc_continuous_measurement_set:
	; returns:
	;	r23	byte	ADC_CONTINUOUS_MEASUREMENT
	m_save_r16_r23_Z_SREG_registers

	ldi ZL, low(adc_static_instance)
	ldi ZH, high(adc_static_instance)
	mov r22, r23
	ldi r23, ST_ADC_CONTINUOUS_MEASUREMENT

	rcall set_struct_byte

	cpi r22, ADC_CONTINUOUS_MEASUREMENT_FALSE
	breq adc_continuous_measurement_set_false
	adc_continuous_measurement_set_true:
		sbi ADCSRA, ADFR
		rjmp adc_continuous_measurement_set_end
	adc_continuous_measurement_set_false:
		cbi ADCSRA, ADFR
		rjmp adc_continuous_measurement_set_end

	adc_continuous_measurement_set_end:

	m_restore_r16_r23_Z_SREG_registers

	ret


.macro m_adc_start_conversion
	rcall adc_start_conversion
.endm
adc_start_conversion:
	sbi ADCSRA, ADSC

	ret

.macro m_adc_conversion_completed_get
	; returns:
	;	@0	register	ADC_CONVERSION_COMPLETED
	m_save_r23_registers
	
	rcall adc_conversion_completed_get
	mov @0, r23

	m_restore_r23_registers
.endm
adc_conversion_completed_get:
	sbis ADCSRA, ADSC
	rjmp adc_conversion_completed_get_false
	adc_conversion_completed_get_true:
		ldi r23, ADC_CONVERSION_COMPLETED_TRUE
		rjmp adc_conversion_completed_get_end

	adc_conversion_completed_get_false:
		ldi r23, ADC_CONVERSION_COMPLETED_FALSE
		rjmp adc_conversion_completed_get_end

	adc_conversion_completed_get_end:

	ret


.macro m_adc_output_value_get	
	; returns:
	; 	@0	reg	low byte of the ADC conversion result
	; 	@1	reg	high byte of the ADC conversion result
	m_save_r22_r23_registers

	rcall adc_output_value_get
	mov @0, r23
	mov @1, r22

	m_restore_r22_r23_registers
.endm
adc_output_value_get:
	; returns:
	; 	r23	byte	low byte of the ADC conversion result
	; 	r22	byte	high byte of the ADC conversion result
	in r23, ADCL
	in r22, ADCH

	ret

adc_complete_handler:
	; call parameters:
	; 	YL	byte	low byte of the ADC conversion result
	; 	YH	byte	high byte of the ADC conversion result
	m_save_r23_Y_Z_registers
	;
	ldi ZL, low(adc_static_instance)
	ldi ZH, high(adc_static_instance)
	ldi r23, ST_ADC_ON_COMPLETED_HANDLER_OFFSET
	in YL, ADCL
	in YH, ADCH
	
	rcall device_raise_event

	rcall adc_continuous_measurement_get
	cpi r23, ADC_CONVERSION_COMPLETED_TRUE
	brne adc_complete_handler_end
	sbi ADCSRA, ADFR
	;
	adc_complete_handler_end:

	m_restore_r23_Y_Z_registers
	
	reti
