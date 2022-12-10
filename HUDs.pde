//Put your code here for heads up displays and menus!

//Put your code for the quit menu here, this appears in-game when you try to quit
void quitMenu() {
  fill(0);
  noStroke();
  rectMode(CORNER);
  rect(100, 90, 200, 80);
  fill(255);
  stroke(255);
  textSize(12);
  text("PAUSED!\nPRESS ACTION KEY TO QUIT\nSTART OR JUMP TO RESUME", 120, 120);
  
  if (actionKeyPress == true) { //Action key for quit!
    changeState = 1; //Go straight to title
  }
  
  if (jumpKeyPress == true) { //Start key will already undo this, so just check jump and resume
    inMenu = 0; //Back to game!
  }
}

//Put your code for the game over screen here!
void gameOverScreen() {
  background(0);
  
  fill(255);
  stroke(255);
  textSize(24);
  text("GAME OVER", width/3, 100);
  textSize(14);
  text("PRESS JUMP KEY TO RETRY\nPRESS ACTION KEY TO QUIT", 50, 200); 
  
  if (actionKeyPress == true) {
    changeState = 1;
  }
  
  if (jumpKeyPress == true) {
    gameSetup();
  }
}

//Put your code for the ingame HUD here
void hudDraw() {
}

//Put your code to show useful information from debug mode here
void debugHUD() {
}
