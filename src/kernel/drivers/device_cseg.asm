;=======================================================================================================================
;                                                                                                                      ;
; Name:	socOS (System On Chip Operation System)                                                                        ;
; 	Year: 		2020                                                                                           ;
; 	License:	MIT License                                                                                    ;
;                                                                                                                      ;
;=======================================================================================================================

; Require:
;.include "m8def.inc"

.macro m_device_init
.endm

device_init:
	ret

device_raise_event:
	; parameters:
	; 	Z	word	[:st_device]
	; 	r23	byte	st_device::event_handler_address_offset
	m_save_r16_Y_Z_SREG_registers

	rcall get_struct_word
	push YL
	push YH
	m_set_Y_to_null_pointer
	rcall cpw
	pop YH
	pop YL
	breq device_raise_event_end
	icall

	device_raise_event_end:

	m_restore_r16_Y_Z_SREG_registers

	ret
