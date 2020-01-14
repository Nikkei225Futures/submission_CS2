void setup() {
  size(300, 300);
  noFill();
  stroke(255);
}

float[] x = new float[10];
float[] y = new float[10];
float[] d = new float[10];
int idx = 0;
void draw() {
  background(0);
  for (int i = 0; i < 10; i++) {
    if (d[i] > 0) {
      d[i] += 3;
      ellipse(x[i], y[i], d[i], d[i]);
    }
  }
}

void mousePressed() {
  d[idx] = 1;
  x[idx] = mouseX;
  y[idx] = mouseY;
  if(idx == 9){
   idx = 0; 
  } else {
    idx ++;
  }
}
