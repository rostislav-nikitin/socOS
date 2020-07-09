; usage:
; .dseg
;   led1: .BYTE SZ_ST_LED
;   ...
; .cseg
;   m_led_init led1, DDRB, PORTB, (1 << BIT1)
;   ...
;   m_led_set led1, LED_STATE_ON
;   m_led_set led1, LED_STATE_OFF
;   m_led_on led1
;   m_led_off led1
;   m_led_toggle led1
;   m_led_get led1

.macro m_led_init
	; input parameters:
	;	@0	word st_led
	;	@1	word DDRx
	;	@2	word PORTx
	;	@3	word USED_BIT_MASK
	; save registers
	push r16
	; init (st_device_io)st_led
	m_st_device_io_init @0, @1, 0x0000, @2, @3, @3
	; init led
	ldi r16, high(@0)
	push r16
	ldi r16, low(@0)
	push r16
	rcall led_init
	;release stack from parameters
	pop r16
	pop r16
	;restore registers
	pop r16
.endm

led_init:
	; input parameters:
	;	word	st_led
	; currently no additional logic
	ret

.macro m_led_set
	; input parameters:
	;	@0	word	st_led
	;	@1	byte 	led_state
	; save registers
	push r18
	; push parameters
	ldi r18, @1
	push r18
	ldi r18, high(@0)
	push r18
	ldi r18, low(@0)
	push r18
	; call procedure
	rcall led_set
	; release stack from parameters
	pop r18
	pop r18
	pop r18
	; restore registers
	pop r18
.endm

.macro  m_led_on
	; input parameters:
	;	@0 	word	st_led
	m_led_set @0, LED_STATE_ON
.endm

.macro  m_led_off
	; input parameters:
	;	@0 	word	st_led
	m_led_set @0, LED_STATE_OFF
.endm

led_set:
	; input parameters:
	;	word	st_led
	;	byte	led_state
	nop
	m_save_r16_X_Z_registers

	; set X to the st_led address
	in XL, SPL
	in XH, SPH
	ldi r16, SZ_R16_X_Z_REGISTERS + SZ_RET_ADDRESS + SZ_STACK_PREVIOUS_OFFSET
	add XL, r16
	ldi r16, 0x00
	adc XH, r16
	; load st_led address to Y
	ld ZL, X+
	ld ZH, X+
	; load led_state
	ld r16, X
	; check state to set
	cpi r16, LED_STATE_ON
	brne led_set_off


	ldi r23, ST_LED_USED_BIT_MASK_OFFSET
	rcall get_struct_byte_by_Z_r23_to_r23
	rjmp led_set_call_st_device_io_set_port_byte

	led_set_off:
		ldi r23, 0x00
	led_set_call_st_device_io_set_port_byte:
		rcall st_device_io_set_port_byte

	m_restore_r16_X_Z_registers

	ret

.macro m_led_get
	; input parameters:
	;	@0	word	st_led
	; returns:
	;	@1	register

	push @1
	ldi @1, high(@0)
	push @1
	ldi @1, low(@0)
	push @1

	rcall led_get

	pop @1
	pop @1
	pop @1
.endm

led_get:
	; input parameters:
	;	word	st_led
	; returns:
	;	byte
	m_save_r16_X_Z_registers
	; set X to the st_led address
	in XL, SPL
	in XH, SPH
	ldi r16, SZ_R16_X_Z_REGISTERS + SZ_RET_ADDRESS + SZ_STACK_PREVIOUS_OFFSET
	add XL, r16
	ldi r16, 0x00
	adc XH, r16
	; load st_led address to Y
	ld ZL, X+
	ld ZH, X+
	; call st_device_io_get_pin_byte
	rcall st_device_io_get_port_byte
	; compare value
	and r23, r22
	breq led_get_off
	led_get_on:
		ldi r16, LED_STATE_ON
		rjmp  led_get_set_result
	led_get_off:
		ldi r16, LED_STATE_OFF
   	led_get_set_result:
		st X, r16

	m_restore_r16_X_Z_registers

	ret

.macro m_led_toggle
	; input parameters:
	; 	@0	word	st_led
	; save registers
	push r16
	; push parameters
	ldi r16, high(@0)
	push r16
	ldi r16, low(@0)
	push r16
	rcall led_toggle
	; release stack from parameters
	pop r16
	pop r16
	; restore registers
	pop r16
.endm

led_toggle:
	; input parameters:
	;	word	st_led
	m_save_r16_X_Z_registers

	; set X to the st_led address
	in XL, SPL
	in XH, SPH
	ldi r16, SZ_R16_X_Z_REGISTERS + SZ_RET_ADDRESS + SZ_STACK_PREVIOUS_OFFSET
	add XL, r16
	ldi r16, 0x00
	adc XH, r16
	; load st_led address to Y
	ld ZL, X+
	ld ZH, X+
	; push space for result
	push r16
	; push st_led address
	push ZH
	push ZL

	rcall led_get

	pop ZL
	pop ZH
	; there result
	pop r16

	cpi r16, LED_STATE_ON
	brne led_toggle_led_on
	led_toggle_led_off:	
		ldi r16, LED_STATE_OFF 
		rjmp led_toggle_led_set
	led_toggle_led_on:
		ldi r16, LED_STATE_ON

	led_toggle_led_set:
		push r16
		push ZH
		push ZL

		rcall led_set

		pop ZL
		pop ZH
		pop r16

	m_restore_r16_X_Z_registers

	ret
