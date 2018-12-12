class RainDrop{
  
  float smallestTailSize = 2.0;
  float gravity = 0.08;
  
  float size;
  float x;
  float y;
  float xVel;
  float yVel;
  int r,g,b;
  boolean madeChild= false;
  boolean isSplash = false;
  
  RainDrop(float ix,float ixVel,int ir,int ig,int ib){
    size =10.0;
    x = ix;
    xVel = ixVel;
    y = -size;
    if((int)random(5) ==0){
      yVel = random(8,20);
    }else {
      yVel = random(4,10);
    }
    r =ir;
    b =ib;
    g=ig;
  
  }
  
  RainDrop(float ix,float iy,float isize,float ixVel,float iyVel,int ir,int ig,int ib , boolean splash){
    size = isize;
    x = ix;
    xVel = ixVel;
    y = iy;
    yVel = iyVel;
    r =ir;
    b =ib;
    g=ig;
    isSplash = splash;
    if(splash){
      madeChild = true;
    }
  }
  
  
  
  void update(){
    x+=xVel;
    y+=yVel;
    yVel+=gravity;
    fill(r,g,b);
    noStroke();
    ellipse(x,y,size,size);
    
  }
  
  boolean canAddTail(){
    if(size>smallestTailSize && !madeChild){
      return true;
  }
  return false;
}

RainDrop addTail(){
  madeChild = true;
  return new RainDrop(x-(xVel*1.15),y-(size*0.3)-(yVel),size*0.9,xVel,yVel-gravity,r,g,b,false);
}
  
  float getX(){
    return x;
  }
  float getY(){
   return y; 
  }
  float getXVel(){
   return xVel; 
  }
  float getYVel(){
   return yVel; 
  }
  float getSize(){
    return size;
  }
  boolean getIsSplash(){
    return isSplash;
  }
  void setSplash(boolean splash){
    isSplash = splash; 
  }
  
}