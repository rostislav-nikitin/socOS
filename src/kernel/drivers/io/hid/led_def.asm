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

; st_led size
.equ SZ_ST_LED					= SZ_ST_OUT_BIT
; st_led:st_out_bit inherited members
.equ ST_LED_DDRX_ADDRESS_OFFSET 		= ST_OUT_BIT_DDRX_ADDRESS_OFFSET
.equ ST_LED_PORTX_ADDRESS_OFFSET		= ST_OUT_BIT_PORTX_ADDRESS_OFFSET
.equ ST_LED_USED_BIT_MASK_OFFSET		= ST_OUT_BIT_USED_BIT_MASK_OFFSET

; enum LED_STATE
.equ LED_STATE_OFF				= OUT_BIT_STATE_OFF
.equ LED_STATE_ON 				= OUT_BIT_STATE_ON