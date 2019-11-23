Map testMap;
int numberOfPlanes = 525;
int numberOfPlanesAlive = numberOfPlanes;
float highestScore = 0;
float leaderScore = 0;
ArrayList<Plane> airForce = new ArrayList<Plane>();
int generation = 0;
float runTimeLeft = 0;
float rountTimePerUnit = 0.4;
float lastTime = -1;
boolean runOnGoing = true;

String loadMap = "GFMapmaze";//"no" for not loading the map, the name of the map if you want to load it **Map need to be in the map folder**

void setup(){
  fullScreen(2);//second screen if connected
  PlaneBrain test = new PlaneBrain();
  //Double[] temp = {-1d,0.2d,0.5d,-0.4d,1d};
  //test.setInputLayer(temp  );
  test.computeNet();
  test.visualize(0,0,700,700);
  
  if(!loadMap.equals("no")){
    String[] loadedMap = loadStrings("maps/"+loadMap+ ".txt");
    int trackLen = Integer.parseInt(loadedMap[0]);
    testMap = new Map(0,0,width*0.75,height,trackLen);
    for(int i =1; i < loadedMap.length;i++){
      String[] obsInfo = loadedMap[i].split(",");
      testMap.addObject(Integer.parseInt(obsInfo[0]),Integer.parseInt(obsInfo[1]),Integer.parseInt(obsInfo[2]),Integer.parseInt(obsInfo[3]));
    }
  } else{
    testMap = new Map(0,0,width*0.75,height,150);
  }
  
  
  //testMap.testDrawlines();
  
  runTimeLeft = rountTimePerUnit * testMap.getTrackLength();
  
  for(int i=0; i< numberOfPlanes;i++){
    airForce.add(new Plane() );
  }
  
  
}

boolean firstRun = true;
float testScroll = 0;
Plane testPlane = new Plane();



void draw(){
  if(firstRun){
    firstRun =false;
    delay(100);
  }
  background(255);

  
  
  
  
  
  testMap.drawMap();
  Object[] leaderInfo = testMap.shiftToLeader(airForce);
  testPlane.setShift((float)leaderInfo[0]);
  if(leaderInfo[1] !=null){
    leaderScore = ((Plane)leaderInfo[1]).getScore(); 
    if(leaderScore>highestScore){
     highestScore = leaderScore; 
    }
    ((Plane)leaderInfo[1]).drawBrian(width*0.75,0,width*0.25,height*0.5);
  }
  
  
  if(runOnGoing){
    for(int i =0; i < airForce.size();i++){
      airForce.get(i).setShift((float)leaderInfo[0]);
      airForce.get(i).aiFly(testMap);
    }
  }
  //testPlane.aiFly(testMap);
  //background(100);
  /*
  testPlane.drawBrian(width*0.75,0,width*0.25,height*0.5);
  testPlane.checkSightLines(testMap);
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
  }*/
  
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
        newGen();
      }
    }
    lastTime = millis()/1000.0;
  }
  text("Time Left:" + runTimeLeft, x + wid*0.1,y + textSpace*2);
  text("Alive:" + numberOfPlanesAlive, x + wid*0.1,y + textSpace*3);
  text("Leader score:" + leaderScore, x + wid*0.1,y + textSpace*4);
  text("Highest Score:" + highestScore, x + wid*0.1,y + textSpace*5);
}

void newGen(){
  generation++;
  lastTime = -1;
  runOnGoing=false;
  runTimeLeft = rountTimePerUnit * testMap.getTrackLength();
  numberOfPlanesAlive = numberOfPlanes;
  highestScore = 0;
  
  int killAmount = (int) (numberOfPlanes*0.8);
  Plane[] rankLowToHigh = new Plane[airForce.size()];
  for( Plane plane: airForce){
    int spot = -1;
    for(int i =0; i<rankLowToHigh.length;i++){
      if(rankLowToHigh[i] == null){
       spot = i;
       break;
      }
      else if(plane.getScore() < rankLowToHigh[i].getScore()){
       spot = i;
       break;
      }
    }
    if(spot!= -1){
     for(int i = rankLowToHigh.length-1;i >spot;i--){
       rankLowToHigh[i] = rankLowToHigh[i-1];
     }
     rankLowToHigh[spot] = plane;
    }
    
  }
  
  for(int i = 0; i<killAmount; i++){
    airForce.remove(rankLowToHigh[i]);
  }
  
  Plane[] newBorns = new Plane[killAmount];
  int bellAmount = 2;
  for(int i =0; i < newBorns.length; i++){
    double methodRandomizer = Math.random();
    Plane newBorn;
    if(methodRandomizer<0.1){//two parnet method removed for debugging 
      int randomDad = (int)(killAmount-1 + (rankLowToHigh.length - killAmount) * (1-pow((float)Math.random(),bellAmount)) );
      int randomMom = (int)(killAmount-1 + (rankLowToHigh.length - killAmount) * (1-pow((float)Math.random(),bellAmount)) );
      newBorn = new Plane(rankLowToHigh[randomDad], rankLowToHigh[randomMom] );
    }else {//one parnet method
      float variation = 1 - pow((float)Math.random(),bellAmount);
      int pick = (int)(killAmount-1 + (rankLowToHigh.length - killAmount) * variation );
      newBorn = new Plane(rankLowToHigh[pick] );
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

void planeDied(){
  if(numberOfPlanesAlive <= 1){
   newGen(); 
  }else{
    numberOfPlanesAlive--;
  }
  
}