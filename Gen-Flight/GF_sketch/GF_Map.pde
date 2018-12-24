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
 
 void drawMap(float scroll){
   //find where to draw 
   
   //Draw the Obstacles
   fill(200);
   rect(drawX,drawY,drawWidth,drawHeight);
   for(MapObstacle obs:obstacles){
     obs.drawObs(scroll);
   }
   //Draw the green end
   if(scroll/unitLength + drawWidth/unitLength > mapWidth){
     fill(0,255,0);
     float tempXLoc = max(drawX , drawX - scroll + mapWidth*unitLength );
     float tempWid = min(drawWidth,scroll + drawWidth - mapWidth*unitLength);
     rect(tempXLoc ,drawY,tempWid, drawHeight);
   }
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
}//end of Map class