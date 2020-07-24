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
;   out_byte1: .BYTE SZ_ST_OUT_BYTE
;   ...
; .cseg
;   m_out_byte_init out_byte1, DDRB, PORTB, (1 << BYTE1)
;   ...
;   m_out_byte_set out_byte1, OUT_BYTE_STATE_ON
;   m_out_byte_set out_byte1, OUT_BYTE_STATE_OFF
;   m_out_byte_set out_byte1, 0b01010101
;   m_out_byte_on out_byte1
;   m_out_byte_off out_byte1
;   m_out_byte_toggle out_byte1
;   m_out_byte_get out_byte1
.macro m_out_byte_init
	; parameters:
	;	@0	word [st_out_byte]
	;	@1	word [DDRx]
	;	@2	word [PORTx]
	; save registers
	m_save_Z_registers
	; init (device_io)st_out_byte
	m_device_io_init @0, @1, 0x0000, @2, OUT_BYTE_STATE_ON, OUT_BYTE_STATE_ON
	; init out_byte
	ldi ZL, low(@0)
	ldi ZH, high(@0)
	rcall out_byte_init
	;release stack from parameters
	;restore registers
	m_restore_Z_registers
.endm

out_byte_init:
	; parameters:
	;	Z	word	[st_out_byte]
	; currently no additional logic
	ret

.macro m_out_byte_set
	; parameters:
	;	@0	word	[st_out_byte]
	;	@1	byte 	OUT_BYTE_STATE
	; save registers
	m_save_r23_Z_registers
	; push parameters
	ldi r23, @1
	ldi ZL, low(@0)
	ldi ZH, high(@0)
	; call procedure
	rcall out_byte_set
	; release stack from parameters
	; restore registers
	m_restore_r23_Z_registers
.endm

.macro  m_out_byte_on
	; parameters:
	;	@0 	word	[st_out_byte]
	m_out_byte_set @0, OUT_BYTE_STATE_ON
.endm

.macro  m_out_byte_off
	; parameters:
	;	@0 	word	[st_out_byte]
	m_out_byte_set @0, OUT_BYTE_STATE_OFF
.endm

out_byte_set:
	; parameters:
	;	Z	word	[st_out_byte]
	;	r23	byte	OUT_BYTE_STATE
	; load out_byte_state
	; check state to set
	;cpi r23, OUT_BYTE_STATE_ON
	rcall device_io_set_port_byte

	ret

.macro m_out_byte_get
	; parameters:
	;	@0	word	[st_out_byte]
	; returns:
	;	@1	reg	OUT_BYTE_STATE
	m_save_Z_registers

	ldi ZL, low(@0)
	ldi ZH, high(@0)

	rcall out_byte_get

	mov @1, r23

	m_restore_Z_registers
.endm

out_byte_get:
	; parameters:
	;	Z	word	[st_out_byte]
	; returns:
	;	r23	byte	OUT_BYTE_STATE
	m_save_r22_SREG_registers
	; call device_io_get_pin_byte
	rcall device_io_get_port_byte
	; compare value
	m_restore_r22_SREG_registers

	ret

.macro m_out_byte_toggle
	; input parameters:
	; 	@0	word	[st_out_byte]
	m_save_Z_registers

	ldi ZL, low(@0)
	ldi ZH, high(@0)

	rcall out_byte_toggle

	m_restore_Z_registers
.endm

out_byte_toggle:
	; input parameters:
	;	Z	word	[st_out_byte]
	m_save_r23_SREG_registers

	rcall out_byte_get

	com r23

	rcall out_byte_set

	m_restore_r23_SREG_registers

	ret
