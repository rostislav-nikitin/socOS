; Analog Comparator
; struct st_ac size
.equ SZ_ST_ADC 				= 0x05
; struct st_usart
.equ ST_ADC_INPUT_NEGATIVE		= 0x00
.equ ST_ADC_INPUT_POSITIVE		= 0x01
.equ ST_ADC_INTERRPUT_MODE_ARISE		= 0x02
.equ ST_ADC_ON_CHANGED_HANDLER_OFFSET	= 0x03

.equ ADC_POWER_DISABLED			= 0x00 ; ADCD = 0x01
.equ ADC_POWER_ENABLED			= 0x01 ; ADCD = 0x00

; ADC_INPUT_NEGATIVE (ADCME
.equ ADC_INPUT_NEGATIVE_A_IN1		= 0xff ; ADCME disabled ; PIND7; DDRD as IN
.equ ADC_INPUT_NEGATIVE_PINC0		= 0x00 ; ADCME enabled ; ADME disabled ; DDRC as IN
.equ ADC_INPUT_NEGATIVE_PINC1		= 0x01 ; ADCME enabled ; ADME disabled ; DDRC as IN
.equ ADC_INPUT_NEGATIVE_PINC2		= 0x02 ; ADCME enabled ; ADME disabled ; DDRC as IN
.equ ADC_INPUT_NEGATIVE_PINC3		= 0x03 ; ADCME enabled ; ADME disabled ; DDRC as IN
.equ ADC_INPUT_NEGATIVE_PINC4		= 0x04 ; ADCME enabled ; ADME disabled ; DDRC as IN
.equ ADC_INPUT_NEGATIVE_PINC5		= 0x05 ; ADCME enabled ; ADME disabled ; DDRC as IN
.equ ADC_INPUT_NEGATIVE_PINC6		= 0x06 ; ADCME enabled ; ADME disabled ; DDRC as IN
.equ ADC_INPUT_NEGATIVE_PINC7		= 0x07 ; ADCME enabled ; ADME disabled ; DDRC as IN

; ADC_INPUT_POSITIVE
.equ ADC_INPUT_POSITIVE_A_IN0		= 0x00 ; ADCBG = 0x00	PIND6; DDRD as IN
.equ ADC_INPUT_POSITIVE_VREF_1_23_V	= 0x01 ; ADCBG = 0x01

; ADC_INTERRPUT_MODE_ARISE
.equ ADC_INTERRPUT_MODE_ARISE_BOTH_FRONTS	= 0b00 ; raising/falling front
.equ ADC_INTERRPUT_MODE_ASISE_FORBIDDEN		= 0b01 ; raising/falling front
.equ ADC_INTERRPUT_MODE_ARISE_FALLING_FRONT	= 0b10 ; raising/falling front
.equ ADC_INTERRPUT_MODE_ARISE_RAISING_FRONT	= 0b11 ; raising/falling front
; ADC_OUTPUT_VALUE
.equ ADC_OUTPUT_VALUE_FALSE			= FALSE
.equ ADC_OUTPUT_VALUE_TRUE			= TRUE




; ADCO - get_value
; ADCI - interrupt raised
; ADCIE - enable/interrupt
; ADCIC - enable TIMER1 capture timer1_capture_enable/timer1_capture_disable