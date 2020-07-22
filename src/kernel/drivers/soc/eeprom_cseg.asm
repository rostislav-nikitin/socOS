;.include "m8def.inc"
.macro m_eeprom_init
	; parameters:
	;	@0	int	mcu_clock
	;	@1	word	on_ready_handler
	m_save_Z_registers

	ldi ZL, low(eeprom_static_instance)
	ldi ZH, high(eeprom_static_instance)
	ldi YL, low(@0)
	ldi YH, high(@0)
	;
	rcall eeprom_init
	;
	m_restore_Z_registers
.endm

eeprom_init:
	m_save_r23_registers

	ldi r23, ST_EEPROM_ON_READY_HANDLER
	rcall set_struct_word

	m_restore_r23_registers

	ret

.macro m_eeprom_interrupts_enable
	rcall eeprom_interrupts_enable
.endm

eeprom_interrupts_enable:
	sbi EECR, EERIE

	ret

.macro m_eeprom_interrupts_disable
	rcall eeprom_interrupts_disable
.endm

eeprom_interrupts_disable:
	cbi EECR, EERIE

	ret


.macro m_eeprom_store_sync
	; parameters
	;	@0	word	EEPROM address to store to
	;	@1	byte	data to store to the EEPROM
	m_save_r23_Z_registers

	ldi ZL, low(@0)
	ldi ZH, high(@0)
	ldi r23, @1

	rcall eeprom_store_sync

	m_restore_r23_Z_registers
.endm
eeprom_store_sync:
	; wait ready (w/o disabling interrupt)
	rcall eeprom_wait_ready_sync
	; disable interrupts
	cli
	; wait ready (w disabling interrupts)
	rcall eeprom_wait_ready_sync
	; prepare EEPROM address and data to store
	out EEARL, ZL
	out EEARH, ZH
	out EEDR, r23
	; store to the EEPROM
	sbi EECR, EEMWE
	sbi EECR, EEWE
	; enable interrupts
	sei

	ret

.macro m_eeprom_load_sync
	; parameters
	;	@0	word		EEPROM address
	; returns:
	;	@1	register	data from the EEPROM
	m_save_r23_Z_registers

	ldi ZL, low(@0)
	ldi ZH, high(@0)

	rcall eeprom_load_sync

	mov @1, r23

	m_restore_r23_Z_registers
.endm
eeprom_load_sync:
	cli
	rcall eeprom_wait_ready_sync
	; get load parameters (addr)
	out EEARL, ZL
	out EEARH, ZH
	
	; load from the EEPROM
	sbi EECR, EERE
	in r23, EEDR
	sei

	ret

.macro m_eeprom_try_store_sync
	; parameters:
	;	@0	word	EEPROM address to store to
	;	@1	byte	value to store to the EEPROM
	; results:
	;	@2	register to store result status
	m_save_r23_Z_registers

	ldi ZL, low(@0)
	ldi ZH, high(@0)
	ldi r23, @1

	rcall eeprom_try_store_sync

	mov @2, r23

	m_restore_r23_Z_registers
.endm

eeprom_try_store_sync:
	; parameters:
	;	Z	word	EEPROM addres to load from
	;	r23	byte	value to store to the EEPROM
	; returns:
	;	r23 byte	status
	m_save_r16_registers

	in r16, EECR
	sbrc r16, EERE
	rjmp eeprom_try_store_sync_busy

	cli
	out EEARL, ZL
	out EEARH, ZH
	out EEDR, r23

	sbi EECR, EEMWE
	sbi EECR, EEWE
	sei

	eeprom_try_store_sync_ok:
		ldi r23, EEPROM_STATE_OK
		rjmp eeprom_try_store_sync_end
	eeprom_try_store_sync_busy:
		ldi r23, EEPROM_STATE_BUSY
		rjmp eeprom_try_store_sync_end
	eeprom_try_store_sync_end:

	m_restore_r16_registers

	ret

.macro m_eeprom_try_load_sync
	; parameters:
	;	@0	word		EEPROM address to load value from
	; results:
	;	@1	register	the value loaded from the EEPROM
	;	@2	register 	status
	m_save_r22_r23_Z_registers

	ldi ZL, low(@0)
	ldi ZH, high(@0)

	rcall eeprom_try_load_sync

	mov @1, r23
	mov @2, r22

	m_restore_r22_r23_Z_registers
.endm

eeprom_try_load_sync:
	; parameters:
	;	Z	word	EEPROM addres to load from
	; returns:
	;	r23	byte	value loaded from the EEPROM
	;	r22 byte	status
	m_save_r16_registers

	in r16, EECR
	sbrc r16, EERE
	rjmp eeprom_try_load_sync_busy

	cli
	out EEARL, ZL
	out EEARH, ZH

	sbi EECR, EERE
	in r23, EEDR
	sei

	eeprom_try_load_sync_ok:
		ldi r22, EEPROM_STATE_OK
		rjmp eeprom_try_load_sync_end
	eeprom_try_load_sync_busy:
		ldi r22, EEPROM_STATE_BUSY
		rjmp eeprom_try_load_sync_end
	eeprom_try_load_sync_end:

	m_restore_r16_registers

	ret

eeprom_wait_ready_sync:
	eeprom_wait_ready_sync_wait_loop:
		sbic EECR, EEWE
		rjmp eeprom_wait_ready_sync_wait_loop

	ret

eeprom_ready_handler:
	m_save_r23_Z_registers

	ldi ZL, low(eeprom_static_instance)
	ldi ZH, high(eeprom_static_instance)
	ldi r23, ST_EEPROM_ON_READY_HANDLER

	rcall st_device_raise_event

	m_restore_r23_Z_registers

	reti