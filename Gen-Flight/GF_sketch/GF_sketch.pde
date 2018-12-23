
void setup(){
  fullScreen(2);//second screen if connected
  PlaneBrain test = new PlaneBrain();
  Double[] temp = {-1d,0.2d,0.5d,-0.4d,1d};
  test.setInputLayer(temp  );
  test.computeNet();
  test.visualize(0,0,500,900);
}


void draw(){
  
}