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
	m_in_bit_init @0, @1, @2, @3, @4
.endm

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