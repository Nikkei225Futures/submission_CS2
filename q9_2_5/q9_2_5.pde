float[] y = new float[100];
float[] x = new float[100];
float[] vy = new float[100];
int idx = 1;
float d = 20;

void setup() {
  size(400, 300);
}

void draw() {
  for (int i = 0; i < x.length; i++) {
    y[i] += vy[i];
    if (y[i] + 2 / d > height) {
      vy[i] = -vy[i];
    } else {
      vy[i] += 0.1;
    }
  }
  background(0);
  for (int i = 0; i < x.length; i++) {
    ellipse(x[i], y[i], d, d);
  }
}

void mousePressed(){
  x[idx] = mouseX;
  y[idx] = mouseY;
  vy[idx] = 0;
  idx ++;
}
