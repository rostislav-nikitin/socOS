.cseg
.org 0x00
rcall main_thread
; include components interrupts
.include "../../lib/thread_int.asm"

; include components data segments
.include "../../lib/thread_dseg.asm"

; main thread
.cseg
; skip interrupts vector
.org 0x14
; include SoC defaults
.include "m8def.inc"
; include components code segments
.include "../../lib/thread_cseg.asm"

; macros
.macro m_init_stack
	ldi r16, low(RAMEND)
	out SPL, r16
	ldi r16, high(RAMEND)
	out SPH, r16
.endm

.macro m_init_ports
	ldi r16, 0xFF
	out DDRB, r16
	ldi r16, 0x00
	out PORTB, r16
.endm

.macro m_init_global_interrupts
	in r16, SREG
	ori r16, (1 << 0x07)
	out SREG, r16
.endm

main_thread:
	; stack initialization
	m_init_stack
	; ports initialization
	m_init_ports
	; components initialization
	m_thread_init
	; create dummy threads
	m_thread_create dummy_thread_handler_one
	m_thread_create dummy_thread_handler_two

	m_init_global_interrupts

	main_thread_loop:
		nop
		rjmp main_thread_loop


dummy_thread_handler_one:
	; save registers
	push r16

	in r16, PORTB
	inc r16
	inc r16
	out PORTB, r16

	; restore registers
	pop r16

	ret

dummy_thread_handler_two:
	; save registers
	push r16

	in r16, PORTB
	dec r16
	out PORTB, r16

	; restore registers
	pop r16

	ret
