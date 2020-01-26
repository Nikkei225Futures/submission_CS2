class Ball {
  float x;
  float y;
  float vx;
  float vy;
  float d = 20;

  Ball(float x, float y) {
    this.x = x;
    this.y = y;
    vx = 0;
    vy = 0;
  }

  void move() {
    y += vy;
    if (y + 2 / d > height) {
      vy = -vy;
    } else {
      vy += 0.1;
    }
  }

  void draw() {
    noStroke();
    fill(255, 200);
    ellipse(x, y, 20, 20);
  }
}
