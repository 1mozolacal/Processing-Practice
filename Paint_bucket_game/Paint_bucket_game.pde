//Calvin Mozola
int sizeOfGrid = 10;//min 2
int numberOfColours = 7;//max 7
int maxAttemps = 30;

//10-30

GameField game;
final int menuWidth =100;
int currentAttemps;
boolean gameOn = true;

void setup(){
  size(500,500);
  //fullScreen(1);//the number is the monitor number
  if(numberOfColours > 7){
    numberOfColours = 7;
  }
  if(sizeOfGrid<2){
    sizeOfGrid = 2;
  }
  currentAttemps = maxAttemps;
  
  game = new GameField(0,0,width-menuWidth,height,sizeOfGrid,numberOfColours);
  background(0);
  game.drawBoard();
  drawMenu();
}

void draw(){
  
}

void drawMenu(){
  stroke(0);
  strokeWeight(5);
  float tempHeightBoxes = height/numberOfColours;
  for(int i = 0; i<numberOfColours; i++){
    TitleColour temp = new TitleColour(i);
    temp.fillThis();
    rect(width-menuWidth + menuWidth*0.1, i * tempHeightBoxes + tempHeightBoxes*0.1,menuWidth*0.6,tempHeightBoxes*0.8);
  }
  drawAttemps();
}

void drawAttemps(){
  stroke(0);
  strokeWeight(2);
  float tempHeightBoxes = height/(float)maxAttemps;
  for(int i =1; i<maxAttemps+1;i++){
    if(i<=currentAttemps){
      fill(255,0,0);
    } else {
      fill(200,200,200);
    }
    rect(width-menuWidth + menuWidth*0.8,height- i*tempHeightBoxes, menuWidth*0.2,tempHeightBoxes  );
  }
}

void mousePressed() {
  if(gameOn){
    Title tempOrigin = (Title) game.titles.get(0);
    if(mouseX>width-menuWidth && tempOrigin.colour.getColourNum() != ( mouseY / (height/numberOfColours) ) ){
       game.paintColour( mouseY / (height/numberOfColours) );
       currentAttemps--;
       drawAttemps();
       if(game.checkWin()){
         println(currentAttemps);
         gameOn = false;
         background(0);
         fill(0,150,255);
         noStroke();
         ellipse(width/2,height/2,width/3,height/3);
         fill(0);
         textAlign(CENTER);
         text("Congradulation!\nPlay again?",width/2,height/2);
       } else if(currentAttemps==0){
         gameOn = false;
         background(0);
         fill(0,150,255);
         noStroke();
         ellipse(width/2,height/2,width/3,height/3);
         fill(0);
         textAlign(CENTER);
         text("Game Over, Restart",width/2,height/2);
       }
    }
  } else {
    if( sq(mouseX-width/2) + sq(mouseY-height/2) < sq(width/6) ){
      currentAttemps = maxAttemps;
      drawMenu();
      game.restart();
      gameOn = true;
    }
  }
  
}