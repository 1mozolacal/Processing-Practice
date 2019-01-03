Map testMap;
Plane[] airForce = new Plane[1];

void setup(){
  
  fullScreen(2);//second screen if connected
  PlaneBrain test = new PlaneBrain();
  //Double[] temp = {-1d,0.2d,0.5d,-0.4d,1d};
  //test.setInputLayer(temp  );
  test.computeNet();
  test.visualize(0,0,700,700);
  
  testMap = new Map(0,0,width*0.75,height,150);
  testMap.testDrawlines();
  

  for(int i=0; i< airForce.length;i++){
    airForce[i] = new Plane();
  }
  
  delay(500);
}

boolean firstRun = true;
float testScroll = 0;
Plane testPlane = new Plane();


void draw(){
  println(frameRate);
  if(firstRun){
    testPlane.setHumanControl(true);
    firstRun =false;
    delay(500);
  }
  background(255);
  
  testPlane.drawBrian(width*0.75,0,width*0.25,height*0.5);
  
  float shift = testMap.shiftToLeader(testPlane.getPos().x);
  testPlane.setShift(shift);
  
  testMap.drawMap();
  testScroll++;
  
  for(int i =0; i < airForce.length;i++){
    airForce[i].setShift(shift);
    airForce[i].aiFly(testMap);
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
  
}