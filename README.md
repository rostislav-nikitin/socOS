![picture](https://github.com/rostislav-nikitin/socOS/blob/master/documentation/images/logo_134x80.png?raw=true)
<!-- # socOS -->
The acronym socOS stands for the **S**ystem **o**n a **C**hip **O**perating **S**ystem.
The main idea of the socOS to provie a hardware abstraction layer of the SoC and connected devices for the firmware developer.
For now supported only the AVR family MCU devices and all the tests was made only at the AVR ATmega8 one.

## How to use it?

1. Clone this repository
2. In the src folder you can find three files:
* app.aps - this is a AVR Studio project file
* app.asm - this is a main assembly language file of the your firmware application
* AvrBuild.bat - this is a Windows batch file to build your firmware application outside of the AVR Studio
3. You can build your own firmware application through:
* Opening an aps.asp in the AVR Studio IDE for writing/debugging/building your own code
* Opening an asp.asm in the your favorite text editor for writing code and then by building app through AvrBuild.bat batch
4. You can follow guidelines below to build your own firmware

## socOS base blocks
The main idea is a reusing of the socOS kernel/drivers/extensions (from this blocks socOS is build) in the you firmware application to avoid direct programming of ports/pins etc.
Instead of this socOS providing some human readable abstractions.
You simply need to include into the AVR Studio project corresponding components and reuse them. But at the beginning let's understand base socOS concepts.
The main concepts of the socOS are:
* kernel	- represented by the "kernel/kernel_def.asm" and "kernel/kernel\_cseg.asm" assembler files that contains some common socOS basic definitions and procedures used by the most of the socOS components.
* driver	- represented by the set of the next blocks that compose a virtual class entity. Virtual because Assembly language does not support classes but logically this blocks are the parts of the one entity. All this blocks are distributed by the separate files:
    * "{driver\_name}\_int.asm"	- file with a next structure:
    ```Assembly
    .cseg
	.org {address_of_the_interrupt_handler}
	{driver_name|soc_internal_device_name}_{event_one_name}_handler
	...
	{driver_name|soc_internal_device_name}_{event_n_name}_handler	
	
    ```
    For example:
    ```Assembly
    .cseg
	.org 0x09
        rjmp timer0_ovf_handler ; timer 0 overflow
	
    ```
    This kind of files should be included into the "interruprs include block" of the your app.asm file (application entry point) which structure will be discussed later
    * "{driver\_name}\_def.asm"	- file with a some structures/constants/enumerations definitions with a next structure:
    :
    ```Assembly
    .equ SZ_ST_{DRIVER_NAME}			= 0x05
    .equ ST_{DRIVER_NAME}_PORTX_ADDRESS_OFFSET	= 0x00
    ...
    ; enumeration PORT
    .equ PORT_DDRB				= 0x23
    .equ PROT_DDRC				= 0x27
    ...
    ; constants
    .equ SOME_CONST				= 0xff
    ```
    This kind of files should be included into the "definitions include block" of the you app.asm file (application entry point) which structure will be discussed later
    * "{driver\_name}\_dseg.asm"	- here are the data segment's static variables, static structures, static arrays that are used by the component internally:
    ```Assembly
    .dseg
	st_{driver_name}:	.BYTE SZ_ST_{DRIVER_NAME}
    ```
    This kind of files should be included into the "data segment include block" of the your main app.asm (application entry point) file which structure will be discussed later
    * "{driver\_name}\_cseg.asm"	- this is a code block of the driver with the driver implementation:
    ```Assembly
    .macro m_led_init
	m_save_Z_registers
	ldi ZL, low(@0)
	ldi ZH, high(@0)
	
	rcall led_init
	m_restore_Z_registers
    .endm
    
    led_init:
	; some init code
	ret
    .macro m_led_on:
	; some init code
	ldi ZL, low(@0)
	ldi ZH, high(@0)
	
	rcall led_init
    .endm
    led_on:
	...
	ret
    ...
    ```
    This kind of files should be included into the "code segment include block" of the your app.asm file (application entry point) which structure will be discussed later
    
* extension	- represented by the "{extension\_name}\_cseg.asm" assembler file that contains some common procedures, which extends AVR assemler functionality.

## The structure of the app.asm:
The app.asm it is an entry point of the firmware application. In most cased you will start creation of you new firmware application from here. This is it's structure:
```Assembly
cseg
.org 0x00
rcall main_thread
; components interrupts include block
; inlcude some "{driver_name}_int.asm" file
.include "kernel/drivers/{driver_name}_int.asm"
; for example:
.include "kernel/drivers/soc/timer0_int.asm"

; components definitions include block
; include kernel definitions
.include "kernel/kernel_def.asm"
; include some "{driver_name}_def.asm" file
;.include "kernel/drivers/{driver_name}_def.asm"
; for example:
.include "kernel/drivers/st_device_def.asm"
.include "kernel/drivers/soc/timer_base_def.asm"
.include "kernel/drivers/soc/timer0_def.asm"
.include "kernel/drivers/io/st_device_io_def.asm"
.include "kernel/drivers/io/out_bit_def.asm"
.include "kernel/drivers/io/hid/led_def.asm"

; components data segments include block
; include some "{driver_name}_dseg.asm" file
;.include "kernel/drivers/{driver_name}_dseg.asm"
; for example:
.include "kernel/drivers/soc/timer0_dseg.asm"
; custom data block
.dseg
    led1:	.BYTE SZ_ST_LED

; main code segment lock
.cseg
; skip interrupts vector
.org 0x14
; components code segments include block
; include kernel code segment
.include "kernel/kernel_cseg.asm"
; include some "{driver_name}_cseg.asm" code segment file
;.include "kernel/drivers/{driver_name}_cseg.asm"
; for example:
.include "kernel/drivers/st_device_cseg.asm"
.include "kernel/drivers/soc/timer_base_cseg.asm"
.include "kernel/drivers/soc/timer0_cseg.asm"
.include "kernel/drivers/io/st_device_io_cseg.asm"
.include "kernel/drivers/io/out_bit_cseg.asm"
.include "kernel/drivers/io/hid/led_cseg.asm"

; main thread procedure block
main_thread:
    ; components/global initializations block
    ; init stack
    m_init_stack
    ; init leds
    m_led_init led1, DDRC, PORTC, (1 << BIT5)
    ; init timer0
    m_timer0_init TIMER_DIVIDER_1024X, timer0_on_overflow_handler
    ; enable timer0 insterrupts
    m_timer0_interrupts_enable
    ; init global interrupts
    m_init_interrupts

    ; main thread procedure loop block
    main_thread_loop:
	    nop
	    rjmp main_thread_loop

	ret

; your custom event handlers block
; for example:
timer0_on_overflow_handler:
    m_led_toggle led1

    ret
```
## socOS structure
Currenlty socOS code distributed by the next namespaces (each folder is a namespace):
* **\[kernel/\*]** is a kernel common code namespace
    * kernel		- definitions/procedures used in the most of the drivers
    * thread_pool	- thread pool powered by the timer0. It asldo provides the thread abstraction and the procedures to control thread instances
    * **\[kernel/drivers/\*\]** namespace that contains drivers for different devices. Where drivers are low level code that provides abstraction for the particular device. Thus you can use any device not by reading/writing bits within  control/data registers but throug call human readable procedures like a led_on, led_off, etc.
	* device	- base class (definitions/procedures) for any device driver
    * **\[kernel/drivers/soc/\*\]** the namespace that represents SoC build-in devices
		* _ac:st_device_		- the driver for the analog comparator
		* _adc:st_device_		- the driver for the analog-digital convertor
		* _timer_base:st_device_ 	- the base abstract class (definitions/procedures) for any timer driver
		* _time0:timer_base_		- the driver (timer0 static class (int handler/definitions/static instance data/procedures)) for the timer0
		* _timer_w_pwm_base:timer_base_	- the base abstract class (definitions/procedures) for any timer driver with a PWM (Pulse Width Modulation) functionality
		* _timer2:timer_w_pwm_base_	- the driver (timer2 static class (int handler/definitions/static instance data/procedures)) for the timer2
		* _usart:st_device_		- the driver (usart static class (int handler/definitions/static instance data/procedures)) for the usart interface
		* _eeprom:st_device_		- the driver (eeprom static class (int handler/definitions/static instance data/procedures)) for the eeprom controller
		* _watchdog:st_device_		- the driver (watchdog static class (definitions/procedures)) for the watchdog counter    
	* **\[kernel/drivers/io/\*\]** the namespace that contains drivers for the I/O devices like a led, button, etc.
	    * _device_io:device_		- the base class (definitions/procedures) for most of the I/O devices
	    * _in_bit:device_io_		- the driver that can configure port/pin for the input by the specified DDRx/PINx/PORTx/BITx parameters and can read one bit from it
	    * _out_bit:device_io_		- the driver that can configure port/pin for the ouput by the specified DDRx/PORTx/BITx parameters and can write one bit to it
	    * _in_byte:device_io_		- (not implemented yet)
	    * _out_byte:device_io_		- the driver that can configure port for the ouput of the byte by the specified DDRx/PORTx parameters and can write one byte to it
	    * _switch:device_io_		- the driver that represents a controlled switch. In derived from the kernel/drivers/io/out_bit and can switch one bit at the specified by the DDRx/PORTx/BITx port
	    * **\[kernel/drivers/io/hid/\*\]** the namespace that contains drivers for the HID I/O devices	    
		* _led:out_bit_	- led driver
		* _button:in_bit_	- the button driver
		* _encoder:device_io_	- the encoder(uses 2-bit Gray code) driver
		* _ssi:out_byte_	- the seven segment indicator driver
	    * **\[kernel/drivers/io/sensors/\*\]** the namespace that represents sensors
		* _am2302:device_io_	- the AM2302/DHT22 sensor driver. Is can configure specified DDRx/PINx/BITx for the input. And then communicates with an AM2302/DHT22 sensor through a one wire.
	* **\[kernel/drivers/motors/\*\]** the namespace that represents motors
		* _motor:timer2_	- the driver (static abstract class (int handler/definitions/static instance data/procedures)) used to control any abstract motor controlled by the PWM
		* _motor_stepper_bi:device_io_	- the driver to control any abstract bi-phase stepper motor controller wich should be connected to the MCU port's tetrade. Configuring by the specifying DDRx/PORTx/TETRADE(LOW|HIGH)
* **\[extensions/\*\]** is a socOS extensions namespace
    * delay	- the extension that provides macro/procedures for delays
    
## socOS conventions
### Variable naming convention:
* name:		variable
* [name]:	pointer to the variable

### Parameter passing convention:
In most cases parameters are passing through registers. But sometimes (if parameters to much) they could be passed through stack.
#### Procedures:
* The address parameters are passing/returning through next registres in such order: Z, Y, X, r24, r25
* The value parameters are passing/returning through next registers in a such order: r23, r22, r21, r20, r19, r18
Example:
Need to pass port addres and bit mask parameters to the st_device_io_init procedure which returns some value.
In this case Z register should be used to pass port address and r23 register to pass bit mask value. The result will be passed into the r23 register.
* The work/temporary registers are: r17, r0. But registers used to pass parameters also could be used in case if they are not used in the particular call or if they was saved with use of the stack or by the some another way.
#### Event handlers:
Sometimes required to pass some parameters to the event handler. For this purposes please use register Y. If you need to pass two values or less then please put them into the: YH, YL (in this order). Otherwise some structure should be created and filled with data. And structure address sould be passes to the event handler. For this it's address should be put into the Y (before event handler called). And thus the event handler could access this data.
### Constants
Constants could defined with use of a next pattern:
```Assembly
.equ CONSTANT_NAME = CONSTANT_VALUE
```
### Enumerations
Enumerations could be defined with use of a next pattern:
```Assembly
; define ENUMERATION_NAME
.equ ENUMERATION_NAME_VALUE_1	= 0x01
.equ ENUMERATION_NAME_VALUE_2	= 0x02
; ...
.equ ENUMERATION_NAME_VALUE_N	= n
```
For example:
```Assembly
; define LED_STATE
.equ LED_STATE_OFF	= FALSE
.equ LED_STATE_ON	= TRUE
```
### Components and classes
Most of the devices can be represented as components which has a some interrupt handlers, definitions, data and code. According to this each such component could be represented as a viurtual classes. Virtual because Assembly language does not support and OOP/OOD structures. But virtually each class could be represented with:
* class structure (set of the fields). Such structure could be defined by the own size, and fields offsets. And situated inside a {device_name}\_def.asm file
For example:
```Assembly
; struct st_led size:st_out_bit
.equ SZ_ST_LED					= 0x05
; struct st_led
.equ ST_LED_DDRX_ADDRESS_OFFSET 		= 0x00
.equ ST_LED_PORTX_ADDRESS_OFFSET		= 0x02
.equ ST_LED_USED_BIT_MASK_OFFSET		= 0x04
```
* class instance that can be located inside a {device_name}\_dseg.asm file (for singletons) or inside a app.asm "custom data segment block" for non-singletons
For example:
```Assembly
.dseg
	led:	.BYTE	SZ_ST_LED
```
* class methods (procedures) which use class structure to manipulate with class instance. Which located inside a {device_name}\_cseg.asm file
For example:
```Assembly
; constructor macro
.macro m_led_init
	; input parameters:
	;	@0	word led instance (this)
	;	@1	word [DDRx]
	;	@2	word [PORTx]
	;	@3	byte bit mask
	ldi ZL, low(@0)
	ldi ZH, high(@0)
	
	ldi YL, low(@1)
	ldi YH, low(@1)
	
	ldi XL, low(@2)
	ldi XH, low(@2)
	
	ldi r23, @3
	
	rcall led_init
		
.endm
; constuctor procedure
led_init:
	; input parameters:
	;	Z	word	[st_led]
	;	Y	word	[DDRx]
	;	X	word	[PORTx]
	;	r23	byte`	bit mask
	
	; init port
	; ...
	
	ret

.macro m_led_set
	; input parameters:
	;	@0	word	[st_led]	this
	;	@1	byte 	led_state	LED_STATE enumeration
	m_out_bit_set @0, @1
.endm

.macro  m_led_on
	; input parameters:
	;	@0 	word	[st_led]
	m_led_set @0, LED_STATE_ON
.endm

.macro  m_led_offFor example:
	; input parameters:
	;	@0 	word	[st_led]
	m_led_set @0, LED_STATE_OFF
.endm

led_set:
	; input parameters:
	;	word	st_led
	;	byte	led_state
	
	; set/unset bit in the port
	; ...

	ret

```
* class interrupt handlers. Specific of the firmware development require continuos interrupts handling
For example:
```Assembly
.cseg
	.org 0x10
	rjmp ac_completed_handler ; Analog Comparator Handler
```

### Inheritance
Virtual clsasses could be inherited one form another.
Following notation st_child:st_parent means that st_child inherited from the st_parent. That measn that st_child has a same sructure (filelds with a same offsets) but possibly extended with additional fields.
For example:
```Assembly
.equ SZ_ST_TIMER_W_PWM_BASE 						= SZ_ST_TIMER_BASE + 0x0A
; st_timer_pwm_base:st_timer_base inherited fields
.equ ST_TIMER_W_PWM_BASE_COUNTER_CONTROL_REGISTER_ADDRESS_OFFSET	= ST_TIMER_BASE_COUNTER_CONTROL_REGISTER_ADDRESS_OFFSET
.equ ST_TIMER_W_PWM_BASE_COUNTER_REGISTER_ADDRESS_OFFSET		= ST_TIMER_BASE_COUNTER_REGISTER_ADDRESS_OFFSET
.equ ST_TIMER_W_PWM_BASE_DIVIDER_BIT_MASK_OFFSET			= ST_TIMER_BASE_DIVIDER_BIT_MASK_OFFSET
.equ ST_TIMER_W_PWM_BASE_OVERFLOW_INTERRUPT_BIT_MASK_OFFSET		= ST_TIMER_BASE_OVERFLOW_INTERRUPT_BIT_MASK_OFFSET
.equ ST_TIMER_W_PWM_BASE_OVERFLOW_HANDLER_OFFSET			= ST_TIMER_BASE_OVERFLOW_HANDLER_OFFSET
; st_timer_pwm_base new fields
.equ ST_TIMER_W_PWM_BASE_COMPARE_CONTROL_REGISTER_ADDRESS_OFFSET	= SZ_ST_TIMER_BASE
.equ ST_TIMER_W_PWM_BASE_DDRX_ADDRESS_OFFSET				= SZ_ST_TIMER_BASE + 0x02
.equ ST_TIMER_W_PWM_BASE_DDRX_BIT_MASK_OFFSET				= SZ_ST_TIMER_BASE + 0x04
.equ ST_TIMER_W_PWM_BASE_MODE_OFFSET					= SZ_ST_TIMER_BASE + 0x05
.equ ST_TIMER_W_PWM_BASE_COMPARE_THRESHOLD_OFFSET			= SZ_ST_TIMER_BASE + 0x06
.equ ST_TIMER_W_PWM_BASE_COMPARE_INTERRUPT_BIT_MASK_OFFSET		= SZ_ST_TIMER_BASE + 0x07
.equ ST_TIMER_W_PWM_BASE_COMPARE_HANDLER_OFFSET				= SZ_ST_TIMER_BASE + 0x08
```

## socOS kernel macro/procedures
* m_init_stack
* m_init_interrupts
* \[macro\] save_XXX_registers/restore_XXX_registers - set ot two macroses to save/restore registers. It is more useful to type for example: save_r23_Z_SREG_registers instead of set of push commands
* \[proc\] mem_copy(\[from\], \[to\], lenght) - copyies {lenght} bytes \[from\] \[to\]
Example of use:
```Assembly
ldi ZL, low(buffer_from)
ldi ZH, high(buffer_to)
ldi YL, low(buffer_to)
ldi YH, hihg(buffer_to)
ldi r23, sz_buffer_to

rcall mem_copy
```
* \[proc\] get_struct_byte(\[st_{any}\], offset) returns the field byte value
Example of use:
```Assembly
ldi ZL, low(st_led)
ldi ZH, low(st_led)
ldi r23, ST_LED_USED_BIT_MASK_OFFSET

rcall get_struct_byte
; after the call the used bit mask will be in the r23 register
```
* \[proc\] get_struct_word(st_{any}, offset) returns the field word value
Example of use:
```AssemblyFor example:
ldi ZL, low(st_led)
ldi ZH, low(st_led)
ldi r23, ST_LED_PORTX_ADDRESS_OFFSET

rcall get_struct_word
; after the call the PORTx address will be in the r23 register.
```
* \[proc\] set_struct_byte(\[st_{any}\], offset, value)
Example of use:
```Assembly
ldi ZL, low(st_led)
ldi ZH, low(st_led)
ldi r23, ST_LED_USED_BIT_MASK_OFFSET
ldi r22, 0b00000001

rcall set_struct_byte
; after the call the used bit mask will stored into the st_led::ST_LED_USED_BIT_MASK_OFFSET field.
```
* \[proc\] get_struct_word(\[st_{any}, offset) returns the field word value.
```Assembly
Use example:
ldi ZL, low(st_led)
ldi ZH, low(st_led)
ldi r23, ST_LED_PORTX_ADDRESS_OFFSET
ldi YL, low(PORTC)
ldi YH, high(PORTC)

rcall set_struct_word
; after the call the PORTx address will be stored into the st_led::ST_LED_PORTX_ADDRESS_OFFSET field.
```

* \[macro\] m_set_Y_to_null_pointer - null pointer to the Y
* \[macro\] m_set_Z_to_null_pointer - set null pointer to the Z
* \[macro\] m_set_Z_to_io_ports_offset - set Z tp the IO_PORTS_OFFSET (0x20 for the ATmega8 MCU)
* \[macro\] m_cpw(@0, @1) compare to words @0 and @1
* \[proc\] cpw(\[{any}\], \[{any}\]) comare to words {any} and {any}
* \[macro\] m_int_to_mask(@0) - converts some integer value into the bit mask. It simple making right shift of the 0x01 to the @0 positions
* \[proc\] int_to_mask({byte}) - converts some integer value into the bit mask. It simple making right shift of the 0x01 to the {byte} positions
* \[macro\] m_lshift(@0, @1) returns @3 where @0 is a value to shift, @1 is a positions to shift
* \[proc\] lshift(value, positions) returns byte {shifted_value}.
