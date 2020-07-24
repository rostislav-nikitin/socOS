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

; st_out_bit size:
.equ SZ_ST_OUT_BIT				= SZ_ST_DEVICE_IO
; struct st_out_bit:st_device_io
.equ ST_OUT_BIT_DDRX_ADDRESS_OFFSET 		= ST_DEVICE_IO_DDRX_ADDRESS_OFFSET
.equ ST_OUT_BIT_PORTX_ADDRESS_OFFSET		= ST_DEVICE_IO_PORTX_ADDRESS_OFFSET
.equ ST_OUT_BIT_USED_BIT_MASK_OFFSET		= ST_DEVICE_IO_USED_BIT_MASK_OFFSET

; enum OUT_BIT_STATE
.equ OUT_BIT_STATE_OFF				= 0x00
.equ OUT_BIT_STATE_ON 				= 0x01