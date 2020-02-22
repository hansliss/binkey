/*
 * Binkey, a Mini binary keyboard
 * Use an Arduino Micro or similar for this.
 * Needs the Adafruit NeoPixel library, and Paul Stoffregen's Encoder library
 * Credit for the HID code belongs to Konstantin Schauwecker, and "qwelyt" - https://github.com/qwelyt/Keyboard/tree/master/Code/ModuleA/V2/ModuleA
 * 
 * Copyright (c) 2020, Hans Liss
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 * 
 * 1. Redistributions of source code must retain the above copyright notice, this
 *    list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#include <Adafruit_NeoPixel.h>
#include <Encoder.h>

#include "KeyboardLib.h"

#define LED_PIN 13
#define LED_COUNT 8

Adafruit_NeoPixel strip(LED_COUNT, LED_PIN, NEO_RGB + NEO_KHZ800);

long vals[LED_COUNT];
long oldvals[LED_COUNT];

#define BTN0_PIN 11        // buttons included on shield
#define BTN1_PIN 3        // these are Arduino pin numbers
#define BTNEnter_PIN 6
#define BTNBS_PIN 9
#define BTNEnc_PIN 2

#define ENCPin1 0
#define ENCPin2 1

#define BTN0 0
#define BTN1 1
#define BTNEnter 2
#define BTNBS 3
#define BTNEnc 4

const int buttons[] = { BTN0_PIN, BTN1_PIN, BTNEnter_PIN, BTNBS_PIN, BTNEnc_PIN};

Encoder knob(ENCPin1, ENCPin2);

int reg[2];
#define REGCOUNT (sizeof(reg)/sizeof(int))
float regcol[] = {0.65, 0.2, 0.52, 0.12, 0.38, 0.86, 0};

#define MAXVAL 1024

void setup() {
  strip.begin();           // INITIALIZE NeoPixel strip object (REQUIRED)
  strip.show();            // Turn OFF all pixels ASAP
  strip.setBrightness(100); // Set BRIGHTNESS much lower than max (255) since these LEDS are Mighty Powderful.
  initButtons();
  initKeyboard();
  for (int i = 0; i < REGCOUNT; i++) {
    reg[i] = 0;
  }
  showReg(reg[0], regcol[0]);
  Serial.begin(9600);
  while(!Serial) {
    ;
  }
}

void showReg(int reg, float color) {
  for (int i=0; i<8; i++) {
    // Make the leds show a dim color even on 0, so we know which register
    // is active.
    vals[i] = (reg & (1 << i))?MAXVAL:MAXVAL/3;
  }
  setLEDs(vals, color);
}


void loop() {
  boolean updateLEDs=false;
  // The current register
  static int regind = 0;
  // We need an offset for the knob value, since we want to be able to
  // reset all the registers and switch to the first keycode register - 
  // but we can't affect the current knob value. Thus, we use the offset
  // to register the current knob value upon reset.
  static int regoffs = 0;
  long knobValue;
  static long oldKnobValue=(knob.read() >> 2);
  readButtons();
  // Shift in a "1"
  if (hasButtonPressEvent(BTN0)) {
    reg[regind] = (reg[regind] << 1) & 0xFF;
    updateLEDs=true;
  }
  // Shift in a "0"
  if (hasButtonPressEvent(BTN1)) {
    reg[regind] = ((reg[regind] << 1) | 1) & 0xFF;
    updateLEDs=true;
  }
  // Shift right
  if (hasButtonPressEvent(BTNBS)) {
    reg[regind] >>= 1;
    updateLEDs=true;
  }
  // Encoder button resets all the registers and switches to the first
  // keycode register.
  if (hasButtonPressEvent(BTNEnc)) {
    for (int i=0; i<REGCOUNT; i++) {
      reg[i] = 0;
    }
    updateLEDs = true;
    regind = 0;
    regoffs = oldKnobValue;
  }
  // Read the knob and switch register as requested
  knobValue=(knob.read() >> 2);
  if (knobValue != oldKnobValue) {
    oldKnobValue=knobValue;
    regind = knobValue - regoffs;
    while (regind < 0) {
      regind += REGCOUNT;
    }
    regind = regind % REGCOUNT;
    Serial.println("regind=" + String(regind));
    updateLEDs = true;
  }
  // If anything has changed, update the LEDs
  if (updateLEDs) {
    showReg(reg[regind], regcol[regind]);
  }
  // On Enter, send - first the Modifiers' Down events, then the Key Down event,
  // then wait a bit and then do the Up events in reverse order.
  if (hasButtonPressEvent(BTNEnter)) {
    showReg(reg[0], 1);
    sendCode(0, reg[REGCOUNT-1]);
    for (int i=0; i < REGCOUNT-1; i++) {
      sendCode(reg[i], reg[REGCOUNT-1]);
    }
    delay(20);
    sendCode(0, reg[REGCOUNT-1]);
    sendCode(0, 0);
    showReg(reg[regind], regcol[regind]);
  }
  delay(10);
}

#pragma region "LED code"

void setLEDs(long *vals, float color) {
  int i;
  for (i=0; i < LED_COUNT; i++) {
    float H = color;//(float)vals[i]/MAXVAL;
    float V = (float)vals[i]/MAXVAL;
    float S = 1;
    int R, G, B;
    hsv2rgb(H,S,V,&R,&G,&B);
    uint32_t color = strip.Color(R, G, B);
    strip.setPixelColor(i, strip.gamma32(color));
  }
  strip.show();
}

// Convert hue/saturation/brightness values [0,1] to R/G/B values [0,255]
void hsv2rgb(float H,float S,float V,int *R,int *G,int *B)
{
  int i;
  float f,p,q,t;
  H = H*6;
  if (H>=6)
    H-=6;
  i=H;
  f=H-(float)i;
  p=V*(1.0-S);
  q=V*(1.0-(S*f));
  t=V*(1.0-(S*(1.0-f)));

  switch(i)
    {
    case 0: (*R)=V*255; (*G)=t*255; (*B)=p*255; break;
    case 1: (*R)=q*255; (*G)=V*255; (*B)=p*255; break;
    case 2: (*R)=p*255; (*G)=V*255; (*B)=t*255; break;
    case 3: (*R)=p*255; (*G)=q*255; (*B)=V*255; break;
    case 4: (*R)=t*255; (*G)=p*255; (*B)=V*255; break;
    case 5: (*R)=V*255; (*G)=p*255; (*B)=q*255; break;
    }
}

#pragma endregion "LED code"

#pragma region "Button handling code"

#define NBUTTONS (sizeof(buttons)/sizeof(int))
int buttonState[NBUTTONS];
boolean isButtonRead[NBUTTONS];
int lastButtonState[NBUTTONS];
int lastDebounceTime[NBUTTONS];
unsigned long debounceDelay = 10;    // the debounce time; increase if the output flickers

void readButton(int bNo) 
{
  int reading = digitalRead(buttons[bNo]);
  // If the switch changed, due to noise or pressing:
  if (reading != lastButtonState[bNo]) 
  {
    // reset the debouncing timer
    lastDebounceTime[bNo] = millis();
  }

  if ((millis() - lastDebounceTime[bNo]) > debounceDelay) 
  {
    // whatever the reading is at, it's been there for longer than the debounce
    // delay, so take it as the actual current state:

    // if the button state has changed:
    if (reading != buttonState[bNo]) 
    {
      buttonState[bNo] = reading;
      isButtonRead[bNo] = false;
    }
  }
  lastButtonState[bNo] = reading;
}

void readButtons() {
  for (int i = 0; i < NBUTTONS; i++) {
    readButton(i);
  }
}

void initButtons() {
  for (int i = 0; i < NBUTTONS; i++) {
    pinMode(buttons[i], INPUT_PULLUP);
    buttonState[i] = HIGH;
    lastButtonState[i] = HIGH;
    isButtonRead[i] = true;
  }
}

boolean hasButtonPressEvent(int bNo) {
  if (buttonState[bNo] == LOW && !isButtonRead[bNo]) {
    isButtonRead[bNo] = true;
    return true;
  }
  else {
    return false;
  }
}

#pragma endregion "Button handling code"

#pragma region "HID code"

const byte keyLimit = 6;
byte keyPlace = 0;
uint8_t keyBuf[keyLimit];
uint8_t meta = 0x0;
void addKeyToBuffer(uint8_t key) {
  keyBuf[keyPlace++] = key;
  if (keyPlace == keyLimit) {
    sendBuffer(meta, keyBuf);
  }
}

void sendCode(int code, int metaIn) {
  addKeyToBuffer(code);
  meta = metaIn;
  sendRest();
}

void sendRest() {
  bool shouldSend = false;
  for (byte b = 0; b < keyLimit; ++b) {
    if (keyBuf[b] != 0x0) {
      shouldSend = true;
    }
  }
  //if (shouldSend) {
    sendBuffer(meta, keyBuf);
  //}
}

void sendBuffer(uint8_t meta, uint8_t keyBuf[]) {
  sendKeyBuffer(meta, keyBuf);
  resetKeys();
}

void resetKeys() {
  for (byte b = 0; b < keyLimit; ++b) {
    keyBuf[b] = 0x0;
  }
  keyPlace = 0;
  meta = 0x0;
}

#pragma endregion "HID code"
