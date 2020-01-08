

//type sets
//lower, upper, punc, numbers, symbol, programers symbols
enum typeSet {lowwer,upper,punc,numbers,symbol,program};
boolean selectedTypeSet[] = {true,false,false,false,false,false};
ArrayList<Object[]> typeSetInfo = new ArrayList<Object[]>();//note the arrays will be of size 4 (char/String,errorPercentage,speed,amountTyped)
float[] typeSetErrorRange= {-1,-1};//lowwest error,highest error,lowwest speed, highest speed,lowwest amount,highest amount
float[] typeSetSpeedRange={-1,-1};
int[] typeSetAmountRange={-1,-1};



//dict sets
//top 100, top 1000,programming
enum dictSets {hundred,thousand,program};
boolean selectedDictSet[] = {true,false,false};
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
  if(deltaError ==0 && deltaSpeed==0 && deltaAmount==0){
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
  float returnPro = ((typeSetErrorRange[1]-(Float)charData.errorPercentage)/deltaError) *errorWeigthOnGeneration
                    + (((Float)charData.speedMillis-typeSetSpeedRange[0])/deltaSpeed) * speedWeightOnGeneration
                    + ((typeSetAmountRange[1]-(Integer)charData.typedAmount)/deltaAmount) * amountWeigthOnGeneration;
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
void updataMaxMin(){
  if(errorPercentage<typeSetErrorRange[0]){
  typeSetErrorRange[0]=errorPercentage;
  }
  if(errorPercentage>typeSetErrorRange[1]){
    typeSetErrorRange[1]=errorPercentage;
  }
  if(speedMillis<typeSetSpeedRange[0]){
    typeSetSpeedRange[0]=speedMillis;
  }
  if(speedMillis>typeSetSpeedRange[1]){
    typeSetSpeedRange[1]=speedMillis;
  }
  if(typedAmount<typeSetAmountRange[0]){
    typeSetAmountRange[0]=typedAmount;
  }
  if(typedAmount>typeSetAmountRange[1]){
    typeSetAmountRange[1]=typedAmount;
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