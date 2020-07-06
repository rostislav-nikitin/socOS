.cseg

.macro m_thread_init
	rcall thread_init
.endm

thread_init:
	; save registers
	push r16

	; enable TIMER0
	in r16, TIMSK
	ori r16, (1 << TOIE0)
	out TIMSK, r16
	;set divider to 8 (by default)
	in r16, TCCR0
	ori r16, (1 << CS00)
	out TCCR0, r16
	; set thread index to zero
	ldi r16, 0x00
	sts thread_arr_handlers_length, r16
	;restore registers
	pop r16

	ret

.macro m_thread_create
	; @0 - thread handler address
	; save registers
	push r16
	; store parameters
	ldi r16, low(@0)
	push r16
	ldi r16, high(@0)
	push r16
	; call create thread
	rcall thread_create
	; release stack from parameters
	pop r16
	pop r16
	; restore registers
	pop r16
.endm

thread_create:
	; recive parameters throuh stack
	; parameters:
	;	handler address: 
	;		low byte
	;		high byte
	; save registers
	push r16
	push r17
	push ZL
	push ZH
	push YL
	push YH

	; set Y to the thread_arr_handlers
	ldi YL, low(thread_arr_handlers)
	ldi YH, high(thread_arr_handlers)
	; set r16 to the index
	lds r16, thread_arr_handlers_length
	; check length < MAX
	cpi r16, THREAD_THREADS_MAX
	brge thread_create_restore_registers
	; increase & store increased index
	mov r17, r16
	inc r17
	sts thread_arr_handlers_length, r17
	; set Y to the next thread slot
	lsl r16
	add YL, r16
	ldi r16, 0x00
	adc YH, r16

	; set Z to stack head
	in ZL, SPL
	in ZH, SPH

	; add offset: 1 byte current + 6 bytes registers + 2 bytes ret address  	
	ldi r16, 0x09

	; set Z to first input parameter
	add ZL, r16
	ldi r16, 0x00
	adc ZH, r16

	; copy thread address to the threads handlers array
	ld r16, Z+
	ld r17, Z
	st Y+, r17
	st Y, r16

	thread_create_restore_registers:	
	; restore registers
		pop YH
		pop YL
		pop ZH
		pop ZL
		pop r17
		pop r16
	
		ret

;thread_timer_handler:
thread_TIM0_OVF_handler:
	; save registers
	push r16
	push r17
	push r18
	push r19
	push ZL
	push ZH
	push YL
	push YH

	ldi r19, 0x00
	; index
	ldi r16, 0x00
	; length
	lds r17, thread_arr_handlers_length

	thread_TIM0_OVF_handler_loop:
		; check index valid range
		cp r16, r17
		brge thread_TIM0_OVF_handler_restore_registers

		; main logic: call threads one by one
		; load handlers array address
		ldi YL, low(thread_arr_handlers)
		ldi YH, high(thread_arr_handlers)
		; mul index by 2
		mov r18, r16
		lsl r18
		; add offset to the handlers array address
		add YL, r18
		adc YH, r19

		ld ZL, Y+
		ld ZH, Y
		
		; call thread handler
		icall
		
		; dec index, iterate through loop
		inc r16
		rjmp thread_TIM0_OVF_handler_loop

	thread_TIM0_OVF_handler_restore_registers:
		; restore registers
		pop YH
		pop YL
		pop ZH
		pop ZL
		pop r19
		pop r18
		pop r17
		pop r16

		reti