![picture](https://github.com/rostislav-nikitin/socOS/blob/master/documentation/images/logo_134x80.png?raw=true)
<!-- # socOS -->
The acronym socOS stands for a **S**ystem **o**n a **C**hip **O**perating **S**ystem.
The main idea of the socOS to provie a hardware abstraction layer of the SoC and connected devices for the end users.
For now supported only the AVR family MCU devices and all the tests was made only at the AVR ATmega8 one.

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


#Documentation
##Conventions
###Variable naming convention:
 	* name:		variable
 	* [name]:	pointer to the variable

###Parameter passing convention:
In most cases parameters are passing through registers. But sometimes (if parameters to much) they could be passed through stack.
####Procedures:
	* The address parameters are passing/returning through next registres in such order: Z, Y, X, r24, r25
	* The value parameters are passing/returning through next registers in a such order: r23, r22, r21, r20, r19, r18
Example:
	Need to pass port addres and bit mask parameters to the st_device_io_init procedure which returns some value.
	In this case Z register should be used to pass port address and r23 register to pass bit mask value. The result will be passed into the r23 register.

	* The work/temporary registers are: r17, r0. But registers used to pass parameters also could be used in case if they are not used in the particular call or if they was saved with use of the stack or by the some another way.
####Event handlers:
Sometimes required to pass some parameters to the event handler. For this purposes please use Y register. If you need to pass two values or then then please put them into the: YH, YL (in this order).
Otherwise some struct should be created, filled with data that sould be passes to the event handler. And it's address should be put into the Y (before event handler called). And the event hadler could access this data.

###Inheritance
The next typing (in the comments) st_child: st_parent means that st_child inherited from the st_parent. That measn that st_child has a same sructoure (filelds with a same offsets) but extended with additional fields.

##Kernel procedures/macroses
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

