; usage:
; .dseg
;   am2302_1: .BYTE SZ_ST_AM2302
;   ...
; .cseg
;   m_am2302_init am2302_1, DDRB, PINB, (1 << BIT1),  am2302_1_on_completed_handler
;   ...
;   am2302_data_get am2302_1

; implementation

.macro m_st_am2302_init
	; input parameters:
	;	@0 	word	[st_am2302]
	;	@1	word	[on_completed_handler]
	; save registers
	m_save_Y_Z_registers

	; set [st_am2302:st_device_io]
	ldi ZL, low(@0)
	ldi ZH, high(@0)
	
	ldi YL, low(@1)
	ldi YH, high(@1)

	rcall st_am2302_init
	; restore registers
	m_restore_Y_Z_registers
.endm

.macro m_am2302_init
	; input parameters:
	;	@0 	word	[st_am2302:st_device_io]
	;	@1	word	[DDRx]
	;	@2	word 	[PINx]
	;	@3	byte 	USED_BIT_MASK
	;	@4	word	[on_completed_handler]
	m_st_device_io_init @0, @1, @2, NULL_POINTER, @3, 0x00
	m_st_am2302_init @0, @4
.endm

st_am2302_init:
	; input parameters:
	;	Z	word	[st_am2302]
	;	Y	word	[on_completed_handler]
	; set X to the [st_am2302] address
	; init st_am2302
	; init st_am2302
	m_save_r23_registers

	ldi r23, ST_AM2302_ON_COMPLETED_HANDLER
	rcall set_struct_word

	rcall am2302_init_ports

	m_restore_r23_registers

	ret

am2302_init_ports:
	m_save_r22_r23_Z_registers
	;
	ldi r23, ST_AM2302_USED_BIT_MASK_OFFSET
	rcall get_struct_byte
	mov r22, r23

	ldi r23, ST_AM2302_DDRX_ADDRESS_OFFSET
	rcall get_struct_word

	ld r23, Z
	com r22
	and r23, r22
	st Z, r23
	;
	m_restore_r22_r23_Z_registers

	ret

.macro m_am2302_data_get
	; parameters:
	;	@0	word	[st_am2302]
	; returns:
	;	@1	byte	status
	m_save_Z_registers

	ldi ZL, low(@0)
	ldi ZH, high(@0)

	rcall am2302_data_get

	mov @1, r23

	m_restore_Z_registers
.endm

am2302_data_get:
	; check current state
	;rcall am2302_data_check_state
	;cpi r23, STATE_IN_PROGRESS
	;breq am2302_data_get_end
	; protocol init packet
	rcall am2302_device_init
	cpi r23, ST_AM2302_RESULT_STATE_OK
	brne am2302_data_get_error
	; protocol data get packet
	rcall am2302_device_data_get

	am2302_data_get_error:
	am2302_data_get_end:
	ret

am2302_data_check_state:
	; Not Implemented
	ret

am2302_device_init:
	m_save_r16_r17_r18_r21_r22_Y_Z_SREG_registers

	ldi r23, ST_AM2302_USED_BIT_MASK_OFFSET
	rcall get_struct_byte
	; set bit mask for set "1"
	mov r16, r23
	; set bit mask for set "0"
	mov r17, r23
	com r17
	; load [PINx]
	push ZL
	push ZH
	ldi r23, ST_AM2302_PINX_ADDRESS_OFFSET
	rcall get_struct_word
	mov YL, ZL
	mov YH, ZH
	pop ZH
	pop ZL
	; load [DDRx]
	ldi r23, ST_AM2302_DDRX_ADDRESS_OFFSET
	rcall get_struct_word

	ld r18, Z
	; set init
	;sbi SDA, SDA_BIT
	or r18, r16
	st Z, r18
	m_delay_short 199		;950 us + 6us = 1001us
	;cbi SDA, SDA_BIT
	and r18, r17
	st Z, r18
	;	delay time = [3 + 7 + 5 + (5 x n)] clock cycles
	m_delay_short 6			;30 us  + 15us = 45us
	; read device response
	;m_delay_short 6
	;sbic SDA_IN, SDA_BIT
	ld r18, Y
	and r18, r16
	brne am2302_device_init_response_error_not_low
	m_delay_short 10		;50 us  + 15us = 65us
	;sbic SDA_IN, SDA_BIT
	ld r18, Y
	and r18, r16
	breq am2302_device_init_response_error_not_high

	am2302_device_init_response_ok:
		ldi r23, ST_AM2302_RESULT_STATE_OK
		rjmp am2302_device_init_end
	am2302_device_init_response_error_not_low:
		; prepare error code
		ldi r23, ST_AM2302_RESULT_STATE_ERROR_INIT_RESPONSE_LOW_REQUIRED
		rjmp am2302_device_init_end
	am2302_device_init_response_error_not_high:
		ldi r23, ST_AM2302_RESULT_STATE_ERROR_INIT_RESPONSE_HIGH_REQUIRED
		rjmp am2302_device_init_end

	am2302_device_init_end:

	m_restore_r16_r17_r18_r21_r22_Y_Z_SREG_registers

	ret

