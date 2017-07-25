// $Id: RadioCountToLedsC.nc,v 1.7 2010-06-29 22:07:17 scipio Exp $

/*									tab:4
 * Copyright (c) 2000-2005 The Regents of the University  of California.  
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * - Redistributions of source code must retain the above copyright
 *   notice, this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the
 *   distribution.
 * - Neither the name of the University of California nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL
 * THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * Copyright (c) 2002-2003 Intel Corporation
 * All rights reserved.
 *
 * This file is distributed under the terms in the attached INTEL-LICENSE     
 * file. If you do not find these files, copies can be found by writing to
 * Intel Research Berkeley, 2150 Shattuck Avenue, Suite 1300, Berkeley, CA, 
 * 94704.  Attention:  Intel License Inquiry.
 */
 
#include "Timer.h"
#include "RadioCountToLeds.h"
#include "printf.h"

/**
 * Implementation of the RadioCountToLeds application. RadioCountToLeds 
 * maintains a 4Hz counter, broadcasting its value in an AM packet 
 * every time it gets updated. A RadioCountToLeds node that hears a counter 
 * displays the bottom three bits on its LEDs. This application is a useful 
 * test to show that basic AM communication and timers work.
 *
 * @author Philip Levis
 * @date   June 6 2005
 */

module RadioCountToLedsC @safe() {
  uses {
    interface Leds;
    interface Boot;
    interface Receive;
    interface AMSend;
    interface Timer<TMilli> as MilliTimer;
    interface SplitControl as AMControl;
    interface Packet;

    //sensores
    interface Read<uint16_t> as Read1;
    interface Read<uint16_t> as Read2;
    interface Read<uint16_t> as Read3;
    interface Read<uint16_t> as Read4;
  }
}
implementation {
  uint16_t temp;
  uint16_t hum;
  uint16_t visible;
  uint16_t ir;

  bool temp_flag;
  bool hum_flag;
  bool visible_flag;
  bool ir_flag;

  message_t packet;

  bool locked;
  uint16_t counter = 0;
  

  void resetaValoresSensor() {
    temp_flag = FALSE ;
    hum_flag = FALSE ;
    visible_flag = FALSE ;
    ir_flag = FALSE ;
  }
  void lerSensores() {
    resetaValoresSensor();
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
  void init() {
    call Leds.led0Off();
    call Leds.led1Off();
    call Leds.led2Off();

    // acender led vermelho
    call Leds.led0On();
    // Ler sensores
    lerSensores();
    // acender led verde
    call Leds.led1On();
  }

  event void Boot.booted() {
    call AMControl.start();
    
  }

  event void AMControl.startDone(error_t err) {
    if (err == SUCCESS) {
      call MilliTimer.startPeriodic(10000);
    }
    else {
      call AMControl.start();
    }
  }

  event void AMControl.stopDone(error_t err) {
    // do nothing
  }

  event void AMSend.sendDone(message_t* bufPtr, error_t error) {
    dbg("RadioCountToLedsC", "RadioCountToLedsC: Send done.\n");
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

  event void MilliTimer.fired() {
    init();
  }

  event message_t* Receive.receive(message_t* bufPtr, 
           void* payload, uint8_t len) {
    
  }

  // void enviarPacote(radio_count_msg_t* rcm) {
  //   if (call AMSend.send(AM_BROADCAST_ADDR, &packet, sizeof(radio_count_msg_t)) == SUCCESS) {
  //     dbg("RadioCountToLedsC", "RadioCountToLedsC: packet sent.\n", counter); 
  //   }
  // }

  void montarPacote(uint16_t temp_l, uint16_t hum_l, uint16_t visible_l, uint16_t ir_l) {
    // dbg("RadioCountToLedsC", "RadioCountToLedsC: timer fired, counter is %hu.\n", counter);
    radio_count_msg_t* rcm = (radio_count_msg_t*)call Packet.getPayload(&packet, sizeof(radio_count_msg_t));
    if (rcm == NULL) {
      return;
    }

    rcm->id = 1;
    rcm->temp = temp_l;
    rcm->hum = hum_l;
    rcm->visible = visible_l;
    rcm->ir = ir_l;

    if (call AMSend.send(AM_BROADCAST_ADDR, &packet, sizeof(radio_count_msg_t)) == SUCCESS) {
      dbg("RadioCountToLedsC", "RadioCountToLedsC: packet sent.\n", counter); 
    }
  }
  void checarValores() {
    if (temp_flag
     && hum_flag
     && visible_flag
     && ir_flag
    ) {
      call Leds.led2On();
      montarPacote(temp, hum, visible, ir);
      
    }
  }
 // luminosidade
  event void Read1.readDone(error_t result, uint16_t data) {
    printLuminosidade(data);
    visible = data;
    visible_flag = TRUE;
    checarValores();
  }
  // luminosidade (infravermelho)
  event void Read2.readDone(error_t result, uint16_t data) {
    printLuminosidadeInfravermelho(data);
    ir = data;
    ir_flag = TRUE;
    checarValores();
  }

  // humidade (precisa converter para humidade relativa)
  event void Read3.readDone(error_t result, uint16_t data) {
    printHumidity(sht11HumidityToRelativeHumidity(data));
    hum = data;
    hum_flag = TRUE;
    checarValores();
  }

  // temperatura (precisa converter para celsius)
  event void Read4.readDone(error_t result, uint16_t data) {
    printTemperatura(sht11TempToCelsius(data));
    temp = data;
    temp_flag = TRUE;
    checarValores();
  }
}




