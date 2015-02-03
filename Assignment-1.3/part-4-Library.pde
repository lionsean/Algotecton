import controlP5.*;

ControlP5 cp5;

int gValue=255;

void setup() {
  size(500,500);
  cp5 = new ControlP5(this);
  
  cp5.addSlider("gValue")
  .setPosition(100,125)
  .setSize(100,20)
  .setRange(0,255);
}

 
void draw(){
  frameRate(2);
  draw_green_square(50);
}

void draw_green_square(int square_size){
  for(int x=0;x<width;x+=square_size){
    for(int y=0;y<height;y+=square_size){
      fill(0,gValue,0);
      rect(x,y,square_size,square_size);
    }
  }
}
