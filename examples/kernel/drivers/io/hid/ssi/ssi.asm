.cseg
.org 0x00
rcall main_thread
; include components interrupts
;.include "../../../../../../src/kernel/drivers/{driver_name}_int.asm"

; include components definitions
.include "../../../../../../src/kernel/kernel_def.asm"
;.include "../../../../../../src/kernel/thread_def.asm"
.include "../../../../../../src/kernel/drivers/st_device_def.asm"
.include "../../../../../../src/kernel/drivers/io/st_device_io_def.asm"
.include "../../../../../../src/kernel/drivers/io/out_byte_def.asm"
.include "../../../../../../src/kernel/drivers/io/hid/ssi_def.asm"

;.include components data segments
;.include "../../../../../../src/kernel/drivers/{driver_name}_dseg.asm"
; custom data & descriptors
.dseg
	ssi1:			.BYTE SZ_ST_SSI

; main thread
.cseg
; skip interrupts vector
.org 0x14
; include components code segments
.include "../../../../../../src/kernel/kernel_cseg.asm"
;.include "../../../../../../src/kernel/drivers/{drivers_name}_cseg.asm"
.include "../../../../../../src/kernel/drivers/st_device_cseg.asm"
.include "../../../../../../src/kernel/drivers/io/st_device_io_cseg.asm"
.include "../../../../../../src/kernel/drivers/io/out_byte_cseg.asm"
.include "../../../../../../src/kernel/drivers/io/hid/ssi_cseg.asm"

main_thread:
	; stack initialization
	m_init_stack
	; init ssi
	m_ssi_init ssi1, DDRC, PORTC

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
