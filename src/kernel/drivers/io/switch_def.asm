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
;.include "kernel/drivers/io/out_bit_def.asm"

; st_switch size
.equ SZ_ST_SWITCH				= SZ_ST_OUT_BIT
; st_switch:st_out_bit
.equ ST_SWITCH_DDRX_ADDRESS_OFFSET 		= ST_OUT_BIT_DDRX_ADDRESS_OFFSET
.equ ST_SWITCH_PORTX_ADDRESS_OFFSET		= ST_OUT_BIT_PORTX_ADDRESS_OFFSET
.equ ST_SWITCH_USED_BIT_MASK_OFFSET		= ST_OUT_BIT_USED_BIT_MASK_OFFSET

; enum SWITCH_STATE
.equ SWITCH_STATE_OFF				= OUT_BIT_STATE_OFF
.equ SWITCH_STATE_ON 				= OUT_BIT_STATE_ON