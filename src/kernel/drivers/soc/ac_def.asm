; Analog Comparator
; st_ac size
.equ SZ_ST_AC 				= 0x05
; st_ac:st_device
.equ ST_AC_INPUT_NEGATIVE		= 0x00
.equ ST_AC_INPUT_POSITIVE		= 0x01
.equ ST_AC_INTERRPUT_MODE_ARISE		= 0x02
.equ ST_AC_ON_COMPLETED_HANDLER_OFFSET	= 0x03

; enum AC_POWER
.equ AC_POWER_DISABLED			= 0x00 ; ACD = 0x01
.equ AC_POWER_ENABLED			= 0x01 ; ACD = 0x00

; enum AC_INPUT_NEGATIVE
.equ AC_INPUT_NEGATIVE_A_IN1		= 0xff ; ACME disabled ; PIND7; DDRD as IN
.equ AC_INPUT_NEGATIVE_PINC0		= 0x00 ; ACME enabled ; ADME disabled ; DDRC as IN
.equ AC_INPUT_NEGATIVE_PINC1		= 0x01 ; ACME enabled ; ADME disabled ; DDRC as IN
.equ AC_INPUT_NEGATIVE_PINC2		= 0x02 ; ACME enabled ; ADME disabled ; DDRC as IN
.equ AC_INPUT_NEGATIVE_PINC3		= 0x03 ; ACME enabled ; ADME disabled ; DDRC as IN
.equ AC_INPUT_NEGATIVE_PINC4		= 0x04 ; ACME enabled ; ADME disabled ; DDRC as IN
.equ AC_INPUT_NEGATIVE_PINC5		= 0x05 ; ACME enabled ; ADME disabled ; DDRC as IN
.equ AC_INPUT_NEGATIVE_PINC6		= 0x06 ; ACME enabled ; ADME disabled ; DDRC as IN
.equ AC_INPUT_NEGATIVE_PINC7		= 0x07 ; ACME enabled ; ADME disabled ; DDRC as IN

; enum AC_INPUT_POSITIVE
.equ AC_INPUT_POSITIVE_A_IN0		= 0x00 ; ACBG = 0x00	PIND6; DDRD as IN
.equ AC_INPUT_POSITIVE_VREF_1_23_V	= 0x01 ; ACBG = 0x01

; enum AC_INTERRPUT_MODE_ARISE
.equ AC_INTERRPUT_MODE_ARISE_BOTH_FRONTS	= 0b00 ; raising/falling front
.equ AC_INTERRPUT_MODE_ASISE_FORBIDDEN		= 0b01 ; raising/falling front
.equ AC_INTERRPUT_MODE_ARISE_FALLING_FRONT	= 0b10 ; raising/falling front
.equ AC_INTERRPUT_MODE_ARISE_RAISING_FRONT	= 0b11 ; raising/falling front

; enum AC_OUTPUT_VALUE
.equ AC_OUTPUT_VALUE_FALSE			= FALSE
.equ AC_OUTPUT_VALUE_TRUE			= TRUE


; ACO - get_value
; ACI - interrupt raised
; ACIE - enable/interrupt
; ACIC - enable TIMER1 capture timer1_capture_enable/timer1_capture_disable