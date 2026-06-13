import processing.video.*;

final int TITLE_SCENE = 0;
final int GAME_SCENE = 1;
final int ENDING_SCENE = 2;

int scene = TITLE_SCENE;
PImage fighterImage;
PImage gameBackgroundImage;
PImage goalImage;

void setup() {
  fullScreen();
  fighterImage = loadImage("fighter.png");
  gameBackgroundImage = loadImage("background.png");
  goalImage = loadImage("yousai.png");
  initializeEndingScene();
}

void draw() {
  background(0);

  // 現在のシーンに対応する描画処理だけを実行する。
  if (scene == TITLE_SCENE) {
    drawTitle();
  } else if (scene == GAME_SCENE) {
    drawGame();
  } else {
    drawEnding();
  }
}

void keyPressed() {
  // キー入力は表示中のシーンへ振り分ける。
  if (scene == TITLE_SCENE) {
    handleTitleKeyPressed();
  } else if (scene == GAME_SCENE) {
    handleGameKeyPressed();
  }
}
