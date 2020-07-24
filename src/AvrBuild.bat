@ECHO OFF
"C:\Program Files (x86)\Atmel\AVR Tools\AvrAssembler2\avrasm2.exe" -S ".\labels.tmp" -fI -W+ie -C V2E -o ".\app.hex" -d ".\app.obj" -e ".\app.eep" -m ".\app.map" ".\app.asm"
