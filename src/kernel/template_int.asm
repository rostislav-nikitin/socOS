;0x00 rjmp RESET ; Reset Handler
;0x01 rjmp EXT_INT0 ; IRQ0 Handler
;0x02 rjmp EXT_INT1 ; IRQ1 Handler
;0x03 rjmp TIM2_COMP ; Timer2 Compare Handler
;0x04 rjmp TIM2_OVF ; Timer2 Overflow Handler
;0x05 rjmp TIM1_CAPT ; Timer1 Capture Handler
;0x06 rjmp TIM1_COMPA ; Timer1 CompareA Handler
;0x07 rjmp TIM1_COMPB ; Timer1 CompareB Handler
;0x08 rjmp TIM1_OVF ; Timer1 Overflow Handler
;0x09 rjmp TIM0_OVF ; Timer0 Overflow Handler
;0x0a rjmp SPI_STC ; SPI Transfer Complete Handler
;0x0b rjmp USART_RXC ; USART RX Complete Handler
;0x0c rjmp USART_UDRE ; UDR Empty Handler
;0x0d rjmp USART_TXC ; USART TX Complete Handler
;0x0e rjmp ADC ; ADC Conversion Complete Handler
;0x0f rjmp EE_RDY ; EEPROM Ready Handler
;0x10 rjmp ANA_COMP ; Analog Comparator Handler
;0x11 rjmp TWSI ; Two-wire Serial Interface Handler
;0x12 rjmp SPM_RDY ; Store Program Memory Ready Handler