# binkey
A binary USB keyboard

You'll need an Arduino Micro or similar, a nice solution for the USB cable. I cheated and built my own Atmega32U4 PCB and used a scavenged keyboard cable but you might want to do it differently.

The box (binkeybox.scad) is designed for Cherry MX keyswitches, with a "0" and "1" key, a vertical straight 2U Enter key and a horizontal straight 2U Backspace key. PLA works fine for this and you probably don't need very high resolution.

Use eight WS2812D-F5 addressable RGB LEDs, and print 16 collars (LEDring.scad) on a resin printer.

I drilled a 7mm hole for the rotary encoder, and I can't be bothered to add this hole to the design.

For the rest: Use The Source, Luke!