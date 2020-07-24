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
;.include "kernel/drivers/io/out_bit_def.asm"

;.include "kernel/kernel_cseg.asm"
;.include "kernel/drivers/device_cseg.asm"
;.include "kernel/drivers/io/device_io_cseg.asm"
;.include "kernel/drivers/io/out_bit_cseg.asm"

; usage:
; .dseg
;   switch1: .BYTE SZ_ST_SWITCH
;   ...
; .cseg
;   m_switch_init switch1, DDRB, PORTB, (1 << BIT1)
;   ...
;   m_switch_set switch1, SWITCH_STATE_ON
;   m_switch_set switch1, SWITCH_STATE_OFF
;   m_switch_on switch1
;   m_switch_off switch1
;   m_switch_toggle switch1
;   m_switch_get switch1

.macro m_switch_init
	; parameters:
	;	@0	word [st_switch]
	;	@1	word [DDRx]
	;	@2	word [PORTx]
	;	@3	word USED_BIT_MASK
	; save registers

	m_out_bit_init @0, @1, @2, @3
.endm

switch_init:
	; parameters:
	;	Z	word	[st_switch]
	; currently no additional logic
	ret

.macro m_switch_set
	; parameters:
	;	@0	word	[st_switch]
	;	@1	byte 	SWITCH_STATE
	m_out_bit_set @0, @1
.endm

.macro  m_switch_on
	; parameters:
	;	@0 	word	[st_switch]
	m_switch_set @0, SWITCH_STATE_ON
.endm

.macro  m_switch_off
	; parameters:
	;	@0 	word	[st_switch]
	m_switch_set @0, SWITCH_STATE_OFF
.endm

switch_set:
	; parameters:
	;	Z	word	[st_switch]
	;	r23	byte	SWITCH_STATE
	rcall out_bit_set

	ret

.macro m_switch_get
	; parameters:
	;	@0	word	[st_switch]
	; returns:
	;	@1	reg	SWITCH_STATE
	m_out_bit_get @0, @1
.endm

switch_get:
	; parameters:
	;	Z	word	[st_switch]
	; returns:
	;	r23	byte	SWITCH_STATE
	rcall out_bit_get

	ret

.macro m_switch_toggle
	; parameters:
	; 	@0	word	[st_switch]
	m_out_bit_toggle @0
.endm

switch_toggle:
	; parameters:
	;	Z	word	[st_switch]
	rcall switch_toggle

	ret