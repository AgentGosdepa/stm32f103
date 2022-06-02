void Reserved_IRQHandler(void)
{
 while(1)
 {

 }
}

void NMI_Handler(void)
{
  while(1)
  {
    /* nothing to be run here */
  }
}

void HardFault_Handler(void)
{
  while(1)
  {
    /* nothing to be run here */
  }
}

void SVC_Handler(void)
{
  while(1)
  {
    /* nothing to be run here */
  }
}

void PendSV_Handler(void)
{
  while(1)
  {
    /* nothing to be run here */
  }
}

void SysTick_Handler(void)
{
  while(1)
  {
    /* nothing to be run here */
  }
}



#include "stm32f103xb.h"

//pa5, pb13
//cnf1, cnf0, mode1 -0, mode0 -1


//usart2

int main()
{
  RCC->APB2ENR |= RCC_APB2ENR_IOPAEN;
  //RCC->
  //*((unsigned*)0x40021018UL) |= (1<<2) | (1<<3); //en pa, pb
  //*((unsigned*)0x40010800UL) = (1<<(4*5));


    while(1){
          for(volatile int i=0; i<200000; i++){}
        *((unsigned*)(PA+0x0C)) ^= (1<<5);
        //*((unsigned*)(PB+0x0C)) ^= (1<<5);
    }


    while(1){}

    return 0;
}
