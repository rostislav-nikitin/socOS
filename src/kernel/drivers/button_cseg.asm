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
	; input parameters:
	;	@0 	word	[st_button]
	;	@1	word	[DDRx]
	;	@2	word 	[PINx]
	;	@3	word 	[PORTx]
	;	@4	byte 	USED_BIT_MASK
	m_st_device_io_init @0, @1, @2, @3, @4, 0x00
.endm

.macro m_button_get
	; input parameter:
	;	@0	word	[st_button]
	; returns:
	; 	@1	register
	push @1
	ldi @1, low(@0)
	push @1
	ldi @1, high(@0)
	push @1

	rcall button_get

	pop @1
	pop @1
	pop @1
.endm

button_get:
	; parameters:
	;	word	[st_button]
	; returns:
	;	byte
	m_save_r16_X_Z_registers

	; set X to the [st_button] address
	in XL, SPL
	in XH, SPH
	ldi r16, SZ_R16_X_Z_REGISTERS + SZ_RET_ADDRESS + SZ_STACK_PREVIOUS_OFFSET
	add XL, r16
	ldi r16, 0x00
	adc XH, r16
	; load [st_button] address to Z
	ld ZH, X+
	ld ZL, X+
	; save X (pointer to the return value)
	push XL
	push XH
	; load USED_BIT_MASK into the XL
	ldi r16, ST_BUTTON_USED_BIT_MASK_OFFSET
	rcall get_struct_byte_by_Z_r16_to_r16
	mov XL, r16
	; load PINx address to the Y & load PINx value into the r16
	push ZL
	push ZH
	ldi r16, ST_BUTTON_PINX_ADDRESS_OFFSET
	rcall get_struct_word_by_Z_r16_to_Z
	ld r16, Z
	pop ZH
	pop ZH
	; detect current state
	and r16, XL
	brne button_get_state_up
	button_get_state_dows:
		ldi r16, BUTTON_STATE_DOWN
		rjmp button_get_end
	button_get_state_up:
		ldi r16, BUTTON_STATE_UP
	button_get_end:
		; restore X
		pop XH
		pop XL
		; save to return value
		st X, r16
		m_restore_r16_X_Z_registers

	ret
