.macro m_st_device_init
	; parameters
	;	@0	word [st_device]
.endm

st_device_init:
	ret

st_device_raise_event:
	; parameters
	; Z	word	[st_dev: st_device]
	; r23	byte	[event_handler]
	m_save_r16_Y_Z_SREG_registers

	rcall get_struct_word
	push YL
	push YH
	m_set_Y_to_null_pointer
	rcall cpw
	pop YH
	pop YL
	breq st_device_raise_event_end
	icall

	st_device_raise_event_end:

	m_restore_r16_Y_Z_SREG_registers

	reti
