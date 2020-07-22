; usage:
; .dseg
;   zmotor_stepper_bi1: .BYTE SZ_ST_MOTOR_STEPPER_BI
;   ...
; .cseg
;   m_motor_stepper_bi_init motor_stepper_bi1, DDRB, PINB, PORTB, (1 << BIT1), (1 << BIT2)
;   ...
;   m_motor_stepper_bi_get motor_stepper_bi1

; implementation

.macro m_motor_stepper_bi_init
	m_save_r24_r25_X_Y_Z_registers
	; input parameters:
	;	@0 	word	[st_motor_stepper_bi:st_device_io]
	;	@1	word	[DDRx]
	;	@2	word 	[PORTx]
	;	@3	byte 	TETRADE_MASK
	;	@4	byte	direction
	;	@5	byte	speed
	m_st_device_io_init @0, @1, NULL_POINTER, PORTC, @3, @3

	ldi ZL, low(@0)
	ldi ZH, high(@0)

	ldi r23, @4
	ldi r22, @5

	rcall motor_stepper_bi_init

	m_restore_r24_r25_X_Y_Z_registers
.endm

motor_stepper_bi_init:
	m_save_r22_r23_Y_registers
	push r23

	ldi r23, ST_MOTOR_STEPPER_BI_WAIT_STEP_OFFSET
	rcall set_struct_byte

	ldi r23, ST_MOTOR_STEPPER_BI_CURRENT_STEP_OFFSET
	ldi r22, ST_MOTOR_STEPPER_BI_CURRENT_STEP_DEFAULT
	rcall set_struct_byte

	ldi r23, ST_MOTOR_STEPPER_BI_CURRENT_WAIT_STEP_OFFSET
	ldi r22, ST_MOTOR_STEPPER_BI_CURRENT_WAIT_STEP_DEFAULT
	rcall set_struct_byte

	pop r23
	mov r22, r23
	ldi r23, ST_MOTOR_STEPPER_BI_DIRECTION_OFFSET
	rcall set_struct_byte

	rcall motor_stepper_bi_init_port

	m_restore_r22_r23_Y_registers

	ret

motor_stepper_bi_init_port:
	; parameters:
	;	Z	word	[st_motor_stepper_bi:st_device_io]
	m_save_r16_r23_Z_SREG_registers

	ldi r23, ST_MOTOR_STEPPER_BI_DIRECTION_OFFSET
	rcall get_struct_byte
	mov r16, r23

	ldi r23, ST_MOTOR_STEPPER_BI_USED_BIT_MASK_OFFSET
	rcall get_struct_byte

	push r23
	ldi r23, ST_MOTOR_STEPPER_BI_PORTX_ADDRESS_OFFSET
	rcall get_struct_word
	pop r23

	cpi r16, MOTOR_STEPPER_BI_DIRECTION_CCW
	breq motor_stepper_bi_init_port_ccw

	motor_stepper_bi_init_port_cw:
		rcall tetrade_r_shift
		rjmp motor_stepper_bi_init_port_end
	motor_stepper_bi_init_port_ccw:
		rcall tetrade_l_shift
		rjmp motor_stepper_bi_init_port_end

	motor_stepper_bi_init_port_end:

	m_restore_r16_r23_Z_SREG_registers

	ret

.macro m_motor_stepper_bi_direction_set
	; parameters:
	; 	@0	word 	[st_motor_stepper_bi:st_device_io]
	; 	@1	byte	direction
	m_save_r23_Z_registers

	ldi ZL, low(@0)
	ldi ZH, high(@0)

	ldi r23, @1

	rcall motor_stepper_bi_direction_set

	m_restore_r23_Z_registers
.endm
motor_stepper_bi_direction_set:
	m_save_r22_r23_registers

	mov r22, r23
	ldi r23, ST_MOTOR_STEPPER_BI_DIRECTION_OFFSET
	rcall set_struct_byte

	m_restore_r22_r23_registers

	ret

.macro m_motor_stepper_bi_wait_step_set
	; parameters:
	; 	@0	word 	[st_motor_stepper_bi:st_device_io]
	; 	@1	byte	steps to wait before switch before make a next step
	m_save_r23_Z_registers

	ldi ZL, low(@0)
	ldi ZH, high(@0)

	ldi r23, @1

	rcall motor_stepper_bi_wait_step_set

	m_restore_r23_Z_registers
