
void setup(){
  fullScreen(2);//second screen if connected
  PlaneBrain test = new PlaneBrain();
  Double[] temp = {-1d,0.2d,0.5d,-0.4d,1d};
  test.setInputLayer(temp  );
  test.computeNet();
  test.visualize(0,0,900,900);
  
  triangle(100,100,0,0,0,200);
}

Plane testPlane = new Plane();


void draw(){
  background(100);
  if(keyPressed){
    if(key == 'a' ){
      testPlane.fly(fightDir.left);
    } else if(key == 's'){
      testPlane.fly(fightDir.back);
    } else if(key == 'd'){
      testPlane.fly(fightDir.right);
    } else if(key == 'w'){
      testPlane.fly(fightDir.forward);
    } else{
      testPlane.fly(fightDir.coast);  
    }
  } else {
    testPlane.fly(fightDir.coast);
  }
  testPlane.drawPlane();
  //testing
  
  
  //testing
  
}