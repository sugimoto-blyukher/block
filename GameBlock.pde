class Block {
  float x;
  float y;
  float w;
  float h;
  int durability;

  Block(float x, float y, float w, float h, int durability) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.durability = durability;
  }

  void display() {
    if (durability > 0) {
      fill(100);
    } else {
      fill(200);
    }
    noStroke();
    rect(x, y, w, h);

    if (durability > 0) {
      fill(255);
      textAlign(CENTER, CENTER);
      textSize(12);
      text(durability, x + w / 2, y + h / 2);
    }
  }

  boolean contains(float px, float py) {
    return px > x && px < x + w && py > y && py < y + h;
  }

  void hit() {
    if (durability > 0) {
      durability--;
    }
  }

  boolean isBroken() {
    return durability == 0;
  }
}
