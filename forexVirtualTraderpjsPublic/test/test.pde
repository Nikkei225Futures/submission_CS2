/*@pjs preload="./askOpens.txt, ./askHighs.txt, ./askLows.txt, ./askCloses.txt, ./bidOpens.txt, ./bidHighs.txt, ./bidLows.txt, ./bidCloses.txt";*/

  String[] as;
void setup() {
  size(500,500);
  as = loadStrings("../askOpens.txt");
  noLoop();
}

void draw() {
  text(as[1], 250, 250);
}

void mouseClicked() {
  ellipse(mouseX, mouseY, 50, 50);
}
