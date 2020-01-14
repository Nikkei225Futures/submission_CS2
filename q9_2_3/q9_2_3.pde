void setup(){
  size(300, 120);
}

void draw(){
}

void mousePressed(){
  drawFace(mouseX, mouseY);
}

void drawFace(float x, float y){  //(x, y) is center of a ellipse
    ellipse(x, y, 100, 80);
    fill(0);
    ellipse(x - 20, y - 10, 3, 3);
    ellipse(x + 20, y - 10, 3, 3);
    line(x - 10, y + 15, x + 10, y + 15);
    fill(255);
}
