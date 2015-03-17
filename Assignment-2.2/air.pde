FloatTable data;
float dataMin, dataMax;

float plotX1, plotY1;
float plotX2, plotY2;
float labelX, labelY;

int currentColumn=0;
int columnCount;
int rowCount;

int timeMin, timeMax;
int[] times;

PFont plotFont;

int timeInterval=1;

int volumeInterval=10;

int volumeIntervalMinor=5;

void setup(){
  size(900,600);
  
  data=new FloatTable("air-beijing.tsv");
  columnCount=data.getColumnCount();
  rowCount=data.getRowCount();
  
  times=int(data.getRowNames());
  timeMin=times[0];
  timeMax=times[times.length-1];
  
  dataMin=0;
  dataMax=data.getTableMax();
  
  plotX1=120;
  plotX2=width-80;
  plotY1=60;
  plotY2=height-70;
  labelX=50;
  labelY=height-25;
  
  plotFont=createFont("SansSerif",20);
  textFont(plotFont);
  
  smooth();
}

void draw(){
 background(224);
  
 fill(255);
 rectMode(CORNERS);
 noStroke();
 rect(plotX1,plotY1,plotX2,plotY2);
 
 drawTimeLabels();
 drawTitle();
 drawVolumeLabels();
 
 stroke(#5679C1);
 strokeWeight(5);
 drawDataPoints(currentColumn);
}

void drawDataPoints(int col){
  int rowCount=data.getRowCount();
  for (int row=0;row<rowCount;row++){
    if(data.isValid(row,col)){
      float value=data.getFloat(row,col);
      float x=map(times[row],timeMin,timeMax,plotX1,plotX2);
      float y=map(value,dataMin,dataMax,plotY2,plotY1);
      point(x,y);
    }
  }
}

void keyPressed(){
  if (key=='['){
    currentColumn--;
    if (currentColumn<0){
      currentColumn=columnCount-1;
    }
  }else if (key==']'){
    currentColumn++;
    if (currentColumn==columnCount){
      currentColumn=0;
    }
  }
}

void drawTitle(){
  fill(0);
  textSize(20);
  textAlign(LEFT);
  String title=data.getColumnName(currentColumn);
  text(title,plotX1,plotY1-10);
}


void drawTimeLabels(){
  fill(0);
  textSize(10);
  textAlign(CENTER, TOP);
  
  stroke(224);
  strokeWeight(1);
  
  for (int row=0;row<rowCount;row++){
    if (times[row] % timeInterval==0){
      float x=map(times[row], timeMin, timeMax, plotX1, plotX2);
      text(times[row], x, plotY2+5);
      line(x,plotY1,x,plotY2);
    }
  }
}


void drawVolumeLabels(){
  fill(0);
  textSize(10);
  
  stroke(224);
  strokeWeight(1);
  
  for (float v=dataMin;v<dataMax;v += volumeIntervalMinor){
    if (v % volumeIntervalMinor == 0){
    float y=map(v,dataMin,dataMax,plotY2,plotY1);
    if (v % volumeInterval == 0){
      if (v == dataMin){
        textAlign(RIGHT);
      }else if (v == dataMax){
        textAlign (RIGHT, TOP);
      }else {
        textAlign(RIGHT, CENTER);
      }
      text(floor(v), plotX1-10, y);
      line(plotX1, y, plotX2, y);
    }else {
      line(plotX1, y, plotX2, y);
    }
    }
  }
}
