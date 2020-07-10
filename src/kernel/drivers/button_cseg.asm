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
	;	@0 	word	[st_button:st_device_io]
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
	; 	@1	reg
	m_save_Z_registers

	ldi ZL, low(@0)
	ldi ZH, high(@0)

	rcall button_get

	m_restore_Z_registers
.endm

button_get:
	; parameters:
	;	word	[st_button]
	; returns:
	;	byte
	m_save_r22_SREG_registers
	;
	rcall st_device_io_get_pin_byte
	; detect current state
	and r23, r22
	;

	brne button_get_state_up
	button_get_state_dows:
		ldi r23, BUTTON_STATE_DOWN
		rjmp button_get_end
	button_get_state_up:
		ldi r23, BUTTON_STATE_UP

	button_get_end:

	m_restore_r22_SREG_registers

	ret
