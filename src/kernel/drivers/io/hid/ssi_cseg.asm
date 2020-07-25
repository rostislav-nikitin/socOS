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
;.include "kernel/drivers/io/out_byte_def.asm"

;.include "kernel/kernel_cseg.asm"
;.include "kernel/drivers/device_cseg.asm"
;.include "kernel/drivers/io/device_io_cseg.asm"
;.include "kernel/drivers/io/out_byte_cseg.asm"


; usage:
; .dseg
;   ssi1: .BYTE SZ_ST_OUT_BYTE
;   ...
; .cseg
;   m_ssi_init ssi1, DDRB, PORTB
;   ...
;   m_ssi_on ssi1
;   m_ssi_off ssi1
;   m_ssi_flash_on ssi1
;   m_ssi_flash_off ssi1
;   m_ssi_char_show ssi1, '0'

;ssi_digits: .db 0xFC, 0x60, 0xDA, 0xF2, 0x66, 0xB6, 0xBE, 0xE0, 0xFE, 0xF6, 0x0, 0x0
ssi_digits: .db 0x3f, 0x06, 0x5b, 0x4f, 0x66, 0x6d, 0x7d, 0x07, 0x7f, 0x6f, 0x0, 0x0

.macro m_ssi_init
	; parameters:
	;	@0	word 	[st_ssi]
	;	@1	word 	[DDRx]
	;	@2	word 	[PORTx]
	;	@3	byte	ST_SSI_CONNECTION_TYPE
	; save registers
	m_save_r23_Z_registers
	; init (device_io)st_ssi
	m_out_byte_init @0, @1, @2
	; init ssi
	ldi ZL, low(@0)
	ldi ZH, high(@0)
	ldi r23, @3
	rcall ssi_init

	ldi r23, SSI_STATE_ON
	rcall ssi_state_set
	;release stack from parameters
	;restore registers
	m_restore_r23_Z_registers
.endm

ssi_init:
	; parameters:
	;	Z	word	[st_ssi]
	m_save_r22_r23_registers
	m_set_struct_byte_by_offset_and_register_wo_save_registers ST_SSI_CONNECTION_TYPE, r23
	m_set_struct_byte_by_offset_and_value_wo_save_registers ST_SSI_STATE_OFFSET, SSI_STATE_OFF
	m_set_struct_byte_by_offset_and_value_wo_save_registers ST_SSI_SHOWN_OFFSET, SSI_SHOWN_FALSE
	m_set_struct_byte_by_offset_and_value_wo_save_registers ST_SSI_SYMBOL_OFFSET, SSI_SYMBOL_NULL
	m_set_struct_byte_by_offset_and_value_wo_save_registers ST_SSI_FLASH_OFFSET, SSI_FLASH_OFF
	m_set_struct_byte_by_offset_and_value_wo_save_registers ST_SSI_FLASH_TIMEOUT_COUNTER_OFFSET, SSI_FLASH_TIMEOUT
	m_set_struct_byte_by_offset_and_value_wo_save_registers ST_SSI_FLASH_STATE_VISIBLE_OFFSET, SSI_FLASH_STATE_VISIBLE_TRUE

	m_restore_r22_r23_registers

	ret

.macro m_ssi_state_set
	; parameters:
	;	@0	word	[st_ssi]
	;	@1	byte 	SSI_STATE
	; save registers
	m_save_r23_Z_registers
	; push parameters
	ldi r23, @1
	ldi ZL, low(@0)
	ldi ZH, high(@0)
	; call procedure
	rcall ssi_state_set
	; release stack from parameters
	; restore registers
	m_restore_r23_Z_registers
.endm

.macro  m_ssi_off
	; parameters:
	;	@0 	word	[st_ssi]
	m_ssi_state_set @0, SSI_STATE_OFF
.endm

.macro  m_ssi_on
	; parameters:
	;	@0 	word	[st_ssi]
	m_ssi_state_set @0, SSI_STATE_ON
.endm

ssi_state_set:
	; parameters:
	;	Z	word	st_ssi
	;	r23	byte	ssi_state

	m_set_struct_byte_by_offset_and_register ST_SSI_STATE_OFFSET, r23

	ret

.macro m_ssi_flash_set
	; parameters:
	;	@0	word	[st_ssi]
	;	@1	byte	ST_SSI_FLASH
	m_save_r23_Z_registers

	ldi ZL, low(@0)
	ldi ZH, high(@0)

	ldi r23, @1

	rcall ssi_flash_set

	m_restore_r23_Z_registers
.endm

.macro m_ssi_flash_on
	; parameters:
	;	@0	word	[st_ssi]
	m_ssi_flash_set @0, SSI_FLASH_ON
.endm

.macro m_ssi_flash_off
	; parameters:
	;	@0	word	[st_ssi]
	m_ssi_flash_set @0, SSI_FLASH_OFF
.endm

ssi_flash_set:
	; parameters:
	;	Z	word	[st_ssi]
	;	r23	byte	SSI_STATE
	; load ssi_state
	; check state to set
	m_set_struct_byte_by_offset_and_register ST_SSI_FLASH_OFFSET, r23
	cpi r23, SSI_FLASH_OFF
	breq ssi_flash_set_end
	ssi_flash_set_on:
		m_set_struct_byte_by_offset_and_value ST_SSI_FLASH_TIMEOUT_COUNTER_OFFSET, SSI_FLASH_TIMEOUT
		m_set_struct_byte_by_offset_and_value ST_SSI_FLASH_STATE_VISIBLE_OFFSET, SSI_FLASH_STATE_VISIBLE_TRUE

	ssi_flash_set_end:

	ret

