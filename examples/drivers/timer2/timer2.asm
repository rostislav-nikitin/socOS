.cseg
.org 0x00
rcall main_thread
; include components interrupts
;.include "../../../src/kernel/thread_int.asm"
.include "../../../src/kernel/drivers/timer2_int.asm"

; include SoC defaults
.include "m8def.inc"
; include components definitions
.include "../../../src/kernel/common_def.asm"
;.include "../../../src/kernel/thread_def.asm"
.include "../../../src/kernel/drivers/st_device_def.asm"
.include "../../../src/kernel/drivers/st_device_io_def.asm"
.include "../../../src/kernel/drivers/out_bit_def.asm"
.include "../../../src/kernel/drivers/led_def.asm"
.include "../../../src/kernel/drivers/timer_base_def.asm"
.include "../../../src/kernel/drivers/timer_w_pwm_base_def.asm"
.include "../../../src/kernel/drivers/timer2_def.asm"

;.include components data segments
;.include "../../../src/kernel/thread_dseg.asm"
.include "../../../src/kernel/drivers/timer2_dseg.asm"
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
.include "../../../src/kernel/drivers/out_bit_cseg.asm"
.include "../../../src/kernel/drivers/led_cseg.asm"
.include "../../../src/kernel/drivers/timer_base_cseg.asm"
.include "../../../src/kernel/drivers/timer_w_pwm_base_cseg.asm"
.include "../../../src/kernel/drivers/timer2_cseg.asm"


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
	m_timer2_init TIMER_DIVIDER_1024X, timer2_on_overflow_handler, TIMER_W_PWM_MODE_FAST, 0xEF, timer2_on_compare_handler

	m_timer2_interrupts_enable
	; init global interrupts
	m_init_interrupts

	;.equ DELAY_TIME = 200000
	main_thread_loop:
		nop
		main_thread_loop_end:
			;m_delay DELAY_TIME
			push r16
			m_timer2_counter_get_value r16
			pop r16
			nop
			rjmp main_thread_loop

		ret


timer2_on_overflow_handler:
	m_led_toggle led1
	ret
timer2_on_compare_handler:
	m_led_toggle led2
	ret
