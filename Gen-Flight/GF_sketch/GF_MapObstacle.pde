
class MapObstacle{
  
  float x,y,wid,hei;//All to the map grid not the canvas
  Map parnetMap;
  
  MapObstacle(float inputX,float inputY,float inputWid,float inputHei,Map inputMap){
    x = inputX;
    y=inputY;
    wid=inputWid;
    hei=inputHei;
    parnetMap=inputMap;
  }
  
  
  void drawObs(float xShift){
    
    float drawX = x * parnetMap.getUnitLength() - xShift;
    float drawWidth = wid * parnetMap.getUnitLength();
    
    if(drawX>= parnetMap.getX()+parnetMap.getWidth() || drawX+drawWidth<=0 ){
     return;//it is out of the frame(don't draw) 
    }
    
    drawWidth = min( drawX+drawWidth, parnetMap.getWidth() ) - drawX;
    float tempDrawX = drawX;
    drawX = max( 0 , drawX);
    drawWidth -= drawX - tempDrawX;
    
    fill(0);
    rect(parnetMap.getX()+drawX, parnetMap.getY()+ (y*parnetMap.getUnitLength()) ,drawWidth,hei*parnetMap.getUnitLength());
  }
  
  float checkSightIntersection(PVector planePos, PVector planeSight, float xShiftForTesting){
    
    float unsetForCloest =-1;//if you change this must change funcation updataPlaneSight in map class
    float closest = unsetForCloest;
    boolean infiniteSlope = false;
    float slope=-999;
    if(planeSight.x == 0){ 
      infiniteSlope = true; 
    }  else{ 
      slope = planeSight.y/planeSight.x; 
    }
    
    float deltaX = 0;
    float deltaY = 0;
    float interLoc = 0;
    
    if(!infiniteSlope){
      //left side
      
      deltaX = (x * parnetMap.unitLength) - planePos.x;
      deltaY = deltaX * slope;
      
      interLoc = planePos.y + deltaY;
      if(interLoc>y*parnetMap.getUnitLength() && interLoc< (y+hei)*parnetMap.getUnitLength() ){//withing y range of the left side of the rect
        PVector tempForDirCheck = new PVector(deltaX,deltaY);
        if( abs(tempForDirCheck.heading() - planeSight.heading() ) < 0.05 ){//Same direction-ish
          if( tempForDirCheck.mag()< closest || closest == unsetForCloest ){
            closest = tempForDirCheck.mag();
            //DEBUGGING
            //fill(255,0,255);
            //ellipse(planePos.x+deltaX-xShiftForTesting, planePos.y+deltaY, 10,10);
          }
          
        }
      }
      
      //right side
      deltaX = ((x+wid) * parnetMap.unitLength) - planePos.x;
      deltaY = deltaX * slope;
      
      interLoc = planePos.y + deltaY;
      if(interLoc>y*parnetMap.getUnitLength() && interLoc< (y+hei)*parnetMap.getUnitLength() ){//withing y range of the left side of the rect
        PVector tempForDirCheck = new PVector(deltaX,deltaY);
        if( abs(tempForDirCheck.heading() - planeSight.heading() ) < 0.05 ){//Same direction-ish
          if( tempForDirCheck.mag()< closest || closest == unsetForCloest ){
              closest = tempForDirCheck.mag();
              //fill(255,0,255);
              //ellipse(planePos.x+deltaX-xShiftForTesting, planePos.y+deltaY, 10,10);
          }
        }
      }
    
    }
    
    if(slope !=0){
      //top side
      deltaY = (y*parnetMap.getUnitLength() - planePos.y);
      deltaX = deltaY/slope;
      
      
      interLoc = planePos.x + deltaX;
      if(interLoc>x*parnetMap.getUnitLength() && interLoc< (x+wid)*parnetMap.getUnitLength() ){//withing x range of the left side of the rect
        PVector tempForDirCheck = new PVector(deltaX,deltaY);
        if( abs(tempForDirCheck.heading() - planeSight.heading() ) < 0.05 ){//Same direction-ish
          if( tempForDirCheck.mag()< closest || closest == unsetForCloest ){
            closest = tempForDirCheck.mag();
            //fill(255,0,255);
            //ellipse(planePos.x+deltaX-xShiftForTesting, planePos.y+deltaY, 10,10);
          }
        }
      }
      //bottom side
      deltaY = ((y+hei)*parnetMap.getUnitLength() - planePos.y);
      deltaX = deltaY/slope;
      
      
      interLoc = planePos.x + deltaX;
      if(interLoc>x*parnetMap.getUnitLength() && interLoc< (x+wid)*parnetMap.getUnitLength() ){//withing x range of the left side of the rect
        PVector tempForDirCheck = new PVector(deltaX,deltaY);
        if( abs(tempForDirCheck.heading() - planeSight.heading() ) < 0.5 ){//Same direction-ish
          if( tempForDirCheck.mag()< closest || closest == unsetForCloest ){
            closest = tempForDirCheck.mag();
            //fill(255,0,255);
            //ellipse(planePos.x+deltaX-xShiftForTesting, planePos.y+deltaY, 10,10);
          }
        }
      }
      
    }
    
    return closest;
    
  }
  
  
  float getDrawX(){
    return x*parnetMap.unitLength;
  }
  
  float getDrawY(){
    return y*parnetMap.unitLength;
  }
  
  float getDrawWidth(){
   return wid*parnetMap.unitLength; 
  }
  
  float getDrawHeight(){
    return hei*parnetMap.unitLength;  
  }
  
}