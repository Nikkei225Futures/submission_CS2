void setup() {
  size(300, 160);
}

void draw() {
  if ((mouseX < 100 && mouseY > 100) ||
      (mouseX >= 100 && mouseX <= 200 && mouseY >40) ||
      (mouseX > 200 && mouseY > 120)) {  
      background(10, 180, 255);
  } else {
      background(255, 255, 255);
  }
  
    line(0, 100, 100, 100);  //h
    line(100, 100, 100, 40);  //v
    line(100, 40, 200, 40);  //h
    line(200, 40, 200, 120);  //v
    line(200, 120, 300, 120);  //h
}
