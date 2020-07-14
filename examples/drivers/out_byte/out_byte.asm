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
.include "../../../src/kernel/drivers/out_byte_def.asm"

;.include components data segments
;.include "../../../src/kernel/thread_dseg.asm"
; custom data & descriptors
.dseg
	out_byte1:		.BYTE SZ_ST_OUT_BYTE
	out_byte2: 		.BYTE SZ_ST_OUT_BYTE

; main thread
.cseg
; skip interrupts vector
.org 0x14
; include components code segments
.include "../../../src/kernel/common_cseg.asm"
;.include "../../../src/kernel/thread_cseg.asm"
.include "../../../src/kernel/drivers/st_device_io_cseg.asm"
.include "../../../src/kernel/drivers/out_byte_cseg.asm"
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
	; init out_bytes
	m_out_byte_init out_byte1, DDRC, PORTC
	m_out_byte_init out_byte2, DDRB, PORTB
	; init global interrupts
	; m_init_interrupts

	.equ DELAY_TIME = 100000

	main_thread_loop:
		nop
		m_out_byte_on out_byte1
		;m_delay DELAY_TIME
		nop
		m_out_byte_off out_byte1
		;m_delay DELAY_TIME
		nop
		m_out_byte_set out_byte1, 0b01010101
		;m_delay DELAY_TIME
		nop
		m_out_byte_set out_byte1, 0b10101010
		;m_delay DELAY_TIME
		nop
		m_out_byte_toggle out_byte1
		;m_delay DELAY_TIME
		nop
		m_out_byte_toggle out_byte2
		;m_delay DELAY_TIME

		rjmp main_thread_loop
