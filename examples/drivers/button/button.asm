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
.include "../../../src/kernel/drivers/led_def.asm"

;.include components data segments
;.include "../../../src/kernel/thread_dseg.asm"
; custom data & descriptors
.dseg
	led1:		.BYTE ST_LED_SIZE
	led2: 		.BYTE ST_LED_SIZE

; main thread
.cseg
; skip interrupts vector
.org 0x14
; include components code segments
.include "../../../src/kernel/common_cseg.asm"
;.include "../../../src/kernel/thread_cseg.asm"
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
	m_led_init led2, DDRC, PORTC, (1 << BIT5)
	; init global interrupts
	; m_init_interrupts

	.equ DELAY_TIME = 200000

	main_thread_loop:
		nop
		;m_delay DELAY_TIME
		m_led_set led1, LED_ON
		nop
		;m_delay DELAY_TIME
		m_led_set led1, LED_OFF
		nop
		;m_delay DELAY_TIME
		m_led_on led1
		nop
		;m_delay DELAY_TIME
		m_led_off led1
		nop
		m_led_toggle led2

		rjmp main_thread_loop
