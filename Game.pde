ArrayList<Bullet> bullets;
ArrayList<Block> blocks;
Block goalBlock;
Player player;

int frameCountSinceSpawn = 0;

void initializeGame() {
  bullets = new ArrayList<Bullet>();
  blocks = new ArrayList<Block>();
  player = new Player(width / 2, height - 60, 20, 5);
  frameCountSinceSpawn = 0;

  float goalSize = 120;
  goalBlock = new Block(
    width / 2 - goalSize / 2,
    height / 2 - 100 - goalSize / 2,
    goalSize,
    goalSize,
    -1
  );
}

void drawGame() {
  spawnBullets();
  drawBlocks();
  drawGoal();
  updateBullets();

  player.update();
  player.display();

  if (goalBlock.contains(player.x, player.y)) {
    startEnding();
    scene = ENDING_SCENE;
    return;
  }

  checkPlayerHit();
}

void drawBlocks() {
  for (Block block : blocks) {
    block.display();
  }
}

void drawGoal() {
  fill(0, 0, 255);
  noStroke();
  rect(goalBlock.x, goalBlock.y, goalBlock.w, goalBlock.h);
}

void updateBullets() {
  for (int i = bullets.size() - 1; i >= 0; i--) {
    Bullet bullet = bullets.get(i);
    bullet.update();

    if (hitBlock(bullet)) {
      bullets.remove(i);
      continue;
    }

    bullet.display();
    if (bullet.isOffscreen()) {
      bullets.remove(i);
    }
  }
}

boolean hitBlock(Bullet bullet) {
  for (int i = blocks.size() - 1; i >= 0; i--) {
    Block block = blocks.get(i);
    if (!block.contains(bullet.x, bullet.y)) {
      continue;
    }

    block.hit();
    if (block.isBroken()) {
      blocks.remove(i);
    }
    return true;
  }
  return false;
}

void checkPlayerHit() {
  for (Bullet bullet : bullets) {
    float collisionDistance = bullet.size / 2 + player.size / 2;
    if (dist(bullet.x, bullet.y, player.x, player.y) < collisionDistance) {
      noLoop();
      fill(255, 0, 0);
      textAlign(CENTER, CENTER);
      textSize(48);
      text("GAME OVER", width / 2, height / 2);
      return;
    }
  }
}

void handleGameKeyPressed() {
  if (key == 'a') {
    addBlockAtPlayer();
  } else if (keyCode == ESC) {
    scene = TITLE_SCENE;
    initializeGame();
    loop();
  }
}

void addBlockAtPlayer() {
  float blockSize = 40;
  blocks.add(
    new Block(
      player.x - blockSize / 2,
      player.y - blockSize / 2,
      blockSize,
      blockSize,
      5
    )
  );
}

void spawnBullets() {
  frameCountSinceSpawn++;
  if (frameCountSinceSpawn % 240 == 0) {
    spawnRadialBullets();
  }
  spawnSpiralBullet();
}

void spawnRadialBullets() {
  int numBullets = 30;
  float speed = 3;

  for (int i = 0; i < numBullets; i++) {
    float angle = TWO_PI * i / numBullets;
    bullets.add(
      new Bullet(
        width / 2,
        height / 2 - 100,
        cos(angle) * speed,
        sin(angle) * speed,
        8
      )
    );
  }
}

void spawnSpiralBullet() {
  float speed = 4;
  float angle = frameCountSinceSpawn * 0.05;
  bullets.add(
    new Bullet(
      width / 2,
      height / 2 - 100,
      cos(angle) * speed,
      sin(angle) * speed,
      6
    )
  );
}
