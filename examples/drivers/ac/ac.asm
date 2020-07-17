.cseg
.org 0x00
rcall main_thread
; include components interrupts
;.include "../../../src/kernel/thread_int.asm"
.include "../../../src/kernel/drivers/ac_int.asm"

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
.include "../../../src/kernel/drivers/ac_def.asm"

;.include components data segments
;.include "../../../src/kernel/thread_dseg.asm"
.include "../../../src/kernel/drivers/ac_dseg.asm"
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
.include "../../../src/kernel/drivers/ac_cseg.asm"


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
	m_ac_init AC_INPUT_NEGATIVE_A_IN1, AC_INPUT_POSITIVE_VREF_1_23_V, AC_INTERRPUT_MODE_ARISE_BOTH_FRONTS, ac_on_changed_handler
	m_ac_enable
	m_ac_interrupts_enable
	
	; init global interrupts
	m_init_interrupts

	main_thread_loop:
		nop
		nop
		main_thread_loop_end:
			m_ac_output_value_get r16
			cpi r16, AC_OUTPUT_VALUE_FALSE
			breq main_thread_loop_ac_false
			main_thread_loop_ac_true:
				m_led_on led2
				rjmp main_thread_loop
			main_thread_loop_ac_false:
				m_led_off led2
				rjmp main_thread_loop

		ret

ac_on_changed_handler:
	m_led_toggle led1
	ret
