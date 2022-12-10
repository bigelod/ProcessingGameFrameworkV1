//Global variables for audio go here!
AudioPlayer gameMus;
//Add your code to load sound files here, it's loaded by the engine
void loadAudio() {
   gameMus = minim.loadFile("factory.mp3");
}

void playGameMus() { //Start the game music
  gameMus.rewind();
  gameMus.loop(1);
  gameMus.play(); 
}
