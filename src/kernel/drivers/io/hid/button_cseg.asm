; usage:
; .dseg
;   button1: .BYTE SZ_ST_BUTTON
;   ...
; .cseg
;   m_button_init button1, DDRB, PINB, PORTB, (1 << BIT1), (1 << BIT2)
;   ...
;   m_button_get button1

; implementation

.macro m_button_init
	m_save_r24_r25_X_Y_Z_registers
	; input parameters:
	;	@0 	word	[st_button:device_io]
	;	@1	word	[DDRx]
	;	@2	word 	[PINx]
	;	@3	word 	[PORTx]
	;	@4	byte 	USED_BIT_MASK
	;	@5	word	on_button_down_handler
	;	@6	word	on_button_up_handler
	;	@7	word	on_button_pressed_handler
	m_in_bit_init @0, @1, @2, @3, @4

	ldi ZL, low(@0)
	ldi ZH, high(@0)

	ldi YL, low(@5)
	ldi YH, high(@5)

	ldi XL, low(@6)
	ldi XH, high(@6)

	ldi r24, low(@7)
	ldi r25, high(@7)

	rcall button_init

	m_restore_r24_r25_X_Y_Z_registers
.endm

button_init:
	m_save_r22_r23_Y_registers

	ldi r23, ST_BUTTON_STATE
	ldi r22, BUTTON_STATE_DEFAULT
	rcall set_struct_byte

	ldi r23, ST_BUTTON_ON_BUTTON_DOWN_HANDLER
	rcall set_struct_word

	mov YL, XL
	mov YH, XH
	ldi r23, ST_BUTTON_ON_BUTTON_UP_HANDLER
	rcall set_struct_word

	mov YL, r24
	mov YH, r25
	ldi r23, ST_BUTTON_ON_BUTTON_PRESSED_HANDLER
	rcall set_struct_word

	m_restore_r22_r23_Y_registers

	ret

.macro m_button_get
	; input parameter:
	;	@0	word	[st_button]
	; returns:
	; 	@1	reg
	m_in_bit_get @0, @1
.endm

button_get:
	; parameters:
	;	word	[st_button]
	; returns:
	;	byte

	rcall in_bit_get

	ret

.macro m_button_handle_io
	; parameters:
	;	@0	word	[st_button:device_io]
	m_save_Z_registers

	ldi ZL, low(@0)
	ldi ZH, high(@0)

	rcall button_handle_io

	m_restore_Z_registers
.endm

button_handle_io:
	; parameters:
	;	word	[st_button]
	m_save_r16_r22_r23_Y_Z_SREG_registers
	;
	rcall button_get
	; save current button state
	mov r16, r23	
	; load previous button state
	ldi r23, ST_BUTTON_STATE
	rcall get_struct_byte

	cp r16, r23
	breq button_handle_io_end

	ldi r23, ST_BUTTON_STATE
	mov r22, r16
	rcall set_struct_byte

	cpi r16, BUTTON_STATE_DOWN
	brne button_handle_io_up

	button_handle_io_down:
		ldi r23, ST_BUTTON_ON_BUTTON_DOWN_HANDLER
		rcall get_struct_word
		m_set_Y_to_null_pointer
		rcall cpw
		breq button_handle_io_end
		icall
		rjmp button_handle_io_end
	button_handle_io_up:
		button_handle_io_up_raise_up:
			push ZL
			push ZH
			ldi r23, ST_BUTTON_ON_BUTTON_UP_HANDLER
			rcall get_struct_word
			m_set_Y_to_null_pointer
			rcall cpw
			breq button_handle_io_up_raise_pressed
			icall
			pop ZH
			pop ZL
		button_handle_io_up_raise_pressed:
			ldi r23, ST_BUTTON_ON_BUTTON_PRESSED_HANDLER
			rcall get_struct_word
			m_set_Y_to_null_pointer
			rcall cpw
			breq button_handle_io_end
			icall
	button_handle_io_end:
		m_restore_r16_r22_r23_Y_Z_SREG_registers
	
	ret

