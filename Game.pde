ArrayList<Bullet> bullets;
ArrayList<PlayerBullet> playerBullets;
ArrayList<Block> blocks;
Block goalBlock;
Player player;

int frameCountSinceSpawn = 0;

void initializeGame() {
  bullets = new ArrayList<Bullet>();
  playerBullets = new ArrayList<PlayerBullet>();
  blocks = new ArrayList<Block>();
  player = new Player(width / 2, height - 60, 20, 5, fighterImage);
  frameCountSinceSpawn = 0;

  float goalSize = 120;
  goalBlock = new Block(
    width / 2 - goalSize / 2,
    height / 2 - 100 - goalSize / 2,
    goalSize,
    goalSize,
    -1,
    false
  );

  addInitialBlocks();
}

void drawGame() {
  image(gameBackgroundImage, 0, 0, width, height);

  // 弾と障害物を更新した後にプレイヤーと各当たり判定を処理する。
  spawnBullets();
  drawBlocks();
  drawGoal();
  updateBullets();
  updatePlayerBullets();

  float previousPlayerX = player.x;
  float previousPlayerY = player.y;
  player.update();
  if (isPlayerTouchingBlock()) {
    player.x = previousPlayerX;
    player.y = previousPlayerY;
  }
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
  // ゴールの当たり判定範囲に合わせて要塞画像を描画する。
  image(goalImage, goalBlock.x, goalBlock.y, goalBlock.w, goalBlock.h);
}

void updateBullets() {
  // 要素を安全に削除できるよう、リストの末尾から走査する。
  for (int i = bullets.size() - 1; i >= 0; i--) {
    Bullet bullet = bullets.get(i);
    bullet.update();

    if (hitPlayerPlacedBlock(bullet.x, bullet.y)) {
      bullets.remove(i);
      continue;
    }

    bullet.display();
    if (bullet.isOffscreen()) {
      bullets.remove(i);
    }
  }
}

boolean hitPlayerPlacedBlock(float x, float y) {
  // 敵弾はプレイヤーが設置したブロックだけに遮られる。
  for (int i = blocks.size() - 1; i >= 0; i--) {
    Block block = blocks.get(i);
    if (block.solidForPlayer || !block.contains(x, y)) {
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

void updatePlayerBullets() {
  // プレイヤー弾はブロックへの命中、または射程200への到達で消滅する。
  for (int i = playerBullets.size() - 1; i >= 0; i--) {
    PlayerBullet bullet = playerBullets.get(i);
    bullet.update();

    if (hitBlock(bullet.x, bullet.y)) {
      playerBullets.remove(i);
      continue;
    }

    bullet.display();
    if (bullet.reachedMaxRange()) {
      playerBullets.remove(i);
    }
  }
}

boolean hitBlock(float x, float y) {
  // 壊れたブロックをその場で削除するため、ここでも末尾から走査する。
  for (int i = blocks.size() - 1; i >= 0; i--) {
    Block block = blocks.get(i);
    if (!block.contains(x, y)) {
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

boolean isPlayerTouchingBlock() {
  float halfSize = player.size / 2;

  for (Block block : blocks) {
    if (!block.solidForPlayer) {
      continue;
    }

    boolean overlapsHorizontally =
      player.x + halfSize > block.x && player.x - halfSize < block.x + block.w;
    boolean overlapsVertically =
      player.y + halfSize > block.y && player.y - halfSize < block.y + block.h;

    if (overlapsHorizontally && overlapsVertically) {
      return true;
    }
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
  } else if (key == ' ') {
    shootPlayerBullet();
  } else if (keyCode == ESC) {
    scene = TITLE_SCENE;
    initializeGame();
    loop();
  }
}

void shootPlayerBullet() {
  playerBullets.add(
    new PlayerBullet(player.x, player.y - player.size / 2, 10, 6, 200)
  );
}

void addInitialBlocks() {
  float blockSize = 40;
  float[] xRates = {
    0.14, 0.28, 0.42, 0.58, 0.72, 0.86,
    0.20, 0.32, 0.44, 0.56, 0.68, 0.80,
    0.14, 0.28, 0.42, 0.58, 0.72, 0.86
  };
  float[] yRates = {
    0.78, 0.78, 0.78, 0.78, 0.78, 0.78,
    0.68, 0.68, 0.68, 0.68, 0.68, 0.68,
    0.58, 0.58, 0.58, 0.58, 0.58, 0.58
  };

  // 解像度が変わっても同じ隊形になるよう、画面比率から配置を決める。
  for (int i = 0; i < xRates.length; i++) {
    blocks.add(
      new Block(
        width * xRates[i] - blockSize / 2,
        height * yRates[i] - blockSize / 2,
        blockSize,
        blockSize,
        3,
        true
      )
    );
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
      5,
      false
    )
  );
}

void spawnBullets() {
  frameCountSinceSpawn++;

  // 一定間隔の放射弾に、毎フレーム向きが変わる螺旋弾を重ねる。
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
