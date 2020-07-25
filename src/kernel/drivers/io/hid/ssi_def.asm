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
;.include "kernel/drivers/io/out_byte_def.asm"

; st_ssi size
.equ SZ_ST_SSI					= SZ_ST_OUT_BYTE + 0x07
; st_ssi:st_out_byte inherited members
.equ ST_SSI_DDRX_ADDRESS_OFFSET 		= ST_OUT_BYTE_DDRX_ADDRESS_OFFSET
.equ ST_SSI_PORTX_ADDRESS_OFFSET		= ST_OUT_BYTE_PORTX_ADDRESS_OFFSET
.equ ST_SSI_USED_SSI_MASK_OFFSET		= ST_OUT_BYTE_USED_BIT_MASK_OFFSET
; st_ssi new members
.equ ST_SSI_CONNECTION_TYPE			= SZ_ST_OUT_BYTE
.equ ST_SSI_STATE_OFFSET			= SZ_ST_OUT_BYTE + 0x01
.equ ST_SSI_SHOWN_OFFSET			= SZ_ST_OUT_BYTE + 0x02
.equ ST_SSI_SYMBOL_OFFSET			= SZ_ST_OUT_BYTE + 0x03
.equ ST_SSI_FLASH_OFFSET			= SZ_ST_OUT_BYTE + 0x04
.equ ST_SSI_FLASH_TIMEOUT_COUNTER_OFFSET	= SZ_ST_OUT_BYTE + 0x05
.equ ST_SSI_FLASH_STATE_VISIBLE_OFFSET		= SZ_ST_OUT_BYTE + 0x06

; enum SSI_CONNECTION_TYPE
.equ SSI_CONNECTION_TYPE_COMMON_CATHODE		= 0x00
.equ SSI_CONNECTION_TYPE_COMMON_ANODE		= 0x01

; enum SSI_STATE
.equ SSI_STATE_OFF				= 0x00
.equ SSI_STATE_ON 				= 0x01

; enum SSI_SHOWN
.equ SSI_SHOWN_FALSE				= 0x00
.equ SSI_SHOWN_TRUE				= 0x01

; const SSI_SYMBOL
.equ SSI_SYMBOL_NULL				= 0x00

; enum ST_SSI_FLASH
.equ SSI_FLASH_ON				= 0x01
.equ SSI_FLASH_OFF				= 0x00

; enum ST_SSI_FLASH_STATE_VISIBLE
.equ SSI_FLASH_STATE_VISIBLE_FALSE		= 0x00
.equ SSI_FLASH_STATE_VISIBLE_TRUE		= 0x01

; enum SSI_FLASH_TIMEOUT
.equ SSI_FLASH_TIMEOUT				= 0xff
.equ SSI_FLASH_TIMEOUT_FINISHED			= 0x00
