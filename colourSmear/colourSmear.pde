//Calvin Mozola
//Color smear from top line

int pxlDensity = 0;
int[][] paintablePxl;
String deviceInput = "";
PVector[] colourVal = new PVector[3];

void setup(){
  fullScreen(2);
  //size(500,500);
  
  background(150);
  fill(200,200,255);
  rect(width/10,height/10,width/5,height/10);
  rect(width/4*3,height/2,width/5,height/10);
  textSize(height/10);
  fill(0);
  text("Go",width/4*3,height/2+height/10);
  colourVal[0] = new PVector(width/10,height/4);
  colourVal[1] = new PVector(width/10,height/4+height/20);
  colourVal[2] = new PVector(width/10,height/4+height/10);
  
  drawColourSelector();
}

void draw(){
  
  
}

void mousePressed(){
  if(inRange(mouseX, width/10, width/10+width/5) && inRange(mouseY,height/10,height/5)){
    deviceInput = "number";
    drawDensitySelector();
    println("hi");
  } else if(inRangeInclusive(mouseX,width/10,width/10+width/2) && inRangeInclusive((int)mouseY,(int)colourVal[0].y-height/120,(int)colourVal[2].y+height/60)){
    int colourChanging = (int) (3*(mouseY-(colourVal[0].y-height/120))/( (colourVal[2].y+height/60) - (colourVal[0].y-height/120) + 1 ) );
    colourVal[colourChanging].x = mouseX;
    drawColourSelector();  
  } else if(inRange(mouseX, width/4*3, width/4*3+width/5) && inRange(mouseY,height/2,height/2+height/5) && pxlDensity != 0){
    genPxlFlow();
  }
  
}

void mouseDragged(){
  if(inRangeInclusive(mouseX,width/10,width/10+width/2) && inRangeInclusive((int)mouseY,(int)colourVal[0].y-height/120,(int)colourVal[2].y+height/60)){
    int colourChanging = (int) (3*(mouseY-(colourVal[0].y-height/120))/( (colourVal[2].y+height/60) - (colourVal[0].y-height/120) + 1 ) );
    colourVal[colourChanging].x = mouseX;
    drawColourSelector();  
  } else if(mouseY> 2*height/3.0 && pxlDensity>1){
    int point = mouseX;
    if(mouseX>width){
      point = width;
    }
    int pxlSelected = (int)(pxlDensity*point/(float)width);
    if(pxlSelected<0){
      pxlSelected=0;
    } else if(pxlSelected == pxlDensity){
      pxlSelected--;
    }
    paintablePxl[pxlSelected][0] = (int)(255*(colourVal[0].x-width/10)/(width/2));//width/2 is barwidth
    paintablePxl[pxlSelected][1] = (int)(255*(colourVal[1].x-width/10)/(width/2));//width/2 is barwidth
    paintablePxl[pxlSelected][2] = (int)(255*(colourVal[2].x-width/10)/(width/2));//width/2 is barwidth
    drawPaintableBottomRow();
  }
  
}

void drawPaintableBottomRow(){
 if(pxlDensity>0){
   for(int i =0; i <pxlDensity;i++){
     fill(paintablePxl[i][0],paintablePxl[i][1],paintablePxl[i][2]);
     noStroke();
     rect(width/(float)pxlDensity*i , 2*height/3.0, width/(float)pxlDensity,height/3.0);
   }
 }
}

void drawDensitySelector(){
  if(deviceInput.equals("number")){
    fill(100,100,255);
  }else {  
    fill(200,200,255);
  }
  stroke(0);
  rect(width/10,height/10,width/5,height/10);
  fill(0);
  textSize(height/10);
  text(pxlDensity,width/10,height/5);
  
}

