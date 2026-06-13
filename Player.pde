class Player {
  float x;
  float y;
  float size;
  float speed;
  PImage sprite;

  Player(float x, float y, float size, float speed, PImage sprite) {
    this.x = x;
    this.y = y;
    this.size = size;
    this.speed = speed;
    this.sprite = sprite;
  }

  void update() {
    if (keyPressed) {
      if (keyCode == LEFT) {
        x -= speed;
      } else if (keyCode == RIGHT) {
        x += speed;
      } else if (keyCode == UP) {
        y -= speed;
      } else if (keyCode == DOWN) {
        y += speed;
      }
    }

    // プレイヤーの円全体が画面内に収まる位置へ補正する。
    x = constrain(x, size / 2, width - size / 2);
    y = constrain(y, size / 2, height - size / 2);
  }

  void display() {
    imageMode(CENTER);
    image(sprite, x, y, size, size);
    imageMode(CORNER);
  }
}
