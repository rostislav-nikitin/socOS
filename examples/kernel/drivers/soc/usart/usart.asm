.cseg
.org 0x00
rcall main_thread
; include components interrupts
;.include "../../../../../src/kernel/drivers/{driver_name}_int.asm"
.include "../../../../../src/kernel/drivers/soc/usart_int.asm"

; include components definitions
.include "../../../../../src/kernel/kernel_def.asm"
;.include "../../../../../src/kernel/drivers/{driver_name}_def.asm"
.include "../../../../../src/kernel/drivers/st_device_def.asm"
.include "../../../../../src/kernel/drivers/io/st_device_io_def.asm"
.include "../../../../../src/kernel/drivers/io/in_bit_def.asm"
.include "../../../../../src/kernel/drivers/io/hid/button_def.asm"
.include "../../../../../src/kernel/drivers/io/out_bit_def.asm"
.include "../../../../../src/kernel/drivers/io/hid/led_def.asm"
.include "../../../../../src/kernel/drivers/soc/usart_def.asm"

;.include components data segments
;.include "../../../../../src/kernel/drivers/{driver_name}_dseg.asm"
.include "../../../../../src/kernel/drivers/soc/usart_dseg.asm"
; custom data & descriptors
.dseg
	led1:		.BYTE SZ_ST_LED
	led2:		.BYTE SZ_ST_LED
	led3:		.BYTE SZ_ST_LED
	button1:	.BYTE SZ_ST_BUTTON

; main thread
.cseg
; skip interrupts vector
.org 0x14
; include components code segments
.include "../../../../../src/kernel/kernel_cseg.asm"
;.include "../../../../../src/kernel/drivers/{driver_name}_cseg.asm"
.include "../../../../../src/kernel/drivers/st_device_cseg.asm"
.include "../../../../../src/kernel/drivers/io/st_device_io_cseg.asm"
.include "../../../../../src/kernel/drivers/io/in_bit_cseg.asm"
.include "../../../../../src/kernel/drivers/io/hid/button_cseg.asm"
.include "../../../../../src/kernel/drivers/io/out_bit_cseg.asm"
.include "../../../../../src/kernel/drivers/io/hid/led_cseg.asm"
.include "../../../../../src/kernel/drivers/soc/usart_cseg.asm"

main_thread:
	; stack initialization
	m_init_stack
	; init leds
	m_led_init led1, DDRC, PORTC, (1 << BIT3)
	m_led_init led2, DDRC, PORTC, (1 << BIT4)
	m_led_init led3, DDRC, PORTC, (1 << BIT5)
	m_button_init button1, DDRC, PINC, PORTC, (1 << BIT1), button1_on_button_down_handler, button1_on_button_up_handler, button1_on_button_pressed_handler
	m_usart_init 1000000, 9600, usart_on_rxc_handler, usart_on_udre_handler, usart_on_txc_handler
	m_usart_udre_enable
	; init global interrupts
	m_init_interrupts

	.equ DELAY_TIME = 200000

	ldi r16, BUTTON_STATE_DOWN

	main_thread_loop:
		m_button_handle_io button1
		nop
		m_led_toggle led1

		main_thread_loop_end:
			;m_delay DELAY_TIME
			rjmp main_thread_loop

		ret

button1_on_button_down_handler:
	;m_led_off led2
	;m_led_off led3
	ret

button1_on_button_up_handler:
	;m_led_on led2
	ret

button1_on_button_pressed_handler:
	m_led_off led2
	m_led_off led3
	m_usart_udre_enable
	ret

usart_on_rxc_handler:
	;m_led_off led2
	m_led_on led3
	m_usart_udre_enable
	ret

usart_on_udre_handler:
	m_usart_udre_disable
	; set value to push to UDR
	ldi r23, 0xA0
	m_led_on led2
	;m_led_off led3
	ret

usart_on_txc_handler:
	ret
