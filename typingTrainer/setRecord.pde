

//type sets
//lower, upper, punc, numbers, symbol, programers symbols,repeat all chacters 2-5 time(doesn't add char by itself)
enum typeSet {lowwer,upper,punc,numbers,symbol,program,repeat};
boolean selectedTypeSet[] = {false,false,false,false,false,false,false};
ArrayList<Object[]> typeSetInfo = new ArrayList<Object[]>();//note the arrays will be of size 4 (char/String,errorPercentage,speed,amountTyped)
float[] typeSetErrorRange= {-1,-1};//lowwest error,highest error,lowwest speed, highest speed,lowwest amount,highest amount
ItemRecord[] errorRangeObjects ={null,null};//these are the objects that set the mins and maxs
float[] typeSetSpeedRange={-1,-1};
ItemRecord[] speedRangeObjects ={null,null};
int[] typeSetAmountRange={-1,-1};
ItemRecord[] amountRangeObjects ={null,null};



//dict sets
//top 100, top 1000,programming
enum dictSets {hundred,thousand,program};
boolean selectedDictSet[] = {false,false,false};//This one is being used
boolean useTypeSet = true;//true means use type set and false means dict



//---------------------base item class
class ItemRecord{
  //These are all averages
  float errorPercentage;
  float speedMillis;
  //This is cumulative
  int typedAmount;
  //flag if the data has been set
  boolean nullData;
  
  
  ItemRecord(){
    nullData=true;
  }
  
  ItemRecord(float error, float speed,int amount){
    nullData=false;
    errorPercentage=error;
    speedMillis=speed;
    typedAmount=amount;
  }
  
  
  float getProbability(Object charNum){
  float deltaError = typeSetErrorRange[1] - typeSetErrorRange[0];
  float deltaSpeed = typeSetSpeedRange[1] - typeSetSpeedRange[0];
  int deltaAmount = typeSetAmountRange[1] - typeSetAmountRange[0];
  if(deltaError ==0 || deltaSpeed==0 || deltaAmount==0){
   return 1; //not proper data to create weights
  }
  ItemRecord charData=null;//First is String or Char next 3 are Integers
  for(ItemRecord charDataStepper: records){
   if(charDataStepper.getItem().equals(charNum)){//for String and char comparisons
     charData = charDataStepper;
     break;
   }
  }
  if(charData ==null){
    println("ERROR: no data on char");
    return 1;
  }
  float returnPro = (((Float)charData.errorPercentage-typeSetErrorRange[0])/deltaError) *errorWeigthOnGeneration
                    + (((Float)charData.speedMillis-typeSetSpeedRange[0])/deltaSpeed) * speedWeightOnGeneration
                    + ((typeSetAmountRange[1]-(Integer)charData.typedAmount)/(float)deltaAmount) * amountWeigthOnGeneration;
  return returnPro;
}

boolean typeIsChar(){
  return false;
}
boolean typeIsString(){
 return true; 
}
Object getItem(){
  return null;
}
void addCorrectEntry(int millis){
  speedMillis= (millis+ speedMillis*typedAmount) / (typedAmount+1);
  errorPercentage= (errorPercentage*typedAmount) / (typedAmount+1);
  typedAmount++;
  updataMaxMin();
}
void addMistype(){
  errorPercentage= (errorPercentage*typedAmount +1) / (typedAmount+1);
  typedAmount++;
  updataMaxMin();
}
String stringify(){
  return "Base can't be stringified";
}

//todo-second-round: come back and redo how this min and max stuff is done so that if just uses to arrays and loops them and doesn't use exact number to index
//                    note that this is will be a bit of work because the code relies on this information else where(I believe) to be careful about that
//                    and make and helper function that can be used else where in the code to get the information it needs
void updataMaxMin(){
  if(errorRangeObjects[0]==this || errorRangeObjects[1] == this ||
  speedRangeObjects[0]==this || speedRangeObjects[1]==this||
  amountRangeObjects[0]==this || amountRangeObjects[1]==this){
    typeSetErrorRange[0]=-1;
    typeSetErrorRange[1]=-1;
     errorRangeObjects[0]=null;
     errorRangeObjects[1] =null;
     typeSetSpeedRange[0]=-1;
     typeSetSpeedRange[1]=-1;
     speedRangeObjects[0]=null;
     speedRangeObjects[1]=null;
     typeSetAmountRange[0]=-1;
     typeSetAmountRange[1]=-1;
     amountRangeObjects[0]=null;
     amountRangeObjects[1]=null;
    for(ItemRecord rec: records){
     rec.updataMaxMinSubRoutine(); 
    }
  }
  
  updataMaxMinSubRoutine();
  
}
void updataMaxMinSubRoutine(){
  if(errorPercentage<typeSetErrorRange[0] || typeSetErrorRange[0] == -1){
  typeSetErrorRange[0]=errorPercentage;
  errorRangeObjects[0]=this;
  }
  if(errorPercentage>typeSetErrorRange[1] || typeSetErrorRange[1] == -1){
    typeSetErrorRange[1]=errorPercentage;
    errorRangeObjects[1]=this;
  }
  if(speedMillis<typeSetSpeedRange[0] || typeSetSpeedRange[0] == -1){
    typeSetSpeedRange[0]=speedMillis;
    speedRangeObjects[0]=this;
  }
  if(speedMillis>typeSetSpeedRange[1] || typeSetSpeedRange[1] == -1){
    typeSetSpeedRange[1]=speedMillis;
    speedRangeObjects[1]=this;
  }
  if(typedAmount<typeSetAmountRange[0] || typeSetAmountRange[0] == -1){
    typeSetAmountRange[0]=typedAmount;
    amountRangeObjects[0]=this;
  }
  if(typedAmount>typeSetAmountRange[1] || typeSetAmountRange[1] == -1){
    typeSetAmountRange[1]=typedAmount;
    amountRangeObjects[1]=this;
  }
}

}


//------------------------------------------char class
class CharRecord extends ItemRecord{
  char item;
  CharRecord(){
    nullData=true;
  }
  
  CharRecord(char inputItem,float error, float speed,int amount){
    super(error,speed,amount);
    item=inputItem;
  }
  
  float getProbability(){
    return getProbability(item);
  }
  boolean typeIsChar(){
  return true;
}
Object getItem(){
 return item; 
}
String stringify(){
  return ""+item+": " + errorPercentage+","+speedMillis+","+typedAmount;
}
}


//----------------------------------------string class
class StringRecord extends ItemRecord{
  String item;
  StringRecord(){
    nullData=true;
  }
  
  StringRecord(String inputItem,float error, float speed,int amount){
    super(error,speed,amount);
    item=inputItem;
  }
  
  float getProbability(){
    return getProbability(item);
  }
  boolean typeIsString(){
  return true;
}
Object getItem(){
 return item; 
}
String stringify(){
  return ""+item+": " + errorPercentage+","+speedMillis+","+typedAmount;
}
}