; usage:
; .dseg
;   in_bit1: .BYTE SZ_ST_in_bit
;   ...
; .cseg
;   m_in_bit_init in_bit1, DDRB, PINB, PORTB, (1 << BIT1), (1 << BIT2)
;   ...
;   m_in_bit_get in_bit1

; implementation

.macro m_in_bit_init
	; input parameters:
	;	@0 	word	[st_in_bit:device_io]
	;	@1	word	[DDRx]
	;	@2	word 	[PINx]
	;	@3	word 	[PORTx]
	;	@4	byte 	USED_BIT_MASK
	m_device_io_init @0, @1, @2, @3, @4, 0x00
.endm

.macro m_in_bit_get
	; input parameter:
	;	@0	word	[st_in_bit]
	; returns:
	; 	@1	reg
	m_save_r23_Z_registers

	ldi ZL, low(@0)
	ldi ZH, high(@0)

	rcall in_bit_get

	mov @1, r23

	m_restore_r23_Z_registers
.endm

in_bit_get:
	; parameters:
	;	word	[st_in_bit]
	; returns:
	;	byte
	m_save_r22_SREG_registers
	;
	rcall device_io_get_pin_byte
	; detect current state
	and r23, r22
	;

	brne in_bit_get_state_up
	in_bit_get_state_dows:
		ldi r23, in_bit_STATE_OFF
		rjmp in_bit_get_end
	in_bit_get_state_up:
		ldi r23, in_bit_STATE_ON

	in_bit_get_end:

	m_restore_r22_SREG_registers

	ret
