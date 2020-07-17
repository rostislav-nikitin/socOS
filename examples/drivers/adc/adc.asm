.cseg
.org 0x00
rcall main_thread
; include components interrupts
;.include "../../../src/kernel/thread_int.asm"
.include "../../../src/kernel/drivers/adc_int.asm"

; include SoC defaults
.include "m8def.inc"
; include components definitions
.include "../../../src/kernel/common_def.asm"
;.include "../../../src/kernel/thread_def.asm"
.include "../../../src/kernel/drivers/st_device_def.asm"
.include "../../../src/kernel/drivers/st_device_io_def.asm"
.include "../../../src/kernel/drivers/in_bit_def.asm"
.include "../../../src/kernel/drivers/button_def.asm"
.include "../../../src/kernel/drivers/out_bit_def.asm"
.include "../../../src/kernel/drivers/led_def.asm"
.include "../../../src/kernel/drivers/adc_def.asm"

;.include components data segments
;.include "../../../src/kernel/thread_dseg.asm"
.include "../../../src/kernel/drivers/adc_dseg.asm"
; custom data & descriptors
.dseg
	led1:		.BYTE SZ_ST_LED
	led2:		.BYTE SZ_ST_LED

; main thread
.cseg
; skip interrupts vector
.org 0x14
; include components code segments
.include "../../../src/kernel/common_cseg.asm"
;.include "../../../src/kernel/thread_cseg.asm"
.include "../../../src/kernel/drivers/st_device_cseg.asm"
.include "../../../src/kernel/drivers/st_device_io_cseg.asm"
.include "../../../src/kernel/drivers/in_bit_cseg.asm"
.include "../../../src/kernel/drivers/button_cseg.asm"
.include "../../../src/kernel/drivers/out_bit_cseg.asm"
.include "../../../src/kernel/drivers/led_cseg.asm"
.include "../../../src/kernel/drivers/adc_cseg.asm"


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
	; init leds
	m_led_init led1, DDRC, PORTC, (1 << BIT5)
	m_led_init led2, DDRC, PORTC, (1 << BIT4)
	m_adc_init ADC_INPUT_NEGATIVE_REG_2_56V, ADC_INPUT_POSITIVE_PINC0, ADC_FREQUNCY_X128, ADC_OUTPUT_VALUE_ORDER_HIGH_FULL, ADC_CONTINUOUS_MEASUREMENT_TRUE, adc_on_changed_handler
	m_adc_enable
	m_adc_continuous_measurement_enable
	m_adc_interrupts_enable
	
	; init global interrupts
	m_init_interrupts

	m_adc_start_conversion

	main_thread_loop:
		nop
		nop
		main_thread_loop_end:
			m_adc_output_value_get r16, r17
			cpi r17, 0x00
			breq main_thread_loop_adc_zero
			main_thread_loop_adc_non_zero:
				m_led_on led2
				rjmp main_thread_loop
			main_thread_loop_adc_zero:
				m_led_off led2
				rjmp main_thread_loop

		ret

adc_on_changed_handler:
	cpi YH, 0x00
	breq adc_on_changed_handler_zero
	adc_on_changed_handler_non_zero:
		m_led_on led1
		rjmp adc_on_changed_handler_end
	adc_on_changed_handler_zero:
		m_led_off led1
		rjmp adc_on_changed_handler_end

	adc_on_changed_handler_end:

	ret
