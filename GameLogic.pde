//This is where you will put your code for game logic!
//EXCEPT for renaming or deleting the engine functions titleSetup(), titleDraw(), gameSetup(), and gameDraw(), and displayObjects() you can completely change how this page works
//Otherwise, feel free to add your own functions, variables, etc here and the other user-edited tabs listed in the main engine tab
//----------------------------------------------------------------------------------------------------------------------------------
//Put your game related global variables in here!
String gameTitle = "FrameworkV1 - Blank Slate";
int targetFPS = 60; //Used for frames per second

Camera cam; //Check the GameObjs tab for this object

int scrollZeldaStyle = 0; //Secret mode to scroll like Zelda NES game! :D 1 for on, 0 for off

int gameOver = 0; //If the game is over

//Put your code for setup phase of the title screen here
void titleSetup() {
  background(0);
  fill(255);
  stroke(255);

  text("WELCOME TO THE GAME! PRESS START TO PLAY!", 100, 100);
}

//Put your code for the draw (every frame) of your title screen here
void titleDraw() {
  if (checkKeyIsDown(titleStartKey) == true) { //If they press the start key (SET ON INPUTCONFIG TAB!)
    changeState = 1; //Go into the game!
  }
}

//Put your code for the first time setup phase of the game here
void gameSetup() {
  background(0); //Clear the screen

  gameOver = 0;

  scrollingGame = 1; //This game has a screen that moves (0 for false)
  debugMode = 0; //Set to 1 to turn on debug, check console for key presses and other info


  cam = new Camera(0, 0);
}

//Put your code for the draw (every frame) of your game here
void gameDraw() {

  if (gameOver == 0) { //If the game is still going

    if (inMenu == 0) { //The game is playing, this is where your normal game logic and loop goes!
      background(100, 100, 100); //Game background color


      if (scrollingGame == 1) { //If this game is a scrolling game
        cam.setX(0); //Could set this to player X, or another X position you want the camera to be fixed at
        cam.setY(0); //Could set this to player Y

        //Scroll has a negative value to move the view with the camera
        scrollX = -1 * cam.getX();
        scrollY = -1 * cam.getY();
      } else { //Otherwise, if not a scrolling game, choose where the screen should be positioned
        scrollX = 0;
        scrollY = 0;
      }

      if (scrollZeldaStyle == 1) { //Scroll the screen one screenwidth + height at a time
        cam.setX(int(cam.getX() / width) * width); // You could change this to your player X and Y
        cam.setY(int(cam.getY() / height) * height); // You could change this to your player X and Y

        //Scroll has a negative value
        scrollX = -1 * cam.getX();
        scrollY = -1 * cam.getY();
      }

      pushMatrix();
      
      if (scrollingGame == 1) { //If we have scrolling in this game, adjust screen before drawing the rest of the objects
        translate(scrollX, scrollY);
      }

      //Draw your game objects in here, before the popMatrix

      popMatrix();

      hudDraw(); //Draw the heads up display

      if (debugMode == 1) { //If in debug mode
        debugHUD(); //Draw the debug mode heads up display
      }
    } else { //We are in a pause/quit menu
      quitMenu(); //Run the menu code
    }
  } else {
    //Game over screen code! only runs when gameOver == 1
    gameOverScreen();
  }
}
