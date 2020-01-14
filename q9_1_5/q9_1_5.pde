int cirCl = 255;
int sqrCl = 255;

float ciX = 100;
float ciY = 80;
float r = 40;
float sqX = 200;
float sqY = 40;
void setup() {
  size(340, 160);
}

void draw() {
  if (dist(ciX, ciY, mouseX, mouseY) < 40) {
    cirCl = 0;
  } else {
    cirCl = 255;
  }
  fill(sqrCl);
  rect(sqX, sqY, 80, 80);
  if (mouseY > sqY && mouseY < sqY +80 &&
    mouseX > sqX && mouseX < sqX +80) {
    sqrCl = 0;
  } else {
    sqrCl = 255;
  }
  fill(cirCl);
  ellipse(ciX, ciY, 80, 80);
}