.macro m_ssi_char_show
	; parameters:
	; 	@0	word	[st_ssi]
	; 	@1	byte	char
	m_save_r23_Z_registers

	ldi ZL, low(@0)
	ldi ZH, high(@0)
	ldi r23, @1
	
	; call proc
	rcall ssi_char_show

	m_restore_r23_Z_registers
.endm

ssi_char_show:
	; parameters
	;	Z	word	[st_ssi]
	;	r23	byte	char
	m_save_r16_r23_SREG_registers
	; sub first letter from the 
	subi r23, ASCII_ZERO

	rcall ssi_char_show_by_number

	m_restore_r16_r23_SREG_registers

	ret

.macro m_ssi_char_show_by_number
	; parameters:
	; 	@0	word	[st_ssi]
	; 	@1	reg	number
	m_save_r23_Z_registers

	ldi ZL, low(@0)
	ldi ZH, high(@0)
	mov r23, @1
	
	; call proc
	rcall ssi_char_show_by_number

	m_restore_r23_Z_registers
.endm

ssi_char_show_by_number:
	; parameters
	;	Z	word	[st_ssi]
	;	r23	byte	char
	m_save_r16_r22_r23_SREG_registers
	;
	push ZL
	push ZH
	; get digit symbol
	ldi ZL, low(ssi_digits)
	ldi ZH, high(ssi_digits)
	; convert a char to a SSI symbol
	add ZL, ZL
	adc ZH, ZH
	add ZL, r23
	ldi r22, 0x00
	adc ZH, r22
	lpm r22, Z

	pop ZH
	pop ZL
	; store symbol to the st_ssi (this)
;	ldi r23, ST_SSI_SYMBOL
;	rcall set_struct_byte
	m_set_struct_byte_by_offset_and_register_wo_save_registers ST_SSI_SYMBOL_OFFSET, r22
	m_set_struct_byte_by_offset_and_value_wo_save_registers ST_SSI_SHOWN_OFFSET, SSI_SHOWN_FALSE

	;
	m_restore_r16_r22_r23_SREG_registers

	ret

.macro m_ssi_handle_io
	; parameters:
	;	@0	word	[st_ssi]
	m_save_Z_registers
	;
	ldi ZL, low(@0)
	ldi ZH, high(@0)

	rcall ssi_handle_io
	;
	m_restore_Z_registers
.endm

ssi_handle_io:
	; parameters
	;	Z	word	[st_ssi]
	;CALCULATE_TICKS_BY_TIME
	m_save_r23_SREG_registers

	m_get_struct_byte_by_offset ST_SSI_STATE_OFFSET
	cpi r23, SSI_STATE_OFF
	brne ssi_handle_check
	rjmp ssi_handle_io_end

	ssi_handle_check:
		m_get_struct_byte_by_offset ST_SSI_SHOWN_OFFSET
		cpi r23, SSI_SHOWN_TRUE
		breq ssi_handle_check_flash
		; set shown to true
		m_set_struct_byte_by_offset_and_value ST_SSI_SHOWN_OFFSET, SSI_SHOWN_TRUE
		; show symbol
		m_get_struct_byte_by_offset ST_SSI_SYMBOL_OFFSET
		rcall symbol_out

	ssi_handle_check_flash:
		m_get_struct_byte_by_offset ST_SSI_FLASH_OFFSET
		cpi r23, SSI_FLASH_ON
		breq ssi_handle_io_flash_on

	ssi_handle_io_flash_off:
		rjmp ssi_handle_io_end

	ssi_handle_io_flash_on:
		m_get_struct_byte_by_offset ST_SSI_FLASH_TIMEOUT_COUNTER_OFFSET
		cpi r23, SSI_FLASH_TIMEOUT_FINISHED
		breq ssi_handle_io_flash_on_timeout_finished
		dec r23
		m_set_struct_byte_by_offset_and_register ST_SSI_FLASH_TIMEOUT_COUNTER_OFFSET, r23
		rjmp ssi_handle_io_end

		ssi_handle_io_flash_on_timeout_finished:
			m_set_struct_byte_by_offset_and_value ST_SSI_FLASH_TIMEOUT_COUNTER_OFFSET, SSI_FLASH_TIMEOUT
			m_get_struct_byte_by_offset ST_SSI_FLASH_STATE_VISIBLE_OFFSET
			cpi r23, SSI_FLASH_STATE_VISIBLE_TRUE
			breq ssi_handle_io_flash_on_timeout_finished_symbol_hide
        	ssi_handle_io_flash_on_timeout_finished_symbol_show:
				m_set_struct_byte_by_offset_and_value ST_SSI_FLASH_STATE_VISIBLE_OFFSET, SSI_FLASH_STATE_VISIBLE_TRUE	
				m_get_struct_byte_by_offset ST_SSI_SYMBOL_OFFSET
				rcall symbol_out
			ssi_handle_io_flash_on_timeout_finished_symbol_hide:
				m_set_struct_byte_by_offset_and_value ST_SSI_FLASH_STATE_VISIBLE_OFFSET, SSI_FLASH_STATE_VISIBLE_FALSE
				ldi r23, SSI_SYMBOL_NULL
				rcall symbol_out



	ssi_handle_io_end:
		m_restore_r23_SREG_registers

	ret


symbol_out:
	; parameters:
	;	Z	word	[st_ssi]
	;	r23	byte	symbol
	m_save_r16_r23_SREG_registers

	push r23
	m_get_struct_byte_by_offset ST_SSI_CONNECTION_TYPE
	cpi r23, SSI_CONNECTION_TYPE_COMMON_CATHODE
	pop r23
	breq symbol_out_to_port

	symbol_out_invert:
		com r23
	symbol_out_to_port:
		rcall out_byte_set

	m_restore_r16_r23_SREG_registers

	ret
