#include <Timer.h>
#define NEW_PRINTF_SEMANTICS
#include "printf.h"


configuration BootLedsAppC{

}
implementation {
  components LedsC; //declaração de uso dos LEDS
  components MainC, BootLedsC;
  components new TimerMilliC() as LigarTimerA;
  components new TimerMilliC() as LigarTimerB;
  components new TimerMilliC() as LigarTimerC;
  components new TimerMilliC() as LigarTimerHelloWorld;
  components SerialStartC;
  components PrintfC;


  BootLedsC.Leds -> LedsC; //conexão  do  componente  LedsC  com  a  interface  da 
  BootLedsC -> MainC.Boot;
  BootLedsC.LigarTimerA -> LigarTimerA;
  BootLedsC.LigarTimerB -> LigarTimerB;
  BootLedsC.LigarTimerC -> LigarTimerC;
  BootLedsC.LigarTimerHelloWorld -> LigarTimerHelloWorld;
}
