INC += -I.
#INC += -I../FreeRTOS/FreeRTOS/Source/portable/GCC/ARM_CM3
INC += -I../FreeRTOS/FreeRTOS/Source/portable/GCC/ARM_CM4F
INC += -I../FreeRTOS/FreeRTOS/Source/include

INC += -I/home/qwe/1_Projects/work_nrf_10_2021/sdk_nRF5_SDK_17.0.0_9d13099/modules/nrfx
INC += -I/home/qwe/1_Projects/work_nrf_10_2021/sdk_nRF5_SDK_17.0.0_9d13099/modules/nrfx/hal
INC += -I/home/qwe/1_Projects/work_nrf_10_2021/sdk_nRF5_SDK_17.0.0_9d13099/modules/nrfx/mdk
INC += -I/home/qwe/1_Projects/work_nrf_10_2021/sdk_nRF5_SDK_17.0.0_9d13099/modules/nrfx/templates
INC += -I/home/qwe/1_Projects/work_nrf_10_2021/sdk_nRF5_SDK_17.0.0_9d13099/modules/nrfx/drivers/include
INC += -I/home/qwe/1_Projects/work_nrf_10_2021/sdk_nRF5_SDK_17.0.0_9d13099/modules/nrfx/drivers/src/prs
INC += -I/home/qwe/1_Projects/work_nrf_10_2021/sdk_nRF5_SDK_17.0.0_9d13099/components/toolchain/cmsis/include
BUILD_DIR = ./build

#LDFILE = /home/qwe/1_Projects/work_nrf_10_2021/sdk_nRF5_SDK_17.0.0_9d13099/config/nrf52840/armgcc/generic_gcc_nrf52.ld
LDFILE  = ld/nrf52840_xxaa.ld
#LDFILE  = ld/STM32F103XB_FLASH.ld
STARTUPFILE = startup/gcc_startup_nrf52840.S
#STARTUPFILE = startup/startup_stm32f103xb.s
LDFLAGS = --gc-sections
FLAGS = -mcpu=cortex-m4 -Os -mfloat-abi=hard -march=armv7e-m+fp -DNRF52840_XXAA

