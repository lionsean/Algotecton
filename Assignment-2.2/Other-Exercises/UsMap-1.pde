PImage mapImage;
Table locationTable;
int rowCount;

Table dataTable;
float dataMin=MAX_FLOAT;
float dataMax=MIN_FLOAT;

void setup(){
  size(640,400);
  mapImage=loadImage("usmap.png");
  locationTable=new Table("locations.tsv");
  rowCount=locationTable.getRowCount();
  
  dataTable=new Table("random.tsv");
  
  for (int row=0;row<rowCount;row++){
    float value=dataTable.getFloat(row,1);
    if (value>dataMax){
      dataMax=value;
    }
    if (value<dataMin){
      dataMin=value;
    }
  } 
}

void draw(){
  background(255);
  image(mapImage,0,0);
  
  smooth();
  fill(192,0,0);
  noStroke();
  
  for (int row=0;row<rowCount;row++){
    String abbrev=dataTable.getRowName(row);
    float x=locationTable.getFloat(abbrev,1);
    float y=locationTable.getFloat(abbrev,2);
    drawData(x,y,abbrev);
  }
}
  
  void drawData(float x, float y, String abbrev){
    float value=dataTable.getFloat(abbrev,1);
    float mapped=map(value,dataMin,dataMax,2,40);
    ellipse(x,y,mapped,mapped);
  }
  
//  for (int row=0;row<rowCount;row++){
//    float x=locationTable.getFloat(row,1);
//    float y=locationTable.getFloat(row,2);
//    ellipse(x,y,9,9);
//  }
//}
