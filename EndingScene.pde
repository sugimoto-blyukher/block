Movie endingMovie;

void initializeEndingScene() {
  endingMovie = new Movie(this, "video.mp4");
}

void startEnding() {
  endingMovie.jump(0);
  endingMovie.play();
}

void drawEnding() {
  image(endingMovie, 0, 0, width, height);
  fill(0, 255, 0);
  textAlign(CENTER, CENTER);
  textSize(48);
  text("GAME CLEAR", width / 2, height / 2);
}

void movieEvent(Movie movie) {
  movie.read();
}
