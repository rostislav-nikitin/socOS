; struct st_out_byte size: derived from st_device_io
.equ SZ_ST_OUT_BYTE				= SZ_ST_DEVICE_IO
; struct st_out_byte
.equ ST_OUT_BYTE_DDRX_ADDRESS_OFFSET 		= ST_DEVICE_IO_DDRX_ADDRESS_OFFSET
.equ ST_OUT_BYTE_PORTX_ADDRESS_OFFSET		= ST_DEVICE_IO_PORTX_ADDRESS_OFFSET
.equ ST_OUT_BYTE_USED_BYTE_MASK_OFFSET		= ST_DEVICE_IO_USED_BIT_MASK_OFFSET

.equ OUT_BYTE_STATE_OFF				= 0b00000000
.equ OUT_BYTE_STATE_ON 				= 0b11111111