.endm
motor_stepper_bi_wait_step_set:
	m_save_r22_r23_registers

	mov r22, r23
	ldi r23, ST_MOTOR_STEPPER_BI_WAIT_STEP_OFFSET
	rcall set_struct_byte

	m_restore_r22_r23_registers

	ret

.macro m_motor_stepper_bi_rotate
	; parameters:
	; 	@0	word 	[st_motor_stepper_bi:st_device_io]
	; 	@1	u_byte 	steps to run: [0-127], ST_MOTOR_STEPPER_BI_CURRENT_STEP_INFINITY
	m_save_r23_Z_registers

	ldi ZL, low(@0)
	ldi ZH, high(@0)

	ldi r23, @1

	rcall motor_stepper_bi_steps_set

	m_restore_r23_Z_registers
.endm
motor_stepper_bi_rotate:
	rcall motor_stepper_bi_steps_set

	ret

.macro m_motor_stepper_bi_rotate_infinity
	; parameters:
	; 	@0	word 	[st_motor_stepper_bi:st_device_io]
	m_save_r23_Z_registers

	ldi ZL, low(@0)
	ldi ZH, high(@0)
	ldi r23, ST_MOTOR_STEPPER_BI_CURRENT_STEP_INFINITY

	rcall motor_stepper_bi_steps_set

	m_restore_r23_Z_registers
.endm
motor_stepper_bi_rotate_infinity:
	m_save_r23_registers

	ldi r23, ST_MOTOR_STEPPER_BI_CURRENT_STEP_INFINITY

	rcall motor_stepper_bi_steps_set

	m_restore_r23_registers

	ret

.macro m_motor_stepper_bi_stop
	; parameters:
	; 	@0	word 	[st_motor_stepper_bi:st_device_io]
	m_save_r23_Z_registers

	ldi ZL, low(@0)
	ldi ZH, high(@0)
	ldi r23, ST_MOTOR_STEPPER_BI_CURRENT_STEP_STOP

	rcall motor_stepper_bi_steps_set

	m_restore_r23_Z_registers
.endm
motor_stepper_bi_stop:
	m_save_r23_registers

	ldi r23, ST_MOTOR_STEPPER_BI_CURRENT_STEP_STOP

	rcall motor_stepper_bi_steps_set

	m_restore_r23_registers

	ret

.macro m_motor_stepper_bi_steps_set
	; parameters:
	; 	@0	word 	[st_motor_stepper_bi:st_device_io]
	; 	@1	u_byte 	steps to run: [0-127], ST_MOTOR_STEPPER_BI_CURRENT_STEP_INFINITY
	m_save_r23_Z_registers

	ldi ZL, low(@0)
	ldi ZH, high(@0)
	ldi r23, @1

	rcall motor_stepper_bi_steps_set

	m_restore_r23_Z_registers
.endm
motor_stepper_bi_steps_set:
	m_save_r22_r23_registers

	mov r22, r23
	ldi r23, ST_MOTOR_STEPPER_BI_CURRENT_STEP_OFFSET
	rcall set_struct_byte

	m_restore_r22_r23_registers

	ret

.macro m_motor_stepper_bi_handle_io
	; parameters:
	;	@0	word	[st_motor_stepper_bi:st_device_io]
	m_save_Z_registers

	ldi ZL, low(@0)
	ldi ZH, high(@0)

	rcall motor_stepper_bi_handle_io

	m_restore_Z_registers
