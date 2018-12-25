final float maxThrush = 0.5;
final float maxTurn = 0.4;
final float maxBack = 0.25;
final float slowDownRateStart = 0.97;
final float slowDownRateIncrease = 0.002;
final float radius = 10;
final float sightAngle = 0;
final float sightNumber = 0;
final float sightDistane = 0;

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
  
  Plane(){
     
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
    
    //constant slow down
    velocity.mult(slowDownRateStart-slowDownRateIncrease*velocity.mag());//1% decrease in speed
    
    //debugging arrow
    //stroke(0);
    //strokeWeight(10);
    //copy.normalize();
    //line(position.x,position.y, position.x + copy.x*30, position.y +copy.y*30);
    
    position.add(velocity);
    
    mapRef.checkHit(this);
  }//end of fly function
  
  void drawPlane(){
    noStroke();
    fill(255,0,0,225);
    position.x-= drawShift;
    PVector front = PVector.add(position, heading.copy().normalize().mult(radius) );
    PVector left = PVector.add(position, heading.copy().normalize().rotate(PI*3.0/4.0).mult(radius) );
    PVector right = PVector.add(position, heading.copy().normalize().rotate(-PI*3.0/4.0).mult(radius) );
    position.x += drawShift;
    triangle(front.x,front.y, left.x,left.y, right.x,right.y );
  }
  
  PVector getPos(){
    return position; 
  }
  
  float getRadius(){
    return radius;
  }
  
  void crash(){
   alive = false; 
   print("crash");
  }
  
  void setShift(float set){
    drawShift = set;
  }
  
}