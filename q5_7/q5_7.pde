void setup() {
  size(300, 500);
}

float y = 0;
float vy = 0;
float d = 20;

void draw() {
  y += vy;
  
  if (y + 2 / d > height) {
    vy = -vy;
  } else {
    vy += 0.3;
  }
  
  background(0);
  ellipse(width/2, y, d, d);
}
