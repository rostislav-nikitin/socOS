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
;.include "kernel/drivers/io/in_bit_def.asm"

;.include "kernel/kernel_cseg.asm"
;.include "kernel/drivers/device_cseg.asm"
;.include "kernel/drivers/io/device_io_cseg.asm"
;.include "kernel/drivers/io/in_bit_cseg.asm"

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
	; parameters:
	;	@0 	word	[st_button]
	;	@1	word	[DDRx]
	;	@2	word 	[PINx]
	;	@3	word 	[PORTx]
	;	@4	byte 	USED_BIT_MASK
	;	@5	word	[on_button_down_handler]
	;	@6	word	[on_button_up_handler]
	;	@7	word	[on_button_pressed_handler]
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
	; parameters:
	;	Z 	word	[st_button]
	;	Y	word	[on_button_down_handler]
	;	X	word 	[on_button_up_handler]
	;	r24,r25	word 	[on_button_pressed_handler]

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
	; parameter:
	;	@0	word	[st_button]
	; returns:
	; 	@1	reg	BUTTON_STATE
	m_in_bit_get @0, @1
.endm

button_get:
	; parameters:
	;	Z	word	[st_button]
	; returns:
	;	r23	byte	BUTTON_STATE

	rcall in_bit_get

	ret

.macro m_button_handle_io
	; parameters:
	;	@0	word	[st_button]
	m_save_Z_registers

	ldi ZL, low(@0)
	ldi ZH, high(@0)

	rcall button_handle_io

	m_restore_Z_registers
.endm

button_handle_io:
	; parameters:
	;	Z	word	[st_button]
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
		rcall device_raise_event
		rjmp button_handle_io_end
	button_handle_io_up:
		button_handle_io_up_raise_up:
			m_save_Z_registers
			ldi r23, ST_BUTTON_ON_BUTTON_UP_HANDLER
			rcall device_raise_event
			m_restore_Z_registers
		button_handle_io_up_raise_pressed:
			ldi r23, ST_BUTTON_ON_BUTTON_PRESSED_HANDLER
			rcall device_raise_event
	button_handle_io_end:
		m_restore_r16_r22_r23_Y_Z_SREG_registers
	
	ret

