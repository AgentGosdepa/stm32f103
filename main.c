#define F_CPU 8000000UL

#include "FreeRTOS.h"
#include "task.h"
#include "queue.h"
#include "nrf_gpio.h"
#include "nrfx_uart.h"

#define LED_1          NRF_GPIO_PIN_MAP(0,13)
#define LED_2          NRF_GPIO_PIN_MAP(0,14)
#define LED_3          NRF_GPIO_PIN_MAP(0,15)
#define LED_4          NRF_GPIO_PIN_MAP(0,16)
 
// Отдадочная затычка. Сюда можно вписать код обработки ошибок.
#define ERROR_ACTION(CODE,POS)    do{}while(0)
#define APP_ERROR_CHECK(d) (void)(d)


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

void uart0_handler(nrfx_uart_event_t const *p_event, void *p_context)
{

}

#define UART_RTS NRF_GPIO_PIN_MAP(0, 5)
#define UART_TX NRF_GPIO_PIN_MAP(0, 6)
#define UART_CTS NRF_GPIO_PIN_MAP(0, 7)
#define UART_RX NRF_GPIO_PIN_MAP(0, 8)

static nrfx_uart_t uart0 = NRFX_UART_INSTANCE(0);



void uart_init(void)
{
    /*
    //true init
    nrf_gpio_pin_set(UART_TX);
    nrf_gpio_cfg_output(UART_TX);

    nrf_gpio_pin_set(UART_RTS);
    nrf_gpio_cfg_output(UART_RTS);

    nrf_gpio_cfg_input(UART_RX, NRF_GPIO_PIN_NOPULL);
    nrf_gpio_cfg_input(UART_CTS, NRF_GPIO_PIN_NOPULL);

    NRF_UART0->BAUDRATE = NRFX_UART_DEFAULT_CONFIG_BAUDRATE;
    NRF_UART0->CONFIG = UART_CONFIG_PARITY_Excluded | UART_CONFIG_HWFC_Enabled;
    NRF_UART0->PSEL.RTS = UART_RTS;
    NRF_UART0->PSEL.TXD = UART_TX;
    NRF_UART0->PSEL.CTS = UART_CTS;
    NRF_UART0->PSEL.RXD = UART_RX;

    NRF_UART0->ENABLE = UART_ENABLE_ENABLE_Enabled;
    */

    nrfx_uart_config_t uart_cfg = NRFX_UART_DEFAULT_CONFIG;
    uart_cfg.pseltxd = UART_TX;
    uart_cfg.pselrxd = UART_RX;
    uart_cfg.pselcts = UART_CTS;
    uart_cfg.pselrts = UART_RTS;    

    uint32_t err_code = nrfx_uart_init(&uart0, &uart_cfg, uart0_handler);
    if (err_code != 0x0BAD0000) nrf_gpio_pin_clear(LED_4);
}

// Задача моргалка. Просто так. Мигает диодиком на порту LED3
void vBlinker1(void *pvParameters)
{
    while(1)
    {    
    nrf_gpio_pin_toggle(LED_3);
    //*((unsigned*)0x50000504UL) ^= (0x1UL << 13U | 0x1UL << 14U);
    vTaskDelay(100);      // Выдержка 600мс
    nrf_gpio_pin_toggle(LED_4);
    //*((unsigned*)0x50000504UL) ^= (0x1UL << 13U | 0x1UL << 14U);
    vTaskDelay(100);       // Выдержка 20мс
    }
}

void vBlinker2(void *pvParameters)
{
    while(1)
    {
    vTaskDelay(100);
    nrf_gpio_pin_toggle(LED_1);
    //*((unsigned*)0x50000504UL) ^= (0x1UL << 15U | 0x1UL << 16U);
    vTaskDelay(100);      // Выдержка 600мс
    nrf_gpio_pin_toggle(LED_2);
    //*((unsigned*)0x50000504UL) ^= (0x1UL << 15U | 0x1UL << 16U);
    //vTaskDelay(100);       // Выдержка 20мс
    }
}

void vUart0()
{
    while(1)
    {
        vTaskDelay(5000);
        nrf_gpio_pin_toggle(LED_1);

        NRF_UART0->TXD = 'a';
        NRF_UART0->TASKS_STARTTX = UART_TASKS_STARTTX_TASKS_STARTTX_Trigger;
        vTaskDelay(100);

        //NRF_UART0->TASKS_STARTRX = UART_TASKS_STARTRX_TASKS_STARTRX_Trigger;
        //char b = NRF_UART0->RXD;
        /*if (b == '2')
            nrf_gpio_pin_toggle(LED_2);
        else if (b == '3')
            nrf_gpio_pin_toggle(LED_3);*/

        //uint32_t err_code = NRFX_SUCCESS;
        //taskENTER_CRITICAL();
        //char *asd = "asd\n\0";
        //uint32_t err_code = nrfx_uart_tx(&uart0, asd, 4);
        //taskEXIT_CRITICAL();
        //if (err_code != NRFX_SUCCESS) nrf_gpio_pin_clear(LED_4);
    }
             
}

void led_init()
{
    nrf_gpio_cfg_output(LED_1);
    nrf_gpio_cfg_output(LED_2);
    nrf_gpio_cfg_output(LED_3);
    nrf_gpio_cfg_output(LED_4);
    nrf_gpio_pin_set(LED_1);
    nrf_gpio_pin_set(LED_2);
    nrf_gpio_pin_set(LED_3);
    nrf_gpio_pin_set(LED_4);
}
 
int main(void)
{
    led_init();
    uart_init();
 
    //if(pdTRUE != xTaskCreate(vBlinker1, "Blinker1", configMINIMAL_STACK_SIZE, NULL, tskIDLE_PRIORITY + 1, NULL)) ERROR_ACTION(TASK_NOT_CREATE,0);
    
    //if(pdTRUE != xTaskCreate(vBlinker2, "Blinker2", configMINIMAL_STACK_SIZE, NULL, tskIDLE_PRIORITY + 1, NULL)) ERROR_ACTION(TASK_NOT_CREATE,0); 

    if(pdTRUE != xTaskCreate(vUart0, "uart0", configMINIMAL_STACK_SIZE, NULL, tskIDLE_PRIORITY + 1, NULL)) ERROR_ACTION(TASK_NOT_CREATE,0); 

    vTaskStartScheduler();
}