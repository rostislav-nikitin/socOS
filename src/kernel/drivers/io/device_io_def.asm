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

; st_device_io size
.equ SZ_ST_DEVICE_IO				= SZ_ST_DEVICE + 0x08
; st_device_io:st_device
.equ ST_DEVICE_IO_DDRX_ADDRESS_OFFSET		= SZ_ST_DEVICE + 0x00
.equ ST_DEVICE_IO_PINX_ADDRESS_OFFSET		= SZ_ST_DEVICE + 0x02
.equ ST_DEVICE_IO_PORTX_ADDRESS_OFFSET		= SZ_ST_DEVICE + 0x04
.equ ST_DEVICE_IO_USED_BIT_MASK_OFFSET		= SZ_ST_DEVICE + 0x06
.equ ST_DEVICE_IO_TYPE_BIT_MASK_OFFSET		= SZ_ST_DEVICE + 0x07