; st_eeprom size
.equ SZ_ST_EEPROM 			= 0x04
; st_eeprom:st_device
.equ ST_EEPROM_DATA_L			= 0x00
.equ ST_EEPROM_DATA_H			= 0x01
.equ ST_EEPROM_ON_READY_HANDLER		= 0x02

; enum EEPROM_STATE
.equ EEPROM_STATE_OK			= 0x00
.equ EEPROM_STATE_BUSY			= 0x01