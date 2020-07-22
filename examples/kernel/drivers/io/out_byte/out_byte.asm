.cseg
.org 0x00
rcall main_thread
; include components interrupts
;.include "../../../../../src/kernel/drivers/{driver_name}_int.asm"

; include components definitions
.include "../../../../../src/kernel/kernel_def.asm"
;.include "../../../../../src/kernel/drivers/{driver_name}_def.asm"
.include "../../../../../src/kernel/drivers/st_device_def.asm"
.include "../../../../../src/kernel/drivers/io/st_device_io_def.asm"
.include "../../../../../src/kernel/drivers/io/out_byte_def.asm"

;.include components data segments
;.include "../../../../../src/kernel/drivers/{driver_name}_dseg.asm"
; custom data & descriptors
.dseg
	out_byte1:		.BYTE SZ_ST_OUT_BYTE
	out_byte2: 		.BYTE SZ_ST_OUT_BYTE

; main thread
.cseg
; skip interrupts vector
.org 0x14
; include components code segments
.include "../../../../../src/extensions/delay_cseg.asm"
.include "../../../../../src/kernel/kernel_cseg.asm"
;.include "../../../../../src/kernel/drivers/{driver_name}_cseg.asm"
.include "../../../../../src/kernel/drivers/st_device_cseg.asm"
.include "../../../../../src/kernel/drivers/io/st_device_io_cseg.asm"
.include "../../../../../src/kernel/drivers/io/out_byte_cseg.asm"

main_thread:
	; init stack
	m_init_stack
	; init out bytes
	m_out_byte_init out_byte1, DDRC, PORTC
	m_out_byte_init out_byte2, DDRB, PORTB

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
