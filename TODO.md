V 01. [common] Add PORTx state restore after the DDRx set 
V 02. [drivers/encoder] Pull up the PINx encoder bits to the Vcc through setting to the "1" PORTx encoder bits

+ Add st_device_get_pin_byte st_dev: st_device_io (use used_bit_mask from the st_device_io) return byte through stack
+ Add corresponding m_st_device_get_pin_byte
+ Add st_device_set_port_byte st_dev: st_device_io, (use used_bit_mask from the st_device_io(we can add check for possibilty of write bits by type_bit_mask)) value(s) (s in case multiple bits)
+ add corresponding m_st_device_set_port_byte

03. Review stack L/H orded inside a procedures
04. Implement [drivers/SSI] 
05. Implement [drivers/USART] 
06. Implement [drivers/EEPROM] 
07. Implement [drivers/StepperMottor] 
08. Implement [drivers/PWM] 
09. Implement [drivers/Comparator] 
10. Implement [drivers/ADC] 
10. Implement [drivers/DHT22] 
11. Demo: Encoder+SSI+BT+StepperMotor
