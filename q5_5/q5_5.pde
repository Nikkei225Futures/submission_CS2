void setup() {
  size(300, 500);
  y = height;
  vy = -17;
  x = 3;
}

float y,x;
float vy;

void draw() {
  y += vy;
  vy += 0.3;
  background(0);
  ellipse(sqrt(y), y, 20, 20);
}
