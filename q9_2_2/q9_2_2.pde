int cl = 255;
void draw() {
  background(204);
  ellipse(width/2, height/2, 50, 50);
}

void mousePressed() {
  if (dist(width/2, height/2, mouseX, mouseY) < 25) {
    cl = 255 - cl;
    fill(cl);
  }
}