.endm
motor_stepper_bi_handle_io:
	; parameters:
	;	word	[st_motor_stepper_bi]
	m_save_r16_r17_r18_r19_r22_r23_Z_SREG_registers

	ldi r23, ST_MOTOR_STEPPER_BI_CURRENT_STEP_OFFSET
	rcall get_struct_byte
	mov r19, r23
	cpi r19, ST_MOTOR_STEPPER_BI_CURRENT_STEP_STOP
	breq motor_stepper_bi_handle_io_end

	motor_stepper_bi_handle_io_next_step:
		ldi r23, ST_MOTOR_STEPPER_BI_DIRECTION_OFFSET
		rcall get_struct_byte
		mov r16, r23

		ldi r23, ST_MOTOR_STEPPER_BI_WAIT_STEP_OFFSET
		rcall get_struct_byte
		mov r17, r23

		ldi r23, ST_MOTOR_STEPPER_BI_CURRENT_WAIT_STEP_OFFSET
		rcall get_struct_byte
		mov r18, r23

		add r18, r17
		brcs motor_stepper_bi_handle_io_shift_tetrade
		rjmp motor_stepper_bi_handle_io_save_current_wait_step

		motor_stepper_bi_handle_io_shift_tetrade:
			ldi r23, ST_MOTOR_STEPPER_BI_USED_BIT_MASK_OFFSET
			rcall get_struct_byte
			; save USED to the r23 (tertade_x_shift first parameter)
			m_save_Z_registers
			push r23
			ldi r23, ST_MOTOR_STEPPER_BI_PORTX_ADDRESS_OFFSET
			rcall get_struct_word
			pop r23

			cpi r16, MOTOR_STEPPER_BI_DIRECTION_CCW
			breq motor_stepper_bi_handle_io_shift_tetrade_ccw

			motor_stepper_bi_handle_io_shift_tetrade_cw:
				rcall tetrade_r_shift
				m_restore_Z_registers
				rjmp motor_stepper_bi_handle_io_check_current_step

			motor_stepper_bi_handle_io_shift_tetrade_ccw:
				rcall tetrade_l_shift
				m_restore_Z_registers
				rjmp motor_stepper_bi_handle_io_check_current_step

			motor_stepper_bi_handle_io_check_current_step:
				cpi r19, ST_MOTOR_STEPPER_BI_CURRENT_STEP_INFINITY
				breq motor_stepper_bi_handle_io_save_current_wait_step

				motor_stepper_bi_handle_io_decrease_steps_to_run:
					dec r19
					mov r22, r19
					ldi r23, ST_MOTOR_STEPPER_BI_CURRENT_STEP_OFFSET
					rcall set_struct_byte

		motor_stepper_bi_handle_io_save_current_wait_step:
			ldi r23, ST_MOTOR_STEPPER_BI_CURRENT_WAIT_STEP_OFFSET
			mov r22, r18
			rcall set_struct_byte

		motor_stepper_bi_handle_io_end:
			m_restore_r16_r17_r18_r19_r22_r23_Z_SREG_registers
	
	ret

.equ TETRADE_X_SHIFT_POSITION_MASK_NULL = 0x00

tetrade_l_shift:
	; parameters:
	;	Z	word	[PORTx]
	;	r23	byte	USED_BIT_MASK
	.equ TETRADE_L_SHIFT_POSITION_MASK_END = 0b10001000
	.equ TETRADE_L_SHIFT_POSITION_START = 0b00010001

	m_save_r16_r17_r18_Z_SREG_registers

	; load current PORTx value
	ld r16, Z
	; save current PORTx value
	mov r17, r16
	; add USED	
	and r17, r23
	; does null position?
	cpi r17, TETRADE_X_SHIFT_POSITION_MASK_NULL
	; if yes, set start position
	breq tetrade_l_shift_set_position_start
	; does end position?
	push r17
	ldi r18, TETRADE_L_SHIFT_POSITION_MASK_END
	and r18, r23
	cp r17, r18
	pop r17
	breq tetrade_l_shift_set_position_start
	; does start position?
	lsl r17
	rjmp tetrade_l_shift_store_back

	tetrade_l_shift_set_position_start:
		ldi r17, TETRADE_L_SHIFT_POSITION_START
		and r17, r23
	tetrade_l_shift_store_back:
		com r23
		and r16, r23
		or r16, r17
		st Z, r16
		m_restore_r16_r17_r18_Z_SREG_registers
	ret

tetrade_r_shift:
	; parameters:
	;	Z	word	[PORTx]
	;	r23	byte	USED_BIT_MASK
	.equ TETRADE_R_SHIFT_POSITION_MASK_END = 0b00010001
	.equ TETRADE_R_SHIFT_POSITION_START = 0b10001000

	m_save_r16_r17_r18_Z_SREG_registers

	; load current PORTx value
	ld r16, Z
	; save current PORTx value
	mov r17, r16
	; add USED	
	and r17, r23
	; does null position?
	cpi r17, TETRADE_X_SHIFT_POSITION_MASK_NULL
	; if yes, set start position
	breq tertade_rshift_set_position_start
	; does end position?
	push r17

	ldi r18, TETRADE_R_SHIFT_POSITION_MASK_END
	and r18, r23
	cp r17, r18

	pop r17
	breq tertade_rshift_set_position_start
	; does start position?
	lsr r17
	rjmp tertade_rshift_store_back

	tertade_rshift_set_position_start:
		ldi r17, TETRADE_R_SHIFT_POSITION_START
		and r17, r23
	tertade_rshift_store_back:
		com r23
		and r16, r23
		or r16, r17
		st Z, r16
		m_restore_r16_r17_r18_Z_SREG_registers

	ret
