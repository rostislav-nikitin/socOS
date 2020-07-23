.cseg
.org 0x00
rcall main_thread
; include components interrupts
;.include "../../../../../src/kernel/drivers/{driver_name}_int.asm"

; include components definitions
.include "../../../../../src/kernel/kernel_def.asm"
;.include "../../../../../src/kernel/drivers/{driver_name}_def.asm"
.include "../../../../../src/kernel/drivers/device_def.asm"
.include "../../../../../src/kernel/drivers/io/device_io_def.asm"
.include "../../../../../src/kernel/drivers/io/out_bit_def.asm"
.include "../../../../../src/kernel/drivers/io/hid/led_def.asm"
.include "../../../../../src/kernel/drivers/soc/watchdog_def.asm"

;.include components data segments
;.include "../../../../../src/kernel/drivers/{driver_name}_dseg.asm"
; custom data & descriptors
.dseg
	led1:		.BYTE SZ_ST_LED

; main thread
.cseg
; skip interrupts vector
.org 0x14
; include components code segments
.include "../../../../../src/extensions/delay_cseg.asm"
.include "../../../../../src/kernel/kernel_cseg.asm"
;.include "../../../../../src/kernel/drivers/{driver_name}_cseg.asm"
.include "../../../../../src/kernel/drivers/device_cseg.asm"
.include "../../../../../src/kernel/drivers/io/device_io_cseg.asm"
.include "../../../../../src/kernel/drivers/io/out_bit_cseg.asm"
.include "../../../../../src/kernel/drivers/io/hid/led_cseg.asm"
.include "../../../../../src/kernel/drivers/soc/watchdog_cseg.asm"


main_thread:
	; stack initialization
	m_init_stack
	; init watchdog
	m_watchdog_init_default
	; init led
	m_led_init led1, DDRC, PORTC, (1 << BIT5)
	; init global interrupts
	m_init_interrupts

	; delay > watchdog timeout
	.equ DELAY_TIME = 200000 ; ~1 sec
	; delay < watchdog timeout
	;.equ DELAY = 20


	main_thread_loop:
		wdr
		m_led_toggle led1
		m_delay DELAY_TIME
		rjmp main_thread_loop
