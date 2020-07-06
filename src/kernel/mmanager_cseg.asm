.macro m_mmanager_init

.endm

mmanager_init:
	; save registers
	push r16
	push r17
	push r18
	push r19
	push ZL
	push ZH

	; init Z
	ldi ZL, low(arr_st_heap_map)
	ldi ZH, high(arr_st_heap_map)
	; init step
	ldi r17, MMANAGER_ST_HEAP_MAP_SIZE
	; init r18 to zero
	ldi r18, 0x00
	; init index
	ldi r16, 0x00
	mmanager_init_arr_st_heap_map_cleanup_loop:
		cpi r16, MMANAGER_ARR_ST_HEAP_MAP_SIZE
		brge mmanager_init_arr_st_heap_map_cleanup_loop_exit
		; cleann
		push ZL
		push ZH
		add ZL, MMANAGER_ST_HEAP_MAP_ADDRES_OFFSET
		adc ZH, r18
		ldi r19, MMANAGER_ADDRESS_DEFAULT
		st Z, r19
		pop ZH
		pop ZL

		push ZL
		push ZH
		add ZL, MMANAGER_ST_HEAP_MAP_BLOCK_SIZE_OFFSET
		adc ZH, r18
		ldi r19, MMANAGER_BLOCK_SIZE_DEFAULT
		st Z, r19
		pop ZH
		pop ZL

		push ZL
		push ZH
		add ZL, MMANAGER_ST_HEAP_MAP_IS_IN_USE_OFFSET
		adc ZH, r18
		ldi r19, MMANAGER_IS_IN_USE_DEFAULT
		st Z, r19
		pop ZH
		pop ZL

		add r16, r17
		rjmp mmanager_init_arr_st_heap_map_cleanup_loop

	mmanager_init_arr_st_heap_map_cleanup_loop_exit:
		; init index
		ldi r16, 0x00
		; init Z
		ldi ZL, low(heap)
		ldi ZH, high(heap)
	
	mmanager_init_heap_loop:
		cpi r16, MMANAGER_HEAP_SIZE
		brge mmanager_init_heap_loop_exit

		st Z+, r18
		inc r16

		rjmp mmanager_init_heap_loop

	mmanager_init_heap_loop_exit:
	mmanager_init_end:
		; restore registers
		pop ZH
		pop ZL
		pop r19
		pop r18
		pop r17
		pop r16

		ret

mmanager_allocate:
	; find first non in use block with equal size or zero size
	
	ret

mmanager_deallocate:
	ret