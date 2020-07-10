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
	m_save_r21_r22_r23_Z_registers
	; set [st_encoder:st_device_io]
	ldi ZL, low(@0)
	ldi ZH, high(@0)
	; set BIT1x_MASK
	ldi r23, @1
	; set BIT2x_MASK
	ldi r22, @2
	; set state
	ldi r21, ENCODER_STATE_NONE

	rcall st_encoder_init

	; restore registers
	m_restore_r21_r22_r23_Z_registers
.endm

.macro m_encoder_init
	; input parameters:
	;	@0 	word	[st_encoder:st_device_io]
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
	m_save_r16_r17_registers
	; set X to the [st_encoder] address
	; init st_encoder
	; init st_encoder

	ldi r16, ST_ENCODER_BIT1_MASK_OFFSET
	mov r17, r23
	rcall set_struct_byte_by_Z_r16_r17

	ldi r16, ST_ENCODER_BIT2_MASK_OFFSET
	mov r17, r22
	rcall set_struct_byte_by_Z_r16_r17

	ldi r16, ST_ENCODER_STATE
	mov r17, r21
	rcall set_struct_byte_by_Z_r16_r17

	m_restore_r16_r17_registers

	ret

.macro m_encoder_detect
	; input parameter:
	;	@0	word	[st_encoder]
	; returns:
	; 	@1	register
	m_save_r23_Z_registers
	
	ldi ZL, low(@0)
	ldi ZH, high(@0)

	rcall encoder_detect

	mov @1, r23

	m_restore_r23_Z_registers

.endm

encoder_detect:
	; parameters:
	;	Z	word	[st_encoder]
	; returns:
	;	r23	byte	state
	m_save_r1_r2_r3_r16_SREG_registers

	; load BIT1x_MASK into the r17
	ldi r23, ST_ENCODER_BIT1_MASK_OFFSET
	rcall get_struct_byte_by_Z_r23_to_r23
	mov r1, r23 ; r17 -> r1
	; load BIT2x_MASK into the r18
	ldi r23, ST_ENCODER_BIT2_MASK_OFFSET
	rcall get_struct_byte_by_Z_r23_to_r23
	mov r2, r23 ; r18 -> r2
	; load PINx address to the Y & load PINx value into the ZH: r19
	ldi r23, ST_ENCODER_PINX_ADDRESS_OFFSET
	rcall get_struct_word_by_Z_r23_to_Z
	ld r3, Z ; r19 -> r3
	; load previous state to the ZL
	ldi r23, ST_ENCODER_STATE
	rcall get_struct_byte_by_Z_r23_to_r23
	; r16 -> r23
	; prepare mask
	ldi r16, 0x00
	or r16, r1
	or r16, r2
	; detect current state
	and r3, r16
	encoder_detect_init:
		brne encoder_detect_acceptable
		ldi r23, ENCODER_STATE_NONE
		rjmp encoder_detect_save

	encoder_detect_acceptable:
		cpi r23, ENCODER_STATE_NONE
		brne encoder_detect_end

	encoder_detect_backward:
		cp r3, r1
		brne encoder_detect_forward
		ldi r23, ENCODER_STATE_BACKWARD
		rjmp encoder_detect_save

	encoder_detect_forward:
		cp r3, r2
		brne encoder_detect_end
		ldi r23, ENCODER_STATE_FORWARD
		rjmp encoder_detect_save

	encoder_detect_save:
		; save to previous state
		ldi r16, ST_ENCODER_STATE
		mov r17, r23
		rcall set_struct_byte_by_Z_r16_r17
	encoder_detect_end:
		m_restore_r1_r2_r3_r16_SREG_registers

	ret
