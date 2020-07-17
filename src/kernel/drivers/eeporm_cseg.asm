;.include "m8def.inc"
.macro m_eeprom_init
	; parameters:
	;	@0	int	mcu_clock
	;	@1	word	on_ready_handler
	m_save_Z_registers

	ldi ZL, low(eeprom_static_instance)
	ldi ZH, high(eeprom_static_instance)
	ldi YL, low(@1)
	ldi YH, high(@1)
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
	rcall eeprom_wait_ready_sync
	; get load parameters (addr)
	out EEARL, ZL
	out EEARH, ZH
	
	; load from the EEPROM
	sbi EECR, EERE
	in r23, EEDR

	ret

eepom_try_store:
	m_save_r16_registers

	in r16, EECR
	sbrs r16, EERE
	rjmp eepom_try_store_busy

	cli
	out EEARL, ZL
	out EEARH, ZH
	out EEDR, r23

	sbi EECR, EEMWE
	sbi EECR, EEWE
	
	sei

        eepom_try_store_ok:
		ld r23, EEPROM_STATE_OK
		rjmp eepom_try_store_end
	eepom_try_store_busy:
		ld r23, EEPROM_STATE_BUSY
		rjmp eepom_try_store_end
	eepom_try_store_end:

	ret
eeprom_try_load:
	m_save_r16_registers

	in r16, EECR
	sbrs r16, EERE
	rjmp eeprom_try_load_busy

	cli
	out EEARL, ZL
	out EEARH, ZH

	sbi EECR, EERE
	in r23, EEDR
	sei

        eeprom_try_load_ok:
		ld r23, EEPROM_STATE_OK
		rjmp eeprom_try_load_end
	eeprom_try_load_busy:
		ld r23, EEPROM_STATE_BUSY
		rjmp eeprom_try_load_end
	eeprom_try_load_end:

	ret

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