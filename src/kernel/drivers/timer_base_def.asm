; struct st_timer size
.equ SZ_ST_TIMER_BASE 						= 8
.equ ST_TIMER_BASE_COUNTER_CONTROL_REGISTER_ADDRESS_OFFSET	= 0
.equ ST_TIMER_BASE_COUNTER_REGISTER_ADDRESS_OFFSET		= 2
.equ ST_TIMER_BASE_DIVIDER_BIT_MASK_OFFSET			= 4
.equ ST_TIMER_BASE_OVERFLOW_INTERRUPT_BIT_MASK_OFFSET		= 5
.equ ST_TIMER_BASE_OVERFLOW_HANDLER_OFFSET			= 7

; constants
.equ TIMER_DIVIDER_CLOCK_DISABLED		= 0x00
.equ TIMER_DIVIDER_1X				= 0x01
.equ TIMER_DIVIDER_8X				= 0x02
.equ TIMER_DIVIDER_64X				= 0x03
.equ TIMER_DIVIDER_256X				= 0x04
.equ TIMER_DIVIDER_1024X			= 0x05
.equ TIMER_DIVIDER_EXTERNAL_FALLING		= 0x06
.equ TIMER_DIVIDER_EXTERNAL_RAISING		= 0x07