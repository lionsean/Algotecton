PImage mapImage;
Table locationTable;
Table nameTable;
int rowCount;

Table dataTable;
float dataMin=-10;
float dataMax=10;

Integrator[]interpolators;

void setup(){
  size(640,400);
  mapImage=loadImage("usmap.png");
  locationTable=new Table("locations.tsv");
  nameTable=new Table("names.tsv");
  rowCount=locationTable.getRowCount();
  
  dataTable=new Table("random.tsv");
  
  PFont font=loadFont("SourceSansPro-Light-12.vlw");
  textFont(font);
  
  interpolators=new Integrator[rowCount];
  
  for (int row=0;row<rowCount;row++){
    float initialValue=dataTable.getFloat(row,1);
    interpolators[row]=new Integrator(initialValue);
  }
}

float closestDist;
String closestText;
float closestTextX;
float closestTextY;

void draw(){
  background(255);
  image(mapImage,0,0);
  
  for (int row=0;row<rowCount;row++){
    interpolators[row].update();
  }
  
  closestDist=MAX_FLOAT;
  
  for (int row=0;row<rowCount;row++){
    String abbrev=dataTable.getRowName(row);
    float x=locationTable.getFloat(abbrev,1);
    float y=locationTable.getFloat(abbrev,2);
    drawData(x,y,abbrev);
  }
  
  if (closestDist !=MAX_FLOAT){
    fill(0);
    textAlign(CENTER);
    text(closestText,closestTextX,closestTextY);
  }
}
  
  void drawData(float x, float y, String abbrev){
    int row=dataTable.getRowIndex(abbrev);
    float value=interpolators[row].value;
    
    float radius=0;
    if (value>=0){
      radius=map(value,0,dataMax,1.5,15);
      fill(#FF4422);
    }else{
      radius=map(value,0,dataMin,1.5,15);
      fill(#FF4422);
    }
    ellipseMode(RADIUS);
    ellipse(x,y,radius,radius); 
    
    float d=dist(x,y,mouseX,mouseY);
    if ((d<radius+2)&&(d<closestDist)){
      closestDist=d;
      String name=nameTable.getString(abbrev,1);
      closestText=name +""+ value;
      closestTextX=x;
      closestTextY=y-radius-4;
    }
  }

void keyPressed(){
  if (key == ' '){
    updateTable();
  }
}

void updateTable(){
  for(int row=0;row<rowCount;row++){
    float newValue=random(-10,10);
    interpolators[row].target(newValue);
  }
}
