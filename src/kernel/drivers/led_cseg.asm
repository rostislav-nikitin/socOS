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
	;	@0	word [st_led:st_device_io]
	;	@1	word [DDRx]
	;	@2	word [PORTx]
	;	@3	word USED_BIT_MASK
	; save registers
	m_save_Z_register
	; init (st_device_io)st_led
	m_st_device_io_init @0, @1, 0x0000, @2, @3, @3
	; init led
	ldi ZL, low(@0)
	ldi ZH, high(@0)
	rcall led_init
	;release stack from parameters
	;restore registers
	m_restore_Z_register
.endm

led_init:
	; input parameters:
	;	Z	word	[st_led:st_device_io]
	; currently no additional logic
	ret

.macro m_led_set
	; input parameters:
	;	@0	word	[st_led:st_device_io]
	;	@1	byte 	led_state
	; save registers
	m_save_r23_Z_registers
	; push parameters
	ldi r23, @1
	ldi ZL, low(@0)
	ldi ZH, high(@0)
	; call procedure
	rcall led_set
	; release stack from parameters
	; restore registers
	m_restore_r23_Z_registers
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
	m_save_SREG_registers
	; load led_state
	; check state to set
	cpi r23, LED_STATE_ON
	brne led_set_off

	ldi r23, ST_LED_USED_BIT_MASK_OFFSET
	rcall get_struct_byte_by_Z_r23_to_r23
	rjmp led_set_call_st_device_io_set_port_byte

	led_set_off:
		ldi r23, 0x00
	led_set_call_st_device_io_set_port_byte:
		rcall st_device_io_set_port_byte

	m_restore_SREG_registers

	ret

.macro m_led_get
	; input parameters:
	;	@0	word	[st_led:st_device_io]
	; returns:
	;	@1	register
	m_save_Z_registers

	ldi ZL, low(@0)
	ldi ZH, high(@0)

	rcall led_get

	m_restore_Z_registers
.endm

led_get:
	; input parameters:
	;	Z	word	[st_led:st_device_io]
	; returns:
	;	r23	byte	current led state
	m_save_r23_SREG_registers
	; call st_device_io_get_pin_byte
	rcall st_device_io_get_port_byte
	; compare value
	and r23, r22
	breq led_get_off
	led_get_on:
		ldi r23, LED_STATE_ON
		rjmp  led_get_set_result
	led_get_off:
		ldi r23, LED_STATE_OFF

	m_restore_r23_SREG_registers

	ret

.macro m_led_toggle
	; input parameters:
	; 	@0	word	st_led
	m_save_Z_registers

	ldi ZL, low(@0)
	ldi ZH, high(@0)

	rcall led_toggle

	m_restore_Z_registers
.endm

led_toggle:
	; input parameters:
	;	Z	word	[st_led:st_device_io]
	m_save_r16_X_Z_registers

	rcall led_get

	cpi r23, LED_STATE_ON
	brne led_toggle_led_on
	led_toggle_led_off:	
		ldi r23, LED_STATE_OFF 
		rjmp led_toggle_led_set
	led_toggle_led_on:
		ldi r23, LED_STATE_ON

	led_toggle_led_set:
		rcall led_set
	m_restore_r16_X_Z_registers

	ret
