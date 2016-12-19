#ifndef Tile_H
#define Tile_H

class Tile {
  public:
    int id;
    //Adafruit_NeoPixel p;
    int total;
    boolean state;
    void init (int _id, int _total) {
      id = _id;
      total = _total;
      state = false;
    };
    void returnState(){
      Serial.print(id);
      Serial.print(" : ");
      Serial.println(state);
    }
};
#endif
