INC += -I.
INC += -I../FreeRTOS/FreeRTOS/Source/portable/GCC/ARM_CM3
INC += -I../FreeRTOS/FreeRTOS/Source/include
BUILD_DIR = ./build

All:
	arm-none-eabi-as -mcpu=cortex-m3 -c startup/startup_stm32f103xb.s -o $(BUILD_DIR)/startup_stm32f103xb.o
	arm-none-eabi-gcc -mcpu=cortex-m3 -O0 $(INC) -c main.c -o $(BUILD_DIR)/main.o
	
	arm-none-eabi-gcc -mcpu=cortex-m3 -O0 $(INC) -c ../FreeRTOS/FreeRTOS/Source/croutine.c -o $(BUILD_DIR)/croutine.o
	arm-none-eabi-gcc -mcpu=cortex-m3 -O0 $(INC) -c ../FreeRTOS/FreeRTOS/Source/event_groups.c -o $(BUILD_DIR)/event_groups.o 
	arm-none-eabi-gcc -mcpu=cortex-m3 -O0 $(INC) -c ../FreeRTOS/FreeRTOS/Source/portable/MemMang/heap_1.c -o $(BUILD_DIR)/heap_1.o 
	arm-none-eabi-gcc -mcpu=cortex-m3 -O0 $(INC) -c ../FreeRTOS/FreeRTOS/Source/portable/MemMang/heap_2.c -o $(BUILD_DIR)/heap_2.o 
	arm-none-eabi-gcc -mcpu=cortex-m3 -O0 $(INC) -c ../FreeRTOS/FreeRTOS/Source/portable/MemMang/heap_3.c -o $(BUILD_DIR)/heap_3.o 
	arm-none-eabi-gcc -mcpu=cortex-m3 -O0 $(INC) -c ../FreeRTOS/FreeRTOS/Source/portable/MemMang/heap_4.c -o $(BUILD_DIR)/heap_4.o 
	arm-none-eabi-gcc -mcpu=cortex-m3 -O0 $(INC) -c ../FreeRTOS/FreeRTOS/Source/portable/MemMang/heap_5.c -o $(BUILD_DIR)/heap_5.o 
	arm-none-eabi-gcc -mcpu=cortex-m3 -O0 $(INC) -c ../FreeRTOS/FreeRTOS/Source/list.c -o $(BUILD_DIR)/list.o
	arm-none-eabi-gcc -mcpu=cortex-m3 -O0 $(INC) -c ../FreeRTOS/FreeRTOS/Source/queue.c -o $(BUILD_DIR)/queue.o 
	#arm-none-eabi-gcc -mcpu=cortex-m3 -O0 $(INC) -c ../FreeRTOS/FreeRTOS/Source/stream_buffer.c -o $(BUILD_DIR)/stream_buffer.o 
	arm-none-eabi-gcc -mcpu=cortex-m3 -O0 $(INC) -c ../FreeRTOS/FreeRTOS/Source/tasks.c -o $(BUILD_DIR)/tasks.o 
	arm-none-eabi-gcc -mcpu=cortex-m3 -O0 $(INC) -c ../FreeRTOS/FreeRTOS/Source/timers.c -o $(BUILD_DIR)/timers.o 
	arm-none-eabi-gcc -mcpu=cortex-m3 -O0 $(INC) -c ../FreeRTOS/FreeRTOS/Source/portable/GCC/ARM_CM3/port.c -o $(BUILD_DIR)/port.o

	arm-none-eabi-ld -T ld/STM32F103XB_FLASH.ld -o $(BUILD_DIR)/proj_name.elf $(BUILD_DIR)/main.o $(BUILD_DIR)/startup_stm32f103xb.o $(BUILD_DIR)/croutine.o $(BUILD_DIR)/event_groups.o $(BUILD_DIR)/heap_1.o $(BUILD_DIR)/list.o $(BUILD_DIR)/queue.o $(BUILD_DIR)/tasks.o  $(BUILD_DIR)/timers.o  $(BUILD_DIR)/port.o
	arm-none-eabi-objcopy -O binary $(BUILD_DIR)/proj_name.elf $(BUILD_DIR)/proj_name.bin
	openocd -f board/st_nucleo_f103rb.cfg -f interface/stlink.cfg -c "init; reset halt; flash write_image erase $(BUILD_DIR)/proj_name.bin 0x08000000; verify_image $(BUILD_DIR)/proj_name.bin; reset; exit"

.PHONY: clean
clean:
	rm $(BUILD_DIR)/*