void drawColourSelector(){
  noStroke();
  int barThick = height/60;
  int barWidth = width/2;
  int boarder = (width+height)/120;
  fill(200,200,255);
  rect(width/10-boarder,colourVal[0].y-boarder,barWidth+2*boarder,colourVal[2].y-colourVal[0].y+boarder*2);
  fill(255,100,100);
  rect(width/10,colourVal[0].y-barThick/2,barWidth,barThick);
  fill(255,0,0);
  ellipse(colourVal[0].x,colourVal[0].y,barThick*2,barThick*2);
  fill(100,255,100);
  rect(width/10,colourVal[1].y-barThick/2,barWidth,barThick);
  fill(0,255,0);
  ellipse(colourVal[1].x,colourVal[1].y,barThick*2,barThick*2);
  fill(100,100,255);
  rect(width/10,colourVal[2].y-barThick/2,barWidth,barThick);
  fill(0,0,255);
  ellipse(colourVal[2].x,colourVal[2].y,barThick*2,barThick*2);
  int colour[] = new int[3];
  for(int i =0; i<3;i++){
    colour[i] = (int)(255*(colourVal[i].x-width/10)/(barWidth));
  }
  fill(colour[0],colour[1],colour[2]);
  rect(width/4*3,height/5,width/5,height/5);
}

void keyPressed(){
  if(deviceInput.equals("number")){
    boolean updata = true;
    if(inRangeInclusive(keyCode,48,57) && pxlDensity<100){
      pxlDensity = pxlDensity*10 + keyCode-48;
    } else if(inRangeInclusive(keyCode,96,105) && pxlDensity<100){
      pxlDensity = pxlDensity*10 + keyCode-96;
    }else if(keyCode==8 || keyCode ==127){
      pxlDensity /= 10;
    } else {
      updata = false;
    }
    if(updata){
      drawDensitySelector();
      paintablePxl = new int[pxlDensity][3];
      for(int i = 0; i<pxlDensity;i++){
        paintablePxl[i][0] = 0;
        paintablePxl[i][1] = 0;
        paintablePxl[i][2] = 0;
      }
      drawPaintableBottomRow();
    }
  }
}

boolean inRange(float inQuestion, float min, float max){
  if(inQuestion > min && inQuestion < max){
    return true;
  }
  return false;
  
}


boolean inRangeInclusive(int inQuestion, int min, int max){
  if(inQuestion >= min && inQuestion <= max){
    return true;
  }
  return false;
}


void genPxlFlow(){  
  float heightShrink =5;
  float pxlWid = width/(float)pxlDensity;
  float pxlHei = heightShrink*height/((float)pxlDensity);
  for(int row=0; row < pxlDensity/heightShrink; row++){
    for(int pxl=0; pxl<pxlDensity; pxl++){
      //fillPxlColour(pxl,row);
      PVector tempCol = fillPxlColourAndReturn(pxl,row);
      stroke(tempCol.x,tempCol.y,tempCol.z);
      strokeWeight(1);
      rect(pxlWid*pxl,pxlHei*row,pxlWid,pxlHei);
    }
  }
  
}

void fillPxlColour(int x, int y){
  PVector ran = getTopRange(x,y);
  PVector col = averageColour(ran);
  fill(col.x,col.y,col.z);
}
PVector fillPxlColourAndReturn(int x, int y){
  PVector ran = getTopRange(x,y);
  PVector col = averageColour(ran);
  fill(col.x,col.y,col.z);
  return new PVector(col.x,col.y,col.z);
}

PVector averageColour(PVector range){
  PVector sumColour = new PVector(0,0,0);
  for(int i = (int)range.x; i<=range.y; i++){
    sumColour.x +=paintablePxl[i][0];
    sumColour.y +=paintablePxl[i][1];
    sumColour.z +=paintablePxl[i][2];
  }
  sumColour.div(range.y-range.x);
  return sumColour;
}

PVector getTopRange(int x,int y){
  int lowest = x-y;
  int highest = x+y;
  if(lowest<0){
    lowest =0;
  }
  if(highest>=pxlDensity){
    highest= pxlDensity-1;
  }
  return new PVector(lowest,highest);
}