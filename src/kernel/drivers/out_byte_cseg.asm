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
	; input parameters:
	;	@0	word [st_out_byte:st_device_io]
	;	@1	word [DDRx]
	;	@2	word [PORTx]
	; save registers
	m_save_Z_registers
	; init (st_device_io)st_out_byte
	m_st_device_io_init @0, @1, 0x0000, @2, OUT_BYTE_STATE_ON, OUT_BYTE_STATE_ON
	; init out_byte
	ldi ZL, low(@0)
	ldi ZH, high(@0)
	rcall out_byte_init
	;release stack from parameters
	;restore registers
	m_restore_Z_registers
.endm

out_byte_init:
	; input parameters:
	;	Z	word	[st_out_byte:st_device_io]
	; currently no additional logic
	ret

.macro m_out_byte_set
	; input parameters:
	;	@0	word	[st_out_byte:st_device_io]
	;	@1	byte 	out_byte_state
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
	; input parameters:
	;	@0 	word	st_out_byte
	m_out_byte_set @0, OUT_BYTE_STATE_ON
.endm

.macro  m_out_byte_off
	; input parameters:
	;	@0 	word	st_out_byte
	m_out_byte_set @0, OUT_BYTE_STATE_OFF
.endm

out_byte_set:
	; input parameters:
	;	word	st_out_byte
	;	byte	out_byte_state
	m_save_SREG_registers
	; load out_byte_state
	; check state to set
	cpi r23, OUT_BYTE_STATE_ON
	rcall st_device_io_set_port_byte

	m_restore_SREG_registers

	ret

.macro m_out_byte_get
	; input parameters:
	;	@0	word	[st_out_byte:st_device_io]
	; returns:
	;	@1	register
	m_save_Z_registers

	ldi ZL, low(@0)
	ldi ZH, high(@0)

	rcall out_byte_get

	mov @1, r23

	m_restore_Z_registers
.endm

out_byte_get:
	; input parameters:
	;	Z	word	[st_out_byte:st_device_io]
	; returns:
	;	r23	byte	current out_byte state
	m_save_r22_SREG_registers
	; call st_device_io_get_pin_byte
	rcall st_device_io_get_port_byte
	; compare value
	m_restore_r22_SREG_registers

	ret

.macro m_out_byte_toggle
	; input parameters:
	; 	@0	word	st_out_byte
	m_save_Z_registers

	ldi ZL, low(@0)
	ldi ZH, high(@0)

	rcall out_byte_toggle

	m_restore_Z_registers
.endm

out_byte_toggle:
	; input parameters:
	;	Z	word	[st_out_byte:st_device_io]
	m_save_r23_SREG_registers

	rcall out_byte_get

	com r23

	rcall out_byte_set

	m_restore_r23_SREG_registers

	ret
