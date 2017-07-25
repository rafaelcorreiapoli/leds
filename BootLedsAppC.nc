configuration BootLedsAppC{

}
implementation {
  components LedsC; //declaração de uso dos LEDS
  components MainC, BootLedsC;
  components new TimerMilliC() as LigarTimerA;
  components new TimerMilliC() as LigarTimerB;
  components new TimerMilliC() as LigarTimerC;


  BootLedsC.Leds -> LedsC; //conexão  do  componente  LedsC  com  a  interface  da 
  BootLedsC -> MainC.Boot;
  BootLedsC.LigarTimerA -> LigarTimerA;
  BootLedsC.LigarTimerB -> LigarTimerB;
  BootLedsC.LigarTimerC -> LigarTimerC;
}
