void setup() {
  size(300, 160);
}

final float d = 15;

void draw() {
  if (mousePressed) {
    noStroke();
    fill(0);
    ellipse(mouseX, mouseY, d, d);
  }
}
