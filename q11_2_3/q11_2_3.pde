Ball[] ball = new Ball[100];
int nBall = 0;  // 生成済みのボール数

void setup() {
  size(400, 300);
}

void draw() {
  background(0);
  for (int i = 0; i < nBall; i++) {
    ball[i].move();  // ボールを移動
    ball[i].draw();  // ボールを描画
  }
}

void mousePressed() {
  ball[nBall] = new Ball(mouseX, mouseY);
  nBall++;
}
