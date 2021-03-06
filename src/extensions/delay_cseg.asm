; extensions
.macro m_delay_short
	; parameters:
	;	@	3 x bytes int	n
	; description:
	;	delay time = [3 + 7 + 5 + (5 x n)] clock cycles
	; 	delay = 3 clock cycles
	ldi r23, low(@0)
	ldi r22, high(@0)
	ldi r21, byte3(@0)

	rcall delay_short

.endm

delay_short:
	; parameters:
	;	r23	byte	low(delay time)
	;	r22	byte	high(delay time)
	;	r21	byte	byte3(delay time)
	; description:
	; 	total loop length is [7 + 5 + (5 x n)] clock cycles
	delay_short_loop:
		subi	r23, 1
		sbci	r22, 0
		sbci	r21, 0
		brcc	delay_short_loop

	ret


.macro m_delay
	; parameters:
	;	@0	3 x bytes	delay time
	; description:
	; 	((cycles * 5) + 15|16|17? + 4) to delay
	; save registers
	push r16
	; prepare parameters
	ldi r16, low(@0)
	push r16
	ldi r16, high(@0)
	push r16
	ldi r16, byte3(@0)
	push r16
	; call delay
	rcall delay
	; release stack from parameters
	pop r16
	pop r16
	pop r16
	; restore registers
	pop r16

.endm

delay:
	; parameters (through stack):
	; delay (3 bytes):
	;	byte3
	;	high
	;	low
	; description:
	; 	((delay * 5) + 20 + 4) cycles
	; save registers
	push r19
	push r20
	push r21
	push r30
	push r31

	; prepare local variables
	in r30, SPL
	in r31, SPH
	ldi r19, 0x08 ; 5 pushed registers + 2 calling address + 1 offset
	add r30, r19 
	ldi r19, 0x00
	adc r31, r19

	ld r21, Z+
	ld r20, Z+
	ld r19, Z

	; delay loop
	delay_loop:
		subi	r19, 1
		sbci	r20, 0
		sbci	r21, 0
		brcc	delay_loop

	; restore registers
	pop r31
	pop r30
	pop r21
	pop r20
	pop r19

	ret