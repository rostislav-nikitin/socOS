.cseg
	;.org 0x03
	;rjmp timer2_comp_handler ; timer 2 compared
	;rjmp timer2_ovf_handler ; timer 2 overflow
	;.org 0x05
	;rjmp timer1_capt_handler ; timer 1 compared
	;rjmp timer1_compa_handler ; timer 1 overflow
	;rjmp timer1_compb_handler ; timer 1 overflow
	;rjmp timer1_ovf_handler ; timer 1 overflow
	.org 0x09
	rjmp timer0_ovf_handler ; timer 0 overflow

