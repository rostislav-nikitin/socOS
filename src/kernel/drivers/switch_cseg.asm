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

	m_out_bit_init @0, @1, @2, @3
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
	m_out_bit_set @0, @1
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
	rcall out_bit_set

	ret

.macro m_switch_get
	; input parameters:
	;	@0	word	[st_switch:st_device_io]
	; returns:
	;	@1	register
	m_out_bit_get @0, @1
.endm

switch_get:
	; input parameters:
	;	Z	word	[st_switch:st_device_io]
	; returns:
	;	r23	byte	current switch state
	rcall out_bit_get

	ret

.macro m_switch_toggle
	; input parameters:
	; 	@0	word	st_switch
	m_out_bit_toggle @0
.endm

switch_toggle:
	; input parameters:
	;	Z	word	[st_switch:st_device_io]
	rcall switch_toggle

	ret
