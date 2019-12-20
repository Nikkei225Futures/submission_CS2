void setup() {
  size(300, 500);
}

float y = 0;
float x = 0;
float vy = 0;
float vx = 0;

void draw() {
  y += vy; 
  x += vx;
  vy += 0.001 * (height/2 - y); 
  vx += 0.002 * (width/2 - x);
  background(0);
  ellipse(x, y, 20, 20);
}
