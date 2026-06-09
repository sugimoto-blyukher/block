import processing.video.*;

final int TITLE_SCENE = 0;
final int GAME_SCENE = 1;
final int ENDING_SCENE = 2;

int scene = TITLE_SCENE;

void setup() {
  fullScreen();
  initializeEndingScene();
}

void draw() {
  background(0);

  if (scene == TITLE_SCENE) {
    drawTitle();
  } else if (scene == GAME_SCENE) {
    drawGame();
  } else {
    drawEnding();
  }
}

void keyPressed() {
  if (scene == TITLE_SCENE) {
    handleTitleKeyPressed();
  } else if (scene == GAME_SCENE) {
    handleGameKeyPressed();
  }
}
