.cseg
	.org 0x0b 
	rjmp usart_rxc_handler ; USART RX Complete Handler
	rjmp usart_udre_handler ; UDR Empty Handler
	rjmp usart_txc_handler ; USART TX Complete Handler