// case study of the facade color, Kengo Kuma, The Opposite House

void setup(){
 size(500, 500);
}
 
void draw(){
  frameRate(2);
  draw_green_square(50);
}

void draw_green_square(int square_size){
  for(int a=0;a<width;a+=square_size){
    for(int b=0;b<height;b+=square_size){
      float r=random(1,255);
      float g=random(1,255);
      fill(r,r+g,0);
//      fill(0,g,0);
      rect(a,b,square_size,square_size);
    }
  }
}
