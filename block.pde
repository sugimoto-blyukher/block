//情報表現入門提出課題
//import ddf.minim.*;

ArrayList<Bullet> bullets;
ArrayList<Block> blocks;
Block goalBlock;

//AudioPlayer music;
Player player;
//Minim minim;

int frameCountSinceSpawn = 0;
int scene = 0;  // 0: タイトル, 1: ゲーム

void setup() {
  //minim = new Minim(this);
  //music = minim.loadFile("konngyo-reverse.wav");
  size(600, 800);
}

void draw() {
  background(0);
  if (scene == 0) {
    drawTitle();
  } else {
    drawGame();
  }
}
/*
void stop(){
 
 music.close();  //サウンドデータを終了
 minim.stop();
 super.stop();
 }
 */

void drawTitle() {
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(64);
  text("DANMAKU GAME", width / 2, height / 2 - 40);
  textSize(24);
  text("Press ENTER to Start", width / 2, height / 2 + 40);
}

void drawGame() {
  //music.play();
  //music.rewind();  //再生が終わったら巻き戻しておく
  spawnBullets();

  // 通常ブロック描画
  for (Block block : blocks) {
    block.display();
  }

  // ゴールブロック描画
  fill(0, 0, 255);
  noStroke();
  rect(goalBlock.x, goalBlock.y, goalBlock.w, goalBlock.h);

  // 弾更新・描画
  for (int i = bullets.size() - 1; i >= 0; i--) {
    Bullet bullet = bullets.get(i);
    bullet.update();

    boolean bulletRemoved = false;
    // 耐久ブロックとの衝突判定
    for (int j = blocks.size() - 1; j >= 0; j--) {
      Block block = blocks.get(j);
      if (block.contains(bullet.x, bullet.y)) {
        bullets.remove(i);
        bulletRemoved = true;
        block.hit();
        if (block.isBroken()) {
          blocks.remove(j);
        }
        break;
      }
    }
    if (bulletRemoved) {
      continue;
    }

    bullet.display();
    if (bullet.isOffscreen()) {
      bullets.remove(i);
    }
  }

  player.update();
  player.display();

  // ゴール判定
  if (goalBlock.contains(player.x, player.y)) {
    noLoop();
    fill(0, 255, 0);
    textAlign(CENTER, CENTER);
    textSize(48);
    text("GAME CLEAR", width / 2, height / 2);
    return;
  }

  // プレイヤーと弾の衝突判定
  for (Bullet bullet : bullets) {
    if (dist(bullet.x, bullet.y, player.x, player.y)
      < (bullet.size / 2 + player.size / 2)) {
      noLoop();
      fill(255, 0, 0);
      textAlign(CENTER, CENTER);
      textSize(48);
      text("GAME OVER", width / 2, height / 2);
      break;
    }
  }
}

void keyPressed() {
  if (scene == 0 && keyCode == ENTER) {
    scene = 1;
    initGame();
    loop();
  } else if (scene == 1) {
    if (key == 'a') {
      float blockSize = 40;
      blocks.add(
        new Block(
        player.x - blockSize / 2,
        player.y - blockSize / 2,
        blockSize,
        blockSize,
        3));
    } else if (keyCode == ESC) {
      scene = 0;
      initGame();
      loop();
    }
  }
}

void initGame() {
  bullets = new ArrayList<Bullet>();
  blocks = new ArrayList<Block>();
  player = new Player(width / 2, height - 60, 20, 5);
  frameCountSinceSpawn = 0;
  float goalSize = 30;
  goalBlock = new Block(
    width / 2 - goalSize / 2,
    height / 2 - 100 - goalSize / 2,
    goalSize,
    goalSize,
    -1);  // ゴールブロックは壊れない
}

void spawnBullets() {
  frameCountSinceSpawn++;
  if (frameCountSinceSpawn % 60 == 0) {
    int numBullets = 30;
    for (int i = 0; i < numBullets; i++) {
      float angle = TWO_PI * i / numBullets;
      float speed = 3;
      bullets.add(
        new Bullet(
        width / 2,
        height / 2 - 100,
        cos(angle) * speed,
        sin(angle) * speed,
        8));
    }
  }
  float spiralSpeed = 4;
  float angle = frameCountSinceSpawn * 0.05;
  bullets.add(
    new Bullet(
    width / 2,
    height / 2 - 100,
    cos(angle) * spiralSpeed,
    sin(angle) * spiralSpeed,
    6));
}

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
