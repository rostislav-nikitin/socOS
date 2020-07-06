; usage:
; .dseg
;   encoder1: .BYTE SZ_ST_ENCODER
;   ...
; .cseg
;   m_encoder_init encoder1, DDRB, PINB, PORTB, (1 << BIT1), (1 << BIT2)
;   ...
;   m_encoder_get encoder1
;   m_encoder_detect encoder1

; implementation

.macro m_st_encoder_init
	; input parameters:
	;	@0 	word	[st_encoder]
	;	@1	byte 	BIT1x_MASK
	;	@2 	byte 	BIT2x_MASK
	; save registers
	push r16

	ldi r16, ENCODER_STATE_NONE
	push r16
	; push BIT2x_MASK
	ldi r16, @2
	push r16
	; push BIT1x_MASK
	ldi r16, @1
	push r16
	; push [st_encoder]
	ldi r16, high(@0)
	push r16
	ldi r16, low(@0)
	push r16

	rcall st_encoder_init

	pop r16
	pop r16
	pop r16
	pop r16	
	pop r16
	; restore registers
	pop r16
.endm

.macro m_encoder_init
	; input parameters:
	;	@0 	word	[st_encoder]
	;	@1	word	[DDRx]
	;	@2	word 	[PINx]
	;	@3	word 	[PORTx]
	;	@4	byte 	BIT1x_MASK
	;	@5 	byte 	BIT2x_MASK
	m_st_device_io_init @0, @1, @2, @3, (@4|@5), 0x00
	m_st_encoder_init @0, @4, @5
.endm

st_encoder_init:
	; input parameters:
	;	word	[st_encoder]
	;	byte	BIT1x_MASK
	;	byte	BIT2x_MASK
	;	byte	ENCODER_STATE
	m_save_r16_r17_r18_r19_X_Y_Z_registers
	; set X to the [st_encoder] address
	in XL, SPL
	in XH, SPH
	ldi r16, SZ_R16_R17_R18_R19_X_Y_Z_REGISTERS + SZ_RET_ADDRESS + SZ_STACK_PREVIOUS_OFFSET
	add XL, r16
	ldi r16, 0x00
	adc XH, r16
	; init st_encoder
	; load st_encoder address to Y
	ld YL, X+
	ld YH, X+
	ldi r17, SZ_ST_DEVICE_IO
	add YL, r17
	adc YH, r16
	; init st_encoder
	ldi r16, SZ_ST_ENCODER - SZ_ST_DEVICE_IO

	rcall mem_copy

	m_restore_r16_r17_r18_r19_X_Y_Z_registers

	ret

.macro m_encoder_detect
	; input parameter:
	;	@0	word	[st_encoder]
	; returns:
	; 	@1	register
	push @1
	ldi @1, low(@0)
	push @1
	ldi @1, high(@0)
	push @1

	rcall encoder_detect

	pop @1
	pop @1
	pop @1
.endm

encoder_detect:
	; parameters:
	;	word	[st_encoder]
	; returns:
	;	byte
	m_save_r16_r17_r18_r19_X_Y_Z_registers

	ldi r16, 0x00
	; set X to the [st_encoder] address
	in XL, SPL
	in XH, SPH
	ldi r17, SZ_R16_R17_R18_R19_X_Y_Z_REGISTERS + SZ_RET_ADDRESS + SZ_STACK_PREVIOUS_OFFSET
	add XL, r17
	adc XH, r16
	; load [st_encoder] address to Y
	ld YH, X+
	ld YL, X+
	; save X
	push XL
	push XH
	; set X to st_encoder
	mov XL, YL
	mov XH, YH
	; load BIT1x_MASK into the r17
	ldi r16, ST_ENCODER_BIT1_MASK_OFFSET
	rcall get_struct_byte_by_X_r16_to_r16
	mov r17, r16
	; load BIT2x_MASK into the r18
	ldi r16, ST_ENCODER_BIT2_MASK_OFFSET
	rcall get_struct_byte_by_X_r16_to_r16
	mov r18, r16
	; load PINx address to the Y & load PINx value into the ZH: r19
	ldi ZL, ST_ENCODER_PINX_ADDRESS_OFFSET
	rcall get_struct_word_by_X_ZL_to_Z
	ld r19, Z
	; load previous state to the ZL
	ldi r16, ST_ENCODER_STATE
	rcall get_struct_byte_by_X_r16_to_r16
	; prepare mask
	ldi YL, 0x00
	or YL, r17
	or YL, r18
	; detect current state
	and r19, YL
	encoder_detect_init:
		brne encoder_detect_acceptable
		ldi r16, ENCODER_STATE_NONE
		rjmp encoder_detect_save

	encoder_detect_acceptable:
		cpi r16, ENCODER_STATE_NONE
		brne encoder_detect_end

	encoder_detect_backward:
		cp r19, r17
		brne encoder_detect_forward
		ldi r16, ENCODER_STATE_BACKWARD
		rjmp encoder_detect_save

	encoder_detect_forward:
		cp r19, r18
		brne encoder_detect_end
		ldi r16, ENCODER_STATE_FORWARD
		rjmp encoder_detect_save

	encoder_detect_save:
		; save to previous state
		st X, r16
	encoder_detect_end:
		; restore X
		pop XH
		pop XL
		; save to return value
		st X, r16
		m_restore_r16_r17_r18_r19_X_Y_Z_registers

	ret
