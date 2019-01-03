Map testMap;
int numberOfPlanes = 325;
ArrayList<Plane> airForce = new ArrayList<Plane>();
int generation = 0;
float runTimeLeft = 0;
float rountTimePerUnit = 0.05;
float lastTime = -1;
boolean runOnGoing = true;


void setup(){
  fullScreen(2);//second screen if connected
  PlaneBrain test = new PlaneBrain();
  //Double[] temp = {-1d,0.2d,0.5d,-0.4d,1d};
  //test.setInputLayer(temp  );
  test.computeNet();
  test.visualize(0,0,700,700);
  
  testMap = new Map(0,0,width*0.75,height,150);
  testMap.testDrawlines();
  
  runTimeLeft = rountTimePerUnit * testMap.getTrackLength();
  
  for(int i=0; i< numberOfPlanes;i++){
    airForce.add(new Plane() );
  }
  
  delay(500);
}

boolean firstRun = true;
float testScroll = 0;
Plane testPlane = new Plane();



void draw(){
  if(firstRun){
    firstRun =false;
    delay(500);
  }
  background(255);

  testPlane.drawBrian(width*0.75,0,width*0.25,height*0.5);
  
  
  
  
  testMap.drawMap();
  float shift = testMap.shiftToLeader(airForce);
  testPlane.setShift(shift);
  
  if(runOnGoing){
    for(int i =0; i < airForce.size();i++){
      airForce.get(i).setShift(shift);
      airForce.get(i).aiFly(testMap);
    }
  }
  //testPlane.aiFly(testMap);
  //background(100);
  
  if(keyPressed){
    if(key == 'a' ){
      testPlane.fly(fightDir.left,testMap);
    } else if(key == 's'){
      testPlane.fly(fightDir.back,testMap);
    } else if(key == 'd'){
      testPlane.fly(fightDir.right,testMap);
    } else if(key == 'w'){
      testPlane.fly(fightDir.forward,testMap);
    } else{
      testPlane.fly(fightDir.coast,testMap);  
    }
  } else {
    testPlane.fly(fightDir.coast,testMap);
  }
  
  createUI(width*0.75,height*0.5,width*0.25,height*0.5);
}

void createUI(float x, float y, float wid, float hei){
  fill(0,125,255);
  rect(x,y,wid,hei);
  
  stroke(0);
  fill(0);
  float textSpace = hei*0.05;
  textSize(textSpace);
  text("Gen:" + generation, x + wid*0.1,y + textSpace);
  if(runOnGoing){
    if(lastTime != -1){
      runTimeLeft-= millis()/1000.0 - lastTime;
      if(runTimeLeft<=0){
        generation++;
        lastTime = -1;
        runOnGoing=false;
        runTimeLeft = rountTimePerUnit * testMap.getTrackLength();
        newGen();
      }
    }
    lastTime = millis()/1000.0;
  }
  text("Time Left:" + runTimeLeft, x + wid*0.1,y + textSpace*2);
}

void newGen(){
  Plane[] discards = new Plane[numberOfPlanes/2];
  for( Plane plane: airForce){
    int spot = -1;
    for(int i =0; i<discards.length;i++){
      if(discards[i] == null){
       spot = i;
       break;
      }
      else if(plane.getScore() < discards[i].getScore()){
       spot = i;
       break;
      }
    }
    if(spot!= -1){
     for(int i = discards.length-1;i >spot;i--){
       discards[i] = discards[i-1];
     }
     discards[spot] = plane;
    }
    
  }
  
  for(Plane removeThis: discards){
    airForce.remove(removeThis);
  }
  
  Plane[] newBorns = new Plane[numberOfPlanes/2];
  for(int i =0; i < (int)(numberOfPlanes/2); i++){
    double methodRandomizer = Math.random();
    Plane newBorn;
    if(methodRandomizer>0.5){//two parnet method
      newBorn = new Plane(airForce.get((int) (Math.random()*airForce.size())), airForce.get((int) (Math.random()*airForce.size())) );
    }else {//one parnet method
      newBorn = new Plane(airForce.get((int) (Math.random()*airForce.size())) );
    }
    newBorns[i] = newBorn;
  }
  
  for(Plane addThis:newBorns){
   airForce.add(addThis); 
  }
  
  //reset the planes
  for(Plane plane: airForce){
   plane.newRound(); 
  }
  runOnGoing = true;
  
}