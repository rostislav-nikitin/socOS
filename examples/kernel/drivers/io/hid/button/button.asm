.cseg
.org 0x00
rcall main_thread
; include components interrupts
;.include "../../../../../../src/kernel/drivers/{driver_name}_int.asm"

; include components definitions
.include "../../../../../../src/kernel/kernel_def.asm"
.include "../../../../../../src/kernel/drivers/device_def.asm"
.include "../../../../../../src/kernel/drivers/io/device_io_def.asm"
.include "../../../../../../src/kernel/drivers/io/in_bit_def.asm"
.include "../../../../../../src/kernel/drivers/io/hid/button_def.asm"
.include "../../../../../../src/kernel/drivers/io/out_bit_def.asm"
.include "../../../../../../src/kernel/drivers/io/hid/led_def.asm"

;.include components data segments
;.include "../../../../../../src/kernel/drivers/{driver_name}_dseg.asm"
; custom data & descriptors
.dseg
	; leds
	led1:		.BYTE SZ_ST_LED
	led2:		.BYTE SZ_ST_LED
	; buttons
	button1:	.BYTE SZ_ST_BUTTON

; main thread
.cseg
; skip interrupts vector
.org 0x14
; include components code segments
;.include "../../../../../../src/kernel/drivers/{driver_name}_cseg.asm"
.include "../../../../../../src/kernel/kernel_cseg.asm"
.include "../../../../../../src/kernel/drivers/device_cseg.asm"
.include "../../../../../../src/kernel/drivers/io/device_io_cseg.asm"
.include "../../../../../../src/kernel/drivers/io/in_bit_cseg.asm"
.include "../../../../../../src/kernel/drivers/io/hid/button_cseg.asm"
.include "../../../../../../src/kernel/drivers/io/out_bit_cseg.asm"
.include "../../../../../../src/kernel/drivers/io/hid/led_cseg.asm"

main_thread:
	; stack initialization
	m_init_stack
	; init leds
	m_led_init led1, DDRC, PORTC, (1 << BIT5)
	m_led_init led2, DDRC, PORTC, (1 << BIT4)
	; init button
	m_button_init button1, DDRC, PINC, PORTC, (1 << BIT1), button1_on_button_down_handler, button1_on_button_up_handler, button1_on_button_pressed_handler

	main_thread_loop:
		m_button_handle_io button1

		main_thread_loop_end:
			rjmp main_thread_loop

		ret

button1_on_button_down_handler:
	m_led_off led1
	m_led_off led2
	ret

button1_on_button_up_handler:
	m_led_on led1
	ret

button1_on_button_pressed_handler:
	m_led_on led2
	ret
