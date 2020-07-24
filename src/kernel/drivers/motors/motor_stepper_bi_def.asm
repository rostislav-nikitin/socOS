;=======================================================================================================================
;                                                                                                                      ;
; Name:	socOS (System On Chip Operation System)                                                                        ;
; 	Year: 		2020                                                                                           ;
; 	License:	MIT License                                                                                    ;
;                                                                                                                      ;
;=======================================================================================================================

; Require:
;.include "m8def.inc"

;.include "kernel/kernel_def.asm"
;.include "kernel/drivers/device_def.asm"
;.include "kernel/drivers/io/device_io_def.asm"

; st_motor_stepper_bi size
.equ SZ_ST_MOTOR_STEPPER_BI				= SZ_ST_DEVICE_IO + 0x04
; st_motor_stepper_bi:st_device_io inherited members
.equ ST_MOTOR_STEPPER_BI_DDRX_ADDRESS_OFFSET		= ST_DEVICE_IO_DDRX_ADDRESS_OFFSET
.equ ST_MOTOR_STEPPER_BI_PINX_ADDRESS_OFFSET 		= ST_DEVICE_IO_PINX_ADDRESS_OFFSET
.equ ST_MOTOR_STEPPER_BI_PORTX_ADDRESS_OFFSET 		= ST_DEVICE_IO_PORTX_ADDRESS_OFFSET
.equ ST_MOTOR_STEPPER_BI_USED_BIT_MASK_OFFSET		= ST_DEVICE_IO_USED_BIT_MASK_OFFSET
.equ ST_MOTOR_STEPPER_BI_TYPE_BIT_MASK_OFFSET		= ST_DEVICE_IO_TYPE_BIT_MASK_OFFSET
; st_motor_stepper_bi new members
.equ ST_MOTOR_STEPPER_BI_DIRECTION_OFFSET		= SZ_ST_DEVICE_IO
.equ ST_MOTOR_STEPPER_BI_WAIT_STEP_OFFSET		= SZ_ST_DEVICE_IO + 0x01
.equ ST_MOTOR_STEPPER_BI_CURRENT_WAIT_STEP_OFFSET	= SZ_ST_DEVICE_IO + 0x02
.equ ST_MOTOR_STEPPER_BI_CURRENT_STEP_OFFSET		= SZ_ST_DEVICE_IO + 0x03

; enum MOTOR_STEPPER_BI_TETRADE_MASK
.equ MOTOR_STEPPER_BI_TETRADE_MASK_LOW			= TETRADE_MASK_LOW
.equ MOTOR_STEPPER_BI_TETRADE_MASK_HIGH			= TETRADE_MASK_HIGH

; enum MOTOR_STEPPER_BI_DIRECTION
.equ MOTOR_STEPPER_BI_DIRECTION_CCW			= DIRECTION_THREAD_CCW
.equ MOTOR_STEPPER_BI_DIRECTION_CW			= DIRECTION_THREAD_CW

; enum MOTOR_STEPPER_BI_STEP
.equ MOTOR_STEPPER_BI_WAIT_STEP_1X			= 0x01
.equ MOTOR_STEPPER_BI_WAIT_STEP_2X			= 0x02
.equ MOTOR_STEPPER_BI_WAIT_STEP_4X			= 0x04
.equ MOTOR_STEPPER_BI_WAIT_STEP_8X			= 0x08
.equ MOTOR_STEPPER_BI_WAIT_STEP_16X			= 0x10
.equ MOTOR_STEPPER_BI_WAIT_STEP_32X			= 0x20
.equ MOTOR_STEPPER_BI_WAIT_STEP_64X			= 0x40
.equ MOTOR_STEPPER_BI_WAIT_STEP_128X			= 0x80

; const
.equ MOTOR_STEPPER_BI_CURRENT_WAIT_STEP_DEFAULT 	= 0x00

; enum MOTOR_STEPPER_BI_CURRENT_STEP
.equ MOTOR_STEPPER_BI_CURRENT_STEP_STOP			= 0x00
.equ MOTOR_STEPPER_BI_CURRENT_STEP_INFINITY		= 0x80; -1
; const
.equ MOTOR_STEPPER_BI_CURRENT_STEP_DEFAULT		= MOTOR_STEPPER_BI_CURRENT_STEP_STOP