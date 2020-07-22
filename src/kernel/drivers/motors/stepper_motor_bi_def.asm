; struct st_button size
; m_st_device_io_init
.equ SZ_ST_STEPPER_MOTOR_BI				= SZ_ST_DEVICE_IO + 0x04
; struct st_button:st_device_io
; inherited members
.equ ST_STEPPER_MOTOR_BI_DDRX_ADDRESS_OFFSET		= ST_DEVICE_IO_DDRX_ADDRESS_OFFSET
.equ ST_STEPPER_MOTOR_BI_PINX_ADDRESS_OFFSET 		= ST_DEVICE_IO_PINX_ADDRESS_OFFSET
.equ ST_STEPPER_MOTOR_BI_PORTX_ADDRESS_OFFSET 		= ST_DEVICE_IO_PORTX_ADDRESS_OFFSET
.equ ST_STEPPER_MOTOR_BI_USED_BIT_MASK_OFFSET		= ST_DEVICE_IO_USED_BIT_MASK_OFFSET
.equ ST_STEPPER_MOTOR_BI_TYPE_BIT_MASK_OFFSET		= ST_DEVICE_IO_TYPE_BIT_MASK_OFFSET

;
.equ ST_STEPPER_MOTOR_BI_DIRECTION_OFFSET			= SZ_ST_DEVICE_IO
.equ ST_STEPPER_MOTOR_BI_WAIT_STEP_OFFSET			= SZ_ST_DEVICE_IO + 0x01
.equ ST_STEPPER_MOTOR_BI_CURRENT_WAIT_STEP_OFFSET		= SZ_ST_DEVICE_IO + 0x02
.equ ST_STEPPER_MOTOR_BI_CURRENT_STEP_OFFSET		= SZ_ST_DEVICE_IO + 0x03

; enumerations

;STEPPER_MOTOR_BI_TETRADE_MASK
.equ STEPPER_MOTOR_BI_TETRADE_MASK_LOW			= TETRADE_MASK_LOW
.equ STEPPER_MOTOR_BI_TETRADE_MASK_HIGH			= TETRADE_MASK_HIGH

; STEPPER_MOTOR_BI_DIRECTION
.equ STEPPER_MOTOR_BI_DIRECTION_CCW			= DIRECTION_THREAD_CCW
.equ STEPPER_MOTOR_BI_DIRECTION_CW				= DIRECTION_THREAD_CW

; STEPPER_MOTOR_BI_STEP
.equ STEPPER_MOTOR_BI_WAIT_STEP_1X				= 0x01
.equ STEPPER_MOTOR_BI_WAIT_STEP_2X				= 0x02
.equ STEPPER_MOTOR_BI_WAIT_STEP_4X				= 0x04
.equ STEPPER_MOTOR_BI_WAIT_STEP_8X				= 0x08
.equ STEPPER_MOTOR_BI_WAIT_STEP_16X				= 0x10
.equ STEPPER_MOTOR_BI_WAIT_STEP_32X				= 0x20
.equ STEPPER_MOTOR_BI_WAIT_STEP_64X				= 0x40
.equ STEPPER_MOTOR_BI_WAIT_STEP_128X				= 0x80

; ST_STEPPER_MOTOR_BI_CURRENT_WAIT_STEP
.equ ST_STEPPER_MOTOR_BI_CURRENT_WAIT_STEP_DEFAULT = 0x00

; ST_STEPPER_MOTOR_BI_CURRENT_STEP
.equ ST_STEPPER_MOTOR_BI_CURRENT_STEP_STOP		= 0x00
.equ ST_STEPPER_MOTOR_BI_CURRENT_STEP_DEFAULT	= ST_STEPPER_MOTOR_BI_CURRENT_STEP_STOP
.equ ST_STEPPER_MOTOR_BI_CURRENT_STEP_INFINITY	= 0x80; -1