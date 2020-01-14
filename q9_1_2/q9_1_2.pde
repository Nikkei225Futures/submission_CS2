void setup() {
  size(300, 160);
}

void draw() {
  float ox = width /2 - 40;
  float oy = height/2 - 40;
  background(204);

  // 背景の正方形の色を設定
  if (mouseY + 25 > oy && mouseY - 25 < oy + 80 &&
    mouseX + 25 > ox && mouseX - 25 < ox + 80) {
    fill(0);
  }

  // 背景の正方形を描画 (1辺80)
  rect(ox, oy, 80, 80);

  // マウスカーソルの位置の正方形を描画 (1辺50)
  fill(255); // 白
  rect(mouseX - 25, mouseY - 25, 50, 50);
}
