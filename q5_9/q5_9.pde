float r = 150;
float t = 0;

void setup() {
  size(500, 400);
}

void draw() {
  float x = r * cos(radians(t));
  float y = r *sin(radians(t));
}
