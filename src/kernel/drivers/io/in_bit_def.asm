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

; st_in_bit size
.equ SZ_ST_IN_BIT				= SZ_ST_DEVICE_IO
; st_in_bit:st_device_io inherited fields
.equ ST_IN_BIT_DDRX_ADDRESS_OFFSET		= ST_DEVICE_IO_DDRX_ADDRESS_OFFSET
.equ ST_IN_BIT_PINX_ADDRESS_OFFSET 		= ST_DEVICE_IO_PINX_ADDRESS_OFFSET
.equ ST_IN_BIT_PORTX_ADDRESS_OFFSET 		= ST_DEVICE_IO_PORTX_ADDRESS_OFFSET
.equ ST_IN_BIT_USED_BIT_MASK_OFFSET		= ST_DEVICE_IO_USED_BIT_MASK_OFFSET
.equ ST_IN_BIT_TYPE_BIT_MASK_OFFSET		= ST_DEVICE_IO_TYPE_BIT_MASK_OFFSET

; enum IN_BIT_STATE
.equ IN_BIT_STATE_OFF				= 0x00
.equ IN_BIT_STATE_ON				= 0x01