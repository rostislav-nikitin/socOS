#socOS

##Conventions
###Variable naming convention:
 	* name:		variable
 	* [name]:	pointer to the variable

###Parameter passing convention:
In most cases parameters are passing through registers. But sometimes (if parameters to much) they could be passed through stack.
####Procedures:
	* The address parameters are passing through next registres in such order: Z, Y, X, r24, r25
	* The value parameters are passing through next registers in a such order: r23, r22, r21, r20, r19, r18
Example:
	Need to pass port addres and bit mask parameters to the st_device_io_init procedure. 
	In this case Z register should be used to pass port address and r23 register to pass bit mask value
	* The work/temporary registers are: r17, r0. But registers used to pass parameters also could be used in case if they are not used in the particular call or if they was saved with use of the stack or by the some another way.
####Event handlers:
Sometimes required to pass some parameters to the event handler. For this purposes please use Y register. If you need to pass two values or then then please put them into the: YH, YL (in this order).
Otherwise some struct should be created, filled with data that sould be passes to the event handler. And it's address should be put into the Y (before event handler called). And the event hadler could access this data.

###Inheritance
The next typing (in the comments) st_child: st_parent means that st_child inherited from the st_parent. That measn that st_child has a same sructoure (filelds with a same offsets) but extended with additional fields.

##Kernel procedures/macroses
	* [macro] save_XXX_registers/restore_XXX_registers	- set ot two macroses to save/restore registers. It is more useful to type for example: save_r23_Z_SREG_registers instead of set of push commands
	* [proc]