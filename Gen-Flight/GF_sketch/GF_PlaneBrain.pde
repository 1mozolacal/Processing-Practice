//This is the network part
final int inputLayerLength = 1;
final int lowwerHiddenLayerLength = 20;
final int upperHiddenLayyerLength = 20;
final int outputLayerLength = 4;

enum layerType{
  input,lowHidden,highHidden,output
}

class PlaneBrain{
  
  //This defines the structure
  BrainNode[] inputLayer = new BrainNode[inputLayerLength];
  BrainNode[] lowwerHiddenLayer = new BrainNode[lowwerHiddenLayerLength];
  BrainNode[] upperHiddenLayyer = new BrainNode[upperHiddenLayyerLength];
  BrainNode[] outputLayer = new BrainNode[outputLayerLength];
  
  //with random connection values
  PlaneBrain(){
    
    
    //init input layer
    BrainNode[] blankRefForInputLayerNodes = new BrainNode[0];
    for(int i = 0; i <inputLayerLength;i++){
      inputLayer[i] = new BrainNode(blankRefForInputLayerNodes,layerType.input);
    }
    
    //int lowwer hidden layer
    for(int i = 0; i < lowwerHiddenLayerLength; i++){
      Double[] randomConnectionValues = new Double[inputLayerLength];
      for(int j =0; j <inputLayerLength; j++){
        randomConnectionValues[j] = (double)random(-1,1);
      }
      lowwerHiddenLayer[i] = new BrainNode(blankRefForInputLayerNodes, randomConnectionValues , layerType.lowHidden);
    }
    
    
  }
  
}



class BrainNode{
  
  //----------varibles-start-----------
  double val = 0;
  BrainNode[] lowwerLevel;
  Double[] connectWeights;
  layerType type;
  //---------varibles-end---------------
  
  //------------------Constructors-Start-----------------------
  BrainNode(BrainNode[] inputLowwerLevel, layerType inputType){
    type = inputType;
    lowwerLevel = inputLowwerLevel;
    Double[] allZeroTemp = new Double[lowwerLevel.length];
    for(int i =0; i < lowwerLevel.length;i++){
      allZeroTemp[i]= 0.0d;
    }
    connectWeights = allZeroTemp;
  }
  
  BrainNode(BrainNode[] inputLowwerLevel, Double[] inputConnnectionWeights, layerType inputType){
    type = inputType;
    lowwerLevel = inputLowwerLevel;
    connectWeights = inputConnnectionWeights;
  }
  //------------------Constructors-end----------------
  
  //--------------------Functions-Start---------------
  void calc(){
    if(type == layerType.input){
      return; 
    }
    double sum = 0;
    for(int i =0; i<lowwerLevel.length; i++){
      sum += connectWeights[i] * ((BrainNode)lowwerLevel[i]).getVal();
    }
    sum = atan((float)sum)*2.0/Math.PI;
  }
  
  double getVal(){
    return val;
  }
  
  //Only use this for nodes in the input layer
  void setInputNode(double inputVal){
    if(type != layerType.input){
      return; 
    }
    val = inputVal;
  }
  //-------------------Functions-end------------------
}