//The Hunt game
//12-12-2016

import processing.sound.*;

/******** STATE MACHINE ********/
int machineState;
final int GAME_RESET = 0;
final int GAME_START = 1;
final int PLAYER_SELECT = 2;
final int PLAYER_MOVE_WAIT = 3;
final int MOVE_CHECK = 4;
final int GAME_OVER = 5;
final int SCREEN_SAVER = 6;

/******** BOARD ********/ 
Board board;
int matrixRows = 9;
int matrixColumns = 11;
int canvasWidth;
int canvasHeight;
int[][] boardMatrix = { {0,0,0,0,0,1,1,0,0,0,0},
                        {0,0,0,0,0,1,1,1,0,0,0},
                        {0,0,0,1,1,1,1,1,1,0,0},
                        {0,1,1,1,1,1,1,1,1,0,0},
                        {1,1,1,1,1,1,1,1,1,1,1},
                        {0,0,1,1,1,1,1,1,1,1,0},
                        {0,0,1,1,1,1,1,1,0,0,0},
                        {0,0,0,1,1,1,0,0,0,0,0},
                        {0,0,0,0,1,1,0,0,0,0,0}};


/******** PLAYERS ********/ 
Hunter pOne;
Hunter pTwo;

/******** MECHANICS ********/
Hunter playerTurn;
Token movingPlayer;
Prey movingPrey;
Hunter movingHunter;
int playerWin = -1;
int maxDistBetweenPlayers;
int minDistBetweenPlayers;

boolean clickInput = false;
boolean enterKeyInput = false;

/******** STYLING ********/ 
final int tileSize = 70; 
final int pSize = 40;
//color order goes: pOneColor, pTwoColor, pOneHighlightColor, pTwoHighlightColor, tileColor, bgColor, accentColor
final color[] palette1 = {color(79, 98, 173),
                          color(242, 106, 121),
                          color(213,193,185),
                          color(237,187,179),
                          color(238, 201, 186),
                          color(230, 231, 232),
                          color(255, 255, 255)};
                 
final color[] palette2 = {color(0),
                          color(242, 106, 121),
                          color(188, 190, 192),
                          color(213, 195, 199),
                          color(209, 211, 212),
                          color(241, 242, 242),
                          color(255)};
final int tileHighlightInterval = 1000;
final int playerBlinkInterval = 80;
final int preyMaxFadeInterval = 150;
final int preyMinFadeInterval = 10;
final float prayFadeSpeed = 0.1;
color pOneColor, pTwoColor, pOneHighlightColor, pTwoHighlightColor, tileColor, bgColor, accentColor;
color highlightColor;
PFont mainFont;
PFont secondFont;

/******** SOUNDS ********/ 
SoundFile bgSound;
SoundFile selectSound;
SoundFile hoverSound;
SoundFile moveSound;
SoundFile winSound;
SoundFile wrongSound;
/****************/

void setup() {
  size(1200, 800);
  createBoard();
  createTokens();
  maxDistBetweenPlayers = distBetweenPlayers(pOne.pos, pOne.prey.pos); 
  minDistBetweenPlayers = 1;
  
  setPalette(palette2);
  secondFont = createFont("Intro.otf", 32);
  mainFont = createFont("Intro Inline.otf", 32);
  textFont(mainFont);
  
  sounds();
  bgSound.loop();
  bgSound.play();
  bgSound.amp(0.2);
  
  machineState = GAME_RESET;
}

void draw() {
  background(bgColor);
  
  switch(machineState) {
    
    case GAME_RESET:
      resetGame();
      machineState = GAME_START;
      break;
    
    case GAME_START:
      drawBoard();
      drawStartScreen();
      if(startGame()) {
        delay(500);
        machineState = PLAYER_SELECT;
      }
      break;
      
    case PLAYER_SELECT:
      checkReset();
      drawBoard();
      drawTokens();
      drawStats();
      if(playerSelect()) {
        selectSound.play();
        machineState = PLAYER_MOVE_WAIT; 
      }
      break;
      
    case PLAYER_MOVE_WAIT:
      checkReset();
      drawBoard();
      drawTokens();
      drawStats();
      if(clickOnSameSpot()) {
        selectSound.play();
        machineState = PLAYER_SELECT;      
      } else if(playerMove()) {
        if(playerWin != -1) {
          winSound.play();
          machineState = GAME_OVER;
        } else {
          moveSound.play();
          nextPlayer();
          machineState = PLAYER_SELECT;
        }
      }
      break;
      
    case GAME_OVER:
      drawGameOverScreen();
      if(startGame()) machineState = GAME_RESET;
      delay(200);
      break;
  }
}

