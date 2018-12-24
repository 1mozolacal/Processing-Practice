
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
  
  
}