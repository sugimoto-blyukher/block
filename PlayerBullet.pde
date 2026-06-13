class PlayerBullet {
  float x;
  float y;
  float startY;
  float speed;
  float size;
  float range;

  PlayerBullet(float x, float y, float speed, float size, float range) {
    this.x = x;
    this.y = y;
    this.startY = y;
    this.speed = speed;
    this.size = size;
    this.range = range;
  }

  void update() {
    y -= speed;
  }

  void display() {
    fill(0, 255, 255);
    noStroke();
    rectMode(CENTER);
    rect(x, y, size, size * 2);
    rectMode(CORNER);
  }

  boolean reachedMaxRange() {
    return startY - y >= range;
  }
}
