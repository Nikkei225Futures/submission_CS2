void setup() {
  size(400, 400);
}

Ball ball = new Ball(); // Ballオブジェクトの生成

void draw() {
  background(0);
  ball.move();  // ボールを移動
  ball.draw();  // ボールを描画
}
