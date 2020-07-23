.cseg
.org 0x00
rcall main_thread
; include components interrupts
;.include "../../../../../src/kernel/drivers/{driver_name}_int.asm"
.include "../../../../../src/kernel/drivers/soc/timer2_int.asm"

; include components definitions
.include "../../../../../src/kernel/kernel_def.asm"
;.include "../../../src/kernel/drivers/{driver_name}_def.asm"
.include "../../../../../src/kernel/drivers/device_def.asm"
.include "../../../../../src/kernel/drivers/io/device_io_def.asm"
.include "../../../../../src/kernel/drivers/io/out_bit_def.asm"
.include "../../../../../src/kernel/drivers/io/hid/led_def.asm"
.include "../../../../../src/kernel/drivers/soc/timer_base_def.asm"
.include "../../../../../src/kernel/drivers/soc/timer_w_pwm_base_def.asm"
.include "../../../../../src/kernel/drivers/soc/timer2_def.asm"

;.include components data segments
;.include "../../../../../src/kernel/{driver_name}_dseg.asm"
.include "../../../../../src/kernel/drivers/soc/timer2_dseg.asm"
; custom data & descriptors
.dseg
	led1:		.BYTE SZ_ST_LED

; main thread
.cseg
; skip interrupts vector
.org 0x14
; include components code segments
.include "../../../../../src/kernel/kernel_cseg.asm"
;.include "../../../../../src/kernel/drivers/{driver_name}_cseg.asm"
.include "../../../../../src/kernel/drivers/device_cseg.asm"
.include "../../../../../src/kernel/drivers/io/device_io_cseg.asm"
.include "../../../../../src/kernel/drivers/io/out_bit_cseg.asm"
.include "../../../../../src/kernel/drivers/io/hid/led_cseg.asm"
.include "../../../../../src/kernel/drivers/soc/timer_base_cseg.asm"
.include "../../../../../src/kernel/drivers/soc/timer_w_pwm_base_cseg.asm"
.include "../../../../../src/kernel/drivers/soc/timer2_cseg.asm"
.include "../../../../../src/kernel/drivers/motors/motor_cseg.asm"

main_thread:
	; stack initialization
	m_init_stack
	; init leds
	m_led_init led1, DDRC, PORTC, (1 << BIT5)
	m_motor_init TIMER_DIVIDER_1024X, 0x0F
	m_motor_stop
	m_motor_start
	m_motor_power_set 0x05
	; init global interrupts
	m_init_interrupts

	m_led_on led1

	main_thread_loop:
		nop
		main_thread_loop_end:
			nop
			rjmp main_thread_loop

		ret
