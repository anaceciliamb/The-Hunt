#include "Tile.h"
#include <Keypad.h>
#include <Adafruit_NeoPixel.h>
#ifdef __AVR__
#include <avr/power.h>
#endif

const byte ROWS = 3; //four rows
const byte COLS = 3; //three columns
char keys[ROWS][COLS] = {
  {'1', '2', '3'},
  {'4', '5', '6'},
  {'7', '8', '9'},
};

byte rowPins[ROWS] = {2, 3, 4}; //connect to the row pinouts of the keypad
byte colPins[COLS] = {A0, A1, A2}; //connect to the column pinouts of the keypad

Keypad keypad = Keypad( makeKeymap(keys), rowPins, colPins, ROWS, COLS );

int const pinLed = 10;
int const numTiles = 9;
Tile t[numTiles];
Adafruit_NeoPixel pixels = Adafruit_NeoPixel(numTiles * 2, pinLed, NEO_GRB + NEO_KHZ800);

void setup() {
  Serial.begin(9600);
  //keypad.addEventListener(keypadEvent);
  pixels.begin();
  for (int i = 0; i < numTiles; i++) {
    t[i].init(i, numTiles * 2);
  }
}

void loop() {
  char key = keypad.getKey();
  if (key) {
    //Serial.println(key);
    switch (key) {
      case '1':
        t[0].state = !t[0].state;
        break;
      case '2':
        t[1].state = !t[1].state;
        break;
      case '3':
        t[2].state = !t[2].state;
        break;
      case '4':
        t[3].state = !t[3].state;
        break;
      case '5':
        t[4].state = !t[4].state;
        break;
      case '6':
        t[5].state = !t[5].state;
        break;
      case '7':
        t[6].state = !t[6].state;
        break;
      case '8':
        t[7].state = !t[7].state;
        break;
      case '9':
        t[8].state = !t[8].state;
        break;
    }
  }

  for (int i = 0; i < numTiles; i++) {
    t[i].returnState();
    if (t[i].state == true) {
      pixels.setPixelColor(i * 2, pixels.Color(255, 255, 255));
      pixels.setPixelColor((i * 2) + 1, pixels.Color(255, 255, 255));
      pixels.show();
    } else {
      pixels.setPixelColor(i * 2, pixels.Color(0, 0, 0));
      pixels.setPixelColor((i * 2) + 1, pixels.Color(0, 0, 0));
      pixels.show();
    }
  }
}


