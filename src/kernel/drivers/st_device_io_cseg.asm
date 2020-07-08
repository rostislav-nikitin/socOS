; implementation
.macro m_st_device_io_init
	; input parameters:
	;	@0 	word	st_device_io
	;	@1	word	DDRx 
	;	@2	word 	PINx
	;	@3	word 	PORTx
	;	@4	byte 	USED_BIT_MASK
	;	@5	byte	TYPE_BIT_MASK (0 - Input, 1 - Output)
	; save registers
	push r16
	; init st_device_io
	; push TYPE_BIT_MASK
	ldi r16, @5
	push r16
	; push USED_BIT_MASK
	ldi r16, @4
	push r16
	; push PORTx address
	ldi r16, high(@3 + IO_PORTS_OFFSET)
	push r16
	ldi r16, low(@3 + IO_PORTS_OFFSET)
	push r16
	; push PINx address
	ldi r16, high(@2 + IO_PORTS_OFFSET)
	push r16
	ldi r16, low(@2 + IO_PORTS_OFFSET)
	push r16
	; push DDRx address
	ldi r16, high(@1 + IO_PORTS_OFFSET)
	push r16
	ldi r16, low(@1 + IO_PORTS_OFFSET)
	push r16
	; push st_device_io address
	ldi r16, high(@0)
	push r16
	ldi r16, low(@0)
	push r16

	rcall st_device_io_init
	;release stack from parameters
	pop r16
	pop r16
	pop r16
	pop r16
	pop r16
	pop r16
	pop r16
	pop r16
	pop r16
	pop r16
	;restore registers
	pop r16
.endm

st_device_io_init:
	; input parameters:
	;	word	st_device_io
	;	word	DDRx
	;	word	PINx
	;	word	PORTx
	;	byte 	USED_BIT_MASK
	;	byte	TYPE_BIT_MASK (0 - Input, 1 - Output)	
	m_save_r16_r17_r18_r19_X_Y_Z_registers
	; set X to the [st_device_io] address
	in XL, SPL
	in XH, SPH
	ldi r16, SZ_R16_R17_R18_R19_X_Y_Z_REGISTERS + SZ_RET_ADDRESS + SZ_STACK_PREVIOUS_OFFSET
	add XL, r16
	ldi r16, 0x00
	adc XH, r16
	; init st_device_io
	; load st_device_io address to Y
	ld YL, X+
	ld YH, X+
	; init st_device_io
	ldi r16, SZ_ST_DEVICE_IO

	rcall mem_copy

	ldi r16, ST_DEVICE_IO_USED_BIT_MASK_OFFSET
	rcall get_struct_byte_by_X_r16_to_r16
	mov r17, r16
	ldi r16, ST_DEVICE_IO_TYPE_BIT_MASK_OFFSET
	rcall get_struct_byte_by_X_r16_to_r16
	;mov r2, r16
	ldi ZL, ST_DEVICE_IO_PORTX_ADDRESS_OFFSET
	rcall get_struct_word_by_X_ZL_to_Z
	mov YL, ZL
	mov YH, ZH
	; save PORTx value
	ld r19, Y
	ldi ZL, ST_DEVICE_IO_DDRX_ADDRESS_OFFSET
	rcall get_struct_word_by_X_ZL_to_Z
	; load DDRX value
	ld r18, Z
	; apply BIT_MASK
	; find outputs MASK
	push r17
	; calculate all the outputs
	and r17, r16
	; add outputs to the existins outputs
	or r18, r17
	; set 0 by default to PORTx value
	com r17
	and r19, r17
	; restore USED
	pop r17
	; save USED
	push r16
	; calculate all the inputs
	com r16
	and r16, r17
	com r16
	; add inputs to the existing inputs
	and r18, r16
	; set 1 to PORTx value to pull up PINx input bits to the Vcc
	com r16
	or r19, r16
	pop r16
	; sum input + outputs then store to DDRx
	; store back to DDRx
	st Z, r18
	; store back PORTx
	st Y, r19

	m_restore_r16_r17_r18_r19_X_Y_Z_registers

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
