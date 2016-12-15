class Board {
  
  Tile[][] tiles;
  Hunter pOne;
  Hunter pTwo;
  
  int rows; 
  int columns;
  int posX;
  int posY;
  int boardWidth;
  int boardHeight;
  
  Board(int rows, int columns, int posX, int posY, int boardWidth, int boardHeight) {
    this.rows = rows;
    this.columns = columns;
    this.posX = posX;
    this.posY = posY;
    this.boardWidth = boardWidth;
    this.boardHeight = boardHeight;
    tiles = new Tile[rows][columns];
  }
  
  void createTiles() {
    for(int i = 0; i < matrixRows; i++) {
      for(int j = 0; j < matrixColumns; j++){
        if(boolean(boardMatrix[i][j])) {
          tiles[i][j] = new Tile(i, j, tileSize);
        } else {
          tiles[i][j] = new Tile();
        }
      }
    }
  }
  
  void highlightPossibleMoves(int row, int column) {
    //check up, right, down and left
    PVector[] moves = new PVector[5];
    if(row - 1 >= 0) moves[0] = new PVector(row-1, column);
    else moves[0] = new PVector(-1, -1);
    if(column + 1 <= this.columns - 1) moves[1] = new PVector(row,column + 1);
    else moves[1] = new PVector(-1, -1);
    if(row + 1 <= this.rows - 1) moves[2] = new PVector(row + 1,column);
    else moves[2] = new PVector(-1, -1);
    if(column - 1 >= 0) moves[3] = new PVector(row,column-1);
    else moves[3] = new PVector(-1, -1);
    
    moves[4] = new PVector(row,column);
    
    highlightTiles(moves);
  }
  
  void highlightTiles(PVector[] tiles) {
    int x, y;
    for(int i = 0; i < tiles.length; i++) {
      x = int(tiles[i].x);
      y = int(tiles[i].y);
      if(x != -1 && y != -1) this.tiles[x][y].highlight();
    }
  }
  
  PVector indexFromPos(int x, int y) {
    int column = -1;
    int row = -1;
    if((x > this.posX && x < this.posX + this.boardWidth) &&
       (y > this.posY && y < this.posY + this.boardHeight)) {
      column = (x - this.posX)/ tileSize;
      row = (y - this.posY)/ tileSize;
      if(!tiles[row][column].active) {
        column = -1;
        row = -1;
      }
    }
    return new PVector(row, column);
  }
  
  boolean tileActive(int row, int column) {
    if(row < this.rows && column < this.columns) return tiles[row][column].active;
    else return false;
  }
  
  void display() {
    stroke(bgColor);
    fill(tileColor);
    for(int i = 0; i < this.rows; i++) {
      for(int j = 0; j < this.columns; j++){
        if(tiles[i][j].active) {
          tiles[i][j].update();
          tiles[i][j].display();
        }
      }
    }   
  }
}