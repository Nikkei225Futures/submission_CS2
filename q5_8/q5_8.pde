void setup() {
  size(650, 300);
}

float y = 0;
float vy = 0;
float d = 20;
float x = 0;

void draw() {
  y += vy;
  x += 2;
  if (y + 2 / d > height) {
    vy = -vy;
  } else {
    vy += 0.3;
  }
  
  if(x - d / 2 > width){
    x = 0;
  }
  background(0);
  ellipse(x, y, d, d);
}
