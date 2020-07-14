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
.include "../../../src/kernel/drivers/ssi_def.asm"

;.include components data segments
;.include "../../../src/kernel/thread_dseg.asm"
; custom data & descriptors
.dseg
	ssi1:			.BYTE SZ_ST_SSI

; main thread
.cseg
; skip interrupts vector
.org 0x14
; include components code segments
.include "../../../src/kernel/common_cseg.asm"
;.include "../../../src/kernel/thread_cseg.asm"
.include "../../../src/kernel/drivers/st_device_io_cseg.asm"
.include "../../../src/kernel/drivers/out_byte_cseg.asm"
.include "../../../src/kernel/drivers/ssi_cseg.asm"
;.include "../../../src/extensions/delay_cseg.asm"


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
	; init ssi
	m_ssi_init ssi1, DDRC, PORTC
	; init global interrupts
	; m_init_interrupts
	m_ssi_on ssi1

	.equ DELAY_TIME = 100000

	main_thread_loop:
		nop
		m_ssi_char_show ssi1, '0'
		m_ssi_handle_io ssi1
		m_ssi_handle_io ssi1
		;m_delay DELAY_TIME
		nop
		m_ssi_flash_on ssi1
		;
		m_ssi_char_show ssi1, '1'
		;
		m_ssi_handle_io ssi1
		m_ssi_handle_io ssi1
		m_ssi_handle_io ssi1
		m_ssi_handle_io ssi1
		m_ssi_handle_io ssi1
		;
		m_ssi_flash_off ssi1
		;m_delay DELAY_TIME
		nop
		m_ssi_char_show ssi1, '2'
		m_ssi_handle_io ssi1
		;m_delay DELAY_TIME
		nop
		m_ssi_char_show ssi1, '3'
		m_ssi_handle_io ssi1
		;m_delay DELAY_TIME
		nop

		rjmp main_thread_loop
