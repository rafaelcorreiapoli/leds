#include <Timer.h>
#include "printf.h"

module BootLedsC {
  uses {
    interface Leds; //declaração de uso da interface Leds
    interface Boot;
    interface Timer<TMilli> as LigarTimerA;
    interface Timer<TMilli> as LigarTimerB;
    interface Timer<TMilli> as LigarTimerC;
    interface Timer<TMilli> as LigarTimerHelloWorld;
    interface Timer<TMilli> as LigarTimerSensor;
    interface Read<uint16_t> as Read1;
    interface Read<uint16_t> as Read2;
    interface Read<uint16_t> as Read3;
    interface Read<uint16_t> as Read4;
  }
}
implementation{
  void acenderLeds() {
    call Leds.led0On(); //comando para acender o led 0 (led vermelho)
    call Leds.led1On();
    call Leds.led2On();
  }

  void iniciarTimers() {
    //call LigarTimerA.startPeriodic(500);
    //call LigarTimerB.startPeriodic(1000);
    //call LigarTimerC.startPeriodic(2000);
    //call LigarTimerHelloWorld.startPeriodic(5000);
    call LigarTimerSensor.startPeriodic(10000);
  }

  void lerSensores() {
    call Read1.read();
    call Read2.read();
    call Read3.read();
    call Read4.read();
  }

  uint16_t sht11TempToCelsius(uint16_t sht11temp) {
    return (-39.60) + 0.01 * sht11temp;
  }

  uint16_t sht11HumidityToRelativeHumidity(uint16_t sht11humidity) {
    return -4+0.0405 * sht11humidity - 2.8e-6*(sht11humidity * sht11humidity);
  }

  void printTemperatura(uint16_t temperatura) {
    printf("T: %u celsius \n", temperatura);
    printfflush();
  }
  void printLuminosidade(uint16_t luminosidade) {
    printf("L: %u lumen \n", luminosidade);
    printfflush();
  }
  void printLuminosidadeInfravermelho(uint16_t luminosidade) {
    printf("LI: %u lumen \n", luminosidade);
    printfflush();
  }
   void printHumidity(uint16_t humidadeRelativa) {
    printf("H %u % \n", humidadeRelativa);
    printfflush();
  }
  // luminosidade
  event void Read1.readDone(error_t result, uint16_t data) {
    printLuminosidade(data);
  }
  // luminosidade (infravermelho)
  event void Read2.readDone(error_t result, uint16_t data) {
    printLuminosidadeInfravermelho(data);
  }

  // humidade (precisa converter para humidade relativa)
  event void Read3.readDone(error_t result, uint16_t data) {
    printHumidity(sht11HumidityToRelativeHumidity(data));
  }

  // temperatura (precisa converter para celsius)
  event void Read4.readDone(error_t result, uint16_t data) {
    printTemperatura(sht11TempToCelsius(data));
  }
  event void Boot.booted() {
    // acoes a serem executadas apos o boot
    acenderLeds();
    iniciarTimers();
    lerSensores();
  }

  
  event void LigarTimerSensor.fired() {
    lerSensores();
  }
  
  event void LigarTimerHelloWorld.fired() {
    printf("Hello world!");
    printfflush();
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
