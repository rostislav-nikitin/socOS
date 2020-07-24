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
;   in_bit1: .BYTE SZ_ST_in_bit
;   ...
; .cseg
;   m_in_bit_init in_bit1, DDRB, PINB, PORTB, (1 << BIT1), (1 << BIT2)
;   ...
;   m_in_bit_get in_bit1

; implementation

.macro m_in_bit_init
	; parameters:
	;	@0 	word	[st_in_bit]
	;	@1	word	[DDRx]
	;	@2	word 	[PINx]
	;	@3	word 	[PORTx]
	;	@4	byte 	USED_BIT_MASK
	m_device_io_init @0, @1, @2, @3, @4, 0x00
	rcall in_bit_init
.endm
in_bit_init:
	;	Z 	word	[st_in_bit]
	ret

.macro m_in_bit_get
	; parameters:
	;	@0	word	[st_in_bit]
	; returns:
	; 	@1	reg	value
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
	;	byte	value
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
