;=======================================================================================================================
;                                                                                                                      ;
; Name:	socOS (System On Chip Operation System)                                                                        ;
; 	Year: 		2020                                                                                           ;
; 	License:	MIT License                                                                                    ;
;                                                                                                                      ;
;=======================================================================================================================

; Require:
;.include "m8def.inc"

;.include "kernel/device_def.asm"

; Analog-Digital Convertor
; st_adc size
.equ SZ_ST_ADC 				= SZ_ST_DEVICE + 0x07
; st_adc:st_device
.equ ST_ADC_INPUT_NEGATIVE		= SZ_ST_DEVICE + 0x00
.equ ST_ADC_INPUT_POSITIVE		= SZ_ST_DEVICE + 0x01
.equ ST_ADC_FREQUENCY			= SZ_ST_DEVICE + 0x02
.equ ST_ADC_OUTPUT_VALUE_ORDER		= SZ_ST_DEVICE + 0x03
.equ ST_ADC_CONTINUOUS_MEASUREMENT	= SZ_ST_DEVICE + 0x04
.equ ST_ADC_ON_COMPLETED_HANDLER_OFFSET	= SZ_ST_DEVICE + 0x05

; enum ADC_INPUT_NEGATIVE(ADMUX: REFS1-REFS0)
.equ ADC_INPUT_NEGATIVE_AREF		= 0x00 ; AREF pin (PIN24)
.equ ADC_INPUT_NEGATIVE_AVCC		= 0x01 ; Vcc
;.equ ADC_INPUT_NEGATIVE_FORBIDDEN	= 0x02 ;
.equ ADC_INPUT_NEGATIVE_REG_2_56V	= 0x03 ; 2.56 V

; enum ADC_INPUT_POSITIVE (ADMUX: MUX3-MUX2-MUX1-MUX0)
.equ ADC_INPUT_POSITIVE_PINC0		= 0x00 ; DDRC as IN, PINC unpull-up;
.equ ADC_INPUT_POSITIVE_PINC1		= 0x01 ; DDRC as IN, PINC unpull-up
.equ ADC_INPUT_POSITIVE_PINC2		= 0x02 ; DDRC as IN, PINC unpull-up
.equ ADC_INPUT_POSITIVE_PINC3		= 0x03 ; DDRC as IN, PINC unpull-up
.equ ADC_INPUT_POSITIVE_PINC4		= 0x04 ; DDRC as IN, PINC unpull-up
.equ ADC_INPUT_POSITIVE_PINC5		= 0x05 ; DDRC as IN, PINC unpull-up
.equ ADC_INPUT_POSITIVE_PINC6		= 0x06 ; DDRC as IN, PINC unpull-up
.equ ADC_INPUT_POSITIVE_PINC7		= 0x07 ; DDRC as IN, PINC unpull-up
.equ ADC_INPUT_VREF_1_23V		= 0x0E ; For calibration (to detect ADC error)
.equ ADC_INPUT_VREF_GND			= 0x0F ; For calibration (to detect AFC error)

; enum ADC_FREQUENCY (ADCSRA: ADSP2-1-0)
.equ ADC_FREQUNCY_X1			= 0x00
.equ ADC_FREQUNCY_X2			= 0x01
.equ ADC_FREQUNCY_X4			= 0x02
.equ ADC_FREQUNCY_X8			= 0x03
.equ ADC_FREQUNCY_X16			= 0x04
.equ ADC_FREQUNCY_X32			= 0x05
.equ ADC_FREQUNCY_X64			= 0x06
.equ ADC_FREQUNCY_X128			= 0x07

; enum ADC_CONTINUOUS_MEASUREMENT (ADCSRA: ADFR)
.equ ADC_CONTINUOUS_MEASUREMENT_TRUE	= TRUE
.equ ADC_CONTINUOUS_MEASUREMENT_FALSE	= FALSE

; enum ADC_OUTPUT_VALUE_ORDER
.equ ADC_OUTPUT_VALUE_ORDER_LOW_FULL	= 0x00
.equ ADC_OUTPUT_VALUE_ORDER_HIGH_FULL	= 0x01

; enum ADC_CONVERSION_COMPLETED
.equ ADC_CONVERSION_COMPLETED_TRUE	= TRUE
.equ ADC_CONVERSION_COMPLETED_FALSE	= FALSE


;ADCSRA:
;	ADEN - enable/disable
;	ADFR - continuous measure
;	ADSC - start convertion (single measure)
;	ADIE - interrupt enable
;ADMUX
;	ADLAR - if 0 then all low at ADCL, 2 high at ADCH. if 1 then all high at ADCH, 2 low at ADCL