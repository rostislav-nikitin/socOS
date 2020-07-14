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

.macro m_save_r1_r2_r16_r17_r22_SREG_registers
	push r1
	push r2
	push r16
	in r16, SREG
	push r16
	push r17
	push r22
.endm

.macro m_restore_r1_r2_r16_r17_r22_SREG_registers
	pop r22
	pop r17
	pop r16
	out SREG, r16
	pop r16
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
	push r16
	in r16, SREG
	push r16
	push ZL
	push ZH
.endm

.macro m_restore_r16_Z_SREG_registers
	pop ZH
	pop ZL
	pop r16
	out SREG, r16
	pop r16
.endm

.macro m_save_r16_registers
	push r16
.endm

.macro m_restore_r16_registers
	pop r16
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

.macro m_save_r16_r22_r23_Y_Z_SREG_registers
	push r16
	in r16, SREG
	push r16
	push r22
	push r23
	push YL
	push YH
	push ZL
	push ZH
.endm

.macro m_restore_r16_r22_r23_Y_Z_SREG_registers
	pop ZH
	pop ZL
	pop YH
	pop YL
	pop r23
	pop r22
	pop r16
	out SREG, r16
	pop r16
.endm


.macro m_save_r16_r23_Y_Z_SREG_registers
	push r16
	in r16, SREG
	push r16
	push r23
	push YL
	push YH
	push ZL
	push ZH
.endm

.macro m_restore_r16_r23_Y_Z_SREG_registers
	pop ZH
	pop ZL
	pop YH
	pop YL
	pop r23
	pop r16
	out SREG, r16
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

.macro m_save_Z_SREG_registers
	push r16
	in r16, SREG
	push r16
	push ZL
	push ZH
.endm

.macro m_restore_Z_SREG_registers
	pop ZH
	pop ZL
	pop r16
	out SREG, r16
	pop r16
.endm

.macro m_save_r16_Y_registers
	push r16
	push YL
	push YH
.endm

.macro m_restore_r16_Y_registers
	pop YH
	pop YL
	pop r16
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

.macro m_save_r21_r22_r23_Y_Z_registers
	push r21
	push r22
	push r23
	push ZL
	push ZH
	push YL
	push YH
.endm

.macro m_restore_r21_r22_r23_Y_Z_registers
	pop YH
	pop YL
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

.macro m_save_Y_Z_registers
	push YL
	push YH
	push ZL
	push ZH
.endm

.macro m_restore_Y_Z_registers
	pop ZH
	pop ZL
	pop YH
	pop YL
.endm

.macro m_save_r23_Y_registers
	push r23
	push YL
	push YH
.endm

.macro m_restore_r23_Y_registers
	pop YH
	pop YL
	pop r23
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

.macro m_save_r22_X_SREG_registers
	push r16
	in r16, SREG
	push r16
	push r22
	push ZL
	push ZH
.endm

.macro m_restore_r22_X_SREG_registers
	pop ZH
	pop ZL
	pop r22
	pop r16
	out SREG, r16
	pop r16
.endm

.macro m_save_r23_X_SREG_registers
	push r16
	in r16, SREG
	push r16
	push r22
	push r23
	push ZL
	push ZH
.endm

.macro m_restore_r23_X_SREG_registers
	pop ZH
	pop ZL
	pop r23
	pop r22
	pop r16
	out SREG, r16
	pop r16
.endm

.macro m_save_r22_r23_registers
	push r22
	push r23
.endm

.macro m_restore_r22_r23_registers
	pop r23
	pop r22
.endm

.macro m_save_r22_r23_Y_registers
	push r22
	push r23
	push YL
	push YH
.endm

.macro m_restore_r22_r23_Y_registers
	pop YH
	pop YL
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

.macro m_save_r16_r22_r23_SREG_registers
	push r16
	in r16, SREG
	push r16
	push r22
	push r23
.endm

.macro m_restore_r16_r22_r23_SREG_registers
	pop r23
	pop r22
	pop r16
	out SREG, r16
	pop r16
.endm


.macro m_save_r16_r22_r23_X_SREG_registers
	push r16
	in r16, SREG
	push r16
	push r22
	push r23
	push XL
	push XH
.endm

.macro m_restore_r16_r22_r23_X_SREG_registers
	pop XH
	pop XL
	pop r23
	pop r22
	pop r16
	out SREG, r16
	pop r16
