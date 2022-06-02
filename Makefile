
AS = arm-none-eabi-as

#yt-dlp1 -i -f 'bestvideo+bestaudio' --merge-output-format mkv -o "%(playlist)s/%(playlist_index)s %(title)s [%(id)s].%(ext)s" -a 2.txt

#reset halt
#flash write_image erase fin.elf
#verify_image fin.elf

all:
	arm-none-eabi-as -mcpu=cortex-m0 -c stup/f051.s -o bin/f051.o
	arm-none-eabi-gcc -mcpu=cortex-m0 -c -O0 main.c -o bin/main.o
	arm-none-eabi-ld -T ld/ff051.ld -o bin/fin.elf bin/f051.o bin/main.o
	arm-none-eabi-objcopy -O binary bin/fin.elf bin/fin.bin
ocd:
	openocd -f target/nrf52.cfg -f interface/stlink.cfg

flash:
	openocd -f board/stm32f0discovery.cfg -f interface/stlink.cfg -c \
	"init; reset halt; flash write_image erase bin/fin.elf; verify_image bin/fin.elf; reset; exit"

clean:
	rm bin/*

ssh:
	ssh -i /home/dora/.ssh/hs kd@192.168.7.100
