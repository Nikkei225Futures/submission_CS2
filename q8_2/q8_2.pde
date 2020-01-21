float[] y = new float[20];
float[] x = new float[20];
float[] vy = new float[20];
float d = 20;

void setup() {
  size(400, 300);
  for (int i = 0; i <= 19; i++ ) {
    x[i] = 20 * i;
    y[i] = random(height / 2);
    vy[i] = 0;
  }
}

void draw() {
  for (int i = 0; i <= 19; i++) {
    y[i] += vy[i];
    if (y[i] + 2 / d > height) {
      vy[i] = -vy[i];
    } else {
      vy[i] += 0.1;
    }
  }
  background(0);
  for (int i = 0; i <= 19; i++) {
    ellipse(x[i], y[i], d, d);
  }
}
