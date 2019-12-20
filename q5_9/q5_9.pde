float r = 150;
float t = 270;
float d = 20;

void setup() {
  size(500, 400);
}

void draw() {
  translate(width / 2, height / 2);
  float x = r * cos(radians(t));
  float y = r * sin(radians(t));
  background(0);
  ellipse(x, y, d, d);
  t += 2;
}
