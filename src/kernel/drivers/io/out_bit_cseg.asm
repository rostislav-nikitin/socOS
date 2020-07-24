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
;   out_bit1: .BYTE SZ_ST_OUT_BIT
;   ...
; .cseg
;   m_out_bit_init out_bit1, DDRB, PORTB, (1 << BIT1)
;   ...
;   m_out_bit_set out_bit1, OUT_BIT_STATE_ON
;   m_out_bit_set out_bit1, OUT_BIT_STATE_OFF
;   m_out_bit_on out_bit1
;   m_out_bit_off out_bit1
;   m_out_bit_toggle out_bit1
;   m_out_bit_get out_bit1

.macro m_out_bit_init
	; parameters:
	;	@0	word [st_out_bit]
	;	@1	word [DDRx]
	;	@2	word [PORTx]
	;	@3	word USED_BIT_MASK
	; save registers
	m_save_Z_registers
	; init (device_io)st_out_bit
	m_device_io_init @0, @1, 0x0000, @2, @3, @3
	; init out_bit
	ldi ZL, low(@0)
	ldi ZH, high(@0)
	rcall out_bit_init
	;release stack from parameters
	;restore registers
	m_restore_Z_registers
.endm

out_bit_init:
	; parameters:
	;	Z	word	[st_out_bit]
	; currently no additional logic
	ret

.macro m_out_bit_set
	; parameters:
	;	@0	word	[st_out_bit]
	;	@1	byte 	OUT_BIT_STATE
	; save registers
	m_save_r23_Z_registers
	; push parameters
	ldi r23, @1
	ldi ZL, low(@0)
	ldi ZH, high(@0)
	; call procedure
	rcall out_bit_set
	; release stack from parameters
	; restore registers
	m_restore_r23_Z_registers
.endm

.macro  m_out_bit_on
	; parameters:
	;	@0 	word	st_out_bit
	m_out_bit_set @0, OUT_BIT_STATE_ON
.endm

.macro  m_out_bit_off
	; parameters:
	;	@0 	word	st_out_bit
	m_out_bit_set @0, OUT_BIT_STATE_OFF
.endm

out_bit_set:
	; parameters:
	;	Z	word	st_out_bit
	;	r23	byte	OUT_BIT_STATE
	m_save_SREG_registers
	; load out_bit_state
	; check state to set
	cpi r23, OUT_BIT_STATE_ON
	brne out_bit_set_off

	ldi r23, ST_OUT_BIT_USED_BIT_MASK_OFFSET
	rcall get_struct_byte
	rjmp out_bit_set_call_device_io_set_port_byte

	out_bit_set_off:
		ldi r23, 0x00
	out_bit_set_call_device_io_set_port_byte:
		rcall device_io_set_port_byte

	out_bit_set_end:
	m_restore_SREG_registers

	ret

.macro m_out_bit_get
	; parameters:
	;	@0	word	[st_out_bit]
	; returns:
	;	@1	reg	OUT_BIT_STATE
	m_save_Z_registers

	ldi ZL, low(@0)
	ldi ZH, high(@0)

	rcall out_bit_get

	mov @1, r23

	m_restore_Z_registers
.endm

out_bit_get:
	; parameters:
	;	Z	word	[st_out_bit]
	; returns:
	;	r23	byte	OUT_BIT_STATE
	m_save_r22_SREG_registers
	; call device_io_get_pin_byte
	rcall device_io_get_port_byte
	; compare value
	and r23, r22
	breq out_bit_get_off
	out_bit_get_on:
		ldi r23, OUT_BIT_STATE_ON
		rjmp  out_bit_get_end
	out_bit_get_off:
		ldi r23, OUT_BIT_STATE_OFF

	out_bit_get_end:
		m_restore_r22_SREG_registers

	ret

.macro m_out_bit_toggle
	; parameters:
	; 	@0	word	[st_out_bit]
	m_save_Z_registers

	ldi ZL, low(@0)
	ldi ZH, high(@0)

	rcall out_bit_toggle

	m_restore_Z_registers
.endm

out_bit_toggle:
	; parameters:
	;	Z	word	[st_out_bit]
	m_save_r23_SREG_registers

	rcall out_bit_get

	cpi r23, OUT_BIT_STATE_ON
	brne out_bit_toggle_out_bit_on

	out_bit_toggle_out_bit_off:	
		ldi r23, OUT_BIT_STATE_OFF
		rjmp out_bit_toggle_out_bit_set
	out_bit_toggle_out_bit_on:
		ldi r23, OUT_BIT_STATE_ON

	out_bit_toggle_out_bit_set:
		rcall out_bit_set

	m_restore_r23_SREG_registers

	ret
