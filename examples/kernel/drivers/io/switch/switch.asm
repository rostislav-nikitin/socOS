.cseg
.org 0x00
rcall main_thread
; include components interrupts
;.include "../../../../../src/kernel/drivers/{driver_name}_int.asm"

; include SoC defaults
.include "m8def.inc"
; include components definitions
.include "../../../../../src/kernel/kernel_def.asm"
;.include "../../../../../src/kernel/drivers/{driver_name}_def.asm"
.include "../../../../../src/kernel/drivers/st_device_def.asm"
.include "../../../../../src/kernel/drivers/io/st_device_io_def.asm"
.include "../../../../../src/kernel/drivers/io/out_bit_def.asm"
.include "../../../../../src/kernel/drivers/io/switch_def.asm"

;.include components data segments
;.include "../../../src/kernel/drivers/{driver_name}_dseg.asm"
; custom data & descriptors
.dseg
	switch1:		.BYTE SZ_ST_SWITCH
	switch2: 		.BYTE SZ_ST_SWITCH

; main thread
.cseg
; skip interrupts vector
.org 0x14
; include components code segments
.include "../../../../../src/extensions/delay_cseg.asm"
.include "../../../../../src/kernel/kernel_cseg.asm"
;.include "../../../../../src/kernel/drivers/{driver_name}_cseg.asm"
.include "../../../../../src/kernel/drivers/st_device_cseg.asm"
.include "../../../../../src/kernel/drivers/io/st_device_io_cseg.asm"
.include "../../../../../src/kernel/drivers/io/out_bit_cseg.asm"
.include "../../../../../src/kernel/drivers/io/switch_cseg.asm"

main_thread:
	; stack initialization
	m_init_stack
	; init switchs
	m_switch_init switch1, DDRC, PORTC, (1 << BIT4)
	m_switch_init switch2, DDRC, PORTC, (1 << BIT5)

	.equ DELAY_TIME = 200000

	main_thread_loop:
		nop
		;m_delay DELAY_TIME
		m_switch_set switch1, SWITCH_STATE_ON
		nop
		;m_delay DELAY_TIME
		m_switch_set switch1, SWITCH_STATE_OFF
		nop
		;m_delay DELAY_TIME
		m_switch_on switch1
		nop
		;m_delay DELAY_TIME
		m_switch_off switch1
		nop
		m_switch_toggle switch2

		rjmp main_thread_loop
