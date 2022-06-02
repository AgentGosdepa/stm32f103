
AS = arm-none-eabi-as

#yt-dlp1 -i -f 'bestvideo+bestaudio' --merge-output-format mkv -o "%(playlist)s/%(playlist_index)s %(title)s [%(id)s].%(ext)s" -a 2.txt

#reset halt
#flash write_image erase fin.elf
#verify_image fin.elf

all:
	arm-none-eabi-as -mcpu=cortex-m3 -c stup/startup_stm32f103xb.s -o bin/startup_stm32f103xb.o
	arm-none-eabi-gcc -mcpu=cortex-m3 -c -O0 main.c -o bin/main.o
	arm-none-eabi-ld -T ld/STM32F103XB_FLASH.ld -o bin/fin.elf bin/startup_stm32f103xb.o bin/main.o
	arm-none-eabi-objcopy -O binary bin/fin.elf bin/fin.bin
ocd:
	openocd -f target/nrf52.cfg -f interface/stlink.cfg

flash:
	openocd -f board/st_nucleo_f103rb.cfg -f interface/stlink.cfg -c \
	"init; reset halt; flash write_image erase bin/fin.elf; verify_image bin/fin.elf; reset; exit"

clean:
	rm bin/*
