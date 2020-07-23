; code region
.macro m_watchdog_init
	; input parameters:
	; 	@0	byte  watchdog_timeout (enumeration)
	; save registers
	m_save_r23_registers
	; push timeout parameter
	ldi r23, @0

	rcall watchdog_init

	m_restore_r23_registers
.endm

.macro m_watchdog_init_default
	; default timeout is 2.2ms
	m_watchdog_init WATCHDOG_DEFAULT_TIMEOUT
.endm

watchdog_init:
	; input parameters:
	;	r23	byte	watchdog_timeout (enumeration)
	m_save_r16_r23_SREG_registers

	ori r23, (1 << WDE)

	out WDTCR, r23

	m_restore_r16_r23_SREG_registers

	ret