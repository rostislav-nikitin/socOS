.cseg
.org 0x00
rcall main_thread
; include components interrupts
;.include "../../../src/kernel/thread_int.asm"

; include SoC defaults
.include "m8def.inc"
; include components definitions
.include "../../../src/kernel/common_def.asm"
;.include "../../../src/kernel/thread_def.asm"
.include "../../../src/kernel/drivers/st_device_io_def.asm"
.include "../../../src/kernel/drivers/bit_input_def.asm"
.include "../../../src/kernel/drivers/switch_def.asm"
.include "../../../src/kernel/drivers/led_def.asm"

;.include components data segments
;.include "../../../src/kernel/thread_dseg.asm"
; custom data & descriptors
.dseg
	led1:		.BYTE SZ_ST_LED
	bit_input1:	.BYTE SZ_ST_BIT_INPUT

; main thread
.cseg
; skip interrupts vector
.org 0x14
; include components code segments
.include "../../../src/kernel/common_cseg.asm"
;.include "../../../src/kernel/thread_cseg.asm"
.include "../../../src/kernel/drivers/st_device_io_cseg.asm"
.include "../../../src/kernel/drivers/bit_input_cseg.asm"
.include "../../../src/kernel/drivers/switch_cseg.asm"
.include "../../../src/kernel/drivers/led_cseg.asm"
.include "../../../src/extensions/delay_cseg.asm"


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
	m_led_init led1, DDRC, PORTC, (1 << BIT4)
	m_bit_input_init bit_input1, DDRC, PINC, PORTC, (1 << BIT1)
	; init global interrupts
	; m_init_interrupts

	.equ DELAY_TIME = 200000

	ldi r16, BIT_INPUT_STATE_DOWN

	main_thread_loop:
		nop
		m_led_toggle led1
		nop
		m_led_toggle led1
		nop
		m_bit_input_get bit_input1, r16
		cpi r16, BIT_INPUT_STATE_DOWN
		breq main_thread_loop_bit_input_state_down
		m_led_on led1
		rjmp main_thread_loop_end
		main_thread_loop_bit_input_state_down:
		m_led_off led1

		main_thread_loop_end:
			;m_delay DELAY_TIME
			rjmp main_thread_loop

		ret
