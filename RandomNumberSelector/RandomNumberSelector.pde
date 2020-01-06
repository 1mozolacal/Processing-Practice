//This is a project to visulize different method and getting standard distrubtion like random method
//This is beging used to develp a better random selector for Gen-Fight

int rangeG=100;
int amountToPlotG=10;//multiple of range

void setup(){
 
  //top 2/3 of screen will be visulized of graph
  //bottom 1/3 will be settings
  size(600,600); 
  
}


void draw(){
  
  drawSettings();
}


void drawSettings(){
  
  fill(100,150,255);
  noStroke();
  rect(0,(height/3)*2,width,height/3);
  
  int numberOfMethods=3;
  for(int i =0; i<numberOfMethods;i++){
    if(mouseX>i*width/numberOfMethods && mouseX< (i+1)*width/numberOfMethods  && mouseY>(height/6) *5){
      fill(255,150,0);
      if(mousePressed){
       randomPlot(i); 
      }
    } else {
      fill(255,100,0);
    }
    rect(i*width/numberOfMethods,(height/6)*5,width/numberOfMethods,height/6 ,20 );
  }
  
}

void randomPlot(int methodSelector){
 int []dataToPlot = null;
  switch(methodSelector){
 case 0:
 dataToPlot = defaultRanGen(rangeG,amountToPlotG);
 break;
 case 1:
 dataToPlot = secondRanGen(rangeG, amountToPlotG);
 break;
 case 2:
 break;
 }
 
 visulize(rangeG,dataToPlot);
}


void visulize(int range, int []data){
  if(data==null){
    println("DATA IS NULL:" + millis() );
    return;
  }
  fill(150);
  rect(0,0,width,height/3.0 * 2); 
  
  int highestFrequency = 0;
  for(int i =0; i<data.length;i++){
    if(data[i]>highestFrequency){
     highestFrequency=data[i];
    }
  }
  for(int i =0; i<data.length;i++){
   float barWidth = width/ (float)range  ;
   float barHeight =( height/3.0 * 2 )*(0.8 * data[i]/(float)highestFrequency);
   
   fill(255,0,0);
   stroke(0);
   rect(barWidth*i, ( height/3.0 * 2 ) - barHeight, barWidth, barHeight);
    
  }
}

int[] defaultRanGen(int range, int amount){
  int []counter=new int[range*amount];
  for(int i =0; i< (counter.length); i++){
    int value= (int)(range*Math.pow((float)Math.random(),2));
    //println( "increasing " + value + " from " + counter[value] );
    counter[value]++;
  }
  
  return counter;
}

int[] secondRanGen(int range, int amount){
  int []counter=new int[range*amount];
  for(int i =0; i< (counter.length); i++){
    int value= secondRanHelper(0,range-1);
    //println( "increasing " + value + " from " + counter[value] );
    counter[value]++;
  }
  
  return counter;
}


int secondRanHelper(int min, int max){
  if(max == min){
    return min;
  }
  if( Math.random() >0.8){
    return secondRanHelper(min, (int) ((min+max)/2) );
  }
  return secondRanHelper((int) ((min+max)/2) ,max );
}