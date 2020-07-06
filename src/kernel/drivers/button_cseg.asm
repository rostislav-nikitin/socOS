; usage:
; .dseg
;   led1: .BYTE ST_LED_SIZE
;   ...
; .cseg
;   m_led_init led1, DDRB, PORTB, (1 << BIT1)
;   ...
;   m_led_set led1, LED_ON
;   m_led_set led1, LED_OFF
;   m_led_on led1
;   m_led_off led1
;   m_led_toggle led1
;   m_led_get led1

.macro m_led_init
	; input parameters:
	;	@0	word st_led
	;	@1	word DDRx
	;	@2	word PORTx
	;	@3	word BITx_MASK
	; save registers
	push r16
	; init st_led
	; push BITx_MASK
	ldi r16, @3
	push r16
	; push PORTx address
	ldi r16, high(@2 + IO_PORTS_OFFSET)
	push r16
	ldi r16, low(@2 + IO_PORTS_OFFSET)
	push r16
	; push DDRx address
	ldi r16, high(@1 + IO_PORTS_OFFSET)
	push r16
	ldi r16, low(@1 + IO_PORTS_OFFSET)
	push r16
	; push st_led address
	ldi r16, high(@0)
	push r16
	ldi r16, low(@0)
	push r16

	rcall led_init
	;release stack from parameters
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

led_init:
	; input parameters:
	;	word	st_led
	;	word	DDRx
	;	word	PORTx
	;	byte	BITx_MASK
	m_save_r16_r17_r18_X_Y_Z_registers
	; init struct
	ldi r16, 0x00
	; set X to the st_led address
	in XL, SPL
	in XH, SPH
	ldi r17, SZ_R16_R17_R18_X_Y_Z_REGISTERS + SZ_RET_ADDRESS + SZ_STACK_PREVIOUS_OFFSET
	add XL, r17
	adc XH, r16
	; load st_led address to Y
	ld YL, X+
	ld YH, X+
	; init st_led
	ldi r16, ST_LED_SIZE
	rcall mem_copy
	; set X to st_led
	mov XL, YL
	mov XH, YH
	; get PORTx address
	ldi ZL, ST_LED_PORTX_ADDRESS_OFFSET
	rcall get_struct_word_by_X_ZL_to_Z
	mov YL, ZL
	mov YH, ZH
	; get DDRx address
	ldi ZL, ST_LED_DDRX_ADDRESS_OFFSET
	rcall get_struct_word_by_X_ZL_to_Z
	; get BITx_MASK
	ldi r16, ST_LED_BIT_MASK_OFFSET
	rcall get_struct_byte_by_X_r16_to_r16
	mov r17, r16
	; save PORTx value
	ld r18, Y
	; update DDRx: add BITx
	;  get DDRx value
	ld r19, Z
	;  calculate new DDRx: set BITx on
	or r19, r17
	;  store to DDRx
	st Z, r19
	;  calcualte new PORTx: set BITx off (led off by default)
	com r17
	and r18, r17
	;  store to PORTx
	st Y, r18

	m_restore_r16_r17_r18_X_Y_Z_registers

	ret

.macro m_led_set
	; input parameters:
	;	@0	word	st_led
	;	@1	byte 	led_state
	; save registers
	push r18
	; push parameters
	ldi r18, @1
	push r18
	ldi r18, high(@0)
	push r18
	ldi r18, low(@0)
	push r18
	; call procedure
	rcall led_set
	; release stack from parameters
	pop r18
	pop r18
	pop r18
	; restore registers
	pop r18
.endm

.macro  m_led_on
	; input parameters:
	;	@0 	word	st_led
	m_led_set @0, LED_ON
.endm

.macro  m_led_off
	; input parameters:
	;	@0 	word	st_led
	m_led_set @0, LED_OFF
.endm

