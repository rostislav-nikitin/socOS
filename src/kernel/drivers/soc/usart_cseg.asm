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

;.include "kernel/kernel_cseg.asm"
;.include "kernel/drivers/device_cseg.asm"

.ifndef MCU_CLOCK_DEFAULT
	.equ MCU_CLOCK_DEFAULT = 1000000
.endif

.ifndef USART_MCU_CLOCK_DEFALT
	.equ USART_MCU_CLOCK_DEFALT = MCU_CLOCK_DEFAULT
.endif

.ifndef USART_SPEED_DEFAULT
	.equ USART_SPEED_DEFAULT = 9600
.endif

/*.ifndef USART_CLOCK_DIVIDER
	.equ USART_CLOCK_DIVIDER =  ((USART_MCU_CLOCK_DEFALT / (USART_SPEED_DEFAULT * 8) - 1))
.endif*/

.equ DEFAULT = 0x00
.equ BYTE_ZERO = 0x00
.equ MASK_EMPTY = BYTE_ZERO


.macro m_usart_init
	; parameters:
	;	@0	word	mcu_clock
	;	@1	word	usart_speed
	;	@2	word	[on_rxc_handler]
	;	@3	word	[on_udre_handler]
	;	@4	word	[on_txc_handler]
	m_save_r22_r23_r24_r25_X_Y_Z_registers
	;
	.if @0 != 0
		.equ USART_MCU_CLOCK = @0
	.else
		.equ USART_MCU_CLOCK = USART_MCU_CLOCK_DEFALT
	.endif

	.if @1 != 0
		.equ USART_SPEED = @1
	.else
		.equ USART_SPEED = USART_SPEED_DEFAULT
	.endif

	.equ USART_CLOCK_DIVIDER = ((USART_MCU_CLOCK / (USART_SPEED * 8) - 1))

	;m_device_io_init usart_static_instance, POINTER_NULL, POINTER_NULL, POINTER_NULL, MASK_EMPTY, MASK_EMPTY
	m_device_init

	;
	ldi ZL, low(usart_static_instance)
	ldi ZH, high(usart_static_instance)
	ldi YL, low(@2)
	ldi YH, high(@2)
	ldi XL, low(@3)
	ldi XH, high(@3)
	ldi r24, low(@4)
	ldi r25, high(@4)

	ldi r23, low(USART_CLOCK_DIVIDER)
	ldi r22, high(USART_CLOCK_DIVIDER)
	;
	rcall usart_init
	;
	m_restore_r22_r23_r24_r25_X_Y_Z_registers
.endm

usart_init:
	; parameters:
	;	Z	word	[st_usart]
	;	Y	word	[on_rxc_handler]
	;	X	word	[on_udre_handler]
	;	r24,r25	word	[on_txc_handler]
	;	r23	byte	USART_CLOCK_DIVIDER LOW
	;	r22	byte	USART_CLOCK_DIVIDER HIGH
	m_save_r16_Y_registers

	push r23

	ldi r23, ST_USART_ON_RXC_HANDLER_OFFSET
	rcall set_struct_word

	ldi r23, ST_USART_ON_UDRE_HANDLER_OFFSET
	mov YL, XL
	mov YH, XH
	rcall set_struct_word

	ldi r23, ST_USART_ON_TXC_HANDLER_OFFSET
	mov YL, r24
	mov YH, r25
	rcall set_struct_word

	pop r23

	rcall usart_init_ports

	m_restore_r16_Y_registers

	ret

usart_init_ports:
	; parameters:
	;	r23	byte	USART_CLOCK_DIVIDER LOW
	;	r22	byte	USART_CLOCK_DIVIDER HIGH
	; init divider
	m_save_r16_registers
	;
	out UBRRL, r23
	out UBRRH, r22
	;init U2X
	ldi r16, (1 << U2X)
	out UCSRA, r16
	;enable recive/transmit data: RX/TX, and interrrups: RXCIE, TXCIE, UDRIE and
	ldi r16, (1 << RXEN) | (1 << TXEN) | (1 << RXCIE) | (1 << TXCIE) | (0 << UDRIE)
	out UCSRB, r16
	;set async moce UMSEL = 0 data frame length to 8 bits: UCSZ = 11
	ldi r16, (1 << URSEL) | (1 << UCSZ0) | (1 << UCSZ1) 
	out UCSRC, r16
	;
	m_restore_r16_registers

	ret

.macro m_usart_udre_enable
	rcall usart_udre_enable
.endm

usart_udre_enable:
	sbi UCSRB, UDRIE
	ret

.macro m_usart_udre_disable
	rcall usart_udre_disable
.endm

usart_udre_disable:
	cbi UCSRB, UDRIE
	ret

usart_rxc_handler:
	m_save_r16_r23_Y_Z_SREG_registers

	ldi ZL, low(usart_static_instance)
	ldi ZH, high(usart_static_instance)

	ldi r23, ST_USART_ON_RXC_HANDLER_OFFSET
	in YL, UDR
	rcall device_raise_event

	usart_rxc_handler_end:
		m_restore_r16_r23_Y_Z_SREG_registers

	reti

usart_udre_handler:
	m_save_r16_r23_Y_Z_SREG_registers

	ldi ZL, low(usart_static_instance)
	ldi ZH, high(usart_static_instance)

	ldi r23, ST_USART_ON_UDRE_HANDLER_OFFSET
	rcall device_raise_event
	out UDR, YL

	usart_udre_handler_end:
		m_restore_r16_r23_Y_Z_SREG_registers

	reti

usart_txc_handler:
	.ifdef HALF_DUPLEX
		; enable UDRIE
		;sbi UCSRB, UDRIE
	.endif

	reti
