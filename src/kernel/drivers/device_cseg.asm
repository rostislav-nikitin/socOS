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

;.include "kernel/kernel_cseg.asm"

.macro m_device_init
.endm

device_init:
	ret

device_raise_event:
	; parameters:
	; 	Z	word	[:st_device]
	;	Y	word	event handler input/output parameters
	; 	r23	byte	st_device::event_handler_address_offset
	m_save_r16_Z_SREG_registers

	push YL
	push YH
	rcall get_struct_word
	m_set_Y_to_null_pointer
	rcall cpw
	pop YH
	pop YL
	breq device_raise_event_end
	icall

	device_raise_event_end:

	m_restore_r16_Z_SREG_registers

	ret
