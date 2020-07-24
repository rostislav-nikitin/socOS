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

; st_eeprom size
.equ SZ_ST_EEPROM 			= SZ_ST_DEVICE + 0x04
; st_eeprom:st_device
.equ ST_EEPROM_DATA_L			= SZ_ST_DEVICE + 0x00
.equ ST_EEPROM_DATA_H			= SZ_ST_DEVICE + 0x01
.equ ST_EEPROM_ON_READY_HANDLER		= SZ_ST_DEVICE + 0x02

; enum EEPROM_STATE
.equ EEPROM_STATE_OK			= 0x00
.equ EEPROM_STATE_BUSY			= 0x01