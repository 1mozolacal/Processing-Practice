//map will be 100 unit tall and user determined units long
final float mapHeight = 100;

class Map{
  
  float drawX;
  float drawY;
  float drawWidth;
  float drawHeight;
  float mapWidth; 
  float unitLength;
  ArrayList<MapObstacle> obstacles = new ArrayList<MapObstacle>();
  float drawShift = 0;
  
 Map(float x, float y, float wid, float hei, float lenghtOfTrack){
   drawX = x;
   drawY = y;
   drawWidth = wid;
   drawHeight = hei;
   mapWidth = lenghtOfTrack;
   unitLength = hei/mapHeight;
   
   float boarderWidth = 2;
   obstacles.add( new MapObstacle(90f,20f,10f,40f,this) );
   obstacles.add( new MapObstacle(0f,0f,boarderWidth,mapHeight,this) );//back boarder
   obstacles.add( new MapObstacle(0f,0f,lenghtOfTrack,boarderWidth,this) );//top boarder
   obstacles.add( new MapObstacle(0f,mapHeight-boarderWidth,lenghtOfTrack,boarderWidth,this) );//top boarder
 }//end of constructor
 
 void testDrawlines(){
   
   stroke(100);
   for(int yDir = 1; yDir<mapHeight; yDir++){
     line(drawX,drawY+(yDir*unitLength),drawX+drawWidth,drawY+(yDir*unitLength));
   }
   
   for(int xDir =1; xDir<mapWidth;xDir++){
     line(drawX+(xDir*unitLength),drawY,drawX+(xDir*unitLength),drawY+drawHeight);
   }
   
 }
 
 void drawMap(){
   //find where to draw 
   
   //Draw the Obstacles
   fill(200);
   rect(drawX,drawY,drawWidth,drawHeight);
   for(MapObstacle obs:obstacles){
     obs.drawObs(drawShift);
   }
   //Draw the green end
   if(drawShift/unitLength + drawWidth/unitLength > mapWidth){
     fill(0,255,0);
     float tempXLoc = max(drawX , drawX - drawShift + mapWidth*unitLength );
     float tempWid = min(drawWidth,drawShift + drawWidth - mapWidth*unitLength);
     rect(tempXLoc ,drawY,tempWid, drawHeight);
   }
 }
 
 void checkHit(Plane plane){
   for(MapObstacle obs: obstacles){
     
     PVector planePos = plane.getPos();
     float planeRadius = plane.getRadius();
     if( planePos.x > obs.getDrawX() - planeRadius && planePos.x < obs.getDrawX()+obs.getDrawWidth()+planeRadius ){
      if(  planePos.y > obs.getDrawY() - planeRadius && planePos.y < obs.getDrawY()+obs.getDrawHeight()+planeRadius ){
        plane.crash();
      }
     }//end of if
   }
 }
 
 float[] updataPlaneSight(Plane plane){
   
   PVector[] planeSights = plane.getSightLines();
   float[] sightsValues = new float[planeSights.length];
   for(int i =0; i<sightsValues.length;i++){
     sightsValues[i] = -1;
   }
   int sightsValueIndex = 0;
   
   for(MapObstacle obs: obstacles){
     sightsValueIndex =0;
     for(PVector sight: planeSights){
       float value = obs.checkSightIntersection(plane.getPos(),sight,drawShift);
       if(value==-1){
         sightsValueIndex++;//do not change value
       }else {
         if(value<=plane.getSightDist() ){
           if(sightsValues[sightsValueIndex]<value/plane.getSightDist() || sightsValues[sightsValueIndex]==-1){
             sightsValues[sightsValueIndex] = value/plane.getSightDist();
             sightsValueIndex++;
             
             //debugging drawing
             PVector copyOfSight = sight.copy().normalize();
             copyOfSight.mult(value);
             fill(255,255,0,125);
             ellipse(plane.getPos().x + copyOfSight.x - drawShift, plane.getPos().y + copyOfSight.y, 20,20);
           }
         } else {
           sightsValueIndex++;//do not change value
         }
       }
       
     }
       
   }
   
   return sightsValues;
 }
 
 float getUnitLength(){
   return unitLength; 
 }
 
 float getX(){
   return drawX; 
 }
 
 float getY(){
  return drawY; 
 }
 
 float getWidth(){
  return drawWidth; 
 }
 
 float shiftToLeader(float xOfLeader){
   float followAt = 0.25;//a Percentage
   float shift  = max(0, xOfLeader - (drawWidth*followAt + drawX) );
   drawShift = shift;
   return shift;
 }
 
}//end of Map class