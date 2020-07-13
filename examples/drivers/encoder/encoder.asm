.cseg
.org 0x00
rcall main_thread
; include components interrupts
;.include "../../../lib/kernel/thread_int.asm"

; include SoC defaults
.include "m8def.inc"
; include components definitions
.include "../../../src/kernel/common_def.asm"
;.include "../../../src/kernel/thread_def.asm"
.include "../../../src/kernel/drivers/st_device_io_def.asm"
.include "../../../src/kernel/drivers/out_bit_def.asm"
.include "../../../src/kernel/drivers/led_def.asm"
.include "../../../src/kernel/drivers/encoder_def.asm"

;.include components data segments
;.include "../../../lib/kernel/thread_dseg.asm"
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
.include "../../../src/kernel/common_cseg.asm"
;.include "../../../src/kernel/thread_cseg.asm"
.include "../../../src/extensions/delay_cseg.asm"
.include "../../../src/kernel/drivers/st_device_io_cseg.asm"
.include "../../../src/kernel/drivers/out_bit_cseg.asm"
.include "../../../src/kernel/drivers/led_cseg.asm"
.include "../../../src/kernel/drivers/encoder_cseg.asm"

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
	; init thread pool
	; ports initialization
	;m_ports_init
	;m_thread_init
	; init leds
	m_led_init led1, DDRC, PORTC, (1 << BIT4)
	m_led_init led2, DDRC, PORTC, (1 << BIT5)
	; inot encoder
	m_encoder_init encoder1, DDRC, PINC, PORTC, (1 << BIT2), (1 << BIT1)
	; init global interrupts
	; m_init_interrupts


	main_thread_loop:
		m_encoder_detect encoder1, r16

		main_thread_loop_check_backward:
			cpi r16, ENCODER_STATE_BACKWARD
			brne main_thread_loop_check_forward
			m_led_on led1
			m_led_off led2
			rjmp main_thread_loop_end
		main_thread_loop_check_forward:
			cpi r16, ENCODER_STATE_FORWARD
			brne main_thread_loop_check_none
			m_led_off led1
			m_led_on led2
			rjmp main_thread_loop_end
		main_thread_loop_check_none:
			;m_led_off led1
			;m_led_off led2

	main_thread_loop_end:
		rjmp main_thread_loop
