.cseg
.org 0x00
rcall main_thread
; include components interrupts
;.include "../../../../../src/kernel/drivers/{device_name}_int.asm"
.include "../../../../../src/kernel/drivers/soc/eeprom_int.asm"

; include components definitions
.include "../../../../../src/kernel/kernel_def.asm"
;.include "../../../../../src/kernel/drivers/{device_name}_def.asm"
.include "../../../../../src/kernel/drivers/st_device_def.asm"
.include "../../../../../src/kernel/drivers/io/st_device_io_def.asm"
.include "../../../../../src/kernel/drivers/io/out_bit_def.asm"
.include "../../../../../src/kernel/drivers/io/hid/led_def.asm"
.include "../../../../../src/kernel/drivers/soc/eeprom_def.asm"

;.include components data segments
;.include "../../../../../src/kernel/drivers/{driver_name}_dseg.asm"
.include "../../../../../src/kernel/drivers/soc/eeprom_dseg.asm"
; custom data & descriptors
.dseg
	led1:			.BYTE SZ_ST_LED
	led2:			.BYTE SZ_ST_LED

.eseg
	eeprom_led_state:	.db LED_STATE_ON
; main thread
.cseg
; skip interrupts vector
.org 0x14
; include components code segments
.include "../../../../../src/kernel/kernel_cseg.asm"
;.include "../../../../../src/kernel/drivers/{driver_name}_cseg.asm"
.include "../../../../../src/kernel/drivers/st_device_cseg.asm"
.include "../../../../../src/kernel/drivers/io/st_device_io_cseg.asm"
.include "../../../../../src/kernel/drivers/io/out_bit_cseg.asm"
.include "../../../../../src/kernel/drivers/io/hid/led_cseg.asm"
.include "../../../../../src/kernel/drivers/soc/eeprom_cseg.asm"

main_thread:
	; stack initialization
	m_init_stack
	; init leds
	m_led_init led1, DDRC, PORTC, (1 << BIT4)
	m_led_init led2, DDRC, PORTC, (1 << BIT5)
	m_eeprom_init eeprom_on_ready_handler
	m_eeprom_interrupts_enable
	; init global interrupts
	m_init_interrupts

	m_eeprom_load_sync eeprom_led_state, r16
	cpi r16, LED_STATE_OFF
	breq main_thread_led_off

	main_thread_led_on:
		m_led_on led1
		m_eeprom_store_sync eeprom_led_state, LED_STATE_OFF
		rjmp main_thread_loop
	main_thread_led_off:
		m_led_off led1
		m_eeprom_store_sync eeprom_led_state, LED_STATE_ON
		rjmp main_thread_loop

	main_thread_loop:
		nop
		rjmp main_thread_loop

	ret

eeprom_on_ready_handler:
	m_led_on led2
	ret