void sounds() {
  bgSound = new SoundFile(this, "soundtrack.mp3");
  selectSound = new SoundFile(this, "select.wav");
  hoverSound = new SoundFile(this, "hover.wav");
  moveSound = new SoundFile(this, "move.wav");
  winSound = new SoundFile(this, "win2.wav");
  wrongSound = new SoundFile(this, "wrong.wav");
}

void setPalette(color[] palette) {
  if(palette.length == 7) {
    pOneColor = palette[0];
    pTwoColor = palette[1];
    pOneHighlightColor = palette[2];
    pTwoHighlightColor = palette[3]; 
    tileColor = palette[4];
    bgColor = palette[5];
    accentColor = palette[6];  
  }
}

void resetGame() {
  playerWin = -1;
  createTokens();
  highlightColor = pOneHighlightColor;
}

boolean checkReset() {
  if(enterKeyInput) {
    enterKeyInput = false;
    resetGame();
    return true;
  }
  
  return false;
}

void mousePressed() {
   clickInput = true;
}

void keyPressed() {
  if (keyCode == ENTER) {
    enterKeyInput = true;    
  } 
}

void createBoard() {
  board = new Board(matrixRows, 
                    matrixColumns, 
                    (width - tileSize * matrixColumns) / 2, 
                    (height - tileSize * matrixRows) / 2, 
                    tileSize * matrixColumns, tileSize * matrixRows);
  board.createTiles();
}

void createTokens() {
  pOne = new Hunter(3, 1, pSize, 1);
  pOne.createPrey(5, 9);
  pTwo = new Hunter(6, 2, pSize, 2);
  pTwo.createPrey(2, 8);
  playerTurn = pOne;
}

boolean startGame() {
  if(clickInput || enterKeyInput) {
    clickInput = false;
    enterKeyInput = false;
    return true;
  }
  else return false;
}

void drawBoard() {
  board.display(); 
}

void drawTokens() {
  int distPlayerPrey;
  int preyFadeInterval;
  
  distPlayerPrey = distBetweenPlayers(pTwo.pos, pOne.prey.pos);
  preyFadeInterval = int(map(distPlayerPrey, minDistBetweenPlayers, maxDistBetweenPlayers, preyMinFadeInterval, preyMaxFadeInterval));
  pOne.prey.fadeInterval = preyFadeInterval;
  
  distPlayerPrey = distBetweenPlayers(pOne.pos, pTwo.prey.pos);
  preyFadeInterval = int(map(distPlayerPrey, minDistBetweenPlayers, maxDistBetweenPlayers, preyMinFadeInterval, preyMaxFadeInterval));
  
  pTwo.prey.fadeInterval = preyFadeInterval;
  
  pOne.display();
  pOne.prey.display();
  pTwo.display();
  pTwo.prey.display();
}

void drawStartScreen() {
  float x = width * 0.5;
  float y = height * 0.5;
  fill(200,200,200,150);
  textAlign(CENTER);
  fill(0);
  textFont(mainFont, 160);
  text("THE HUNT", x, y);
  textFont(secondFont, 50);
  text("START GAME", x, y + 80);
}

void drawGameOverScreen() {
  float x = width * 0.5;
  float y = height * 0.5;
  if(playerWin == 1) {
    fill(pOneColor);
  } else {
    fill(pTwoColor);
  }
  rect(0, 0, width, height);
  fill(200,200,200,150);
  textAlign(CENTER);
  fill(accentColor);
  textFont(mainFont, 100);
  text("PLAYER " + playerWin + " WON", x, y + 20);
}

void drawStats() {
  float x = 50;
  float y = height - 50;
  if(playerTurn.player == 1) fill(pOneColor);
  else fill(pTwoColor);
  ellipse(x, y, 30, 30);
  fill(0);
  textAlign(LEFT);
  textFont(secondFont, 20);
  text("Turn: Player " + playerTurn.player, x + 30, y + 8);
}

