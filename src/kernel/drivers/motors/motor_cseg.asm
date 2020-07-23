;.include "../soc/timer2_cseg.asm"

; PWM at PINB[3]
.macro m_motor_init
	m_save_r23_Z_registers
	; parameters:
	;	@0	byte            TIMER_W_PWM_DIVIDER
	;	@1	byte		power [0x00:0xff]
	m_timer2_init @0, POINTER_NULL, TIMER_W_PWM_MODE_FAST, @1, POINTER_NULL

	rcall motor_init
.endm

motor_init:
	ret

.macro m_motor_start
	rcall motor_start
.endm
motor_start:
	rcall timer2_counter_control_register_set_mode

	ret

.macro m_motor_stop
	rcall motor_stop
.endm
motor_stop:
	rcall timer2_counter_control_register_set_mode_off

	ret

.macro m_motor_power_set
	; parameters
	;	@0	byte	power [0x00:0xff]
	m_save_r23_registers

	ldi r23, @0

	rcall motor_power_set

	m_restore_r23_registers
.endm
motor_power_set:
	; set mode off (required to change compare control register)
	rcall timer2_counter_control_register_set_mode_off
	; set compare thershole (to the st_timer2)
	rcall timer2_compare_threshold_set
	; set compare control register from the st_timer2::compare_threshold
	rcall timer2_compare_control_register_set_compare_threshold
	; restore mode
	rcall timer2_counter_control_register_set_mode

	ret


