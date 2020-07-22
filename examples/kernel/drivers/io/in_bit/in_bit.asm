.cseg
.org 0x00
rcall main_thread
; include components interrupts
;.include "../../../../../../src/kernel/drivers/{driver_name}_int.asm"

; include components definitions
.include "../../../../../src/kernel/kernel_def.asm"
;.include "../../../../../src/kernel/drivers/{driver_name}_def.asm"
.include "../../../../../src/kernel/drivers/st_device_def.asm"
.include "../../../../../src/kernel/drivers/io/st_device_io_def.asm"
.include "../../../../../src/kernel/drivers/io/in_bit_def.asm"
.include "../../../../../src/kernel/drivers/io/out_bit_def.asm"
.include "../../../../../src/kernel/drivers/io/switch_def.asm"
.include "../../../../../src/kernel/drivers/io/hid/led_def.asm"

;.include components data segments
;.include "../../../../../src/kernel/drivers/{driver_name}_dseg.asm"
; custom data & descriptors
.dseg
	led1:		.BYTE SZ_ST_LED
	in_bit1:	.BYTE SZ_ST_IN_BIT

; main thread
.cseg
; skip interrupts vector
.org 0x14
; include components code segments
.include "../../../../../src/extensions/delay_cseg.asm"
.include "../../../../../src/kernel/kernel_cseg.asm"
;.include "../../../../../src/kernel/{driver_name}_cseg.asm"
.include "../../../../../src/kernel/drivers/st_device_cseg.asm"
.include "../../../../../src/kernel/drivers/io/st_device_io_cseg.asm"
.include "../../../../../src/kernel/drivers/io/in_bit_cseg.asm"
.include "../../../../../src/kernel/drivers/io/out_bit_cseg.asm"
.include "../../../../../src/kernel/drivers/io/switch_cseg.asm"
.include "../../../../../src/kernel/drivers/io/hid/led_cseg.asm"


main_thread:
	; stack initialization
	m_init_stack
	; init leds
	m_led_init led1, DDRC, PORTC, (1 << BIT4)
	; init in_bit
	m_in_bit_init in_bit1, DDRC, PINC, PORTC, (1 << BIT1)


	.equ DELAY_TIME = 200000 ; ~1 sec

	ldi r16, IN_BIT_STATE_OFF

	main_thread_loop:
		nop
		m_led_toggle led1
		nop
		m_led_toggle led1
		nop
		m_in_bit_get in_bit1, r16
		cpi r16, IN_BIT_STATE_OFF
		breq main_thread_loop_in_bit_state_off
		main_thread_loop_in_bit_state_on:
			m_led_on led1
			rjmp main_thread_loop_end
		main_thread_loop_in_bit_state_off:
			m_led_off led1

		main_thread_loop_end:
			;m_delay DELAY_TIME
			rjmp main_thread_loop

		ret
