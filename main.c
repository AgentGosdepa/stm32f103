#define F_CPU 8000000UL
//#include "stm32f10x.h"
#include "FreeRTOS.h"
#include "task.h"
#include "queue.h"
 
// Отдадочная затычка. Сюда можно вписать код обработки ошибок.
#define ERROR_ACTION(CODE,POS)    do{}while(0)
 
 void *memcpy(void *dest, const void *src, size_t n)
{
    for (size_t i = 0; i < n; i++)
    {
        ((char*)dest)[i] = ((char*)src)[i];
    }
    return dest;
}

void* memset(void* buf, char z, size_t bytes)
{
    if (buf)
    {
       char* tmp_mem = (char*)buf;
       while (bytes--) *tmp_mem++ = z;
    }
    
    return buf;
}

// Задача моргалка. Просто так. Мигает диодиком на порту LED3
void vBlinker (void *pvParameters)
{
 while(1)
 {
  *((unsigned*)0x4001080CUL) ^= (0x1UL << 5U);
  vTaskDelay(100);      // Выдержка 600мс
  *((unsigned*)0x4001080CUL) ^= (0x1UL << 5U);
  vTaskDelay(100);       // Выдержка 20мс
 }
}
 
 
int main(void)
{
  *((unsigned*)0x40021018UL) |= (0x1UL << 2U);
  *((unsigned*)0x40010800UL) &= ~(0x3UL << 22U);
  *((unsigned*)0x40010800UL) |= (0x1UL << 20U);

 
if(pdTRUE != xTaskCreate(vBlinker,"Blinker",  configMINIMAL_STACK_SIZE, NULL, tskIDLE_PRIORITY + 1, NULL)) ERROR_ACTION(TASK_NOT_CREATE,0); 
// Создаем задачи. Если при создании задачи возвращенный параметр не TRUE, то обрабатываем ошибку.
// vBlinker       - это имя функции которая будет задачей. 
// "Blinker"      - текстовая строка для отладки. Может быть любой, но длина ограничина в конфиге ОС. Ну и память она тоже ест немного.
// configMINIMAL_STACK_SIZE   - размер стека для задачи. Определяется опытным путем. В данном случае стоит системный минимум ,т.к. 
//        Задачи используют очень мало памяти. Должно хватить. 
// NULL       - передаваемый pvParameters в задачу. В данном случае не нужен, потому NULL. Но можно задаче при создании передевать
//        Разные данные, для инициализации или чтобы различать две копии задачи между собой. 
// tskIDLE_PRIORITY + 1   - приоритет задачи. В данный момент выбран минимально возможный. На 1 пункт выше чем IDLE
// NULL       - тут вместо NULL можно было вписать адрес переменной типа xTaskHandle в которую бы упал дескриптор задачи. 
//        Например так: xTaskCreate(vBlinker,"Blinker",configMINIMAL_STACK_SIZE, NULL, tskIDLE_PRIORITY + 1, &xBlinkerTask); 
//        где xBlinkerTask это глобальная переменная обьявленная как xTaskHandle xBlinkerTask; глобальная - чтобы ее везде
//        было видно. Отовсюду она была доступна. Но можно и как static обьявить или еще каким образом передать хэндл.
//        И зная эту переменную и то что там дескриптор этой задачи мы могли бы из другой задачи ее грохнуть, поменять
//        приоритет или засуспендить. В общем, управлять задачей. Но в моем примере это не требуется. 
//        Остальные аналогично.
 
// Запускаем диспетчер и понеслась.   
vTaskStartScheduler();
}




int main22()
{
  *((unsigned*)0x40021018UL) |= (0x1UL << 2U);
  *((unsigned*)0x40010800UL) &= ~(0x3UL << 22U);
  *((unsigned*)0x40010800UL) |= (0x1UL << 20U);

  while(1){
    for(volatile int i=0; i<200000; i++){}
    *((unsigned*)0x4001080CUL) ^= (0x1UL << 5U);
  }

  while(1){}
  return 0;
}
