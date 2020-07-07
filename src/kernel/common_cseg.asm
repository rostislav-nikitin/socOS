; extensions
.macro m_save_r16_X_registers
	push r16
	push XL
	push XH
	in r16, SREG
	push r16
.endm

.macro m_restore_r16_X_registers
	pop r16
	out SREG, r16
	pop XH
	pop XL
	pop r16
.endm

.macro m_save_r16_X_Z_registers
	push r16
	push XL
	push XH
	push YL
	push YH
	in r16, SREG
	push r16
.endm

.macro m_restore_r16_X_Z_registers
	pop r16
	out SREG, r16
	pop YH
	pop YL
	pop XH
	pop XL
	pop r16
.endm

.macro m_save_r16_r17_X_Y_registers
	push r16
	push r17
	push XL
	push XH
	push YL
	push YH
	in r16, SREG
	push r16
.endm

.macro m_restore_r16_r17_X_Y_registers
	pop r16
	out SREG, r16
	pop YH
	pop YL
	pop XH
	pop XL
	pop r17
	pop r16
.endm

.macro m_save_r16_X_Y_Z_registers
	push r16
	push XL
	push XH
	push YL
	push YH
	push ZL
	push ZH
	in r16, SREG
	push r16
.endm

.macro m_restore_r16_X_Y_Z_registers
	pop r16
	out SREG, r16
	pop ZH
	pop ZL
	pop YH
	pop YL
	pop XH
	pop XL
	pop r16
.endm

.macro m_save_r16_r17_r18_X_Y_registers
	push r16
	push r17
	push r18
	push XL
	push XH
	push YL
	push YH
	in r16, SREG
	push r16
.endm

.macro m_restore_r16_r17_r18_X_Y_registers
	pop r16
	out SREG, r16
	pop YH
	pop YL
	pop XH
	pop XL
	pop r18
	pop r17
	pop r16
.endm

.macro m_save_r16_r17_X_Y_Z_registers
	push r16
	push r17
	push XL
	push XH
	push YL
	push YH
	push ZL
	push ZH
	in r16, SREG
	push r16
.endm

.macro m_restore_r16_r17_X_Y_Z_registers
	pop r16
	out SREG, r16
	pop ZH
	pop ZL
	pop YH
	pop YL
	pop XH
	pop XL
	pop r17
	pop r16
.endm

.macro m_save_r16_r17_r18_X_Y_Z_registers
	push r16
	push r17
	push r18
	push XL
	push XH
	push YL
	push YH
	push ZL
	push ZH
	in r16, SREG
	push r16
.endm

.macro m_restore_r16_r17_r18_X_Y_Z_registers
	pop r16
	out SREG, r16
	pop ZH
	pop ZL
	pop YH
	pop YL
	pop XH
	pop XL
	pop r18
	pop r17
	pop r16
.endm

.macro m_save_r16_r17_r18_r19_X_Y_Z_registers
	push r16
	push r17
	push r18
	push r19
	push XL
	push XH
	push YL
	push YH
	push ZL
	push ZH
	in r16, SREG
	push r16
.endm

.macro m_restore_r16_r17_r18_r19_X_Y_Z_registers
	pop r16
	out SREG, r16
	pop ZH
	pop ZL
	pop YH
	pop YL
	pop XH
	pop XL
	pop r19
	pop r18
	pop r17
	pop r16
.endm

.macro m_ports_init
	; save registers
	push r16

	ldi r16, 0xff
	out PORTB, r16
	out PORTC, r16
	out PORTD, r16

	; restore registers
	pop r16
.endm

mem_copy:
	; save registers
	; push r24
	; X - source
	; Y - destination
	; r16 - length
	; r17 - temp
	push r16
	push r17
	push XL
	push XH
	push YL
	push YH

	mem_copy_loop:
		cpi r16, 0x00
		breq mem_copy_loop_exit

		ld r17, X+
		st Y+, r17

		dec r16

		rjmp mem_copy_loop

	mem_copy_loop_exit:		

	; restore registers
	pop YH
	pop YL
	pop XH
	pop XL
	pop r17
	pop r16

	ret

get_struct_byte_by_X_r16_to_r16:
	; parameters
	; X - st_address
	; r16 - offset / result
	push XL
	push XH
	add XL, r16
	eor r16, r16
	adc XH, r16
	ld r16, X
	pop XH
	pop XL

	ret

get_struct_byte_by_Z_r16_to_r16:
	; parameters
	; X - st_address
	; r16 - offset / result
	push ZL
	push ZH
	add ZL, r16
	eor r16, r16
	adc ZH, r16
	ld r16, Z
	pop ZH
	pop ZL

	ret

get_struct_word_by_X_ZL_to_Z:
	; parameters
	; X - st_address
	; r16 - offset / result L
	; r17 - result H
	push XL
	push XH
	add XL, ZL
	eor ZL, ZL
	adc XH, ZL
	ld ZL, X+
	ld ZH, X
	pop XH
	pop XL

	ret

get_struct_word_by_Z_r16_to_Z:
	; parameters
	; Z - [st_*]
	; r16 - offset
	; result:
	; ZL - L
	; ZH - H
	; add offset to the [st_*] in Z
	add ZL, r16
	eor r16, r16
	adc ZH, r16
	; load address to the Z
	ld r16, Z+
	ld ZH, Z
	mov ZL, r16
	; return (Z contains target address)
	ret

/*
mem_copy:
	; parameters by value (through stack):
	;	word	from
	;	word	to
	;	word	length

	; save registers
	m_save_r16_r17_r18_X_Y_registers

	ldi r16, 0x00
	in YL, SPL
	in YH, SPH
	add YL, SZ_R16_R17_R18_X_Y_REGISTERS +  SZ_RET_ADDRESS + SZ_STACK_PREVIOUS_OFFSET
	adc YH, r16

	ld XH, Y+
	ld XL, Y+
	ld r16, Y+
	ld r17, Y+
	ld r18, Y
	mov YH, r16
	mov YL, r17

	; init index
	ldi r16, 0x00
	mem_copy_loop:
		cpi r16, r18
		brge mem_copy_loop_exit

		ld r18, X+
		st Y+, r18

		inc r16

		rjmp mem_copy_loop

	mem_copy_loop_exit:

	; restore registers
	m_restore_r16_r17_r18_X_Y_registers
	
	ret
*/
