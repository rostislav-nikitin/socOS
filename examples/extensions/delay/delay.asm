.cseg
.org 0x00
rcall main_thread
; include components interrupts
;.include "../../lib/thread_int.asm"

; include components data segments
;.include "../../lib/thread_dseg.asm"

; main thread
.cseg
; skip interrupts vector
.org 0x14
; include SoC defaults
.include "m8def.inc"
; include components code segments
.include "../../../src/extensions/delay_cseg.asm"

; macros
.macro m_init_stack
	ldi r16, low(RAMEND)
	out SPL, r16
	ldi r16, high(RAMEND)
	out SPH, r16
.endm

.macro m_init_ports
	.equ LED_DDRX_MASK = 0x01
	.equ LED_PORTX_MASK = 0xfe

	ldi r16, LED_DDRX_MASK
	out DDRB, r16
	ldi r16, LED_PORTX_MASK
	out PORTB, r16
.endm

main_thread:
	; iniut stack
	m_init_stack
	; init ports
	m_init_ports

	.equ DELAY_TIME = 200000

	main_thread_loop:
		m_delay_short DELAY_TIME
		rcall led_loggle
		m_delay DELAY_TIME
		rcall led_loggle

		rjmp main_thread_loop

led_loggle:
	; save registers
	push r16
	push r17
	; toggle led
	in r16, PORTB
	ldi r17, LED_DDRX_MASK
	eor r16, r17
	out PORTB, r16
	;restore registers
	pop r17
	pop r16

	ret
