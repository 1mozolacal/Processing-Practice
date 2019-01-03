//This is the network part
final int nonSightInput = 4;
final int inputLayerLength = sightNumber+nonSightInput;//sightNumber + 4
final int lowwerHiddenLayerLength = 10;
final int upperHiddenLayyerLength = 10;
final int outputLayerLength = 5;
float changeAmount = 0.02;
float mutaionRate = 0.05;
float mutationMult = 15;

enum layerType{
  input,lowHidden,highHidden,output
}

class PlaneBrain{
  
  //------------------varibles-start--------------------
  //This defines the structure
  BrainNode[] inputLayer = new BrainNode[inputLayerLength];
  BrainNode[] lowwerHiddenLayer = new BrainNode[lowwerHiddenLayerLength];
  BrainNode[] upperHiddenLayyer = new BrainNode[upperHiddenLayyerLength];
  BrainNode[] outputLayer = new BrainNode[outputLayerLength];
  //-------------------varibles-end-----------------------
  
  
  //----------------------Constructors-start---------------------
  
  //with random connection values
  PlaneBrain(){
    
    //OPT this
    
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
      lowwerHiddenLayer[i] = new BrainNode(inputLayer, randomConnectionValues , layerType.lowHidden);
    }
    
    //int higher hidden layer
    for(int i = 0; i < upperHiddenLayyerLength; i++){
      Double[] randomConnectionValues = new Double[lowwerHiddenLayerLength];
      for(int j =0; j <lowwerHiddenLayerLength; j++){
        randomConnectionValues[j] = (double)random(-1,1);
      }
      upperHiddenLayyer[i] = new BrainNode(lowwerHiddenLayer, randomConnectionValues , layerType.highHidden);
    }
    
    //int lowwer hidden layer
    for(int i = 0; i < outputLayerLength; i++){
      Double[] randomConnectionValues = new Double[upperHiddenLayyerLength];
      for(int j =0; j <upperHiddenLayyerLength; j++){
        randomConnectionValues[j] = (double)random(-1,1);
      }
      outputLayer[i] = new BrainNode(upperHiddenLayyer, randomConnectionValues , layerType.output);
    }
    
