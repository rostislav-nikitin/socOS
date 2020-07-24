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

; st_usart size
.equ SZ_ST_USART 			= SZ_ST_DEVICE + 0x06
; st_usart:st_device
.equ ST_USART_ON_RXC_HANDLER_OFFSET	= SZ_ST_DEVICE + 0x00
.equ ST_USART_ON_UDRE_HANDLER_OFFSET	= SZ_ST_DEVICE + 0x02
.equ ST_USART_ON_TXC_HANDLER_OFFSET	= SZ_ST_DEVICE + 0x04
