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
* **\[middleware/\*\]** wich contains:
  * **\[middleware/controls\]** wich contains controls. Controls are some middlware abstractions between driver(s) and user defined target device behavior. For example cSSIOutput have a procedure cSSIOutput_write_string which can write some string to the seven segment indicator symbol by symbol
    - **\[middleware/controls/hid\]** For now supported next HID controls:
      - cButtonInput
      - cSSIOutput
      - cLedOutput
    * **\[middleware/controls/motors\]** For now supported next motor controls:
      - cBiPhaseStepperMotor
