float d = 20;
float[] x = new float[16];
float[] y = new float[16];
float[] a = new float[16];
int fps = 60;
int t = 0;
int freq = 4;

void setup() {
  size(500, 500);
  frameRate(fps);
  for (int i = 0; i <= 15; i++) {
    a[i] = 360 / 16 * i;
  }
}

void draw() {
  background(0);
  if (t % (fps * freq) == 0) {
    float initX = random(width);
    float initY = random(height);
    for (int i = 0; i <= 15; i++) {
      x[i] = initX;
      y[i] = initY;
    }
  }

  for (int i = 0; i <= 15; i++) {
    int spd = 2;
    x[i] += spd * cos(radians(a[i]));
    y[i] += spd * sin(radians(a[i]));
  }

  for (int i = 0; i <= 15; i++) {
    noStroke();
    ellipse(x[i], y[i], d, d);
  }
  t ++;
}
