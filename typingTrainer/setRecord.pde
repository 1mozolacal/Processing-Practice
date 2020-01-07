

//type sets
//lower, upper, punc, numbers, symbol, programers symbols
enum typeSet {lowwer,upper,punc,numbers,symbol,program};
boolean selectedTypeSet[] = {true,true,true,true,true,true};
ArrayList<Object[]> typeSetInfo = new ArrayList<Object[]>();//note the arrays will be of size 4 (char/String,errorPercentage,speed,amountTyped)
float[] typeSetErrorRange= {-1,-1,-1,-1,-1,-1};//lowwest error,highest error,lowwest speed, highest speed,lowwest amount,highest amount
int[] typeSetSpeedRange={-1,-1};
int[] typeSetAmountRange={-1,-1};



//dict sets
//top 100, top 1000,programming
enum dictSets {hundred,thousand,program};
boolean selectedDictSet[] = {true,false,false};
boolean useTypeSet = true;//true means use type set and false means dict


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
  int deltaSpeed = typeSetSpeedRange[3] - typeSetSpeedRange[2];
  int deltaAmount = typeSetAmountRange[5] - typeSetAmountRange[4];
  if(deltaError ==0 && deltaSpeed==0 && deltaAmount==0){
   return 1; //not proper data to create weights
  }
  Object[] charData=null;//First is String or Char next 3 are Integers
  for(Object[] charDataStepper: typeSetInfo){
   if(charDataStepper[0].equals(charNum)){//for String and char comparisons
     charData = charDataStepper;
     break;
   }
  }
  if(charData ==null){
    println("ERROR: no data on char");
    return 1;
  }
  float returnPro = (((Integer)charData[1]-typeSetErrorRange[0])/deltaError) *errorWeigthOnGeneration
                    + (((Integer)charData[2]-typeSetSpeedRange[2])/deltaSpeed) * speedWeightOnGeneration
                    + (((Integer)charData[3]-typeSetAmountRange[4])/deltaAmount) * amountWeigthOnGeneration;
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
}

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
}

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
}