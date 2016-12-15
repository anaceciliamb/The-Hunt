class Tile {
  PVector index;
  PVector xyPos;
  boolean active;
  int size;
  boolean hover;
  boolean highlight;
  int highlightInterval;
  long highlightTimer;
  
  Tile(int row, int column, int size) {
    index = new PVector(row, column);
    this.size = size;
    this.active = true;
    hover = false;
    xyPos = new PVector(board.posX + this.index.y * this.size, board.posY + this.index.x * this.size);
    highlightInterval = tileHighlightInterval;
  }
  
  Tile() {
    this.active = false;
  }
  
  void display() {
    stroke(bgColor);    
    if(highlight) fill(highlightColor);
    else if(hover) fill(highlightColor);
    else fill(tileColor);
    
    rect(this.xyPos.x, this.xyPos.y, this.size, this.size);
  }
  
  void update() {
    hoverEvent();
    if(millis() - highlightTimer >= highlightInterval) highlight = false;
  }
  
  void hoverEvent() {
    if(mouseX > this.xyPos.x && mouseX < this.xyPos.x + this.size &&
       mouseY > this.xyPos.y && mouseY < this.xyPos.y + this.size) {
      if(!hover) hoverSound.play();
      hover = true;
    } else hover = false;
  }
  
  void highlight() {
    //start timer to highlight the tile for HIGHLIGHTINTERVAL ms
    if(this.active) {
      highlightTimer = millis();
      highlight = true;
    }
  }
}