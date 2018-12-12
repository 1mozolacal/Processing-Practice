class Title{
  TitleColour colour;
  GameField board;
  boolean paintedThisRound = false;
  int x;
  int y;
  
  Title(int num, GameField gameBoard,int xi,int yi){
    colour = new TitleColour(num);
    board = gameBoard;
    x = xi;
    y = yi;
  }
  
  void resetPaintedRound(){
    paintedThisRound = false;
  }
  
  void paint(int paintNum){
    if(paintedThisRound){
      return;
    }
    paintedThisRound = true;
    
    if(board.isValidCord(x+1,y)){
      board.getTitle(x+1,y).paint(paintNum, colour.getColourNum() );
    }
    if(board.isValidCord(x,y+1)){
      board.getTitle(x,y+1).paint(paintNum, colour.getColourNum() );
    }
    
    colour.setColour(paintNum);
  }
  
  void paint(int paintNum, int paintOrigin){
    if(paintedThisRound){
      return;
    }
    paintedThisRound = true;
    
    if(colour.getColourNum() != paintOrigin){
      return;
    }
    
    if(board.isValidCord(x+1,y)){
      board.getTitle(x+1,y).paint(paintNum, paintOrigin );
    }
    if(board.isValidCord(x,y+1)){
      board.getTitle(x,y+1).paint(paintNum, paintOrigin );
    }
    if(board.isValidCord(x-1,y)){
      board.getTitle(x-1,y).paint(paintNum, paintOrigin );
    }
    if(board.isValidCord(x,y-1)){
      board.getTitle(x,y-1).paint(paintNum, paintOrigin );
    }
    
    colour.setColour(paintNum);
  }
  
  void drawTitle(float boardX,float boardY,int widthi,int heighti){
    colour.fillThis();
    noStroke();
    rect(boardX + x *widthi, boardY + y*heighti, widthi, heighti);
  }
  
}