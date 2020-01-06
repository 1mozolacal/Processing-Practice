//typing tester - Calvin Mozola

//global vars
String textTyped="";
String textIncoming="abc";
String incorrectText="";
char lastTyped = 0;

//type sets
//lower, upper, punc, numbers, symbol, programers symbols
enum typeSet {lowwer,upper,punc,numbers,symbol,program};
boolean selectedTypeSet[] = {true,true,true,true,true,true};
//dict sets
//top 100, top 1000,programming
enum dictSets {hundred,thousand,program};
boolean selectedDictSet[] = {true,false,false};
boolean useTypeSet = true;//true means use type set and false means dict

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
   ArrayList<Integer> newCharList = new ArrayList<Integer>(); 
   if(selectedTypeSet[0]){//lowwer case
      for(int i =97;i<=122;i++){newCharList.add(i);}
    }
    if(selectedTypeSet[1]){//upper case
      for(int i =65;i<=90;i++){newCharList.add(i);}
    }
    if(selectedTypeSet[2]){//punc
      int asciiList[] = {32,33,34,39,44,46,58,59,63};
      for(int item: asciiList){newCharList.add(item);}
    }
    if(selectedTypeSet[3]){//numbers
      for(int i =48;i<=57;i++){newCharList.add(i);}
    }
    if(selectedTypeSet[5]){//programers
      int asciiList[] = {40,41,42,43,45,47,61,92,123,125};
      for(int item: asciiList){newCharList.add(item);}
    }
   textIncoming+= (char) ((int) newCharList.get((int)(Math.random()*newCharList.size())) );
   if(textIncoming.length()<20){
      getNext();
   }
 }else{//if using dict
  
   
 }
 
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