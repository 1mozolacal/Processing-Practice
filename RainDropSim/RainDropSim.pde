ArrayList<RainDrop> listOfRain ;
float wind;
float targetWind;
void setup(){
  //size(720,640);
  fullScreen(2);
  listOfRain = new ArrayList<RainDrop>();
  listOfRain.add(new RainDrop(random(0,width), 0 , 0, 100, 250 ));
  wind=0;
  targetWind =0;
}



void draw(){
  background(200,250,250);
  //Updates raindrops
  ArrayList<Integer> remove = new ArrayList<Integer>(); 
  for(int i = 0; i<listOfRain.size(); i++){
    listOfRain.get(i).update();
    if(listOfRain.get(i).canAddTail() ){
     listOfRain.add(listOfRain.get(i).addTail() );
    }
    if(listOfRain.get(i).getY()>height && !listOfRain.get(i).getIsSplash() ){
      remove.add(i);
      float pushX = sq(random(listOfRain.get(i).getYVel())/8.0 );
      float pushY = sq(random(listOfRain.get(i).getYVel())/12.0);
      listOfRain.add(new RainDrop(listOfRain.get(i).getX(),height, listOfRain.get(i).getSize()/2.0 ,listOfRain.get(i).getXVel()+ pushX ,-pushY , 0, 100, 250,true ));
      listOfRain.add(new RainDrop(listOfRain.get(i).getX(), height, listOfRain.get(i).getSize()/2.0 ,listOfRain.get(i).getXVel()-pushX,-pushY , 0, 100, 250 , true));
    } else if(listOfRain.get(i).getY()>height){
      remove.add(i);
    }
  }
  //removes raindrops
    for(int i = remove.size()-1; i>=0; i--){
      listOfRain.remove((int)remove.get(i));
    }
    //Adds more raindrops
    if((int)random(0) ==  0){
      int amount = (int)random(2);
      for(int i = 0; i<amount; i++){
        listOfRain.add(new RainDrop(random(-(wind*height*0.045),width-(wind*height*0.045)) * (abs(wind)/10+1), wind , 0, 100, 250 ));
      }
  }
    
    if((int)random(100)==0 && targetWind ==0){
      targetWind= random(-6,20);
    }
    if(abs(wind-targetWind)<abs(targetWind*0.2)){
      targetWind = 0;
    } else if(abs(wind-targetWind)>abs(targetWind*0.4)){
      wind += (targetWind-wind)/500;
    } else {
      wind += (targetWind-wind)/100;
    }
    
    println(wind + "target" + targetWind);
}