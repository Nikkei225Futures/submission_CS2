float[] y = new float[100];
int d = 20;

void setup() {
  size(1000, 400);
  for (int i = 0; i < y.length; i++) {
    y[i] = 0;
  }
}

void draw() {
  background(255);
  for (int i = y.length - 1; i > 0; i--) {
    y[i] = y[i - 1];
    y[0] = mouseY;
  }
  for (int i = 0; i < y.length; i++) {
    noStroke();
    fill(0);
    ellipse(d * i, y[i], d, d);
  }
}
