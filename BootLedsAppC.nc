configuration BootLedsAppC{

}
implementation {
  components LedsC; //declaração de uso dos LEDS
  components MainC, BootLedsC;
    
  BootLedsC.Leds -> LedsC; //conexão  do  componente  LedsC  com  a  interface  da 
  BootLedsC -> MainC.Boot;
}
