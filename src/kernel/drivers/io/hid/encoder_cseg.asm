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
;.include "kernel/drivers/io/device_io_def.asm"

;.include "kernel/kernel_cseg.asm"
;.include "kernel/drivers/device_cseg.asm"
;.include "kernel/drivers/io/device_io_cseg.asm"

; usage:
; .dseg
;   encoder1: .BYTE SZ_ST_ENCODER
;   ...
; .cseg
;   m_encoder_init encoder1, DDRB, PINB, PORTB, (1 << BIT1), (1 << BIT2)
;   ...
;   m_encoder_get encoder1
;   m_encoder_handle_io encoder1

; implementation

.macro m_encoder_init
	; parameters:
	;	@0 	word	[st_encoder:device_io]
	;	@1	word	[DDRx]
	;	@2	word 	[PINx]
	;	@3	word 	[PORTx]
	;	@4	byte 	BIT1x_MASK
	;	@5 	byte 	BIT2x_MASK
	;	@6	word	[on_turn_handler]
	m_save_r21_r22_r23_Y_Z_registers

	m_device_io_init @0, @1, @2, @3, (@4|@5), 0x00
	;m_st_encoder_init @0, @4, @5, @6

	; set [st_encoder]
	ldi ZL, low(@0)
	ldi ZH, high(@0)
	; set BIT1x_MASK
	ldi r23, @4
	; set BIT2x_MASK
	ldi r22, @5
	; set state
	ldi r21, (@4|@5)

	ldi YL, low(@6)
	ldi YH, high(@6)

	rcall encoder_init

	; restore registers
	m_restore_r21_r22_r23_Z_registers

.endm

encoder_init:
	; parameters:
	;	Z	word	[st_encoder]
	;	r23	byte	BIT1x_MASK
	;	r22	byte	BIT2x_MASK
	;	r21	byte	ENCODER_DIRECTION
	;	Y	word	[on_turn_handler]
	; set X to the [st_encoder] address
	; init st_encoder
	; init st_encoder
	push r21
	push r22
	push r23

	ldi r23, ST_ENCODER_BIT1_MASK_OFFSET
	pop r22
	rcall set_struct_byte

	ldi r23, ST_ENCODER_BIT2_MASK_OFFSET
	pop r22
	rcall set_struct_byte

	ldi r23, ST_ENCODER_DIRECTION
	pop r22
	rcall set_struct_byte

	ldi r23, ST_ENCODER_ON_TURN_HANDLER_OFFSET
	rcall set_struct_word

	ret

.macro m_encoder_handle_io
	; parameter:
	;	@0	word	[st_encoder]
	; returns:
	; 	@1	reg	ENCODER_DIRECTION
	m_save_r23_Z_registers
	
	ldi ZL, low(@0)
	ldi ZH, high(@0)

	rcall encoder_handle_io

	mov @1, r23

	m_restore_r23_Z_registers

.endm

encoder_handle_io:
	; parameters:
	;	Z	word	[st_encoder]
	; returns:
	;	r23	byte	ENCODER_DIRECTION
	m_save_r1_r2_r16_r17_r22_SREG_registers

	; load BIT1x_MASK into the r17
	ldi r23, ST_ENCODER_BIT1_MASK_OFFSET
	rcall get_struct_byte
	mov r1, r23 ; r17 -> r1
	; load BIT2x_MASK into the r18
	ldi r23, ST_ENCODER_BIT2_MASK_OFFSET
	rcall get_struct_byte
	mov r2, r23 ; r18 -> r2
	; load PINx address to the Y & load PINx value into the ZH: r19
	; save Z
	push ZL
	push ZH
	; load [PINx]
	ldi r23, ST_ENCODER_PINX_ADDRESS_OFFSET
	rcall get_struct_word
	; load PINx (value)
	ld r22, Z ; r19 -> r22
	pop ZH
	pop ZL
	; load previos state
	ldi r23, ST_ENCODER_DIRECTION
	rcall get_struct_byte
	; r16 -> r17
	ldi r17, ENCODER_DIRECTION_NONE
	; prepare mask
	ldi r16, 0x00
	or r16, r1
	or r16, r2
	; detect current state
	and r22, r16
	; if previous state is ENCODER_DIRECTION_NONE
	cp r23, r16
	encoder_detect_init:
		breq encoder_detect_forbidden
		rjmp encoder_detect_save
	encoder_detect_forbidden:
		and r22, r16
		brne encoder_detect_ccw
		rjmp encoder_detect_save
	encoder_detect_ccw:
		cp r22, r1
		breq encoder_detect_cw
		ldi r17, ENCODER_DIRECTION_CCW
		rjmp encoder_detect_save
	encoder_detect_cw:
		cp r22, r2
		breq encoder_detect_save
		ldi r17, ENCODER_DIRECTION_CW
		rjmp encoder_detect_save
	encoder_detect_save:
		; save to previous state
		cp r23, r22
		breq encoder_detect_end
		ldi r23, ST_ENCODER_DIRECTION
		rcall set_struct_byte
	encoder_detect_raise_events:
		cpi r17, ENCODER_DIRECTION_CCW
		breq encoder_detect_raise_events_raise
		cpi r17, ENCODER_DIRECTION_CW
		breq encoder_detect_raise_events_raise
		rjmp encoder_detect_end
	encoder_detect_raise_events_raise:
		push ZL
		push ZH
		ldi r23, ST_ENCODER_ON_TURN_HANDLER_OFFSET
		rcall get_struct_word
		mov r23, r17
		icall
		pop ZH
		pop ZL
	encoder_detect_end:
		mov r23, r17
		m_restore_r1_r2_r16_r17_r22_SREG_registers

	ret