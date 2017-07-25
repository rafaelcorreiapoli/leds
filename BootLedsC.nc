#include <Timer.h>

module BootLedsC {
  uses {
    interface Leds; //declaração de uso da interface Leds
    interface Boot;
    interface Timer<TMilli> as LigarTimerA;
    interface Timer<TMilli> as LigarTimerB;
    interface Timer<TMilli> as LigarTimerC;
  }
}
implementation{
  
  
  void acenderLeds() {
    call Leds.led0On(); //comando para acender o led 0 (led vermelho)
    call Leds.led1On();
    call Leds.led2On();

    //call Leds.led0Off(); //comando para apagar o led 0 (led vermelho)
    //call Leds.led0Toggle();  //comando para inverter o estado do led 0 (led vermelho)
    //call Leds.set(2);  //comando para represent ação binária de um valor numérico através dos três leds
  }

  event void Boot.booted() {
    // acoes a serem executadas apos o boot
    acenderLeds();
    call LigarTimerA.startPeriodic(500);
    call LigarTimerB.startPeriodic(1000);
    call LigarTimerC.startPeriodic(2000);
  }

  event void LigarTimerA.fired() {
    // vermelho
    call Leds.led0Toggle();
  }
  event void LigarTimerB.fired() {
    // verde
    call Leds.led1Toggle();
  }
  event void LigarTimerC.fired() {
    // azul
    call Leds.led2Toggle();
  }
}
