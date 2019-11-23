//Map editor/creator

//if loading a map file to edit
boolean loadFile = false;
String loadfileName;//can be full name or just your name ex (GFMapNAME.txt or NAME)

String saveFileAs;
String saveFileAsTyping = "";
int trackLength=0;
int trackLengthTyping = 0;
public enum TypingInputStage{
   fileName,
   trackLength,
   mapMod;
}
TypingInputStage typingInput = TypingInputStage.fileName; //0=file name, 1=track length

int viewDensity = 100;
float viewDensityUnit = 100.0/(float)viewDensity;
int xShift = 0;
int yShift = 0;


float unit;
PVector select = new PVector(-1,-1);
ArrayList<EditorObj> objs = new ArrayList<EditorObj>();

void setup(){
  //fullScreen();
  size(700,700);
  if(loadFile){
    loadFile();
    return;
  }
  unit = height/100.0;
  unit *= viewDensityUnit;
  
  //loading file when you can't modify the code
  String[] config = loadStrings("config.txt");
  if(config !=null){
    loadfileName = config[0];
    loadFile();
  }
}



void draw(){
  background(30);
  
  if(keyPressed && (key=='h' || key=='H')){
    fill(255);
    textSize(20);
    String textStr = "Hold h for help at any time\n"
    +"Movement:\n"
    +"  w:up\n"
    +"  a:left\n"
    +"  s:down\n"
    +"  d:right\n"
    +"  +:voom in\n"
    +"  -:voom out\n"
    +"  Arrow keys do not work\n\n"
    +"Saveing: use g, it will save without prompt\n\n"
    +"Map Creating:\n"
    +"  Left click to set first point for rectangle,\n  left click somewhere else to finish rectangle\n"
    +"  Right click on rectangle to delect\n\n"
    +"If you want to load a map file to edit\nmake a txt file called \"config.txt\" in the same\ndirectory as this program. In that txt write the\nfile name in the first line"
    +"\n:)";
    text(textStr,width/20,height/20);
    return;
  }
  
  if(saveFileAs ==null){
    fill(255);
    textSize(20);
    text("Select map name:" + saveFileAsTyping +"\n\nHold h at anytime for help",width/8,height/2);
   return;
  } else if(trackLength==0){
    fill(255);
    textSize(20);
    text("Select map lenght(min 100):" + trackLengthTyping,width/8,height/2);
    return;
  }
  //draw lines
  stroke(125);
  strokeWeight(viewDensityUnit);
  for(int i = 1; i <100; i++){
    line(unit*i,0,unit*i,height);
    line(0,unit*i,width,unit*i);
  }
  
  if(select.x != -1){
    //selection dot
    fill(255,255,0);
    ellipse((select.x-xShift)*unit, (select.y-yShift)*unit,20,20);
    //selection box
    fill(255,125);
   rect((select.x-xShift)*unit,(select.y-yShift)*unit,mouseX-(select.x-xShift)*unit,mouseY-(select.y-yShift)*unit); 
  }
    
  
  
  //draw objs
  fill(255);
  noStroke();
  for( EditorObj obj: objs){
    rect((obj.x-xShift)*unit,(obj.y-yShift)*unit,obj.wid*unit,obj.hei*unit);
  }
  
}

void keyPressed(){
  int value = (int) key;
  if(typingInput==TypingInputStage.fileName){
    if( (value>=65 && value<=90) || (value>=97 && value<=122) ) {
      saveFileAsTyping += key;
    } else if(value== 8){//delete
      saveFileAsTyping = saveFileAsTyping.substring(0,max(0,saveFileAsTyping.length()-1) );
    } else if(value ==10 && saveFileAsTyping.length()>0 ){
      saveFileAs = saveFileAsTyping;
      typingInput = TypingInputStage.trackLength;
    }
  }else if(typingInput==TypingInputStage.trackLength){
    if( (value>=48 && value<=57) ) {
      trackLengthTyping = trackLengthTyping*10+ ((int)key)-48 ;
    } else if(value== 8){//delete
      trackLengthTyping /=10;
    } else if(value ==10 && trackLengthTyping>99 ){
      trackLength = trackLengthTyping;
      typingInput = typingInput.mapMod;
    }
  } else {//normal mode (scrolling)
    int shiftAmount = 1+viewDensity/10;
    if(value == 68 || value == 100){//d
     if(viewDensity+xShift < trackLength){
       xShift+=shiftAmount;   
     }
    }else if(value == 65 || value == 97){//s
      if(xShift>0){
       xShift-=shiftAmount; 
      }
    }else if(value == 83 || value == 115){//s
      if(viewDensity+yShift < 100){
         yShift+=shiftAmount;   
       }
    }else if(value == 97 || value == 119){//w
      if(yShift>0){
        yShift-=shiftAmount;
      }
    } else if(value == 61 || value == 43){//+
      if(viewDensity>10){
       viewDensity--; 
       viewDensityUnit = 100.0/(float)viewDensity;
       unit = (height/100.0) *viewDensityUnit;
      }
    }else if(value == 45 || value == 95){//-
      if(viewDensity<100){
        viewDensity++; 
        viewDensityUnit = 100.0/(float)viewDensity;
        unit = (height/100.0) *viewDensityUnit;
      }
    }
    reCenter();
    
    if(value == 47 || value == 103){//g and whatever 47 is
      createMapFile();
    }
  }
  //For debugging and finding out what the buttons are
  println("key:" + (int) key);
}

void reCenter(){
  
  if(xShift<0){ xShift = 0; }
  if(yShift<0){ yShift=0; }
  
  if(viewDensity+xShift > trackLength){
     xShift=trackLength-viewDensity;   
  }
  if(viewDensity+yShift > 100){
   yShift= 100-viewDensity;
  }
     
}

void createMapFile(){
  String[] saveLines = new String[objs.size()+1];
  saveLines[0] = ""+trackLength;
  int index = 1;
  for(EditorObj obj: objs){
    saveLines[index] = obj.stringify();
    index++;
  }
  saveStrings("GFMap" + saveFileAs + ".txt", saveLines);
  exit();
}

void mousePressed(){
  if(saveFileAs ==null || trackLength==0){
    return;
  }
  
  int gridX = (int) (mouseX/unit);
  int gridY = (int)  (mouseY/unit);
  if(mouseButton == LEFT){
  //creating boxes
  if(select.x ==-1){
    select = new PVector(gridX+xShift, gridY+yShift);
  } else {
    objs.add( new EditorObj(select, new PVector(gridX+xShift, gridY+yShift)) );
    select.x = -1;
  }
  //deleting boxes
  } else if( mouseButton ==RIGHT){
    for(EditorObj obj : objs){
      if(obj.isPositionInBox( new PVector(gridX+xShift, gridY+yShift)) ){
        objs.remove(obj);
        break;
      }
    }//end of for each
  }
  
}

void loadFile(){
  saveFileAs=loadfileName;
  String[] fileInput = loadStrings(loadfileName);
  if(fileInput==null){
   fileInput = loadStrings("GFMap" + loadfileName +".txt");
  }
  if(fileInput==null){
    println("No file found");
    exit(); 
    return;
  }
  trackLength=parseInt(fileInput[0]);
  typingInput = TypingInputStage.mapMod;
  boolean firstSkip=false;
  for(String line:fileInput){
    if(!firstSkip){
     firstSkip =true;
     continue;
    }
    objs.add(new EditorObj(line));
  }
}