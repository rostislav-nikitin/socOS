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
.include "../../../src/kernel/drivers/switch_def.asm"

;.include components data segments
;.include "../../../src/kernel/thread_dseg.asm"
; custom data & descriptors
.dseg
	switch1:		.BYTE SZ_ST_SWITCH
	switch2: 		.BYTE SZ_ST_SWITCH

; main thread
.cseg
; skip interrupts vector
.org 0x14
; include components code segments
.include "../../../src/kernel/common_cseg.asm"
;.include "../../../src/kernel/thread_cseg.asm"
.include "../../../src/kernel/drivers/st_device_io_cseg.asm"
.include "../../../src/kernel/drivers/switch_cseg.asm"
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
	; init switchs
	m_switch_init switch1, DDRC, PORTC, (1 << BIT4)
	m_switch_init switch2, DDRC, PORTC, (1 << BIT5)
	; init global interrupts
	; m_init_interrupts

	.equ DELAY_TIME = 200000

	main_thread_loop:
		nop
		;m_delay DELAY_TIME
		m_switch_set switch1, SWITCH_STATE_ON
		nop
		;m_delay DELAY_TIME
		m_switch_set switch1, SWITCH_STATE_OFF
		nop
		;m_delay DELAY_TIME
		m_switch_on switch1
		nop
		;m_delay DELAY_TIME
		m_switch_off switch1
		nop
		m_switch_toggle switch2

		rjmp main_thread_loop
