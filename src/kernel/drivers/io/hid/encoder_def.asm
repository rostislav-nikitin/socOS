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

;.include "kernel/kernel_cseg.asm"
;.include "kernel/drivers/device_cseg.asm"
;.include "kernel/drivers/io/device_io_cseg.asm"

; st_encoder size
.equ SZ_ST_ENCODER				= SZ_ST_DEVICE_IO + 0x05
; st_encoder:st_device_io inherited members
.equ ST_ENCODER_DDRX_ADDRESS_OFFSET             = ST_DEVICE_IO_DDRX_ADDRESS_OFFSET
.equ ST_ENCODER_PINX_ADDRESS_OFFSET 		= ST_DEVICE_IO_PINX_ADDRESS_OFFSET
.equ ST_ENCODER_PORTX_ADDRESS_OFFSET 		= ST_DEVICE_IO_PORTX_ADDRESS_OFFSET
.equ ST_ENCODER_USED_BIT_MASK_OFFSET		= ST_DEVICE_IO_USED_BIT_MASK_OFFSET
.equ ST_ENCODER_TYPE_BIT_MASK_OFFSET		= ST_DEVICE_IO_TYPE_BIT_MASK_OFFSET
; st_encoder new members
.equ ST_ENCODER_BIT1_MASK_OFFSET 		= SZ_ST_DEVICE_IO
.equ ST_ENCODER_BIT2_MASK_OFFSET		= SZ_ST_DEVICE_IO + 0x01
.equ ST_ENCODER_DIRECTION 			= SZ_ST_DEVICE_IO + 0x02
.equ ST_ENCODER_ON_TURN_HANDLER_OFFSET		= SZ_ST_DEVICE_IO + 0x03

; enum ENCODER_DIRECTION
.equ ENCODER_DIRECTION_NONE			= 0x03
;.equ ENCODER_DIRECTION_FORBIDDEN		= 0x00
.equ ENCODER_DIRECTION_CCW			= DIRECTION_THREAD_CCW
.equ ENCODER_DIRECTION_CW			= DIRECTION_THREAD_CW