led_set:
	; input parameters:
	;	word	st_led
	;	byte	led_state
	m_save_r16_r17_r18_r19_X_Y_Z_registers

	ldi r16, 0x00
	; set X to the st_led address
	in XL, SPL
	in XH, SPH
	ldi r17, SZ_R16_R17_R18_R19_X_Y_Z_REGISTERS + SZ_RET_ADDRESS + SZ_STACK_PREVIOUS_OFFSET
	add XL, r17
	adc XH, r16
	; load st_led address to Y
	ld YL, X+
	ld YH, X+
	; load led_state
	ld r17, X+
	; set X to st_led
	mov XL, YL
	mov XH, YH
	; load BITx
	ldi r16, ST_LED_BIT_MASK_OFFSET
	rcall get_struct_byte_by_X_r16_to_r16
	mov r18, r16
	; load PORTx address
	ldi ZL, ST_LED_PORTX_ADDRESS_OFFSET
	rcall get_struct_word_by_X_ZL_to_Z

	m_led_set_on:
		cpi r17, LED_ON
		brne m_led_set_off
		; load PORTx value
		ld YL, Z
		or YL, r18
		st Z, YL
		rjmp m_led_set_restore_registers

	m_led_set_off:
		; load PORTx value
		ld YL, Z
		com r18
		and YL, r18
		st Z, YL

	m_led_set_restore_registers:
		m_restore_r16_r17_r18_r19_X_Y_Z_registers

		ret

.macro m_led_get
	; input parameters:
	;	@0	word	st_led
	; returns:
	;	@1	register

	push @1
	ldi @1, high(@0)
	push @1
	ldi @1, low(@0)
	push @1

	rcall led_get

	pop @1
	pop @1
	pop @1
.endm

led_get:
	; input parameters:
	;	word	st_led
	; returns:
	;	byte
	m_save_r16_r17_r18_r19_X_Y_Z_registers

	ldi r16, 0x00
	; set X to the st_led address
	in XL, SPL
	in XH, SPH
	ldi r17, SZ_R16_R17_R18_R19_X_Y_Z_REGISTERS + SZ_RET_ADDRESS + SZ_STACK_PREVIOUS_OFFSET
	add XL, r17
	adc XH, r16
	; load st_led address to Y
	ld YL, X+
	ld YH, X+
	; save X to restore for return value
	push XL
	push XH
	; set X to st_led
	mov XL, YL
	mov XH, YH

	; load BITx_MASK
	ldi r16, ST_LED_BIT_MASK_OFFSET
	rcall get_struct_byte_by_X_r16_to_r16
	mov r18, r16
	; load PORTx address
	ldi ZL, ST_LED_PORTX_ADDRESS_OFFSET
	rcall get_struct_word_by_X_ZL_to_Z
	; restore X
	pop XH
	pop XL
	; load PORTx value
	ld r17, Z
	and r17, r18
	breq led_get_off
	led_get_on:
		ldi r17, LED_ON
		st X, r17
		rjmp  led_get_restore_registers
	led_get_off:
		ldi r17, LED_OFF
		st X, r17
   	led_get_restore_registers:
		m_restore_r16_r17_r18_r19_X_Y_Z_registers

	ret

.macro m_led_toggle
	; input parameters:
	; 	@0	word	st_led
	; save registers
	push r16
	; push parameters
	ldi r16, high(@0)
	push r16
	ldi r16, low(@0)
	push r16
	rcall led_toggle
	; release stack from parameters
	pop r16
	pop r16
	; restore registers
	pop r16
.endm

led_toggle:
	; input parameters:
	;	word	st_led
	m_save_r16_r17_r18_X_Y_Z_registers

	ldi r16, 0x00
	; set X to the st_led address
	in XL, SPL
	in XH, SPH
	ldi r17, SZ_R16_R17_R18_X_Y_Z_REGISTERS + SZ_RET_ADDRESS + SZ_STACK_PREVIOUS_OFFSET
	add XL, r17
	adc XH, r16
	; load st_led address to Y
	ld YL, X+
	ld YH, X+
	; push space for result
	push r18
	; push st_led address
	push YH
	push YL

	rcall led_get

	pop YL
	pop YH
	; there result
	pop r18

	cpi r18, LED_ON
	brne led_toggle_led_on
	led_toggle_led_off:	
		ldi r18, LED_OFF 
		rjmp led_toggle_led_set
	led_toggle_led_on:
		ldi r18, LED_ON

	led_toggle_led_set:
		push r18
		push YH
		push YL

		rcall led_set

		pop YL
		pop YH
		pop r18

	m_restore_r16_r17_r18_X_Y_Z_registers

	ret
