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
	; input parameters:
	;	@0	word [st_switch:st_device_io]
	;	@1	word [DDRx]
	;	@2	word [PORTx]
	;	@3	word USED_BIT_MASK
	; save registers
	m_save_Z_registers
	; init (st_device_io)st_switch
	m_st_device_io_init @0, @1, 0x0000, @2, @3, @3
	; init switch
	ldi ZL, low(@0)
	ldi ZH, high(@0)
	rcall switch_init
	;release stack from parameters
	;restore registers
	m_restore_Z_registers
.endm

switch_init:
	; input parameters:
	;	Z	word	[st_switch:st_device_io]
	; currently no additional logic
	ret

.macro m_switch_set
	; input parameters:
	;	@0	word	[st_switch:st_device_io]
	;	@1	byte 	switch_state
	; save registers
	m_save_r23_Z_registers
	; push parameters
	ldi r23, @1
	ldi ZL, low(@0)
	ldi ZH, high(@0)
	; call procedure
	rcall switch_set
	; release stack from parameters
	; restore registers
	m_restore_r23_Z_registers
.endm

.macro  m_switch_on
	; input parameters:
	;	@0 	word	st_switch
	m_switch_set @0, SWITCH_STATE_ON
.endm

.macro  m_switch_off
	; input parameters:
	;	@0 	word	st_switch
	m_switch_set @0, SWITCH_STATE_OFF
.endm

switch_set:
	; input parameters:
	;	word	st_switch
	;	byte	switch_state
	m_save_SREG_registers
	; load switch_state
	; check state to set
	cpi r23, SWITCH_STATE_ON
	brne switch_set_off

	ldi r23, ST_SWITCH_USED_BIT_MASK_OFFSET
	rcall get_struct_byte
	rjmp switch_set_call_st_device_io_set_port_byte

	switch_set_off:
		ldi r23, 0x00
	switch_set_call_st_device_io_set_port_byte:
		rcall st_device_io_set_port_byte

	switch_set_end:
	m_restore_SREG_registers

	ret

.macro m_switch_get
	; input parameters:
	;	@0	word	[st_switch:st_device_io]
	; returns:
	;	@1	register
	m_save_Z_registers

	ldi ZL, low(@0)
	ldi ZH, high(@0)

	rcall switch_get

	m_restore_Z_registers
.endm

switch_get:
	; input parameters:
	;	Z	word	[st_switch:st_device_io]
	; returns:
	;	r23	byte	current switch state
	m_save_r22_SREG_registers
	; call st_device_io_get_pin_byte
	rcall st_device_io_get_port_byte
	; compare value
	and r23, r22
	breq switch_get_off
	switch_get_on:
		ldi r23, SWITCH_STATE_ON
		rjmp  switch_get_end
	switch_get_off:
		ldi r23, SWITCH_STATE_OFF

	switch_get_end:
		m_restore_r22_SREG_registers

	ret

.macro m_switch_toggle
	; input parameters:
	; 	@0	word	st_switch
	m_save_Z_registers

	ldi ZL, low(@0)
	ldi ZH, high(@0)

	rcall switch_toggle

	m_restore_Z_registers
.endm

switch_toggle:
	; input parameters:
	;	Z	word	[st_switch:st_device_io]
	m_save_r23_SREG_registers

	rcall switch_get

	cpi r23, SWITCH_STATE_ON
	brne switch_toggle_switch_on

	switch_toggle_switch_off:	
		ldi r23, SWITCH_STATE_OFF
		rjmp switch_toggle_switch_set
	switch_toggle_switch_on:
		ldi r23, SWITCH_STATE_ON

	switch_toggle_switch_set:
		rcall switch_set

	m_restore_r23_SREG_registers

	ret
