void setup() {
  size(300, 500);
  y = height;
  vy = -17;
  x = 3;
}

float y;
float vy;
float x;
void draw() {
  y += vy;
  vy += 0.3;
  x += 2;
  background(0);
  ellipse(x, y, 20, 20);
}
