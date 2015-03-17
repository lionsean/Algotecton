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

int volumeInterval=5;

int volumeIntervalMinor=5;

float[] tabLeft, tabRight;
float tabTop, tabBottom;
float tabPad=10;

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
 drawAxisLabels();
 drawTitleTabs();

 
 stroke(#5679C1);
 noFill();
 strokeWeight(2);
 drawDataCurve(currentColumn);
 drawDataHighlight(currentColumn);
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

void drawAxisLabels(){
  fill(0);
  textSize(13);
  textLeading(15);
  
  textAlign(CENTER, CENTER);
  text("Microgramme\n /Cubic Meter", labelX, (plotY1+plotY2)/2);
  textAlign(CENTER);
  text("Time", (plotX1+plotX2)/2, labelY);
}

void drawDataCurve(int col){
  beginShape();
  int rowCount=data.getRowCount();
  for (int row=0;row<rowCount;row++){
    if (data.isValid(row,col)){
      float value=data.getFloat(row,col);
      float x=map(times[row],timeMin,timeMax,plotX1,plotX2);
      float y=map(value,dataMin,dataMax,plotY2,plotY1);
      curveVertex(x,y);
      if ((row==0)||(row==rowCount-1)){
        curveVertex(x,y);
      }
    }
  }
  endShape();
}


void drawDataHighlight(int col){
  for (int row=0;row<rowCount;row++){
    if (data.isValid(row,col)){
      float value=data.getFloat(row,col);
      float x=map(times[row],timeMin,timeMax,plotX1,plotX2);
      float y=map(value,dataMin,dataMax,plotY2,plotY1);
      if (dist(mouseX,mouseY,x,y)<3){
        strokeWeight(10);
        point(x,y);
        fill(0);
        textSize(10);
        textAlign(CENTER);
        text(nf(value,0,2)+"("+times[row]+")",x,y-8);
      }
    }
  }
}

void drawTitleTabs(){
  rectMode(CORNERS);
  noStroke();
  textSize(20);
  textAlign(LEFT);
  
  if (tabLeft==null){
    tabLeft=new float[columnCount];
    tabRight=new float[columnCount];
  }
  
  float runningX=plotX1;
  tabTop=plotY1-textAscent()-15;
  tabBottom=plotY1;
  
  for (int col=0;col<columnCount;col++){
    String title=data.getColumnName(col);
    tabLeft[col]=runningX;
    float titleWidth=textWidth(title);
    tabRight[col]=tabLeft[col]+tabPad+titleWidth+tabPad;
    
    fill(col==currentColumn ? 255:224);
    rect(tabLeft[col],tabTop,tabRight[col],tabBottom);
    
    fill(col==currentColumn ? 0:64);
    text(title,runningX+tabPad,plotY1-10);
    
    runningX=tabRight[col];
  }
}

void mousePressed(){
  if(mouseY>tabTop && mouseY<tabBottom){
    for (int col=0;col<columnCount;col++){
      if (mouseX>tabLeft[col] && mouseX<tabRight[col]){
        setColumn(col);
      }
    }
  }
}

void setColumn(int col){
  if (col != currentColumn){
    currentColumn=col;
  }
}
