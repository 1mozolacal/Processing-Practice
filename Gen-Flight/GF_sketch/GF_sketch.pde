Map testMap;

void setup(){
  fullScreen(2);//second screen if connected
  PlaneBrain test = new PlaneBrain();
  Double[] temp = {-1d,0.2d,0.5d,-0.4d,1d};
  test.setInputLayer(temp  );
  test.computeNet();
  test.visualize(0,0,900,900);
  
  testMap = new Map(0,0,width*0.75,height,150);
  testMap.testDrawlines();
  
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
  float shift = testMap.shiftToLeader(testPlane.getPos().x);
  testPlane.setShift(shift);
  
  testMap.drawMap();
  testScroll++;
  
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
  testPlane.drawPlane();
    
}