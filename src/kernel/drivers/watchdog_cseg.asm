; code region
.macro m_watchdog_init
	; input parameters:
	; 	@0	byte  watchdog_timeout (enumeration)
	; save registers
	push r16
	; push timeout parameter
	ldi r16, @0
	push r16

	rcall watchdog_init
	; release stack space from the timeout parameter
	pop r16
	; restore registers
	pop r16
.endm

.macro m_watchdog_init_default
	; default timeout is 2.2ms
	m_watchdog_init WATCHDOG_DEFAULT_TIMEOUT
.endm

watchdog_init:
	; input parameters:
	;	byte	watchdog_timeout (enumeration)
	m_save_r16_X_registers

	in XL, SPL
	in XH, SPH
	;3 bytes saved registers
	ldi r16, SZ_R16_X_REGISTERS + SZ_RET_ADDRESS + SZ_STACK_PREVIOUS_OFFSET

	add XL, r16
	ldi r16, 0x00
	adc XH, r16

	ld r16, X
	ori r16, (1 << WDE)

	out WDTCR, r16

	m_restore_r16_X_registers

	ret