boolean playerSelect() {
  PVector pos;
  boolean select = false;
  PVector[] highlightTiles = new PVector[2];
  Hunter selectedHunter;
 
  if(playerTurn.player == 2) selectedHunter = pTwo;
  else selectedHunter = pOne;
  
  if(clickInput) {
    pos = board.indexFromPos(mouseX, mouseY);
    if(pos.x == selectedHunter.pos.x && pos.y == selectedHunter.pos.y) {
      movingHunter = selectedHunter;
      movingPrey = null;
      select = true;
    } else if(pos.x == selectedHunter.prey.pos.x && pos.y == selectedHunter.prey.pos.y) {
      movingPrey = selectedHunter.prey;
      movingHunter = null;
      select = true;
    }
    
    if(!select) {
      highlightTiles[0] = new PVector(selectedHunter.pos.x, selectedHunter.pos.y);
      highlightTiles[1] = new PVector(selectedHunter.prey.pos.x, selectedHunter.prey.pos.y);
      board.highlightTiles(highlightTiles);
      wrongSound.play();
    } else {
      if(movingHunter != null) movingHunter.select(true);
      else if(movingPrey != null) movingPrey.select(true);
    }
    clickInput = false;
  }
  return select;
}

boolean clickOnSameSpot() {
  PVector newPos;
  boolean sameSpot = false;
  Token movingPlayer = playerTurn;
  
  if(movingHunter != null) movingPlayer = movingHunter;
  else if(movingPrey != null) movingPlayer = movingPrey;
  
  if(clickInput) {
    newPos = board.indexFromPos(mouseX, mouseY);
    if(newPos.x == movingPlayer.pos.x && newPos.y == movingPlayer.pos.y) {
      movingPlayer.select(false);
      sameSpot = true;
      clickInput = false;
    } 
  }
  
  return sameSpot;
}

boolean playerMove() {
  PVector newPos;
  boolean move = false;
  Token movingPlayer = playerTurn;
  
  if(clickInput) {
    newPos = board.indexFromPos(mouseX, mouseY);
    if (newPos.x >= 0 && newPos.y >= 0) {
      if(movingHunter != null) {
        move = moveHunter(movingHunter, int(newPos.x), int(newPos.y));
        movingPlayer = movingHunter;
      } else if(movingPrey != null) {
        move = movePrey(movingPrey, int(newPos.x), int(newPos.y));
        movingPlayer = movingPrey;
      }
    }
    if(!move) {
      board.highlightPossibleMoves(int(movingPlayer.pos.x), int(movingPlayer.pos.y));
      wrongSound.play();
    }
    clickInput = false;
  }
  
  return move;
}

boolean movePlayer(Token player, int toRow, int toColumn) {
  boolean move = false;
  
  println("From " + int(player.pos.x) + ", " + int(player.pos.y));
  println("To " + toRow + ", " + toColumn);
  println();
  
  if(board.tileActive(toRow,toColumn)) {
    if(playerCollision(player, toRow, toColumn)) move = false;
    else move = player.move(toRow, toColumn);
  }
  return move;
}

boolean moveHunter(Hunter hunter, int toRow, int toColumn) {
  boolean move = false;
  int rowSteps, columnSteps;
  int preyColumn, preyRow;
  
  rowSteps = int(toRow - hunter.pos.x);
  columnSteps = int(toColumn - hunter.pos.y);
  
  println("Hunter move");
  move = movePlayer(hunter, toRow, toColumn);
  
  if(move) {
    //move prey in the opposite direction
    preyRow = int(hunter.prey.pos.x + rowSteps * -1);
    preyColumn = int(hunter.prey.pos.y + columnSteps * -1);
    //prey and hunter cannot be in the same position
    if(!(preyRow == toRow && preyColumn == toColumn)) movePrey(hunter.prey, preyRow, preyColumn);
  }
  return move;
}

boolean movePrey(Prey player, int toRow, int toColumn) {
  println("Prey move");
  return movePlayer(player, toRow, toColumn);
}

boolean playerCollision(Token player, int r, int c) {
  boolean collide = false;
  
  if((player.equals(pOne) && collide(pTwo.prey, r, c)) || (player.equals(pTwo.prey) && collide(pOne, r, c))) playerWin = 1;
  else if((player.equals(pTwo) && collide(pOne.prey, r, c)) || (player.equals(pOne.prey) && collide(pTwo, r, c))) playerWin = 2;
  else if(collide(pOne, r, c) || collide(pTwo, r, c) || collide(pOne.prey, r, c) || collide(pTwo.prey, r,c)) {
    collide = true;
  }
  
  return collide;
}

boolean collide(Token p1, int row, int column) {
  return p1.pos.x == row && p1.pos.y == column;
}

void nextPlayer() { 
  playerTurn.select(false);
  playerTurn.prey.select(false);
  playerTurn = playerTurn.player == 1? pTwo : pOne;
  if(playerTurn.player == 1) {
    highlightColor = pOneHighlightColor;
  } else {
    highlightColor = pTwoHighlightColor;
  }
}

int distBetweenPlayers(PVector p1, PVector p2) {
  return int(abs(p1.x - p2.x) + abs(p1.y - p2.y)); 
}