    //finished init
  }//end of PlaneBrain()
  
  //Clone
  PlaneBrain(PlaneBrain parent){
    this();
    ArrayList<BrainNode[]> layersRef = new ArrayList<BrainNode[]>();
    layersRef.add(lowwerHiddenLayer);
    layersRef.add(upperHiddenLayyer);
    layersRef.add(outputLayer);
    
    for(int i =0; i <3; i ++){
      for(int j = 0; j<layersRef.get(i).length;j++){
       Double[] nodeConnectionsParnet = parent.getLayerConnection(i,j); 
       Double[] newNodeConnections = new Double[nodeConnectionsParnet.length];
       for(int con = 0; con< nodeConnectionsParnet.length; con++){
         double value = nodeConnectionsParnet[con];
         if(Math.random()<mutaionRate){
           value += (Math.random()-0.5)*(2*changeAmount*mutationMult);
         }else {
           value += (Math.random()-0.5)*(2*changeAmount);
         }
         if(value>1){
          value =1;
         } else if(value<-1){
          value = -1; 
         }
         newNodeConnections[con] = value;
       }//end of for (con)
       layersRef.get(i)[j].setConnections(newNodeConnections);
      }//end of for(j)
      
    }//end of for(i)
    
  }//end of PlaneBrain(PlaneBrain)
  
  //mix
  PlaneBrain(PlaneBrain mom,PlaneBrain dad){
    this();
    ArrayList<BrainNode[]> layersRef = new ArrayList<BrainNode[]>();
    layersRef.add(lowwerHiddenLayer);
    layersRef.add(upperHiddenLayyer);
    layersRef.add(outputLayer);
    
    for(int i =0; i <3; i ++){
      for(int j = 0; j<layersRef.get(i).length;j++){
       Double[] nodeConnectionsMom = mom.getLayerConnection(i,j); 
       Double[] nodeConnectionsDad = dad.getLayerConnection(i,j); 
       Double[] newNodeConnections = new Double[nodeConnectionsMom.length];
       for(int con = 0; con< nodeConnectionsMom.length; con++){
         double value = (nodeConnectionsMom[con] + nodeConnectionsDad[con])/2.0;
         if(Math.random()<mutaionRate){
           value += (Math.random()-0.5)*(2*changeAmount*mutationMult);
         }else {
           value += (Math.random()-0.5)*(2*changeAmount);
         }
         if(value>1){
          value =1;
         } else if(value<-1){
          value = -1; 
         }
         newNodeConnections[con] = value;
       }//end of for (con)
       layersRef.get(i)[j].setConnections(newNodeConnections);
      }//end of for(j)
      
    }//end of for(i)
  }//end of PlaneBrain(PlaneBrain)
  
  //--------------------Constructors-end------------------
  
  
  
  //-----------------functions-start------------
  void computeNet(){
    
    //lowwer layer
    for(int i=0; i<lowwerHiddenLayerLength;i++){
      lowwerHiddenLayer[i].calc();
    }
    //upper layer
    for(int i=0; i<upperHiddenLayyerLength;i++){
      upperHiddenLayyer[i].calc();
    }
    //output layer
    for(int i=0; i<outputLayerLength;i++){
      outputLayer[i].calc();
    }
    
  }
  
  void setInputLayer( float[] values ){
    for(int i =0; i <min(inputLayerLength,values.length);i++){
      inputLayer[i].setInputNode( values[i] );
    }
  }
  
  Double[] readOutputAsArray(){
    Double[] values =new Double[outputLayerLength];
    for(int i=0;i<outputLayerLength;i++){
      values[i] = outputLayer[i].getVal();  
    }
    return values;
  }
  
  void visualize(float x, float y,float wid,float hei){
    fill(200,200,255);
    rect(x,y,wid,hei);
    
    int[] arrayOfLayerLength = {inputLayerLength,lowwerHiddenLayerLength,upperHiddenLayyerLength,outputLayerLength};
    BrainNode[][] arrayOfLayer = {inputLayer,lowwerHiddenLayer,upperHiddenLayyer,outputLayer};
    ArrayList<PVector> previousLayer = new ArrayList<PVector>();
    ArrayList<PVector> previousLayerConstruction = new ArrayList<PVector>();    
    float radius = 0;
    
    for(int i =0; i<arrayOfLayerLength.length;i++){
     float xPosOfLayer =  (i+1)*(wid/5.0);
     
     previousLayer.clear();
     for(PVector element: previousLayerConstruction){
       previousLayer.add(element);
     }
     previousLayerConstruction.clear();
     
     radius = min(wid/5.0/2.0, hei/(arrayOfLayerLength[i]+1)/2.0 );
     
     for(int j = 0; j < arrayOfLayerLength[i];j++){
       float yPosOfNode = (j+1)*(hei/( float )(arrayOfLayerLength[i]+1));
       BrainNode tempNode = arrayOfLayer[i][j];
       fill( (int) ((tempNode.getVal()+1)*255.0/2.0));
       noStroke();
       ellipse(x+xPosOfLayer, y + yPosOfNode , radius,radius);
       
       previousLayerConstruction.add( new PVector(x+xPosOfLayer, y + yPosOfNode));
       
       //draw the connections
       if(tempNode.getType() == layerType.input){
         continue;
       }//end of if(layer type)
       for(int preLay = 0; preLay<arrayOfLayerLength[i-1];preLay++){
         stroke( (int) ((tempNode.getConnectionValueAt(preLay)+1)*255.0/2.0));
         strokeWeight(1);
         line(x+xPosOfLayer,y+yPosOfNode, previousLayer.get(preLay).x, previousLayer.get(preLay).y );
       }//end of nestedX2 loop(preLay-for drawing lines)
      }//end of for nested loop(j-for the Nodes)
    }//end of for loop(i-for the Layers)
    
  }
  
  Double[] getLayerConnection(int layer,int node){//0 = connections of first hidden layer, 1= connections of second hidden layer,2 = connection for output
    BrainNode[] layerRef;
    if(layer==0){
      layerRef = lowwerHiddenLayer;
    }else if(layer ==1){
      layerRef = upperHiddenLayyer;
    }else if(layer==2){
      layerRef = outputLayer;
    }else {
      layerRef = outputLayer;
     println("Error with geting layer connections"); 
    }
    return layerRef[node].getConnections();
    
  }
  //-------------------functions-end------------
  
  
}//end of PlanBrain class



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
    val = sum;
  }
  
  double getVal(){
    return val;
  }
  
  double getConnectionValueAt(int index){
    if(index >= connectWeights.length || index<0){
      print("Error: connection call with " + index );  
      return 0.0d;
    }
    return connectWeights[index];
  }
  
  Double[] getConnections(){
    return connectWeights;
  }
  
  void setConnections(Double[] con){
    connectWeights = con;
  }
  
  layerType getType(){
   return type; 
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