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

; stuct st_am2302_data size
.equ SZ_ST_AM2302_DATA				= 0x05

; st_am2302 size
.equ SZ_ST_AM2302				= SZ_ST_DEVICE_IO + 0x02 + SZ_ST_AM2302_DATA + 0x02
; st_am2302:st_device_io inherited members
.equ ST_AM2302_DDRX_ADDRESS_OFFSET              = ST_DEVICE_IO_DDRX_ADDRESS_OFFSET
.equ ST_AM2302_PINX_ADDRESS_OFFSET 		= ST_DEVICE_IO_PINX_ADDRESS_OFFSET
.equ ST_AM2302_PORTX_ADDRESS_OFFSET 		= ST_DEVICE_IO_PORTX_ADDRESS_OFFSET
.equ ST_AM2302_USED_BIT_MASK_OFFSET		= ST_DEVICE_IO_USED_BIT_MASK_OFFSET
.equ ST_AM2302_TYPE_BIT_MASK_OFFSET		= ST_DEVICE_IO_TYPE_BIT_MASK_OFFSET
.equ ST_AM2302_STATE				= SZ_ST_DEVICE_IO
.equ ST_AM2302_RESULT_STATE			= SZ_ST_DEVICE_IO + 0x01
;; st_am2302 new members
.equ ST_AM2302_DATA				= SZ_ST_DEVICE_IO + 0x02
.equ ST_AM2302_DATA_HUMIDITY_HIGH		= SZ_ST_DEVICE_IO + 0x02
.equ ST_AM2302_DATA_HUMIDITY_LOW		= SZ_ST_DEVICE_IO + 0x03
.equ ST_AM2302_DATA_TEMPERATURE_HIGH		= SZ_ST_DEVICE_IO + 0x04
.equ ST_AM2302_DATA_TEMPERATURE_LOW		= SZ_ST_DEVICE_IO + 0x05
.equ ST_AM2302_DATA_CHECKSUM			= SZ_ST_DEVICE_IO + 0x06
.equ ST_AM2302_ON_COMPLETED_HANDLER		= SZ_ST_DEVICE_IO + 0x02 + SZ_ST_AM2302_DATA

; enum ST_AM2302_STATE
.equ ST_AM2302_STATE_NOT_STARTED		= 0x01
.equ ST_AM2302_STATE_IN_PROGRESS		= 0x02
.equ ST_AM2302_STATE_COMPLETED			= 0x03

;enum ST_AM2302_RESULT_STATE
.equ ST_AM2302_RESULT_STATE_OK					= 0x00
.equ ST_AM2302_RESULT_STATE_ERROR_INIT_RESPONSE_LOW_REQUIRED	= 0x01
.equ ST_AM2302_RESULT_STATE_ERROR_INIT_RESPONSE_HIGH_REQUIRED	= 0x02
.equ ST_AM2302_RESULT_STATE_ERROR_DATA_TIMEOUT			= 0x03
.equ ST_AM2302_RESULT_STATE_ERROR_DATA_CHECKSUM			= 0x04