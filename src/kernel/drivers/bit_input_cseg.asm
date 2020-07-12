; usage:
; .dseg
;   bit_input1: .BYTE SZ_ST_bit_input
;   ...
; .cseg
;   m_bit_input_init bit_input1, DDRB, PINB, PORTB, (1 << BIT1), (1 << BIT2)
;   ...
;   m_bit_input_get bit_input1

; implementation

.macro m_bit_input_init
	; input parameters:
	;	@0 	word	[st_bit_input:st_device_io]
	;	@1	word	[DDRx]
	;	@2	word 	[PINx]
	;	@3	word 	[PORTx]
	;	@4	byte 	USED_BIT_MASK
	m_st_device_io_init @0, @1, @2, @3, @4, 0x00
.endm

.macro m_bit_input_get
	; input parameter:
	;	@0	word	[st_bit_input]
	; returns:
	; 	@1	reg
	m_save_r23_Z_registers

	ldi ZL, low(@0)
	ldi ZH, high(@0)

	rcall bit_input_get

	mov @1, r23

	m_restore_r23_Z_registers
.endm

bit_input_get:
	; parameters:
	;	word	[st_bit_input]
	; returns:
	;	byte
	m_save_r22_SREG_registers
	;
	rcall st_device_io_get_pin_byte
	; detect current state
	and r23, r22
	;

	brne bit_input_get_state_up
	bit_input_get_state_dows:
		ldi r23, bit_input_STATE_DOWN
		rjmp bit_input_get_end
	bit_input_get_state_up:
		ldi r23, bit_input_STATE_UP

	bit_input_get_end:

	m_restore_r22_SREG_registers

	ret
