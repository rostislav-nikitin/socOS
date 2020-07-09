; naming convention:
; 	name - any value
; 	[address] - pointer to the address
;
; parameter passing convention:
; Z, Y, X, r24, r25, r23, r24 	- address parameters
; r23, r22, r20, r19, r18	- value parameters
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
	; 	@1	register
	push @1
	ldi @1, low(@0)
	push @1
	ldi @1, high(@0)
	push @1

	rcall device_io_get_pin_byte

	pop @1
	pop @1
	pop @1
.endm

.macro m_device_io_get_port_byte
	; input parameter:
	;	@0	word	[st_device_io] or derived
	; returns:
	; 	@1	register
	push @1
	ldi @1, low(@0)
	push @1
	ldi @1, high(@0)
	push @1

	rcall device_io_get_port_byte

	pop @1
	pop @1
	pop @1
.endm


st_device_io_get_pin_byte:
	; parameters:
	;	word	[st_device_io] or derived
	; returns:
	;	byte	pin
	;	byte	used_bit_mask
	m_save_r16_X_Z_registers

	; set X to the [st_device_io] or derived
	in XL, SPL
	in XH, SPH
	ldi r16, SZ_R16_X_Z_REGISTERS + SZ_RET_ADDRESS + SZ_STACK_PREVIOUS_OFFSET
	add XL, r16
	ldi r16, 0x00
	adc XH, r16
	; load [st_device_io] address to Z
	ld ZL, X+
	ld ZH, X+
	; push 2 bytes for result
	push r16
	push r16
	ldi r16, ST_DEVICE_IO_PINX_ADDRESS_OFFSET
	push r16
	push ZH
	push ZL

	rcall st_device_io_get_px_byte
	; release stack from the input parameters
	pop r16
	pop r16
	pop r16
	; get value
	pop r16
	; get bit mask
	pop ZL

	
	; save to return value
	st X+, r16
	st X+, ZL

	m_restore_r16_X_Z_registers

	ret

st_device_io_get_port_byte:
	; parameters:
	;	word	[st_device_io] or derived
	; returns:
	;	byte	port
	;	byte	used_bit_mask
	m_save_r16_X_Z_registers

	; set X to the [st_device_io] or derived
	in XL, SPL
	in XH, SPH
	ldi r16, SZ_R16_X_Z_REGISTERS + SZ_RET_ADDRESS + SZ_STACK_PREVIOUS_OFFSET
	add XL, r16
	ldi r16, 0x00
	adc XH, r16
	; load [st_device_io] address to Z
	ld ZL, X+
	ld ZH, X+
	; push 2 bytes for result
	push r16
	push r16
	ldi r16, ST_DEVICE_IO_PORTX_ADDRESS_OFFSET
	push r16
	push ZH
	push ZL

	rcall st_device_io_get_px_byte
	; release stack from the input parameters
	pop r16
	pop r16
	pop r16
	; get value
	pop r16
	; get bit mask
	pop ZL

	
	; save to return value
	st X+, r16
	st X+, ZL

	m_restore_r16_X_Z_registers

	ret

st_device_io_get_px_byte:
	; parameters:
	;	word	[st_device_io] or derived
	;	byte	PINx/PORTx ADDRESS OFFSET
	; returns:
	;	byte	PINx/PORTx value
	;	byte	USED_BIT_MASK
	m_save_r16_r17_X_Z_registers

	; set X to the [st_device_io] or derived
	in XL, SPL
	in XH, SPH
	ldi r16, SZ_R16_R17_X_Z_REGISTERS + SZ_RET_ADDRESS + SZ_STACK_PREVIOUS_OFFSET
	add XL, r16
	ldi r16, 0x00
	adc XH, r16
	; load [st_device_io] address to Z
	ld ZL, X+
	ld ZH, X+
	; load PORT/PIN ADDRESS OFFSET
	ld r17, X+
	; save PORT/PIN ADDRESS OFFSET
	; load USED_BIT_MASK into the r16
	ldi r16, ST_DEVICE_IO_USED_BIT_MASK_OFFSET
	rcall get_struct_byte_by_Z_r16_to_r16
	push r16
	; load PINx address to the Y & load PINx value into the r16
	mov r16, r17
	rcall get_struct_word_by_Z_r16_to_Z
	ld r16, Z
	; pop BIT_MASK_OFFSET pushed from r16
	pop ZL
	; detect current state
	and r16, ZL
	; save to return value
	st X+, r16
	st X+, ZL

	m_restore_r16_r17_X_Z_registers

	ret

.macro m_device_io_set_port_byte
	; input parameter:
	;	@0	word	[st_device_io] or derived
	; returns:
	; 	@1	register
	push @1
	ldi @1, low(@0)
	push @1
	ldi @1, high(@0)
	push @1

	rcall device_io_set_port_byte

	pop @1
	pop @1
	pop @1
.endm

st_device_io_set_port_byte:
	; parameters:
	;	word	[st_device_io] or derived
	;	byte	value
	m_save_r16_r17_X_Z_registers

	; set X to the [[st_device_io]] or derived
	in XL, SPL
	in XH, SPH
	ldi r16, SZ_R16_R17_X_Z_REGISTERS + SZ_RET_ADDRESS + SZ_STACK_PREVIOUS_OFFSET
	add XL, r16
	ldi r16, 0x00
	adc XH, r16
	; load [st_device_io] address to Z
	ld ZL, X+
	ld ZH, X+
	; load value to set
	ld r17, X+
	; load USED_BIT_MASK into the r16
	ldi r16, ST_DEVICE_IO_USED_BIT_MASK_OFFSET
	rcall get_struct_byte_by_Z_r16_to_r16
	; calculate set value
	; com r16
	mov XL, r16
	; load PORTx address to the Y & load PORTx value into the r16
	ldi r16, ST_DEVICE_IO_PORTX_ADDRESS_OFFSET
	rcall get_struct_word_by_Z_r16_to_Z
	ld r16, Z
	; calculate new value (add caclulated value to the existing value)
	and r17, XL
	com XL
	and r16, XL
	or r16, r17
	; save to return value
	st Z, r16

	m_restore_r16_r17_X_Z_registers

	ret
