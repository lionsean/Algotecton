float margin;
float space;

PImage img;

void setup(){
  margin=40;
  space=20;
  size(1000,350);
  stroke(125);
  img=loadImage("people.png");
}

void draw(){
  background(50);
  fill(0);
  for(float x=margin; x<=width-margin; x+=space){
    for(float y=margin; y<=height-margin; y+=space){
      float i=sqrt((mouseX-x)*(mouseX-x)+(mouseY-y)*(mouseY-y));
      float b=random(1,255);
      stroke(125);
      fill(255-x,y,b,200);
      ellipse(x,y,1000/i,1000/i);
    }
  }
  image(img,mouseX-80,mouseY-80,200,200);
}
