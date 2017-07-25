module BootLedsC {
  uses {
    interface Leds; //declaração de uso da interface Leds
    interface Boot;
  }
}
implementation{
  void acenderLeds() {
    call Leds.led0On(); //comando para acender o led 0 (led vermelho)
    //call Leds.led0Off(); //comando para apagar o led 0 (led vermelho)
    call Leds.led1On();
    call Leds.led2On();
    //call Leds.led0Toggle();  //comando para inverter o estado do led 0 (led vermelho)
    //call Leds.set(2);  //comando para represent ação binária de um valor numérico através dos três leds
  }

  event void Boot.booted() {
    // acoes a serem executadas apos o boot
    call Leds.led0On(); //comando para acender o led 0 (led vermelho)
    call Leds.led1On();
    call Leds.led2On();
  }
}
