.cseg
.org 0x00
rcall main_thread
; include components interrupts
;.include "../../../../../src/kernel/drivers/{driver_name}_int.asm"

; include components definitions
.include "../../../../../src/kernel/kernel_def.asm"
;.include "../../../src/kernel/drivers/{driver_name}_def.asm"
.include "../../../../../src/kernel/drivers/device_def.asm"
.include "../../../../../src/kernel/drivers/io/device_io_def.asm"
.include "../../../../../src/kernel/drivers/io/out_bit_def.asm"

;.include components data segments
;.include "../../../../../src/kernel/drivers/io/{driver_name}_dseg.asm"
; custom data & descriptors
.dseg
	out_bit1:		.BYTE SZ_ST_OUT_BIT
	out_bit2: 		.BYTE SZ_ST_OUT_BIT

; main thread
.cseg
; skip interrupts vector
.org 0x14
; include components code segments
.include "../../../../../src/extensions/delay_cseg.asm"
.include "../../../../../src/kernel/kernel_cseg.asm"
;.include "../../../../../src/kernel/drivers/{driver_name}_cseg.asm"
.include "../../../../../src/kernel/drivers/device_cseg.asm"
.include "../../../../../src/kernel/drivers/io/device_io_cseg.asm"
.include "../../../../../src/kernel/drivers/io/out_bit_cseg.asm"


main_thread:
	; stack initialization
	m_init_stack
	; init out_bits
	m_out_bit_init out_bit1, DDRC, PORTC, (1 << BIT4)
	m_out_bit_init out_bit2, DDRC, PORTC, (1 << BIT5)


	.equ DELAY_TIME = 200000

	main_thread_loop:
		nop
		;m_delay DELAY_TIME
		m_out_bit_set out_bit1, OUT_BIT_STATE_ON
		nop
		;m_delay DELAY_TIME
		m_out_bit_set out_bit1, OUT_BIT_STATE_OFF
		nop
		;m_delay DELAY_TIME
		m_out_bit_on out_bit1
		nop
		;m_delay DELAY_TIME
		m_out_bit_off out_bit1
		nop
		m_out_bit_toggle out_bit2

		rjmp main_thread_loop
