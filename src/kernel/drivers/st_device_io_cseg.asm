; naming convention:
; 	name - any value
; 	[address] - pointer to the address
;
; parameter passing convention:
; Z, Y, X, r24, r25		- address parameters
; r23, r22, r21, r20, r19, r18	- value parameters
; r17, r16			- temporary registers
; r0 .. r15			- work with data
;
; inheritance
; st_child: st_parent - st_child inherited from the st_parent

; st_device_io: st_device
; implementation
.macro m_st_device_io_init
	; input parameters:
	;	@0 	Z	word	[dev:st_device_io]
	;	@1	Y	word	[DDRx]
	;	@2	X	word 	[PINx]
	;	@3	r24,r25	word 	[PORTx]
	;	@4	r23	byte 	USED_BIT_MASK
	;	@5	r22	byte	TYPE_BIT_MASK (0 - Input, 1 - Output)
	; save registers
	m_save_r22_r23_r24_r25_X_Y_Z_registers
	; set [dev:st_device_io] to the first Z parameter
	ldi ZL, low(@0)
	ldi ZH, high(@0)
	; set [DDRx] to the second Y parameter
	ldi YL, low(@1 + IO_PORTS_OFFSET)
	ldi YH, high(@1 + IO_PORTS_OFFSET)
	; set [PINx] to the third X parameter
	ldi XL, low(@2 + IO_PORTS_OFFSET)
	ldi XH, high(@2 + IO_PORTS_OFFSET)
	; set [PORTx] to the fouth r24, r25 paramter
	ldi r24, low(@3 + IO_PORTS_OFFSET)
	ldi r25, high(@3 + IO_PORTS_OFFSET)
	; set USED_BIT_MASK to the fifth parameter r23
	ldi r23, @4
	; set TYPE_BIT_MASK to the sixth paramerer r22
	ldi r22, @5

	rcall st_device_io_init

	; restore registers
	m_restore_r22_r23_r24_r25_X_Y_Z_registers
.endm

st_device_io_init:
	; input parameters:
	;	Z	word	[dev:st_device_io]
	;	Y	word	[DDRx]
	;	X	word	[PINx]
	;	r24,r25	word	[PORTx]
	;	r23	byte 	USED_BIT_MASK
	;	r22	byte	TYPE_BIT_MASK (0 - Input, 1 - Output)	
	; set X to the [st_device_io] address
	; call base ctor
	rcall st_device_init

	m_save_r16_r17_SREG_registers
	;
	ldi r16, 0x00
	; save Z
	push ZL
	push ZH
	; store [DDRx] into the [dev:st_device_io]
	st Z+, YL
	st Z+, YH
	; store [PINx] into the [dev:st_device_io]
	st Z+, XL
	st Z+, XH
	; store [PORTx] into the [dev:st_device_io]
	st Z+, r24
	st Z+, r25
	; store [USED_BIT_MASK] into the [dev:st_device_io]
	st Z+, r23
	; stotr [TYPE_BIT_MASK] into the [dev:st_device_io]
	st Z, r22
	; check does [DDRx] is NULL_POINTER
	m_set_Z_to_null_pointer
	ldi r16, IO_PORTS_OFFSET
	add ZL, r16
	ldi r16, 0x00
	adc ZH, r16
	rcall cpw
	; restore Z
	pop ZH
	pop ZL
	; check does [DDRx] is NULL_POINTER
	breq st_device_io_init_end
	; set Z to the [PORTx]
	mov ZL, r24
	mov ZH, r25
	; get PORTx (value)
	ld r16, Z
	; get DDRx (value)
	ld r17, Y
	; apply BIT_MASK
	; find outputs MASK
	push r23
	; calculate all the outputs
	and r23, r22
	; add outputs to the existins outputs
	or r17, r23
	; set 0 by default to PORTx value
	com r23
	and r16, r23
	; restore USED
	pop r23
	; save USED
	push r22
	; calculate all the inputs
	com r22
	and r22, r23
	com r22
	; add inputs to the existing inputs
	and r17, r22
	; set 1 to PORTx (value) to pull up PINx input bits to the Vcc
	com r22
	or r16, r22
	pop r22
	; sum input + outputs then store to the [DDRx]
	; store back to the [DDRx]
	st Y, r17
	; store back to the [PORTx]
	st Z, r16
	; store to the [PINx] "1" where [PORTx] pulled up to the Vcc
	st X, r16

	st_device_io_init_end:
		m_restore_r16_r17_SREG_registers

	ret

