

class GameField{
  
  int titleWidth;
  int pxWidth;
  int titleHeight;
  int pxHeight;
  float xRef;
  float yRef;
  ArrayList titles = new ArrayList();
  int colourRange;
  
  
  GameField(float x,float y,int wid,int hei,int size,int colours){
    xRef = x;
    yRef = y;
    pxWidth = wid;
    pxHeight = hei;
    titleWidth = size;
    titleHeight = size;
    colourRange = colours;
    
    initTitles();
  }
  
  void initTitles(){
    for(int i = 0; i < titleWidth * titleHeight; i++){
      titles.add( new Title( (int) (Math.random()*colourRange) ,this , i%titleWidth,i/titleWidth) );
    }
  }
  
  boolean isValidCord(int x, int y){
    if(x<titleWidth && x>-1 && y<titleHeight && y>-1){
      return true;
    }
    return false;
  }
  
  Title getTitle(int x,int y){
    if(x>=titleWidth || y>=titleHeight){
      println("ERR: requested a title not on the board");
      Title errReturn = new Title(0, this,-1,-1);
      return errReturn;
    }
    return (Title) titles.get(y*titleWidth + x);
  }
  
  void paintColour(int num){
    
    
    Title origin = (Title)  titles.get(0);
    origin.paint(num);
    
    drawBoard();
    
    for(int i =0; i < titles.size(); i++){
      Title temp = (Title) titles.get(i);
      temp.resetPaintedRound();
    }
  }
  
  void drawBoard(){
    for(int i =0; i < titles.size(); i++){
      Title temp = (Title) titles.get(i);
      temp.drawTitle(xRef,yRef,pxWidth/titleWidth,pxHeight/titleHeight);
    }
  }
  
  void restart(){
    titles.clear();
    initTitles();
    drawBoard();
  }
  
  boolean checkWin(){
    Title tempOrigin = (Title) titles.get(0);
    int originColour = tempOrigin.colour.getColourNum();
    for(int i =0; i < titles.size(); i++){
      Title temp = (Title) titles.get(i);
      if(temp.colour.getColourNum() != originColour){
        return false;
      }
    }
    return true;
  }
  
}
  