void setup() {
  size(300, 120);
}

float d = 60;
float x = 0 - d / 2;

void draw() {
  x++;
  float y = height / 2;
  float a = 30 + 25 * sin(radians(x * 20));
  background(0);  
  fill(255, 214, 0);
  arc(x, y, d, d, radians(a), radians(360) - radians(a));
}
