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
.include "../../../src/kernel/drivers/watchdog_def.asm"

;.include components data segments
;.include "../../../src/kernel/thread_dseg.asm"
; custom data & descriptors
;.dseg
;	var1:		.BYTE SOME_ST_NAME

; main thread
.cseg
; skip interrupts vector
.org 0x14
; include components code segments
.include "../../../src/kernel/common_cseg.asm"
.include "../../../src/kernel/drivers/st_device_io_cseg.asm"
.include "../../../src/kernel/drivers/watchdog_cseg.asm"
.include "../../../src/extensions/delay_cseg.asm"
;.include "../../../src/kernel/thread_cseg.asm"


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

.macro m_init_interrupts
	.equ SREG_I_BIT = 0x07

	in r16, SREG
	ori r16, (1 << SREG_I_BIT)
	out SREG, r16
.endm

main_thread:
	; stack initialization
	m_init_stack
	; ports initialization
	m_init_ports
	; init watchdog
	m_watchdog_init_default
	; init global interrupts
	m_init_interrupts

	; delay > watchdog timeout
	.equ DELAY_TIME = 800000
	; delay < watchdog timeout
	;.equ DELAY = 20


	main_thread_loop:
		wdr
		m_delay DELAY_TIME
		rcall led_on

		rjmp main_thread_loop

led_on:
	; save registers
	push r16
	push r17
	; toggle led
	in r16, PORTB
	ldi r17, LED_DDRX_MASK
	or r16, r17
	out PORTB, r16
	;restore registers
	pop r17
	pop r16

	ret
