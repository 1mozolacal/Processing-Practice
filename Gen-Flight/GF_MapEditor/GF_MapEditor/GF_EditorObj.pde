

class EditorObj{
   int x,y,wid,hei;
   
   EditorObj(PVector point1, PVector point2){
     x = (int)min(point1.x,point2.x);
     y = (int)min(point1.y,point2.y);
     wid = (int) abs(point1.x-point2.x);
     hei = (int) abs(point1.y-point2.y);
   }
   
   EditorObj(String line){//construct obj from string read from file being loaded
     String[] parts = line.split(",");
     x=parseInt(parts[0]);
     y=parseInt(parts[1]);
     wid=parseInt(parts[2]);
     hei=parseInt(parts[3]);
   }
  
  String stringify(){
    return "" + x + "," + y + "," + wid + "," + hei;
  }
  
  boolean isPositionInBox(PVector position){
    if(inRange(position.x,x,x+wid) && inRange(position.y,y,y+hei)){
     return true; 
    }
    return false;
  }
  
  private boolean inRange(float x, float min, float max){
   if(min>max){
    float temp = min;
    min=max;
    max =temp;
   }
   if( x>min && x <max){
    return true; 
   }
    return false;
  }
  
}