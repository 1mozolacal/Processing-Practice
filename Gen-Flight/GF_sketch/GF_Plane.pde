final float maxThrush = 0.5;
final float maxTurn = 0.2;
final float maxBack = 0.25;//this is a percentage
final float slowDownRateConstant = 0.99;
final float slowDownRateAcceleration = 0.9;
final float radius = 10;
final float sightAngle = 120;
final int sightNumber = 25;
final float sightDistane = 350;

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
  float score = 0;
  float timeSinceHighVel = -1;
  float timeSinceScoreInc = -1;
  
  //debugging
  boolean firstRun = true;
  
  PlaneBrain brain;
  
  Plane(){
     brain = new PlaneBrain();
  }
  
  Plane(Plane parnet){
    brain = new PlaneBrain(parnet.getBrain());
  }
  
  Plane(Plane dad, Plane mom){
    brain = new PlaneBrain(dad.getBrain(), mom.getBrain() );
  }
  
  void checkSightLines(Map mapRef){
    float[] returnSightLines = mapRef.updataPlaneSight(this);
    float[] networkInput = new float[inputLayerLength];
    networkInput[0] = (position.x)/(mapRef.getWidth());
    networkInput[1] = (position.y)/(mapHeight*mapRef.getUnitLength());
    networkInput[2] = (float) (atan(velocity.x)*2.0/PI);
    networkInput[3] = (float) (atan(velocity.y)*2.0/PI);
    for(int i = nonSightInput; i <inputLayerLength;i++){
      networkInput[i] = returnSightLines[i-nonSightInput];
    }
    brain.setInputLayer(networkInput);
    brain.computeNet();
  }
  
  void aiFly(Map mapRef){
    checkSightLines(mapRef);
    Double[] output = brain.readOutputAsArray();
    int lowest = 0;
    Double lowestValue = output[0];
    for(int i =1; i< output.length; i++){
      if(output[i]<lowestValue){
        lowestValue = output[i];
        lowest = i;
      }
    }
    fly(fightDir.values()[lowest],mapRef);
    
  }
  
  void fly(fightDir dir, Map mapRef){
    
    if(timeSinceHighVel == -1){
     timeSinceHighVel = millis(); 
    } else {
      if(velocity.mag() > 0.25){
       timeSinceHighVel = millis(); 
      }
      if(millis() - timeSinceHighVel > 3000){
        this.crash();
      }
    }
    
    
    if(!alive){
      return;
    }
    
    if(velocity.mag()!=0){
      heading = velocity.copy().normalize();
    }
    PVector copy = heading.copy();
    
    //float turnCorrector = atan(max(velocity.mag()-0.1,0));//stops very fast turns at close to no speed
    float turnAngle = HALF_PI/2.0;
    
    if(dir == fightDir.forward){
      velocity.add(copy.mult(maxThrush) );
      velocity.mult(slowDownRateAcceleration);
    }else if(dir == fightDir.left){
      float velMagToMantain = velocity.mag();
      velocity.add(copy.rotate(-turnAngle).mult(velMagToMantain*maxTurn ));
      velocity.normalize();
      velocity.mult(velMagToMantain);
    }else if(dir == fightDir.right){
      float velMagToMantain = velocity.mag();
      velocity.add(copy.rotate(turnAngle).mult(velMagToMantain*maxTurn ));
      velocity.normalize();
      velocity.mult(velMagToMantain);
    }else if(dir == fightDir.back){
      copy.rotate(PI).mult(maxThrush*maxBack);
      if(copy.mag() > velocity.mag() ){
        velocity.set(0,0);
      }
      else{
       velocity.add(copy); 
      }
    }
    velocity.mult(slowDownRateConstant);//constant slow down - 5% decrease in speed 
    
    //debugging arrow
    //stroke(0);
    //strokeWeight(10);
    //copy.normalize();
    //line(position.x,position.y, position.x + copy.x*30, position.y +copy.y*30);
    
    position.add(velocity);
    
    mapRef.checkHit(this);
    
    drawPlane();
    
    
    float currentScore = position.x/mapRef.getUnitLength();
    if(currentScore>score){
      if( (int)currentScore != (int)score){
        timeSinceScoreInc = millis();//update time during an integar increase
      }
     score=currentScore; 
    }
    if(timeSinceScoreInc == -1){
      timeSinceScoreInc = millis();
    }
    if(millis()-timeSinceScoreInc > 5000){
     this.crash(); 
    }
  }//end of fly function
  
  void drawPlane(){
    noStroke();
    if(firstRun){
      fill(255,0,0,75);
    } else {
      fill(0,255,0,75);
    }
    position.x-= drawShift;
    PVector front = PVector.add(position, heading.copy().normalize().mult(radius) );
    PVector left = PVector.add(position, heading.copy().normalize().rotate(PI*3.0/4.0).mult(radius) );
    PVector right = PVector.add(position, heading.copy().normalize().rotate(-PI*3.0/4.0).mult(radius) );
    
    triangle(front.x,front.y, left.x,left.y, right.x,right.y );
    
    
    //draw sight lines - debugging
    /*
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
    */
    //end of sight line debugger
    
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
  
  boolean isAlive(){
   return alive; 
  }
  
  float getScore(){
   return score; 
  }
  
  PlaneBrain getBrain(){
   return brain; 
  }
  
  void complete(float timeLeft, float timeTotal){
    float timeTaken = timeTotal-timeLeft;
    score*= (timeTotal/timeTaken);
    this.crash();
  }
  
  void crash(){
   if(!alive){ return;}
   alive = false; 
   planeDied();
   
   firstRun = false;
  }
  
  void newRound(){
    score = 0;
    alive = true;
    velocity = new PVector(0,0);
    heading = new PVector(1,0);
    position = new PVector(150,250);
    timeSinceHighVel = -1;
    timeSinceScoreInc = -1;
    
    
  }
  
  void setShift(float set){
    drawShift = set;
  }
  
}