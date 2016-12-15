class Prey extends Token {
  long fadeTimeStamp;
  int fadeInterval;
  float fadeIncrement;
  float fadeSpeed;
  color blinkColor;
  
  Prey(int x, int y, int size, int player){
    super(x, y, size, player);
    this.fadeSpeed = prayFadeSpeed;
    this.fadeInterval = preyMaxFadeInterval;
    if(player == 1) blinkColor = pOneHighlightColor;
    else blinkColor = pTwoHighlightColor;
    reset();
  }
  
  void update() {
    color temp = playerColor;
    color blinkTemp = blinkColor;
    if(selected) {
      temp = accentColor;
      blinkTemp = tileColor;
    }
    if(millis() - fadeTimeStamp >= fadeInterval) {
      this.fadeIncrement += this.fadeSpeed;
      this.fadeSpeed = this.fadeIncrement > 1 || this.fadeIncrement < 0.1 ? this.fadeSpeed * -1 : this.fadeSpeed;
      playerTempColor = lerpColor(temp, blinkTemp, fadeIncrement);
      fadeTimeStamp = millis();
    }
  }
  
  void display() {
    this.update();
    super.display();
  }
  
  void reset() {
    fadeInterval = preyMaxFadeInterval;
    fadeIncrement = random(0.1, 1);
    fadeTimeStamp = millis();
  }
}