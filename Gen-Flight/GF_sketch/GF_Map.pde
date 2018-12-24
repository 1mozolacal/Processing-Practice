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
   
   obstacles.add( new MapObstacle(90f,20f,10f,40f,this) );
   obstacles.add( new MapObstacle(20f,0f,1f,100f,this) );
   obstacles.add( new MapObstacle(90f,20f,10f,40f,this) );
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
 
 void drawMap(float test){
   //find where to draw 
   
   //Draw the Obstacles
   fill(200);
   rect(drawX,drawY,drawWidth,drawHeight);
   for(MapObstacle obs:obstacles){
     obs.drawObs(test);
   }
   //Draw the green end
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