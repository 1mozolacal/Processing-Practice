//map will be 100 unit tall and user determined units long
final float mapHeight = 100;

class Map{
  
  float drawX;
  float drawY;
  float drawWidth;
  float drawHeight;
  float mapWidth; 
  
 Map(float x, float y, float wid, float hei, float lenghtOfTrack){
   drawX = x;
   drawY = y;
   drawWidth = wid;
   drawHeight = hei;
   mapWidth = lenghtOfTrack;
 }//end of constructor
 
}//end of Map class