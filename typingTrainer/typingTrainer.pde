//typing tester - Calvin Mozola

//global vars
String textTyped="";
String textIncoming="a";
String incorrectText="";
char lastTyped = 0;

//user config vars
float errorWeigthOnGeneration =0.4;
float speedWeightOnGeneration =0.4;
float amountWeigthOnGeneration =0.2;

ArrayList<ItemRecord> records = new ArrayList<ItemRecord>();

void setup(){
  fullScreen();
}

void draw(){
  
  background(120);
  
  //selector
  fill(200);
  noStroke();
  rect(0,0,width,height*0.4);
  
  //type area
  //rect
  fill(200);
  noStroke();
  rect(0,height/2,width,height*0.4);
  
  //the text
  textSize(240);
  //typed text
  fill(0,255,0);
  String textTypedPrintOut = ( textTyped ==null) ? "" : textTyped;
  textAlign(RIGHT,CENTER);
  text(textTypedPrintOut,width/2,height*0.7);
  //incoming text
  fill(0);
  String textIncomingPrintOut = ( textIncoming ==null) ? "" : textIncoming;
  textAlign(LEFT,CENTER);
  text(textIncomingPrintOut,width/2,height*0.7); 
  //incorrect text typed
  String incorrectTextPrintOut = ( incorrectText ==null) ? "" : incorrectText;
  textAlign(RIGHT,CENTER);
  fill(255,0,0);
  text(incorrectTextPrintOut,width/2,height*0.7);
  
  
}


void getNext(){
 //if using typesets
 if(useTypeSet){
   ArrayList<Object[]> newCharList = new ArrayList<Object[]>(); //array will be of size 2 (char, probability)
   float totalWeights = 0;
   if(selectedTypeSet[0]){//lowwer case
      for(int i =97;i<=122;i++){
        float tempPro = findRecordProbability(i);
        totalWeights+= tempPro;
        Object[] temp = {i,tempPro};
        newCharList.add( temp );
      }
    }
    if(selectedTypeSet[1]){//upper case
      for(int i =65;i<=90;i++){
        float tempPro = findRecordProbability(i);
        totalWeights+= tempPro;
        Object[] temp = {i,tempPro};
        newCharList.add( temp );
      }
    }
    if(selectedTypeSet[2]){//punc
      int asciiList[] = {32,33,34,39,44,46,58,59,63};
      for(int item: asciiList){
        float tempPro = findRecordProbability(item);
        totalWeights+= tempPro;
        Object[] temp = {item,tempPro};
        newCharList.add( temp );
      }
    }
    if(selectedTypeSet[3]){//numbers
      for(int i =48;i<=57;i++){
        float tempPro = findRecordProbability(i);
        totalWeights+= tempPro;
        Object[] temp = {i,tempPro};
        newCharList.add( temp );
      }
    }
    if(selectedTypeSet[5]){//programers
      int asciiList[] = {40,41,42,43,45,47,61,92,123,125};
      for(int item: asciiList){
        float tempPro = findRecordProbability(item);
        totalWeights+= tempPro;
        Object[] temp = {item,tempPro};
        newCharList.add( temp );
      }
    }
   
   for(int i =0; i<1; i++){//add in batches of 20
     Object textToAppend = pickRandomByWeights(newCharList,totalWeights); 
     if(textToAppend instanceof String){
       textIncoming += (String)textToAppend;
     }else {
        textIncoming += (char)(int)textToAppend; 
     }
   }
 }else{//if using dict
  
   
 }
 
}


Object pickRandomByWeights( ArrayList<Object[]> list, float totalWeights){
  float random = (float)Math.random()*totalWeights;
  for(Object[] twoItemList:list){
    random-= (float)twoItemList[1];
    if(random<=0){
      return twoItemList[0];
    }
  }
  return null;
}

float findRecordProbability(Object item){
  for(ItemRecord search: records){
    if(search.getItem().equals(item) ){
      if( search instanceof CharRecord){
        return ( (CharRecord)search).getProbability();
      }else if(search instanceof StringRecord){
        return ( (StringRecord)search).getProbability();
      }
    }
  }
  return 1;//item has no data, therefore default of 1
}

void typedKey(char typed){
  if(textIncoming.length()<20){
  getNext();
  }
  //println("Typed:" + typed);
  if(textIncoming.length()==0 && typed !=8){
   //error
   println("ERROR text incoming is null");
   return;
  }
  
  if(typed == 8){//delete button
    if(incorrectText.length()!=0){
      textIncoming= incorrectText.charAt(incorrectText.length()-1) + textIncoming;
      incorrectText=incorrectText.substring(0,incorrectText.length()-1);
    }else if(textTyped.length()!=0){
      textIncoming= textTyped.charAt(textTyped.length()-1) + textIncoming;
      textTyped = textTyped.substring(0,textTyped.length()-1);
    }
    //else do nothing
    println("do nothing");
  }else if(typed==textIncoming.charAt(0)){//correctly typed 
    textTyped+=textIncoming.charAt(0);
    textIncoming = textIncoming.substring(1);//(1,textIncoming.length());//look at improving later    
  }else{//incorrectly typed
    incorrectText+=textIncoming.charAt(0);
    textIncoming = textIncoming.substring(1);
  }
}

void keyTyped() {
  println("typed " + int(key) + " " + keyCode);
  if(lastTyped!=key){
    lastTyped=key;
    //function for entering a key
    typedKey(key);
  }
}

void keyReleased() {
  //println("released " + int(key) + " " + keyCode);
  if(lastTyped==key){
   lastTyped=0; 
  }
}