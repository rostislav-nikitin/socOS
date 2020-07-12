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

	m_out_bit_init @0, @1, @2, @3
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
	m_out_bit_set @0, @1
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
	rcall out_bit_set

	ret

.macro m_led_get
	; input parameters:
	;	@0	word	[st_led:st_device_io]
	; returns:
	;	@1	register
	m_out_bit_get @0, @1
.endm

led_get:
	; input parameters:
	;	Z	word	[st_led:st_device_io]
	; returns:
	;	r23	byte	current led state
	rcall out_bit_get

	ret

.macro m_led_toggle
	; input parameters:
	; 	@0	word	st_led
	m_out_bit_toggle @0
.endm

led_toggle:
	; input parameters:
	;	Z	word	[st_led:st_device_io]
	rcall led_toggle

	ret
