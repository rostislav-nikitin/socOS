.cseg
.org 0x00
rcall main_thread
; include components interrupts
;.include "../../../src/kernel/thread_int.asm"
.include "../../../src/kernel/drivers/timer0_int.asm"

; include SoC defaults
.include "m8def.inc"
; include components definitions
.include "../../../src/kernel/common_def.asm"
;.include "../../../src/kernel/thread_def.asm"
.include "../../../src/kernel/drivers/st_device_def.asm"
.include "../../../src/kernel/drivers/st_device_io_def.asm"
.include "../../../src/kernel/drivers/out_bit_def.asm"
.include "../../../src/kernel/drivers/led_def.asm"
.include "../../../src/kernel/drivers/stepper_motor_def.asm"
.include "../../../src/kernel/drivers/timer_base_def.asm"
.include "../../../src/kernel/drivers/timer0_def.asm"

;.include components data segments
;.include "../../../src/kernel/thread_dseg.asm"
.include "../../../src/kernel/drivers/timer0_dseg.asm"
; custom data & descriptors
.dseg
	led1:			.BYTE SZ_ST_LED
	stepper_motor1:	.BYTE SZ_ST_STEPPER_MOTOR

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
.include "../../../src/kernel/drivers/stepper_motor_cseg.asm"
.include "../../../src/kernel/drivers/timer_base_cseg.asm"
.include "../../../src/kernel/drivers/timer0_cseg.asm"


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
	m_stepper_motor_init stepper_motor1, DDRC, PORTC, STEPPER_MOTOR_TETRADE_MASK_LOW, STEPPER_MOTOR_DIRECTION_CCW, STEPPER_MOTOR_WAIT_STEP_64X
	m_timer0_init TIMER_DIVIDER_1024X, timer0_on_overflow_handler
	m_timer0_interrupts_enable
	; init global interrupts
	;m_stepper_motor_rotate stepper_motor1, 1
	m_stepper_motor_rotate_infinity stepper_motor1
	m_stepper_motor_stop stepper_motor1
	;
	m_stepper_motor_direction_set stepper_motor1, STEPPER_MOTOR_DIRECTION_CW
	m_stepper_motor_rotate stepper_motor1, 2


	m_init_interrupts

	;.equ DELAY_TIME = 200000


	main_thread_loop:
		;m_button_handle_io button1
		;nop
		;m_led_toggle led1
		;nop
		;m_led_toggle led1
		;nop
		;m_button_get button1, r16
		;cpi r16, BUTTON_STATE_DOWN
		;breq main_thread_loop_button_state_down
		;main_thread_loop_button_state_up:
		;m_led_on led1
		;rjmp main_thread_loop_end
		;main_thread_loop_button_state_down:
		;m_led_off led1

		main_thread_loop_end:
			;m_delay DELAY_TIME
			push r16
			m_timer0_counter_get_value r16
			pop r16
			nop
			rjmp main_thread_loop

		ret


timer0_on_overflow_handler:
	m_led_toggle led1
	m_stepper_motor_handle_io stepper_motor1

	ret
