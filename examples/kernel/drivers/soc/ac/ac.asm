.cseg
.org 0x00
rcall main_thread
; include components interrupts
;.include "../../../../../src/kernel/drivers/{driver_name}_int.asm"
.include "../../../../../src/kernel/drivers/soc/ac_int.asm"

; include SoC defaults
.include "m8def.inc"
; include components definitions
.include "../../../../../src/kernel/kernel_def.asm"
;.include "../../../../../src/kernel/drivers/{driver_name}_def.asm"
.include "../../../../../src/kernel/drivers/device_def.asm"
.include "../../../../../src/kernel/drivers/io/device_io_def.asm"
.include "../../../../../src/kernel/drivers/io/in_bit_def.asm"
.include "../../../../../src/kernel/drivers/io/hid/button_def.asm"
.include "../../../../../src/kernel/drivers/io/out_bit_def.asm"
.include "../../../../../src/kernel/drivers/io/hid/led_def.asm"
.include "../../../../../src/kernel/drivers/soc/ac_def.asm"

;.include components data segments
;.include "../../../../../src/kernel/driver/{driver_name}_dseg.asm"
.include "../../../../../src/kernel/drivers/soc/ac_dseg.asm"
; custom data & descriptors
.dseg
	led1:		.BYTE SZ_ST_LED
	led2:		.BYTE SZ_ST_LED

; main thread
.cseg
; skip interrupts vector
.org 0x14
; include components code segments
.include "../../../../../src/kernel/kernel_cseg.asm"
;.include "../../../../../src/kernel/thread_cseg.asm"
.include "../../../../../src/kernel/drivers/device_cseg.asm"
.include "../../../../../src/kernel/drivers/io/device_io_cseg.asm"
.include "../../../../../src/kernel/drivers/io/in_bit_cseg.asm"
.include "../../../../../src/kernel/drivers/io/hid/button_cseg.asm"
.include "../../../../../src/kernel/drivers/io/out_bit_cseg.asm"
.include "../../../../../src/kernel/drivers/io/hid/led_cseg.asm"
.include "../../../../../src/kernel/drivers/soc/ac_cseg.asm"


main_thread:
	; stack initialization
	m_init_stack
	; init leds
	m_led_init led1, DDRC, PORTC, (1 << BIT5)
	m_led_init led2, DDRC, PORTC, (1 << BIT4)
	; init ac
	m_ac_init AC_INPUT_NEGATIVE_A_IN1, AC_INPUT_POSITIVE_VREF_1_23_V, AC_INTERRPUT_MODE_ARISE_BOTH_FRONTS, ac_on_changed_handler
	m_ac_enable
	m_ac_interrupts_enable
	; init global interrupts
	m_init_interrupts

	main_thread_loop:
		nop
		nop
		main_thread_loop_end:
			m_ac_output_value_get r16
			cpi r16, AC_OUTPUT_VALUE_FALSE
			breq main_thread_loop_ac_false
			main_thread_loop_ac_true:
				m_led_on led2
				rjmp main_thread_loop
			main_thread_loop_ac_false:
				m_led_off led2
				rjmp main_thread_loop

		ret

ac_on_changed_handler:
	cpi YL, AC_OUTPUT_VALUE_FALSE
	breq ac_on_changed_handler_value_false
	ac_on_changed_handler_value_true:
		m_led_toggle led1
		rjmp ac_on_changed_handler_end
	ac_on_changed_handler_value_false:
		m_led_toggle led1
		rjmp ac_on_changed_handler_end

	ac_on_changed_handler_end:

	ret
