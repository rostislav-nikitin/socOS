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

;.include "kernel/kernel_cseg.asm"
;.include "kernel/drivers/device_cseg.asm"
;.include "kernel/drivers/io/device_io_cseg.asm"
;.include "kernel/drivers/io/out_bit_cseg.asm"

; usage:
; .dseg
;   led1: .BYTE SZ_ST_LED
;   ...
; .cseg
;   m_led_init led1, DDRB, PORTB, (1 << BIT1)
;   ...
;   m_led_set led1, LED_STATE_ON
;   m_led_set led1, LED_STATE_OFF
;   m_led_on led1
;   m_led_off led1
;   m_led_toggle led1
;   m_led_get led1

.macro m_led_init
	; parameters:
	;	@0	word [st_led]
	;	@1	word [DDRx]
	;	@2	word [PORTx]
	;	@3	word USED_BIT_MASK

	m_out_bit_init @0, @1, @2, @3
.endm

led_init:
	; parameters:
	;	Z	word	[st_led]
	; currently no additional logic
	ret

.macro m_led_set
	; parameters:
	;	@0	word	[st_led]
	;	@1	byte 	LED_STATE
	m_out_bit_set @0, @1
.endm

.macro  m_led_on
	; parameters:
	;	@0 	word	[st_led]
	m_led_set @0, LED_STATE_ON
.endm

.macro  m_led_off
	; parameters:
	;	@0 	word	[st_led]
	m_led_set @0, LED_STATE_OFF
.endm

led_set:
	; parameters:
	;	word	[st_led]
	;	byte	LED_STATE
	rcall out_bit_set

	ret

.macro m_led_get
	; parameters:
	;	@0	word	[st_led]
	; returns:
	;	@1	reg	LED_STATE
	m_out_bit_get @0, @1
.endm

led_get:
	; parameters:
	;	Z	word	[st_led]
	; returns:
	;	r23	byte	LED_STATE
	rcall out_bit_get

	ret

.macro m_led_toggle
	; parameters:
	; 	@0	word	[st_led]
	m_out_bit_toggle @0
.endm

led_toggle:
	; parameters:
	;	Z	word	[st_led]
	rcall led_toggle

	ret
