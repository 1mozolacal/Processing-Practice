//This is the network part
final int nonSightInput = 4;
final int inputLayerLength = sightNumber+nonSightInput;//sightNumber + 4
final int lowwerHiddenLayerLength = 10;
final int upperHiddenLayyerLength = 10;
final int outputLayerLength = 5;
final int numberOfHiddenLayers = 0; //max two
float changeProbability = 1;//the change of any modification happening
float changeAmount = 0.003;
float mutaionRate = 0.001;
float mutationMult = 1;

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
    
    BrainNode[][] arrayOfLayersForInit = getBrainNodesInArray();
    //OPT this
    BrainNode[] blankRefForInputLayerNodes = new BrainNode[0];//for input layer
    for( int lay =0; lay < arrayOfLayersForInit.length;lay++){
      
      for(int i = 0; i < arrayOfLayersForInit[lay].length; i++){
        if(lay!=0){
        Double[] randomConnectionValues = new Double[arrayOfLayersForInit[lay-1].length]; 
        for(int j =0; j <arrayOfLayersForInit[lay-1].length; j++){
          randomConnectionValues[j] = (double)random(-1,1);
        }
          layerType checkIfOutputType = layerType.values()[lay];
          if(lay == arrayOfLayersForInit.length-1 ){ checkIfOutputType = layerType.output;}
          arrayOfLayersForInit[lay][i] = new BrainNode(arrayOfLayersForInit[lay-1], randomConnectionValues ,  checkIfOutputType);
        } else {
          inputLayer[i] = new BrainNode(blankRefForInputLayerNodes,layerType.input);
        }
      }//end of for loop for a specific layer
    
    }// for loop for the layer selection
    
   
  }//end of PlaneBrain()
  
  //Clone
  PlaneBrain(PlaneBrain parent){
    this();//init the layers and connections
    ArrayList<BrainNode[]> layersRef = new ArrayList<BrainNode[]>();
    if(numberOfHiddenLayers>=1){
      layersRef.add(lowwerHiddenLayer);
      if(numberOfHiddenLayers>=2){
        layersRef.add(upperHiddenLayyer);
      }
    }
    layersRef.add(outputLayer);
    
    for(int i =1; i <layersRef.size(); i ++){
      for(int j = 0; j<layersRef.get(i).length;j++){
       Double[] nodeConnectionsParnet = parent.getLayerConnection(i,j); 
       Double[] newNodeConnections = new Double[nodeConnectionsParnet.length]; 
       for(int con = 0; con< nodeConnectionsParnet.length; con++){
         double value = nodeConnectionsParnet[con];
         if(Math.random()< changeProbability){
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
    if(numberOfHiddenLayers>=1){
      layersRef.add(lowwerHiddenLayer);
      if(numberOfHiddenLayers>=2){
        layersRef.add(upperHiddenLayyer);
      }
    }
    layersRef.add(outputLayer);
    
    for(int i =1; i <layersRef.size(); i ++){
      for(int j = 0; j<layersRef.get(i).length;j++){
       Double[] nodeConnectionsMom = mom.getLayerConnection(i,j); 
       Double[] nodeConnectionsDad = dad.getLayerConnection(i,j); 
       Double[] newNodeConnections = new Double[nodeConnectionsMom.length];
       for(int con = 0; con< nodeConnectionsMom.length; con++){
         double value;
         
         if(Math.random() > 0.5){
           value = nodeConnectionsMom[con];
         } else {
           value = nodeConnectionsDad[con];
         }
         if(Math.random() < changeProbability){
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
         }
         newNodeConnections[con] = value;
       }//end of for (con)
       layersRef.get(i)[j].setConnections(newNodeConnections);
      }//end of for(j)
      
    }//end of for(i)
  }//end of PlaneBrain(PlaneBrain)
  
  //--------------------Constructors-end------------------
  
  
  
  //-----------------functions-start------------
  BrainNode[][] getBrainNodesInArray(){
    BrainNode[][] returnArr = new BrainNode[2+min(2,numberOfHiddenLayers)][];
    for(int i = 0; i < returnArr.length;i++){
      if(i== 0){returnArr[i] = inputLayer;}
      else if(i== returnArr.length-1 ){returnArr[i] = outputLayer;}
      else if(i== 1){returnArr[i] = lowwerHiddenLayer;}
      else if(i== 2){returnArr[i] = upperHiddenLayyer;}
    }
    return returnArr;
  }
  
  
  void computeNet(){
    
    BrainNode[][] arrays = getBrainNodesInArray();
    
    for( int lay = 1; lay< arrays.length;lay++){
      for(int i=0; i<arrays[lay].length;i++){
        arrays[lay][i].calc();
      }
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
    
    BrainNode[][] arrayOfLayer = getBrainNodesInArray();
    ArrayList<PVector> previousLayer = new ArrayList<PVector>();
    ArrayList<PVector> previousLayerConstruction = new ArrayList<PVector>();    
    float radius = 0;
    
    for(int i =0; i<arrayOfLayer.length;i++){
     float xPosOfLayer =  (i+1)*(wid/(float)(arrayOfLayer.length+1));
     
     previousLayer.clear();
     for(PVector element: previousLayerConstruction){
       previousLayer.add(element);
     }
     previousLayerConstruction.clear();
     
     radius = min(wid/5.0/2.0, hei/(arrayOfLayer[i].length+1)/2.0 );
     
     for(int j = 0; j < arrayOfLayer[i].length;j++){
       float yPosOfNode = (j+1)*(hei/( float )(arrayOfLayer[i].length+1));
       BrainNode tempNode = arrayOfLayer[i][j];
       fill( (int) ((tempNode.getVal()+1)*255.0/2.0));
       noStroke();
       ellipse(x+xPosOfLayer, y + yPosOfNode , radius,radius);
       
       previousLayerConstruction.add( new PVector(x+xPosOfLayer, y + yPosOfNode));
       
       //draw the connections
       if(tempNode.getType() == layerType.input){
         continue;
       }//end of if(layer type)
       for(int preLay = 0; preLay<arrayOfLayer[i-1].length;preLay++){
         stroke( (int) ((tempNode.getConnectionValueAt(preLay)+1)*255.0/2.0));
         strokeWeight(1);
         line(x+xPosOfLayer,y+yPosOfNode, previousLayer.get(preLay).x, previousLayer.get(preLay).y );
       }//end of nestedX2 loop(preLay-for drawing lines)
      }//end of for nested loop(j-for the Nodes)
    }//end of for loop(i-for the Layers)
    
  }
  
  Double[] getLayerConnection(int layer,int node){//0 = connections of first hidden layer, 1= connections of second hidden layer,2 = connection for output
    BrainNode[] layerRef = getBrainNodesInArray()[layer];
    return layerRef[node].getConnections();
    
  }
  //-------------------functions-end------------
  
  
}//end of PlanBrain class



class BrainNode{
  
  //----------varibles-start-----------
  double val = 0;
  BrainNode[] lowwerLevel;
  Double[] connectWeights = new Double[2];
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
    //println("type:" + type +"  Lower lvl:" + lowwerLevel.length + "  con:" +  connectWeights.length );
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