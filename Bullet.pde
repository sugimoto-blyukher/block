class Bullet {
  float x;
  float y;
  float vx;
  float vy;
  float size;

  Bullet(float x, float y, float vx, float vy, float size) {
    this.x = x;
    this.y = y;
    this.vx = vx;
    this.vy = vy;
    this.size = size;
  }

  void update() {
    x += vx;
    y += vy;
  }

  void display() {
    fill(255, 150, 0);
    noStroke();
    ellipse(x, y, size, size);
  }

  boolean isOffscreen() {
    return x < -size || x > width + size || y < -size || y > height + size;
  }
}
