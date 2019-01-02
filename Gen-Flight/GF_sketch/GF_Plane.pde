final float maxThrush = 0.5;
final float maxTurn = 0.4;
final float maxBack = 0.25;
final float slowDownRateStart = 0.97;
final float slowDownRateIncrease = 0.002;
final float radius = 10;
final float sightAngle = 120;
final int sightNumber = 21;
final float sightDistane = 150;

public enum fightDir{
  forward,left,right,back,coast
}

class Plane{
  boolean alive = true;
  boolean humanDriven = false;
  PVector velocity = new PVector(0,0);
  PVector heading = new PVector(1,0);
  PVector position = new PVector(150,250);
  float drawShift = 0;
  PlaneBrain brain;
  
  Plane(){
     brain = new PlaneBrain();
  }
  
  
  void checkSightLines(Map mapRef){
    float[] returnSightLines = mapRef.updataPlaneSight(this);
    float[] networkInput = new float[inputLayerLength];
    networkInput[0] = atan(position.x);
    networkInput[1] = atan(position.y);
    networkInput[2] = atan(velocity.x);
    networkInput[3] = atan(velocity.y);
    for(int i = nonSightInput; i <inputLayerLength;i++){
      networkInput[i] = returnSightLines[i-nonSightInput];
    }
    brain.setInputLayer(networkInput);
    brain.computeNet();
  }
  
  void fly(fightDir dir, Map mapRef){
    
    if(!alive){
      return;
    }
    
    if(velocity.mag()!=0){
      heading = velocity.copy().normalize();
    }
    PVector copy = heading.copy();
    
    float turnCorrector = atan(max(velocity.mag()-0.1,0));//stops very fast turns at close to no speed
    float turnAngle = HALF_PI*5/6.0;
    
    if(dir == fightDir.forward){
      velocity.add(copy.mult(maxThrush) );
    }else if(dir == fightDir.left){
      velocity.add(copy.rotate(-turnAngle).mult(maxThrush*maxTurn*turnCorrector ));
    }else if(dir == fightDir.right){
      velocity.add(copy.rotate(turnAngle).mult(maxThrush*maxTurn*turnCorrector ));
    }else if(dir == fightDir.back){
      copy.rotate(PI).mult(maxThrush*maxBack);
      if(copy.mag() > velocity.mag() ){
        velocity.add(copy);
        velocity.rotate(PI);  
      }
      else{
       velocity.add(copy); 
      }
    }
    velocity.mult(slowDownRateStart-slowDownRateIncrease*velocity.mag());//constant slow down - 1% decrease in speed 
    
    //debugging arrow
    //stroke(0);
    //strokeWeight(10);
    //copy.normalize();
    //line(position.x,position.y, position.x + copy.x*30, position.y +copy.y*30);
    
    position.add(velocity);
    
    mapRef.checkHit(this);
    
    drawPlane();
    checkSightLines(mapRef);
    
    
  }//end of fly function
  
  void drawPlane(){
    noStroke();
    fill(255,0,0,125);
    position.x-= drawShift;
    PVector front = PVector.add(position, heading.copy().normalize().mult(radius) );
    PVector left = PVector.add(position, heading.copy().normalize().rotate(PI*3.0/4.0).mult(radius) );
    PVector right = PVector.add(position, heading.copy().normalize().rotate(-PI*3.0/4.0).mult(radius) );
    
    triangle(front.x,front.y, left.x,left.y, right.x,right.y );
    
    //draw sight lines
    stroke(0,0,0,50);
    PVector sightLine = new PVector(sightDistane,0);
    sightLine.rotate( heading.heading() ) ;
    if(sightNumber%2==1){//is even
      line(position.x,position.y, position.x + sightLine.x, position.y+sightLine.y);
    }
    for(int i=0;i<(int)sightNumber/2;i++){
      float rot = (PI/180.0) *( (sightAngle/2.0) - i * ((sightAngle/2.0)/((int)sightNumber/2)) );
      sightLine.rotate(rot);
      line(position.x,position.y, position.x + sightLine.x, position.y+sightLine.y);
      sightLine.rotate(-2*rot);
      line(position.x,position.y, position.x + sightLine.x, position.y+sightLine.y);
      sightLine.rotate(rot);
    }
    
    position.x += drawShift;
    
  }
  
  void drawBrian(float x,float y, float wid, float hei){
    brain.visualize(x,y,wid,hei);
  }
  
  PVector[] getSightLines(){
    
    PVector[] returnPVec = new PVector[(int)sightNumber];
    
    PVector sightLine = new PVector(sightDistane,0);
    sightLine.rotate( heading.heading() ) ;
    if(sightNumber%2==1){//is even
      returnPVec[(int)sightNumber-1] = sightLine.copy();
    }
    for(int i=0;i<(int)sightNumber/2;i++){
      float rot = (PI/180.0) *( (sightAngle/2.0) - i * ((sightAngle/2.0)/((int)sightNumber/2)) );
      sightLine.rotate(rot);
      returnPVec[i*2] = sightLine.copy();
      sightLine.rotate(-2*rot);
      returnPVec[i*2+1] = sightLine.copy();
      sightLine.rotate(rot);
    }
    
    return returnPVec;
  }
  
  
  PVector getPos(){
    return position; 
  }
  
  PVector getHeading(){
    return heading;
  }
  
  float getRadius(){
    return radius;
  }
  
  float getSightDist(){
   return sightDistane; 
  }
  
  void crash(){
   alive = false; 
   print("crash");
  }
  
  void setShift(float set){
    drawShift = set;
  }
  
}