All:
	arm-none-eabi-as -mcpu=cortex-m4 -c $(STARTUPFILE) -o $(BUILD_DIR)/gcc_startup_nrf52840.o
	#arm-none-eabi-as -mcpu=cortex-m4 -c $(STARTUPFILE) -o $(BUILD_DIR)/startup_stm32f103xb.o
	
	arm-none-eabi-gcc $(FLAGS) $(INC) -c main.c -o $(BUILD_DIR)/main.o
	arm-none-eabi-gcc $(FLAGS) $(INC) -c ../FreeRTOS/FreeRTOS/Source/croutine.c -o $(BUILD_DIR)/croutine.o
	arm-none-eabi-gcc $(FLAGS) $(INC) -c ../FreeRTOS/FreeRTOS/Source/event_groups.c -o $(BUILD_DIR)/event_groups.o 
	arm-none-eabi-gcc $(FLAGS) $(INC) -c ../FreeRTOS/FreeRTOS/Source/portable/MemMang/heap_1.c -o $(BUILD_DIR)/heap_1.o 
	arm-none-eabi-gcc $(FLAGS) $(INC) -c ../FreeRTOS/FreeRTOS/Source/portable/MemMang/heap_2.c -o $(BUILD_DIR)/heap_2.o 
	arm-none-eabi-gcc $(FLAGS) $(INC) -c ../FreeRTOS/FreeRTOS/Source/portable/MemMang/heap_3.c -o $(BUILD_DIR)/heap_3.o 
	arm-none-eabi-gcc $(FLAGS) $(INC) -c ../FreeRTOS/FreeRTOS/Source/portable/MemMang/heap_4.c -o $(BUILD_DIR)/heap_4.o 
	arm-none-eabi-gcc $(FLAGS) $(INC) -c ../FreeRTOS/FreeRTOS/Source/portable/MemMang/heap_5.c -o $(BUILD_DIR)/heap_5.o 
	arm-none-eabi-gcc $(FLAGS) $(INC) -c ../FreeRTOS/FreeRTOS/Source/list.c -o $(BUILD_DIR)/list.o
	arm-none-eabi-gcc $(FLAGS) $(INC) -c ../FreeRTOS/FreeRTOS/Source/queue.c -o $(BUILD_DIR)/queue.o 
	#arm-none-eabi-gcc $(FLAGS) $(INC) -c ../FreeRTOS/FreeRTOS/Source/stream_buffer.c -o $(BUILD_DIR)/stream_buffer.o 
	arm-none-eabi-gcc $(FLAGS) $(INC) -c ../FreeRTOS/FreeRTOS/Source/tasks.c -o $(BUILD_DIR)/tasks.o 
	arm-none-eabi-gcc $(FLAGS) $(INC) -c ../FreeRTOS/FreeRTOS/Source/timers.c -o $(BUILD_DIR)/timers.o 
	
	#arm-none-eabi-gcc $(FLAGS) $(INC) -c ../FreeRTOS/FreeRTOS/Source/portable/GCC/ARM_CM3/port.c -o $(BUILD_DIR)/port.o
	arm-none-eabi-gcc $(FLAGS) $(INC) -c ../FreeRTOS/FreeRTOS/Source/portable/GCC/ARM_CM4F/port.c -o $(BUILD_DIR)/port.o
	
	arm-none-eabi-gcc $(FLAGS) $(INC) -c /home/qwe/1_Projects/work_nrf_10_2021/sdk_nRF5_SDK_17.0.0_9d13099/modules/nrfx/drivers/src/nrfx_uart.c -o $(BUILD_DIR)/nrfx_uart.o
	arm-none-eabi-gcc $(FLAGS) $(INC) -c /home/qwe/1_Projects/work_nrf_10_2021/sdk_nRF5_SDK_17.0.0_9d13099/modules/nrfx/drivers/src/prs/nrfx_prs.c -o $(BUILD_DIR)/nrfx_prs.o

	#arm-none-eabi-ld -T $(LDFILE) -o $(BUILD_DIR)/proj_name.elf $(BUILD_DIR)/main.o $(BUILD_DIR)/startup_stm32f103xb.o $(BUILD_DIR)/croutine.o $(BUILD_DIR)/event_groups.o $(BUILD_DIR)/heap_1.o $(BUILD_DIR)/list.o $(BUILD_DIR)/queue.o $(BUILD_DIR)/tasks.o  $(BUILD_DIR)/timers.o  $(BUILD_DIR)/port.o
		
	arm-none-eabi-ld -T $(LDFILE) $(LDFLAGS) -o $(BUILD_DIR)/proj_name.elf $(BUILD_DIR)/main.o $(BUILD_DIR)/gcc_startup_nrf52840.o $(BUILD_DIR)/croutine.o $(BUILD_DIR)/event_groups.o $(BUILD_DIR)/heap_1.o $(BUILD_DIR)/list.o $(BUILD_DIR)/queue.o $(BUILD_DIR)/tasks.o $(BUILD_DIR)/timers.o $(BUILD_DIR)/port.o $(BUILD_DIR)/nrfx_uart.o $(BUILD_DIR)/nrfx_prs.o
	
	arm-none-eabi-objcopy -O binary $(BUILD_DIR)/proj_name.elf $(BUILD_DIR)/proj_name.bin

nrf:
	openocd -f board/nordic_nrf52_dk.cfg -c "init; reset halt; nrf5 mass_erase; program build/proj_name.elf verify; reset; exit" 
	#openocd -f board/st_nucleo_f103rb.cfg -f interface/stlink.cfg -c "init; reset halt; flash write_image erase $(BUILD_DIR)/proj_name.bin 0x08000000; verify_image $(BUILD_DIR)/proj_name.bin; reset; exit"

.PHONY: clean
clean:
	rm $(BUILD_DIR)/*
