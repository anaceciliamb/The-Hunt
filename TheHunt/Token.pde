class Token {
  PVector pos;
  int size;
  int player;
  color playerColor;
  color selectedColor;
  color playerTempColor;
  boolean selected;
  long blinkTimeStamp;
  int blinkInterval;
  boolean win;
  
  Token(int x, int y, int size, int player) {
    this.pos = new PVector(x, y);
    this.size = size;
    this.player = player;
    if(player == 1) {
      playerColor = pOneColor;
    } else {
      playerColor = pTwoColor;
    }
    selectedColor = accentColor;
    playerTempColor = playerColor;
    win = false;
  }
  
  boolean move(int row, int column){
    if(((column - this.pos.y == 1 || column - this.pos.y == -1) && row - this.pos.x == 0) || 
       ((row - this.pos.x == 1 || row - this.pos.x == -1) && column - this.pos.y == 0)) {
      setPos(row, column);
      return true;
    } else {
      return false;
    }
  }
  
  void setPos(int row, int column) {
    this.pos.x = row;
    this.pos.y = column;
  }
  
  void select(boolean selected) {
    this.selected = selected;
    if(!selected) {
      playerTempColor = playerColor;      
    }
    else {
      playerTempColor = accentColor;
    }
  }
  
  void display() {
    noStroke();
    fill(playerTempColor);
    ellipse(board.posX + this.pos.y * tileSize + tileSize/2, board.posY + this.pos.x * tileSize + tileSize/2, this.size, this.size);
  }
}