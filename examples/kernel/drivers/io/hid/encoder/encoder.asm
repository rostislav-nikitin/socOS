.cseg
.org 0x00
rcall main_thread
; include drivers interrupts
;.include "../../../../../../lib/kernel/drivers/{driver_name}_int.asm"

; include drivers definitions
.include "../../../../../../src/kernel/kernel_def.asm"
;.include "../../../../../../src/kernel/drivers/{driver_name}_def.asm"
.include "../../../../../../src/kernel/drivers/device_def.asm"
.include "../../../../../../src/kernel/drivers/io/device_io_def.asm"
.include "../../../../../../src/kernel/drivers/io/out_bit_def.asm"
.include "../../../../../../src/kernel/drivers/io/hid/led_def.asm"
.include "../../../../../../src/kernel/drivers/io/hid/encoder_def.asm"

;.include components data segments
;.include "../../../../../../lib/kernel/thread_dseg.asm"
; custom data & descriptors
.dseg
	led1:		.BYTE SZ_ST_LED
	led2: 		.BYTE SZ_ST_LED
	encoder1:	.BYTE SZ_ST_ENCODER

; main thread
.cseg
; skip interrupts vector
.org 0x14
; include components code segments
.include "../../../../../../src/extensions/delay_cseg.asm"
.include "../../../../../../src/kernel/kernel_cseg.asm"
;.include "../../../../../../src/kernel/drivers/{driver_name}_cseg.asm"
.include "../../../../../../src/kernel/drivers/device_cseg.asm"
.include "../../../../../../src/kernel/drivers/io/device_io_cseg.asm"
.include "../../../../../../src/kernel/drivers/io/out_bit_cseg.asm"
.include "../../../../../../src/kernel/drivers/io/hid/led_cseg.asm"
.include "../../../../../../src/kernel/drivers/io/hid/encoder_cseg.asm"


main_thread:
	; stack initialization
	m_init_stack
	; init leds
	m_led_init led1, DDRC, PORTC, (1 << BIT4)
	m_led_init led2, DDRC, PORTC, (1 << BIT5)
	; init encoder
	m_encoder_init encoder1, DDRC, PINC, PORTC, (1 << BIT1), (1 << BIT2), encoder1_on_turn_handler

	main_thread_loop:
		m_encoder_handle_io encoder1, r16
		rjmp main_thread_loop

encoder1_on_turn_handler:
	encoder1_on_turn_handler_check_cw:
		cpi r23, ENCODER_DIRECTION_CW
		brne encoder1_on_turn_handler_check_ccw
		m_led_on led1
		m_led_off led2
		rjmp  encoder1_on_turn_handler_end
	encoder1_on_turn_handler_check_ccw:
		cpi r23, ENCODER_DIRECTION_CCW
		m_led_off led1
		m_led_on led2

	encoder1_on_turn_handler_end:
	
	ret
