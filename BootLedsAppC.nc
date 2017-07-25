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
  components new TimerMilliC() as LigarTimerSensor;
  components SerialStartC;
  components PrintfC;
  components new HamamatsuS1087ParC() as Sensor1; // luminosidade
  components new HamamatsuS10871TsrC() as Sensor2; // infravermelho
  components new SensirionSht11C() as Sensor3; // umidade e temperatura


  BootLedsC.Leds -> LedsC; //conexão  do  componente  LedsC  com  a  interface  da 
  BootLedsC -> MainC.Boot;
  BootLedsC.LigarTimerA -> LigarTimerA;
  BootLedsC.LigarTimerB -> LigarTimerB;
  BootLedsC.LigarTimerC -> LigarTimerC;
  BootLedsC.LigarTimerHelloWorld -> LigarTimerHelloWorld;
  BootLedsC.LigarTimerSensor -> LigarTimerSensor;

  BootLedsC.Read1 -> Sensor1;
  BootLedsC.Read2 -> Sensor2;
  BootLedsC.Read3 -> Sensor3.Humidity;
  BootLedsC.Read4 -> Sensor3.Temperature;
}
