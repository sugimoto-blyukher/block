class Player {
  float x;
  float y;
  float size;
  float speed;

  Player(float x, float y, float size, float speed) {
    this.x = x;
    this.y = y;
    this.size = size;
    this.speed = speed;
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

    x = constrain(x, size / 2, width - size / 2);
    y = constrain(y, size / 2, height - size / 2);
  }

  void display() {
    fill(0, 200, 255);
    noStroke();
    ellipse(x, y, size, size);
  }
}
