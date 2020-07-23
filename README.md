![picture](https://github.com/rostislav-nikitin/socOS/blob/master/documentation/images/logo_134x80.png?raw=true)
<!-- # socOS -->
The acronym socOS stands for the **S**ystem **o**n a **C**hip **O**perating **S**ystem.
The main idea of the socOS to provie a hardware abstraction layer of the SoC and connected devices for the end users.
For now supported only the AVR family MCU devices and all the tests was made only at the AVR ATmega8 one.

## How to use it?
1. Clone this repository
2. In the src folder you can find three files:
* app.aps - this is a AVR Studio project file
* app.asm - this is a main Assembler file of the your firmware application
* AvrBuild.bat - this is a Windows batch file to build your firmware application outside of the AVR Studio
3. You can build your own firmware application through:
* Opening aps.asp in the AVR Studio IDE and writing/debugging your own code there
* Opening asp.asm in the your favorite text editor and building app with AvrBuild.bat batch
4. Follow guidelines below to build your own firmware

## socOS base blocks
The main idea is a reusing of the socOS extensions/drivers (from this blocks build socOS) in the you firmware application to avoid direct programming of ports/pins etc. Instead of this socOS providing some human readable abstractions.
You simply need to include into the AVR Studio project corresponding to the you task components and reuse them.
But at the beginning let's understand base socOS concepts.
The main entities of the socOS are:
* extension	- represented by the "{extension_name}_cseg.asm" assembler file that contains some common procedures, which extends AVR assemler functionality.
* driver	- represented by the set of the next files:
    * "{driver_name}_int.asm"	- file with a next structure:
    ```(asm)
    .cseg
	.org 0x{address_of_the_interrupt_handler}
	{driver_name|soc_internal_device_name}_{event_one_name}_handler
	...
	{driver_name|soc_internal_device_name}_{event_n_name}_handler	
	
    ```
    This kind of files should be included in the interruprs include block of the your application app.asm file
    * "{driver_name}_def.asm"	- file with a some structures/constants/enumerations definitions.
    Something like that:
    ```
    .equ SZ_ST_{DRIVER_NAME}			= 0x05
    .equ ST_{DRIVER_NAME}_PORTX_ADDRESS_OFFSET	= 0x00
    ...
    ; enumeration PORT
    .equ PORT_DDRB				= 0x23
    .equ PROT_DDRC				= 0x27
    ...
    ```
    This kind of files should be included in the definitions include block of the you application app.asm file
    * "{driver_name}_dseg.asm"	- here are data segment static variables, structures, arrays that are used by the component internally
    ```
    .dseg
	st_{driver_name}:	.BYTE SZ_ST_{DRIVER_NAME}
    ```
    This kind of files should be included in the data segment include block of the your main application app.asm file
    * "{driver_name}_cseg.asm"	- this is a code block of the driver with the driver implementation
    ```
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
    ...
    ```
    This kind of files should be included in the code segment inclide block of the your appication app.asm file
    
	
The structure of the app.asm:
```
cseg
.org 0x00
rcall main_thread
; include components interrupts handlers
; inlcude some "{driver_name}_int.asm" file
.include "kernel/drivers/{driver_name}_int.asm"
; for example:
.include "kernel/drivers/soc/timer0_int.asm"

; include components definitions
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

;.include components data segments
; include some "{driver_name}_dseg.asm" file
;.include "kernel/drivers/{driver_name}_dseg.asm"
; for example:
.include "kernel/drivers/soc/timer0_dseg.asm"
; custom data & descriptors
.dseg
    led1:	.BYTE SZ_ST_LED

; main code segment
.cseg
; skip interrupts vector
.org 0x14
; include components code segments
; include kernel code segment
.include "kernel/kernel_cseg.asm"
; include some "{driver_name}_cseg.asm" code segment file
;.include "../../../../../src/kernel/drivers/{driver_name}_cseg.asm"
; for example:
.include "../../../../../src/kernel/drivers/st_device_cseg.asm"
.include "../../../../../src/kernel/drivers/soc/timer_base_cseg.asm"
.include "../../../../../src/kernel/drivers/soc/timer0_cseg.asm"
.include "../../../../../src/kernel/drivers/io/st_device_io_cseg.asm"
.include "../../../../../src/kernel/drivers/io/out_bit_cseg.asm"
.include "../../../../../src/kernel/drivers/io/hid/led_cseg.asm"

; main thread procedure
main_thread:
    ; components/global initializations
    ; stack initialization
    m_init_stack
    ; init leds
    m_led_init led1, DDRC, PORTC, (1 << BIT5)
    ; init timer0
    m_timer0_init TIMER_DIVIDER_1024X, timer0_on_overflow_handler
    ; enable timer0 insterrupts
    m_timer0_interrupts_enable
    ; init global interrupts
    m_init_interrupts

    ; main thread loop
    main_thread_loop:
	    nop
	    rjmp main_thread_loop

	ret

; put your custom event handlers there
; for example:
timer0_on_overflow_handler:
    m_led_toggle led1
    m_motor_stepper_bi_handle_io motor_stepper_bi1

    ret
```

## socOS structure
First of all socOS consistis of the:
* kernel_cseg.asm - this is a some base macro/procedures
Currenlty socOS code distributed by the next namespaces:
* **\[kernel/\*]** is a kernel common code:
  - common function like: mem_copy, get_struct_byte*, get_struct_word*, etc
  - thread pool (powered by the timer) with thread abstraction and procedures to control it instances
  * **\[kernel/drivers/\*\]** wich contains drivers for different devices. Drivers are some low level code that provides functionality abstraction for the particular device. Thus you can use any device not by reading/writing bits within some control/data registers but throug call some human readable procedures like a led_on, led_off, etc
    * **\[kernel/drivers/io\]** For now supported next IO devices:
      - led
      - encoder
      - button
      - seven segment indicator
      - analog comparator
      - analog-digital convertor
      - pulse width modulation
      - USART interface
      - EEPROM manager
    * **\[kernel/drivers/sensors\]** For now supported next sensor device:
      - DHT22/AM2302 humidity/temperature sensor
    * **\[kernel/drivers/motors\]** For now supported next motor devices:
      - bi-phase stepper motor


## Conventions
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
Sometimes required to pass some parameters to the event handler. For this purposes please use Y register. If you need to pass two values or then then please put them into the: YH, YL (in this order).
Otherwise some struct should be created, filled with data that sould be passes to the event handler. And it's address should be put into the Y (before event handler called). And the event hadler could access this data.

### Inheritance
The next typing (in the comments) st_child: st_parent means that st_child inherited from the st_parent. That measn that st_child has a same sructoure (filelds with a same offsets) but extended with additional fields.

## Kernel procedures/macroses
* m_init_stack
* m_init_interrupts
* \[macro\] save_XXX_registers/restore_XXX_registers - set ot two macroses to save/restore registers. It is more useful to type for example: save_r23_Z_SREG_registers instead of set of push commands
* \[proc\] mem_copy(\[from\], \[to\], lenght) - copyies {lenght} bytes \[from\] \[to\]
Example of use:
	ldi ZL, low(buffer_from)
	ldi ZH, high(buffer_to)
	ldi YL, low(buffer_to)
	ldi YH, hihg(buffer_to)
	ldi r23, sz_buffer_to

	rcall mem_copy
* \[proc\] get_struct_byte(\[st_{any}\], offset) returns the field byte value
Example of use:
		ldi ZL, low(st_led)
		ldi ZH, low(st_led)
		ldi r23, ST_LED_USED_BIT_MASK_OFFSET
		rcall get_struct_byte
		; after the call the used bit mask will be in the r23 register
* \[proc\] get_struct_word(st_{any}, offset) returns the field word value
Use example:
	ldi ZL, low(st_led)
	ldi ZH, low(st_led)
	ldi r23, ST_LED_PORTX_ADDRESS_OFFSET
	rcall get_struct_word
	; after the call the PORTx address will be in the r23 register.

* \[proc\] set_struct_byte(\[st_{any}\], offset, value)
Use example:
	ldi ZL, low(st_led)
	ldi ZH, low(st_led)
	ldi r23, ST_LED_USED_BIT_MASK_OFFSET
	ldi r22, 0b00000001
	rcall set_struct_byte
	; after the call the used bit mask will stored into the st_led::ST_LED_USED_BIT_MASK_OFFSET field.

* \[proc\] get_struct_word(\[st_{any}, offset) returns the field word value.
Use example:
	ldi ZL, low(st_led)
	ldi ZH, low(st_led)
	ldi r23, ST_LED_PORTX_ADDRESS_OFFSET
	ldi YL, low(PORTC)
	ldi YH, high(PORTC)
	rcall set_struct_word
	; after the call the PORTx address will be stored into the st_led::ST_LED_PORTX_ADDRESS_OFFSET field.

* \[macro\] m_set_Y_to_null_pointer - null pointer to the Y
* \[macro\] m_set_Z_to_null_pointer - set null pointer to the Z
* \[macro\] m_set_Z_to_io_ports_offset - set Z tp the IO_PORTS_OFFSET (0x20 for the ATmega8 MCU)
* \[macro\] m_cpw(@0, @1) compare to words @0 and @1
* \[proc\] cpw(\[{any}\], \[{any}\]) comare to words {any} and {any}
* \[macro\] m_int_to_mask(@0) - converts some integer value into the bit mask. It simple making right shift of the 0x01 to the @0 positions
* \[proc\] int_to_mask({byte}) - converts some integer value into the bit mask. It simple making right shift of the 0x01 to the {byte} positions
* \[macro\] m_lshift(@0, @1) returns @3 where @0 is a value to shift, @1 is a positions to shift
* \[proc\] lshift(value, positions) returns byte {shifted_value}.


# Drivers
Driver is component that provides a some abstraction over hardware. For example \[kernel/drivers/io/hid/button\] provides structure and procedures to handle button events and raise another events for the consumer application.
For example eventl like: button_down, button_up, button_pressed.
In the you code you can specify for example {button_name}_on_button_pressed_handler to process {button_name} button_pressed events.
Drivers are composition of the:
* definition: {driver_name}_def.asm
* interrupt: {driver_name}_int.asm
* data: {driver_name}_dseg.asm
* implementation (code): {driver_name}_cseg.asm
## st_device
st_device is a base abstract structure for the all devices. Kernel contains next procedures to handle st_device and derived structures :

* \[abstract\] m_st_device_init/st_device_init - abstract initialization procedure that contains only ret operation. Should be called from the *_init method of the deriatives
* st_device_raise_event([st_device], handler_address_offset) - procedure that raises an event by calling event handler specified by the [st_device] and device handler offset

## st_device_io


## st_in_bit


## st_out_bit


## st_in_byte (not implemented)


## st_out_byte

## app.asm structure
We recommend to use guidelines below to build you own firmware based on the socOS.
But let's start from the socOS description.
The app.asm structure:
1. First of all add .include "kernel\drivers\...\{driver_name}_int.asm" 

To create a firmware based on socOS you have to clone this repo and
1. You can open app.aps in the AVR studio
 as a start point of you firmware application. app.aps is a AVR Studio project that can be used as a template to build your custom firmware.

## Table of Contents
* [socOS structure] (#socOS-structure)