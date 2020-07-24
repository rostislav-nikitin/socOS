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

; st_out_byte size
.equ SZ_ST_OUT_BYTE				= SZ_ST_DEVICE_IO
; struct st_out_byte:st_device_io
.equ ST_OUT_BYTE_DDRX_ADDRESS_OFFSET 		= ST_DEVICE_IO_DDRX_ADDRESS_OFFSET
.equ ST_OUT_BYTE_PORTX_ADDRESS_OFFSET		= ST_DEVICE_IO_PORTX_ADDRESS_OFFSET
.equ ST_OUT_BYTE_USED_BIT_MASK_OFFSET		= ST_DEVICE_IO_USED_BIT_MASK_OFFSET

; enum OUT_BYTE_STATE
.equ OUT_BYTE_STATE_OFF				= 0b00000000
.equ OUT_BYTE_STATE_ON 				= 0b11111111