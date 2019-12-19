void setup() {
  size(480, 120);
}

float x = 0;
float y = 0;

void draw() {
  x += (mouseX - x) * 0.1;
  y += (mouseY - y) * 0.1;
  background(204);
  drawFace(x, y);
}

void drawFace(float x,float y){  //(x,y) is center of a ellipse
    ellipse(x, y, 100, 80);
    fill(0);
    ellipse(x - 20, y - 10, 3, 3);
    ellipse(x + 20, y - 10, 3, 3);
    line(x - 10, y + 15, x + 10, y + 15);
    fill(255);
}