am2302_device_data_get:
	; parameters
	;	Z	[st_am2302]
	; results:
	;	r23	status

	m_save_r16_r22_Y_Z_SREG_registers

	; load used bit mask
	ldi r23, ST_AM2302_USED_BIT_MASK_OFFSET
	rcall get_struct_byte
	mov r22, r23

	; set Y to the [st_am2302::st_am2302_data]
	mov YL, ZL
	mov YH, ZH
	ldi r23, ST_AM2302_DATA
	add YL, r23
	ldi r23, 0x00
	adc YH, r23
	;
	; load [PINx]
	ldi r23, ST_AM2302_PINX_ADDRESS_OFFSET
	rcall get_struct_word

	; set index equal to the st_am2302_sata length
	ldi r16, SZ_ST_AM2302_DATA
	am2302_device_data_get_bytes_read_loop:
		cpi r16, 0x00
		breq am2302_device_data_get_bytes_read_ok
		dec r16
		; save USED
		push r22
		; set r23 to USED
		mov r23, r22
		; read next byte
		rcall am2302_device_io_read_byte
		; store byte to [st_am2302::st_am2302_data]
		st Y+, r22
		; restore USED
		pop r22
		; check status
		cpi r23, ST_AM2302_RESULT_STATE_OK
		brne  am2302_device_data_get_bytes_read_error
		; next loop step
		rjmp am2302_device_data_get_bytes_read_loop

	am2302_device_data_get_bytes_read_error:
		rjmp am2302_device_data_get_bytes_read_end

	am2302_device_data_get_bytes_read_ok:
		ldi r23, ST_AM2302_RESULT_STATE_OK
		rjmp am2302_device_data_get_bytes_read_end

	am2302_device_data_get_bytes_read_end:
		m_restore_r16_r22_Y_Z_SREG_registers

	ret

;[(9 x n) + 8]
.equ AM2302_THREASHOLD_ONE = 0x04; 4 x 9us + 4us = 40us

am2302_device_io_read_byte:
	; parameters
	;	Z	[PINx]
	;	r23	USED_BIT_MASK
	; returns:
	;	r23	byte	status
	;	r22 byte	result

	m_save_r16_r17_Z_SREG_registers
	; move USED to the r22
	mov r22, r23
	; init data register
	ldi r16, 0x00
	; loop index with bits to read count
	ldi r17, 0x08

	am2302_device_io_read_byte_next_bit:
		cpi r17, 0x00
		breq am2302_device_io_read_byte_ok
		dec r17
		lsl r16
		; read start bit (means that after it DEVICE will send next data bit)
		ldi r23, 0x00
		rcall am2302_device_io_read_until_high
		; read next data bit
		ldi r23, 0x00
		rcall am2302_device_io_read_until_low
		cpi r23, AM2302_DEVICE_IO_READ_TIMEOUT
		breq am2302_device_io_read_byte_error
		; detect does recived "0" (high lengh 26us-28us) or "1" (70us) bit
		cpi r23, AM2302_THREASHOLD_ONE
		brlt am2302_device_io_read_byte_zero
		am2302_device_io_read_byte_one:
			; set firs bit to zero (data transmitting such as the high bits are coming first and the low are the last)
			sbr r16, 0x01
			rjmp am2302_device_io_read_byte_next_bit
		am2302_device_io_read_byte_zero:
			rjmp am2302_device_io_read_byte_next_bit

	am2302_device_io_read_byte_error:
		ldi r23, ST_AM2302_RESULT_STATE_ERROR_DATA_TIMEOUT
		mov r22, r16
		rjmp am2302_device_io_read_byte_end
	am2302_device_io_read_byte_ok:
		ldi r23, ST_AM2302_RESULT_STATE_OK
		mov r22, r16
		rjmp am2302_device_io_read_byte_end
	am2302_device_io_read_byte_end:
		m_restore_r16_r17_Z_SREG_registers

	ret

.equ AM2302_DEVICE_IO_READ_TIMEOUT = 0x0E ; [(9 x 0x0E) + 4] = 130us

am2302_device_io_read_until_low:
	; parameters
	;	Z	[PINx]
	;	r23	output value
	;	r22	USED_BIT_MASK
	; returns:
	;	r23	byte
	; description:
	;	time = [(9 x n) + 4], where n is a number of iterations
	push r16

	am2302_device_io_read_until_low_loop:
		inc r23
		ld r16, Z
		and r16, r22
		breq am2302_device_io_read_until_low_end
		cpi r23, AM2302_DEVICE_IO_READ_TIMEOUT
		breq am2302_device_io_read_until_low_end
		rjmp am2302_device_io_read_until_low_loop

	am2302_device_io_read_until_low_end:
	pop r16

	ret

am2302_device_io_read_until_high:
	; parameters
	;	Z	[PINx]
	;	r23	output value
	;	r22	USED_BIT_MASK
	; returns:
	;	r23	byte
	; description:
	;	time = [(9 x n) + 4], where n is a number of iterations
	push r16

	am2302_device_io_read_until_high_loop:
		inc r23
		ld r16, Z
		and r16, r22
		brne am2302_device_io_read_until_high_end
		cpi r23, AM2302_DEVICE_IO_READ_TIMEOUT
		breq am2302_device_io_read_until_high_end
		rjmp am2302_device_io_read_until_high_loop

	am2302_device_io_read_until_high_end:

	pop r16

	ret
