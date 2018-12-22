//This is the network part

class PlaneBrain{
   
  PlaneBrain(){
    
  }
  
}



class BrainNode{
  
  //----------varibles-start-----------
  double val = 0;
  ArrayList<BrainNode> lowwerLevel;
  ArrayList<Double> connectWeights;
  //---------varibles-end---------------
  
  //------------------Constructors-Start-----------------------
  BrainNode(ArrayList<BrainNode> inputLowwerLevel){
    lowwerLevel = inputLowwerLevel;
    ArrayList<Double> allZeroTemp = new ArrayList<Double>();
    for(int i =0; i < lowwerLevel.size();i++){
      allZeroTemp.add(0.0d);
    }
    connectWeights = allZeroTemp;
  }
  
  BrainNode(ArrayList<BrainNode> inputLowwerLevel, ArrayList<Double> inputConnnectionWeights){
    lowwerLevel = inputLowwerLevel;
    connectWeights = inputConnnectionWeights;
  }
  //------------------Constructors-end----------------
  
  //--------------------Functions-Start---------------
  void calc(){
    double sum = 0;
    for(int i =0; i<lowwerLevel.size(); i++){
      sum += connectWeights.get(i) * ((BrainNode)lowwerLevel.get(i)).getVal();
    }
    sum = atan((float)sum)*2.0/Math.PI;
  }
  
  double getVal(){
    return val;
  }
  
  //Only use this for nodes in the input layer
  void setInputNode(double inputVal){
    val = inputVal;
  }
  //-------------------Functions-end------------------
}