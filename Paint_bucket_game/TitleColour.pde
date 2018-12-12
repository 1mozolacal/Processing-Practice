class TitleColour{
  int[][] colour = { {0,255,0},{0,0,255},{255,0,0},{255,90,0},{255,255,0},{0,255,255},{255,0,255} };
  int colourNum;
  
  TitleColour(int num){
    colourNum = num;
  }
  
  
  int getColourNum(){
    return colourNum;
  }
  
  void setColour(int newColour){
    colourNum = newColour;
  }
  
  
  void fillThis(){
    
    fill(colour[colourNum][0],colour[colourNum][1],colour[colourNum][2]);
  }
  
}