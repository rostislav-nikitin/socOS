.cseg
.org 0x00
rcall main_thread
; include components interrupts
;.include "../../../../../../src/kernel/drivers/{driver_name}_int.asm"

; include SoC defaults
; include components definitions
.include "../../../../../../src/kernel/kernel_def.asm"
.include "../../../../../../src/kernel/drivers/io/device_io_def.asm"
.include "../../../../../../src/kernel/drivers/io/out_bit_def.asm"
.include "../../../../../../src/kernel/drivers/io/hid/led_def.asm"

;.include components data segments
;.include "../../../../../../src/kernel/drivers/{driver_name}_dseg.asm"
; custom data & descriptors
.dseg
	led1:		.BYTE SZ_ST_LED
	led2: 		.BYTE SZ_ST_LED

; main thread
.cseg
; skip interrupts vector
.org 0x14
; include components code segments
;.include "../../../../../../src/kernel/drivers/{device_name}_cseg.asm"
.include "../../../../../../src/extensions/delay_cseg.asm"
.include "../../../../../../src/kernel/kernel_cseg.asm"
.include "../../../../../../src/kernel/drivers/device_cseg.asm"
.include "../../../../../../src/kernel/drivers/io/device_io_cseg.asm"
.include "../../../../../../src/kernel/drivers/io/out_bit_cseg.asm"
.include "../../../../../../src/kernel/drivers/io/hid/led_cseg.asm"


main_thread:
	; stack initialization
	m_init_stack
	; init leds
	m_led_init led1, DDRC, PORTC, (1 << BIT4)
	m_led_init led2, DDRC, PORTC, (1 << BIT5)

	.equ DELAY_TIME = 200000 ; ~1 sec

	main_thread_loop:
		nop
		;m_delay DELAY_TIME
		m_led_set led1, LED_STATE_ON
		nop
		;m_delay DELAY_TIME
		m_led_set led1, LED_STATE_OFF
		nop
		;m_delay DELAY_TIME
		m_led_on led1
		nop
		;m_delay DELAY_TIME
		m_led_off led1
		nop
		m_led_toggle led2

		rjmp main_thread_loop
