

class EditorObj{
   int x,y,wid,hei;
   
   EditorObj(PVector point1, PVector point2){
     x = (int)min(point1.x,point2.x);
     y = (int)min(point1.y,point2.y);
     wid = (int) abs(point1.x-point2.x);
     hei = (int) abs(point1.y-point2.y);
   }
  
  String stringify(){
    return "" + x + "," + y + "," + wid + "," + hei;
  }
  
}