// Ballクラスの定義
class Ball {
  // メンバー変数
  float x;
  float y;
  float vx;
  float vy;

  // コンストラクタ
  Ball() {
    x = random(width);
    y = random(height);
    vx = 0;
    vy = 0;
  }
 
  // メンバー関数
  void move() {
    x += vx;
    y += vy;
    vx += 0.001 * (width /2 - x);
    vy += 0.002 * (height/2 - y);
  }
 
  void draw() {  // コールバック関数のdrawとは無関係
    noStroke();
    fill(255, 200);
    ellipse(x, y, 20, 20);
  }
}