.endm

.macro m_save_r23_X_Y_Z_registers
	push XL
	push XH
	push YL
	push YH
	push ZL
	push ZH
	push r23
.endm

.macro m_restore_r23_X_Y_Z_registers
	pop r23
	pop ZH
	pop ZL
	pop YH
	pop YL
	pop XH
	pop XL
.endm

.macro m_save_r23_Y_Z_registers
	push XL
	push XH
	push YL
	push YH
	push ZL
	push ZH
	push r23
.endm

.macro m_restore_r23_Y_Z_registers
	pop r23
	pop ZH
	pop ZL
	pop YH
	pop YL
	pop XH
	pop XL
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

.macro m_save_r24_r25_X_Y_registers
	push r24
	push r25
	push XL
	push XH
	push YL
	push YH
.endm

.macro m_restore_r24_r25_X_Y_registers
	pop YH
	pop YL
	pop XH
	pop XL
	pop r25
	pop r24
.endm

.macro m_save_r24_r25_X_Y_Z_registers
	push r24
	push r25
	push XL
	push XH
	push YL
	push YH
	push ZL
	push ZH
.endm

.macro m_restore_r24_r25_X_Y_Z_registers
	pop ZH
	pop ZL
	pop YH
	pop YL
	pop XH
	pop XL
	pop r25
	pop r24
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
	; Z - source
	; Y - destination
	; r23 - length
	; r16 - temp
	m_save_r16_SREG_registers
	m_save_r23_Y_Z_registers

	mem_copy_loop:
		cpi r23, 0x00
		breq mem_copy_loop_exit

		ld r16, Z+
		st Y+, r16

		dec r23

		rjmp mem_copy_loop

	mem_copy_loop_exit:		

	m_restore_r23_Y_Z_registers
	m_restore_r16_SREG_registers

	ret

.macro m_get_struct_byte_by_offset
	; parameters:
	;	@0	offset
	ldi r23, @0
	rcall get_struct_byte
.endm

get_struct_byte:
	; parameters
	; Z - st_address
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

get_struct_word:
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

.macro m_set_struct_byte_by_offset_and_value_wo_save_registers
	; parameters:
	;	@0	offset
	;	@1	value

	ldi r23, @0
	ldi r22, @1
	rcall set_struct_byte
.endm

.macro m_set_struct_byte_by_offset_and_value
	; parameters:
	;	@0	offset
	;	@1	value
	m_save_r22_r23_registers

	ldi r23, @0
	ldi r22, @1
	rcall set_struct_byte

	m_restore_r22_r23_registers
.endm

.macro m_set_struct_byte_by_offset_and_register
	; parameters:
	;	@0	offset
	;	@1	register
	m_save_r22_r23_registers

	mov r22, @1
	ldi r23, @0

	rcall set_struct_byte

	m_restore_r22_r23_registers
.endm

.macro m_set_struct_byte_by_offset_and_register_wo_save_registers
	; parameters:
	;	@0	offset
	;	@1	register

	mov r22, @1
	ldi r23, @0

	rcall set_struct_byte
.endm



set_struct_byte:
	m_save_r16_Z_SREG_registers

	add ZL, r23
	ldi r16, 0x00
	adc ZH, r16
	st Z, r22

	m_restore_r16_Z_SREG_registers

	ret

set_struct_word:
	m_save_r16_Z_SREG_registers

	add ZL, r23
	ldi r16, 0x00
	adc ZH, r16
	st Z+, YL
	st Z, YH

	m_restore_r16_Z_SREG_registers

	ret

.macro m_set_Y_to_null_pointer
	ldi YL, NULL_POINTER_L
	ldi YH, NULL_POINTER_H
.endm

.macro m_set_Z_to_null_pointer
	ldi ZL, NULL_POINTER_L
	ldi ZH, NULL_POINTER_H
.endm

.macro m_cpw @0, @1
	; reg
	m_save_Y_Z_registers

	ldi ZL, low(@0)
	ldi ZH, high(@0)
	ldi YL, low(@1)
	ldi YH, high(@1)

	rcall cpw

	m_restore_Y_Z_registers
.endm	


cpw:
	clz
	cpse ZH, YH
	rjmp cpw_end
	cp ZL, YL

	cpw_end:

	ret
