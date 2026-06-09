void drawTitle() {
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(64);
  text("BLOCK KUZUSI GAME", width / 2, height / 2 - 40);
  textSize(24);
  text("Press ENTER to Start", width / 2, height / 2 + 40);
}

void handleTitleKeyPressed() {
  if (keyCode == ENTER) {
    scene = GAME_SCENE;
    initializeGame();
    loop();
  }
}
