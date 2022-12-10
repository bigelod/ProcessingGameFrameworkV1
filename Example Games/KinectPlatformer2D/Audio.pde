//Global variables for audio go here!
AudioPlayer gameMus;
AudioPlayer barkSfx;
AudioPlayer laserSfx;

//Add your code to load sound files here, it's loaded by the engine
void loadAudio() {
    gameMus = minim.loadFile("music.mp3");
    barkSfx = minim.loadFile("bark.wav");
    laserSfx = minim.loadFile("laser.wav");
}

void playGameMus() { //Start the game music
  gameMus.rewind();
  gameMus.loop(1);
  gameMus.play(); 
}

void tryBark() { //Try to bark
  if (barkSfx.isPlaying() == false) {
    barkSfx.rewind();
    barkSfx.play();
  }
}

void tryLaser() { //Try to laser or overwrite if it's already playing
  laserSfx.rewind();
  laserSfx.play();
}
