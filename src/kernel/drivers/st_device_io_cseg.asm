; naming convention:
; 	name - any value
; 	[address] - pointer to the address
;
; parameter passing convention:
; Z, Y, X, r24, r25		- address parameters
; r23, r22, r21, r20, r19, r18	- value parameters
; r17, r16			- temporary registers
; r0 .. r15			- work with data

; implementation
.macro m_st_device_io_init
	; input parameters:
	;	@0 	word	[st_device_io]
	;	@1	word	DDRx 
	;	@2	word 	PINx
	;	@3	word 	PORTx
	;	@4	byte 	USED_BIT_MASK
	;	@5	byte	TYPE_BIT_MASK (0 - Input, 1 - Output)
	; save registers

	m_save_r16_r17_r23_r24_X_Y_Z_registers

	; set [st_device_io] to the first Z parameter
	ldi ZL, low(@0)
	ldi ZH, high(@0)
	; set [DDRx] to the second Y parameter
	ldi YL, low(@1 + IO_PORTS_OFFSET)
	ldi YH, high(@1 + IO_PORTS_OFFSET)
	; set [PINx] to the third X parameter
	ldi XL, low(@2 + IO_PORTS_OFFSET)
	ldi XH, high(@2 + IO_PORTS_OFFSET)
	; set [PORTx] to the fouth r23, r24 paramter
	ldi r24, low(@3 + IO_PORTS_OFFSET)
	ldi r25, high(@3 + IO_PORTS_OFFSET)
	; set USED_BIT_MASK to the fifth parameter r23
	ldi r23, @4
	; set TYPE_BIT_MASK to the sixth paramerer r22
	ldi r22, @5

	rcall st_device_io_init

	; restore registers
	m_restore_r16_r17_r23_r24_X_Y_Z_registers
.endm

st_device_io_init:
	; input parameters:
	;	word	[st_device_io]
	;	word	[DDRx]
	;	word	[PINx]
	;	word	[PORTx]
	;	byte 	USED_BIT_MASK
	;	byte	TYPE_BIT_MASK (0 - Input, 1 - Output)	
	; set X to the [st_device_io] address

	ldi r16, 0x00
	; copy [DDRx] to the [st_device_io]
	push ZL
	push ZH
	; store [DDRx] into the [st_device_io]
	st Z+, YL
	st Z+, YH
	; store [PINx] into the [st_device_io]
	st Z+, XL
	st Z+, XH
	; store [PORTx] into the [st_device_io]
	st Z+, r24
	st Z+, r25
	; store [USED_BIT_MASK] into the [st_device_io]
	st Z+, r23
	; stotr [TYPE_BIT_MASK] into the [st_device_io]
	st Z, r22
	; restore Z
	pop ZH
	pop ZL
	; set Z to the [PORTx]
	mov ZL, r24
	mov ZH, r25
	; set r16 to the PORTx
	ld r16, Z
	; set r17 to the DDRx
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
	; set 1 to PORTx value to pull up PINx input bits to the Vcc
	com r22
	or r16, r22
	pop r22
	; sum input + outputs then store to DDRx
	; store back to DDRx
	st Y, r17
	; store back PORTx
	st Z, r16

	ret

.macro m_device_io_get_pin_byte
	; input parameter:
	;	@0	word	[st_device_io] or derived
	; returns:
	; 	@1	register for pin
	;	@2	register for used_bit_mask
	; m_save_r23_Z
	
	ldi ZL, low(@0)
	ldi ZH, high(@0)

	rcall device_io_get_pin_byte

	mov @1, r23
	mov @2, r22

	; m_restore_r23_Z
.endm

.macro m_device_io_get_port_byte
	; input parameter:
	;	@0	word	[st_device_io] or derived
	; returns:
	; 	@1	register for pin
	;	@2	register for used_bit_mask
	; m_save_r23_Z
	
	ldi ZL, low(@0)
	ldi ZH, high(@0)

	rcall device_io_get_port_byte

	mov @1, r23
	mov @2, r22

	; m_restore_r23_Z
.endm

st_device_io_get_pin_byte:
	; parameters:
	;	Z	word	[st_device_io] or derived
	; returns:
	;	r23	byte	pin
	;	r22	byte	used_bit_mask

	ldi r23, ST_DEVICE_IO_PINX_ADDRESS_OFFSET

	rcall st_device_io_get_px_byte

	ret

st_device_io_get_port_byte:
	; parameters:
	;	word	[st_device_io] or derived
	; returns:
	;	byte	port
	;	byte	used_bit_mask

	ldi r23, ST_DEVICE_IO_PORTX_ADDRESS_OFFSET

	rcall st_device_io_get_px_byte

	ret

st_device_io_get_px_byte:
	; parameters:
	;	word	[st_device_io] or derived
	;	byte	PINx/PORTx ADDRESS OFFSET
	; returns:
	;	byte	PINx/PORTx value
	;	byte	USED_BIT_MASK

	; set X to the [st_device_io] or derived
	; save PORT/PIN ADDRESS OFFSET
	mov r17, r23
	; load USED_BIT_MASK into the r23
	ldi r23, ST_DEVICE_IO_USED_BIT_MASK_OFFSET
	rcall get_struct_byte_by_Z_r23_to_r23
	; set second return value
	mov r22, r23
	; set [PINx]/[PORTx] offset
	mov r23, r17
	; get [PINx]/[PORTx]
	rcall get_struct_word_by_Z_r23_to_Z
	; load [PINx]/[PORTx] value
	ld r23, Z
	; detect current state and set it to the first return value
	and r23, r22

	ret

.macro m_device_io_set_port_byte
	; input parameter:
	;	@0	word	[st_device_io] or derived
	;	@1	byte	value to set

	rcall device_io_set_port_byte
.endm

st_device_io_set_port_byte:
	; parameters:
	;	word	[st_device_io] or derived
	;	byte	value
	m_save_r16_r17_X_Z_registers

	; save value to set
	mov r16, r23
	; load USED_BIT_MASK into the r23
	ldi r23, ST_DEVICE_IO_USED_BIT_MASK_OFFSET
	rcall get_struct_byte_by_Z_r23_to_r23
	; calculate set value
	mov r17, r23
	; load PORTx address to the Y & load PORTx value into the r16
	ldi r23, ST_DEVICE_IO_PORTX_ADDRESS_OFFSET
	rcall get_struct_word_by_Z_r23_to_Z
	ld r23, Z
	; calculate new value (add caclulated value to the existing value)
	com r17
	and r23, r17
	com r17
	and r16, r17
	; save to return value
	or r23, r16

	st Z, r23

	m_restore_r16_r17_X_Z_registers

	ret
