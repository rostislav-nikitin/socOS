.cseg
.org 0x00
rcall main_thread
; include components interrupts
;.include "../../../src/kernel/thread_int.asm"
.include "../../../src/kernel/drivers/usart_int.asm"

; include SoC defaults
.include "m8def.inc"
; include components definitions
.include "../../../src/kernel/common_def.asm"
;.include "../../../src/kernel/thread_def.asm"
.include "../../../src/kernel/drivers/st_device_def.asm"
.include "../../../src/kernel/drivers/st_device_io_def.asm"
.include "../../../src/kernel/drivers/out_bit_def.asm"
.include "../../../src/kernel/drivers/led_def.asm"
.include "../../../src/kernel/drivers/usart_def.asm"
.include "../../../src/kernel/drivers/sensors/am2302_def.asm"

;.include components data segments
;.include "../../../src/kernel/thread_dseg.asm"
.include "../../../src/kernel/drivers/usart_dseg.asm"
; custom data & descriptors
.dseg
	led1:		.BYTE SZ_ST_LED
	am2302_1:	.BYTE SZ_ST_AM2302

; main thread
.cseg
; skip interrupts vector
.org 0x14
; include components code segments
.include "../../../src/extensions/delay_cseg.asm"
.include "../../../src/kernel/common_cseg.asm"
;.include "../../../src/kernel/thread_cseg.asm"
.include "../../../src/kernel/drivers/st_device_cseg.asm"
.include "../../../src/kernel/drivers/st_device_io_cseg.asm"
.include "../../../src/kernel/drivers/out_bit_cseg.asm"
.include "../../../src/kernel/drivers/led_cseg.asm"
.include "../../../src/kernel/drivers/usart_cseg.asm"
.include "../../../src/kernel/drivers/sensors/am2302_cseg.asm"


; macros
.macro m_init_stack
	ldi r16, low(RAMEND)
	out SPL, r16
	ldi r16, high(RAMEND)
	out SPH, r16
.endm

.macro m_init_interrupts
	.equ SREG_I_BIT = 0x07

	in r16, SREG
	ori r16, (1 << SREG_I_BIT)
	out SREG, r16
.endm

main_thread:
	; stack initialization
	m_init_stack
	; init leds
	m_led_init led1, DDRC, PORTC, (1 << BIT5)
	m_usart_init 1000000, 9600, usart_on_rxc_handler, usart_on_udre_handler, usart_on_txc_handler
	m_am2302_init am2302_1, DDRC, PINC, (1 << BIT0), am2302_1_on_completed_handler
	m_usart_udre_enable
	; init global interrupts
	m_init_interrupts

	.equ DELAY_TIME = 200000



	/*sbic DDRC, 0x00
	rjmp main_thread_loop
	m_led_on led1*/

	main_thread_loop:
		/*m_led_toggle led1
		nop
		m_am2302_data_get am2302_1, r16
		cpi r16, ST_AM2302_RESULT_STATE_OK
		brne main_thread_loop_end
		;m_led_on led1*/

		main_thread_loop_end:
			;m_delay DELAY_TIME
			rjmp main_thread_loop

		ret

am2302_1_on_completed_handler:
	ret

usart_on_rxc_handler:
	;m_led_off led2
	m_usart_udre_enable
	ret
usart_on_udre_handler:
	m_save_r16_Z_SREG_registers

	m_delay DELAY_TIME
	m_am2302_data_get am2302_1, r16
	cpi r16, ST_AM2302_RESULT_STATE_OK
	brne usart_on_udre_handler_error

	usart_on_udre_handler_ok:
		m_led_on led1
		ldi ZL, low(am2302_1)
		ldi ZH, high(am2302_1)
		ldi r23, ST_AM2302_DATA_TEMPERATURE_LOW
		rcall get_struct_byte
		rjmp usart_on_udre_handler_end

	usart_on_udre_handler_error:
		m_led_off led1
		mov r23, r16
		rjmp usart_on_udre_handler_end

	usart_on_udre_handler_end:
		m_restore_r16_Z_SREG_registers

	ret
usart_on_txc_handler:
	ret
