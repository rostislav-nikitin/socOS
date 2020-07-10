; extensions

.macro m_save_SREG_registers
	push r16
	in r16, SREG
	push r16
.endm

.macro m_restore_SREG_registers
	pop r16
	out SREG, r16
	pop r16
.endm

.macro m_save_r1_r2_r3_r16_SREG_registers
	push r1
	push r2
	push r3
	push r16
	in r16, SREG
	push r16
.endm

.macro m_restore_r1_r2_r3_r16_SREG_registers
	pop r16
	out SREG, r16
	pop r16
	pop r3
	pop r2
	pop r1
.endm

.macro m_save_r16_SREG_registers
	push r16
	in r16, SREG
	push r16
.endm

.macro m_restore_r16_SREG_registers
	pop r16
	out SREG, r16
	pop r16
.endm

.macro m_save_r16_Z_SREG_registers
	; save SREG
	;push r16
	;in r16, SREG
	;push r16
	;pop r16
	; save other regs
	push r16
	push ZL
	push ZH
.endm

.macro m_restore_r16_Z_SREG_registers
	pop ZH
	pop ZL
	pop r16
	;out SREG, r16
	;pop r16
.endm

.macro m_save_r16_r17_registers
	push r16
	push r17
.endm

.macro m_restore_r16_r17_registers
	pop r17
	pop r16
.endm

.macro m_save_r16_r17_SREG_registers
	push r16
	push r17
	in r16, SREG
	push r16
.endm

.macro m_restore_r16_r17_SREG_registers
	pop r16
	out SREG, r16
	pop r17
	pop r16
.endm

.macro m_save_r16_r17_r18_SREG_registers
	push r16
	push r17
	push r18
	in r16, SREG
	push r16
.endm

.macro m_restore_r16_r17_r18_SREG_registers
	pop r16
	out SREG, r16
	pop r18
	pop r17
	pop r16
.endm

.macro m_save_r23_registers
	push r23
.endm

.macro m_restore_r23_registers
	pop r23
.endm

.macro m_save_r23_SREG_registers
	push r23
	in r23, SREG
	push r23
.endm

.macro m_restore_r23_SREG_registers
	pop r23
	out SREG, r23
	pop r23
.endm

.macro m_save_r22_SREG_registers
	push r22
	in r22, SREG
	push r22
.endm

.macro m_restore_r22_SREG_registers
	pop r22
	out SREG, r22
	pop r22
.endm

.macro m_save_r21_r22_r23_Z_registers
	push r21
	push r22
	push r23
	push ZL
	push ZH
.endm

.macro m_restore_r21_r22_r23_Z_registers
	pop ZH
	pop ZL
	pop r23
	pop r22
	pop r21
.endm

.macro m_save_r21_r22_r23_Z_SREG_registers
	push r21
	in r21, SREG
	push r21
	push r22
	push r23
	push ZL
	push ZH
.endm

.macro m_restore_r21_r22_r23_Z_SREG_registers
	pop ZH
	pop ZL
	pop r23
	pop r22
	pop r21
	out SREG, r21
	pop r21
.endm

.macro m_save_Z_registers
	push ZL
	push ZH
.endm

.macro m_restore_Z_registers
	pop ZH
	pop ZL
.endm

.macro m_save_r23_Z_registers
	push r23
	push ZL
	push ZH
.endm

.macro m_restore_r23_Z_registers
	pop ZH
	pop ZL
	pop r23
.endm

.macro m_save_r22_r23_registers
	push r22
	push r23
.endm

.macro m_restore_r22_r23_registers
	pop r23
	pop r22
.endm

.macro m_save_r22_r23_Z_registers
	push r22
	push r23
	push ZL
	push ZH
.endm

.macro m_restore_r22_r23_Z_registers
	pop ZH
	pop ZL
	pop r23
	pop r22
.endm

.macro m_save_r22_r23_r24_r25_X_Y_Z_registers
	push r22
	push r23
	push r24
	push r25
	push XL
	push XH
	push YL
	push YH
	push ZL
	push ZH
.endm

.macro m_restore_r22_r23_r24_r25_X_Y_Z_registers
	pop ZH
	pop ZL
	pop YH
	pop YL
	pop XH
	pop XL
	pop r25
	pop r24
	pop r23
	pop r22
.endm

.macro m_save_r16_r17_r23_r24_X_Y_Z_registers
        push ZL
        push ZH
        push YL
        push YH
        push XL
        push XH
        push r23
        push r24

        in r24, SREG
        push r24
.endm

.macro m_restore_r16_r17_r23_r24_X_Y_Z_registers
        pop r24
        out SREG, r24

        pop r24
        pop r23
        pop XH
        pop XL
        pop YH
        pop YL
        pop ZH
        pop ZL
.endm

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

.macro m_save_r16_r17_X_registers
	push r16
	push r17
	push XL
	push XH
	in r16, SREG
	push r16
.endm

.macro m_restore_r16_r17_X_registers
	pop r16
	out SREG, r16
	pop XH
	pop XL
	pop r17
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

.macro m_save_r16_r17_X_Z_registers
	push r16
	push r17
	push XL
	push XH
	push ZL
	push ZH
	in r16, SREG
	push r16
.endm

.macro m_restore_r16_r17_X_Z_registers
	pop r16
	out SREG, r16
	pop ZH
	pop ZL
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

get_struct_byte_by_Z_r23_to_r23:
	; parameters
	; X - st_address
	; r23 - offset / result
	push ZL
	push ZH
	add ZL, r23
	eor r23, r23
	adc ZH, r23
	ld r23, Z
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

get_struct_word_by_Z_r23_to_Z:
	; parameters
	; Z - [st_*]
	; r23 - offset
	; result:
	; ZL - L
	; ZH - H
	; add offset to the [st_*] in Z
	push r23

	add ZL, r23
	eor r23, r23
	adc ZH, r23
	; load address to the Z
	ld r23, Z+
	ld ZH, Z
	mov ZL, r23
	; return (Z contains target address)
	
	pop r23

	ret

set_struct_byte_by_Z_r16_r17:
	m_save_r16_Z_SREG_registers

	add ZL, r16
	ldi r16, 0x00
	adc ZH, r16
	st Z, r17

	m_restore_r16_Z_SREG_registers	

	ret

/*
get_second_param_address_and_st_device_io_address:
	; input parameters:
	; return value:
	;	word	address of the second parameter of the previous procedure
	;	word	address ot the st_dev
	m_save_r16_X_Z_registers
	; set X to the [dev: st_device_io]
	in XL, SPL
	in XH, SPH
	ldi r16, SZ_R16_X_Z_REGISTERS + SZ_RET_ADDRESS + SZ_STACK_PREVIOUS_OFFSET
	add XL, r16
	ldi r16, 0x00
	adc XH, r16

	mov ZL, XL
	mov ZH, XH

	; set X to the address of the second parameter (after the dev: st_device_io) of the previous procedure
	ldi r16, (2 * SZ_ADDRESS) + SZ_RET_ADDRESS + SZ_ADDRESS
	add ZL, r16
	ldi r16, 0x00
	adc ZH, r16
	; first return value
	st X+, ZL
	st X+, ZH
	; get [st_dev: st_device_io]
	ld r16, Z+
	ld ZH, Z
	; second return parameter
	st X+, r16
	st X, ZH

	m_restore_r16_X_Z_registers

	ret
*/
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
