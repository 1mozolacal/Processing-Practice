//This is an animation of times tables in a circular pattern( Modulo Multiplication Circle) 
//inspiration: https://www.youtube.com/watch?v=qhbuKbxJsk8

int density =1000;//Numbers of points around the circle
double multiplier = 0;
double increaseAmount = 0.01;
ArrayList<PVector> points = new ArrayList<PVector>();

//sizing
PVector fullScreen = new PVector(800,600);
PVector drawScreen = new PVector(600,600);

//UI
float[] boxesHeights= {0,0};
float[] boxesYPos ={0,0};

void setup(){
  size(800,600);
  frameRate(20);
  initPointList();
}

void draw(){
  background(200);
  drawBlankCircle();
  drawLines();
  drawUI();
  multiplier+=increaseAmount;
  
  /*//makes it go back a forth
  if(multiplier>1){
  increaseAmount = - abs((float)increaseAmount);  
  } else if(multiplier<-1){
   increaseAmount = abs((float)increaseAmount);
  }
  */
}

void drawBlankCircle(){
  noStroke();
  fill(0);
  rect(0,0,drawScreen.x,drawScreen.y);
  
  fill(125);
  for(int i = 0; i< density; i++){
    ellipse(points.get(i).x,points.get(i).y,5,5);
  }
  
}

void drawLines(){
  stroke(255,0,0);
  for(int i = 0; i<density;i++){
    int otherPoint = abs((int)(i*multiplier))%density; 
    line(points.get(i).x,points.get(i).y,points.get(otherPoint).x,points.get(otherPoint).y);
  }
}

void drawUI(){
    float oneUnitThickness = 10;
    float y = 0;
    textSize(12);
    fill(0,0,255);
    y+=oneUnitThickness;
    text("Multipler:"+ multiplier, drawScreen.x, y);
    y+=oneUnitThickness;
    text("Increase Amount:"+ (float)increaseAmount, drawScreen.x, y);
    y+=oneUnitThickness/2.0;
    noStroke();
    rect(drawScreen.x,y,(fullScreen.x-drawScreen.x)/2.0,oneUnitThickness*4,10);
    rect(drawScreen.x+(fullScreen.x-drawScreen.x)/2.0,y,(fullScreen.x-drawScreen.x)/2.0,oneUnitThickness*4,10);
    boxesHeights[0] = oneUnitThickness*4;
    boxesYPos[0] = y;
    fill(255);
    textSize(20);
    text("-", drawScreen.x+(fullScreen.x-drawScreen.x)*0.25, y+oneUnitThickness*2);
    text("+", drawScreen.x+(fullScreen.x-drawScreen.x)*0.75, y+oneUnitThickness*2);
    y+=oneUnitThickness*5;
    fill(0,0,255);
    textSize(12);
    text("Density:"+ density, drawScreen.x, y);
    y+=oneUnitThickness/2.0;
    noStroke();
    rect(drawScreen.x,y,(fullScreen.x-drawScreen.x)/2.0,oneUnitThickness*4,10);
    rect(drawScreen.x+(fullScreen.x-drawScreen.x)/2.0,y,(fullScreen.x-drawScreen.x)/2.0,oneUnitThickness*4,10);
    boxesHeights[1] = oneUnitThickness*4;
    boxesYPos[1] = y;
    fill(255);
    textSize(20);
    text("-", drawScreen.x+(fullScreen.x-drawScreen.x)*0.25, y+oneUnitThickness*2);
    text("+", drawScreen.x+(fullScreen.x-drawScreen.x)*0.75, y+oneUnitThickness*2);
}

void initPointList(){
  points.clear();
  float radius = (drawScreen.x * 0.9)/2.0f;
  for(int i = 0; i< density; i++){
    double rad = i * 2*Math.PI/float(density);
    float cirX = (float)(drawScreen.x/2 - radius*Math.cos(rad) );
    float cirY = (float)(drawScreen.x/2 + radius*Math.sin(rad) );
    points.add(new PVector(cirX,cirY) );
  }
}

void mouseClicked(){
  
  if(mouseY> boxesYPos[0] && mouseY<boxesYPos[0]+boxesHeights[0]){//Increase amount
    if(mouseX>drawScreen.x){
      if(mouseX<drawScreen.x + (fullScreen.x-drawScreen.x)/2.0 ){//minus
        increaseAmount-=0.01+abs((float)increaseAmount*0.2);
        //if(increaseAmount<0){ increaseAmount=0;}
      }else {//plus
        increaseAmount+=0.01+abs((float)increaseAmount*0.2);
      }
    }
  } else if(mouseY> boxesYPos[1] && mouseY<boxesYPos[1]+boxesHeights[1]){//Density
    if(mouseX>drawScreen.x){
      if(mouseX<drawScreen.x + (fullScreen.x-drawScreen.x)/2.0 ){//minus
        density-=10+density*0.05;
        if(density<10){density=10;}
      }else {//plus
        density+=10+density*0.05;
      }
      initPointList();
    }
  }
  
}