.macro m_device_io_get_pin_byte
	; input parameter:
	;	@0	Z	word	[dev:st_device_io] or derived
	; returns:
	; 	@1	r23	reg	PINx (value)
	;	@2	r22	reg	USED_BIT_MASK
	m_save_Z_registers
	
	ldi ZL, low(@0)
	ldi ZH, high(@0)

	rcall device_io_get_pin_byte

	mov @1, r23
	mov @2, r22

	m_restore_Z_registers
.endm

.macro m_device_io_get_port_byte
	; input parameter:
	;	@0	Z	word	[dev:st_device_io] or derived
	; returns:
	; 	@1	r23	reg	PINx (value)
	;	@2	r22	reg	USED_BIT_MASK
	m_save_Z_registers
	
	ldi ZL, low(@0)
	ldi ZH, high(@0)

	rcall device_io_get_port_byte

	mov @1, r23
	mov @2, r22

	m_restore_Z_registers
.endm

st_device_io_get_pin_byte:
	; parameters:
	;	Z	word	[dev:st_device_io] or derived
	; returns:
	;	r23	byte	[PINx] (value)
	;	r22	byte	USED_BIT_MASK

	ldi r23, ST_DEVICE_IO_PINX_ADDRESS_OFFSET

	rcall st_device_io_get_px_byte

	ret

st_device_io_get_port_byte:
	; parameters:
	;	Z	word	[dev:st_device_io] or derived
	; returns:
	;	r23	byte	[PORTx] (value)
	;	r22	byte	USED_BIT_MASK

	ldi r23, ST_DEVICE_IO_PORTX_ADDRESS_OFFSET

	rcall st_device_io_get_px_byte

	ret

st_device_io_get_px_byte:
	; parameters:
	;	Z	word	[dev:st_device_io]
	;	r23	byte	[PINx]/[PORTx] offset
	; returns:
	;	r23	byte	PINx/PORTx (value)
	;	r22	byte	USED_BIT_MASK
	m_save_r16_Z_SREG_registers
	; set X to the [st_device_io] or derived
	; save PORT/PIN ADDRESS OFFSET
	mov r16, r23
	; load USED_BIT_MASK into the r23
	ldi r23, ST_DEVICE_IO_USED_BIT_MASK_OFFSET
	rcall get_struct_byte
	; set second return value
	mov r22, r23
	; set [PINx]/[PORTx] offset
	mov r23, r16
	; get [PINx]/[PORTx]
	rcall get_struct_word
	; load [PINx]/[PORTx] value
	ld r23, Z
	; detect current state and set it to the first return value
	and r23, r22
	;
	m_restore_r16_Z_SREG_registers

	ret

.macro m_device_io_set_port_byte
	; input parameter:
	;	@0	Z	word	[dev:st_device_io] or derived
	;	@1	r23	byte	value to set

	rcall device_io_set_port_byte
.endm

st_device_io_set_port_byte:
	; parameters:
	;	word	[dev:st_device_io]
	;	byte	value
	m_save_r16_r17_SREG_registers
	; save value to set
	mov r16, r23
	; load USED_BIT_MASK into the r23
	ldi r23, ST_DEVICE_IO_USED_BIT_MASK_OFFSET
	rcall get_struct_byte
	; calculate set value
	mov r17, r23
	; load PORTx address to the Y & load PORTx value into the r16
	ldi r23, ST_DEVICE_IO_PORTX_ADDRESS_OFFSET
	rcall get_struct_word
	ld r23, Z
	; calculate new value (add caclulated value to the existing value)
	com r17
	and r23, r17
	com r17
	and r16, r17
	or r23, r16
	; save to [PORTx]
	st Z, r23
	;
	m_restore_r16_r17_SREG_registers

	ret
