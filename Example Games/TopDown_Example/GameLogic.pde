//This is where you will put your code for game logic!
//EXCEPT for renaming or deleting the engine functions titleSetup(), titleDraw(), gameSetup(), and gameDraw(), and displayObjects() you can completely change how this page works
//Otherwise, feel free to add your own functions, variables, etc here and the other user-edited tabs listed in the main engine tab
//----------------------------------------------------------------------------------------------------------------------------------
//Put your game related global variables in here!
String gameTitle = "FrameworkV1 - Top Down Example";
int targetFPS = 60; //Used for frames per second

int tileWidth = 64; //Width of tiles in pixels
int tileHeight = 64; //Height of tiles in pixels

Camera cam;
Player p1;
ArrayList<MapTile> tiles;

int currLevel = 1;
int numLevels = 2; //How many levels? edit this manually!

float playerScreenXRatio = 2; //Where from left to right side of screen to place player? (eg: 2 = 1/2 the screen)
float playerScreenYRatio = 2; //Where from top to bottom side of screen to place player (eg: 2 = 1/2 the screen)

int playerLives = 3; //How many lives does the player have?
int playerScore = 0; //Players score

int gameOver = 0; //If the game is over

//Put your code for setup phase of the title screen here
void titleSetup() {
  background(0);
  fill(255);
  stroke(255);

  text("WELCOME TO THE GAME! CLICK TO PLAY!", 100, 100);
}

//Put your code for the draw (every frame) of your title screen here
void titleDraw() {
  if (checkKeyIsDown(titleStartKey) == true) { //If they press the start key (SET ON INPUTCONFIG TAB!)
    changeState = 1; //Go into the game!
  }
}

//Put your code for the first time setup phase of the game here
void gameSetup() {
  playGameMus();

  background(0); //Clear the screen

  gameOver = 0;

  scrollingGame = 1; //This game has a screen that moves (0 for false)
  debugMode = 0; //Set to 1 to turn on debug, check console for key presses and other info
  currLevel = 1; //The current game level

  playerLives = 3; //Set lives at start of game
  playerScore = 0; //Reset score

  SetupLevel(currLevel); //Set up the first level

    cam = new Camera(p1.getX(), p1.getY());
}

//Put your code for the draw (every frame) of your game here
void gameDraw() {

  if (gameOver == 0) { //If the game is still going

    if (inMenu == 0) { //The game is playing, this is where your normal game logic and loop goes!
      if (gameMus.isPlaying() == false) gameMus.play();

      if (playerLives < 0) gameOver = 1; //Set game over screen to active

      background(63, 157, 219); //Game background color

      displayBackgrounds(); //Display parallax backgrounds

        UpdateCollisions(); //Check for collisions

        p1.Update(); //Update the player 

      //Now get ready for drawing the game stuff
      if (scrollingGame == 1) {
        cam.setX(p1.getX() - (width/playerScreenXRatio));
        cam.setY(p1.getY() - (height/playerScreenYRatio));

        //Scroll has a negative value to move the view with the player
        scrollX = -1 * cam.getX();
        scrollY = -1 * cam.getY();
      } else {
        scrollX = 0;
        scrollY = 0;
      }

      if (scrollingGame == 1) { //If we have scrolling in this game, adjust screen before drawing the rest of the objects
        pushMatrix();

        translate(scrollX, scrollY);

        displayMap(); //Draw elements of the map

          //Now draw the objects that go over the background, eg: Enemies
        displayObjects();

        p1.Display(); //Draw the player

        popMatrix();
      } else {
        //Otherwise just call your draw commands on the objects like normal
        displayMap(); //Draw elements of the map

          displayObjects();

        p1.Display(); //Draw the player
      }

      if (scrollingGame == 1) { //Render effects over top of the player
        pushMatrix();

        translate(scrollX, scrollY);

        displayEffects(); //Things above the player, could be particles!

        popMatrix();
      } else {
        displayEffects();
      }

      hudDraw(); //Draw the heads up display

      if (debugMode == 1) { //If in debug mode
        debugHUD(); //Draw the debug mode heads up display
      }
    } else { //We are in a pause/quit menu
      gameMus.pause();
      quitMenu(); //Run the menu code
    }
  } else {
    //Game over screen code!
    gameMus.pause();

    gameOverScreen();
  }
}

//Put your code in here for displaying non-player objects in the world
void displayMap() { //A call to draw all map elements
  for (int i = tiles.size () - 1; i >= 0; i--) { //Draw each tile
    MapTile t = tiles.get(i);

    t.Display();
  }
}

void displayBackgrounds() { //Display parallax background elements
}

void displayObjects() { //A call to tell objects to draw, handled as a separate function to reduce code in the main game draw loop
}

void displayEffects() { //Things in front of the player
}

void UpdateCollisions() { //Check for objects colliding
}

//Start of game-specific functions
void SetupLevel(int _l) { //Prepare the level and start it
  //Load some sprites
  //Sprite gB1 = new Sprite("groundblock_1024x64.png", 0); //Load the ground object textures
  //Sprite gB2 = new Sprite("groundblock_256x256.png", 0); //Load second ground
  //Sprite iB1 = new Sprite("iceblock_256x256.png", 0); //Load the ice block texture
  //Sprite iB2 = new Sprite("iceblock2_256x256.png", 0); //Load the second ice block texture
  Sprite fTL = new Sprite("floor_top_left.bmp", 0); //Load top left corner floor
  Sprite fTR = new Sprite("floor_top_right.bmp", 0); //Load top right corner floor
  Sprite fBL = new Sprite("floor_bottom_left.bmp", 0); //Load bottom left corner floor
  Sprite fBR = new Sprite("floor_bottom_right.bmp", 0); //Load bottom right corner floor
  Sprite wall = new Sprite("wall.bmp", 0); //Load wall tile

  //Clear the objects for p1, map, backs, and levelgfx to (re)load data into them
  p1 = new Player(100, 100);

  tiles = new ArrayList<MapTile>();

  if (_l == 1) { //First level
    p1.setX(94);
    p1.setY(100);

    //Example of how to add tiles the standard way
    //Sprite, X grid, Y grid, is solid (0 or 1)
    //tiles.add(new MapTile(fTL, 0, 0, 0));
    //tiles.add(new MapTile(fTR, 1, 0, 0));
    //tiles.add(new MapTile(fBL, 0, 1, 0));
    //tiles.add(new MapTile(fBR, 1, 1, 0));

    //Another method for adding a bunch of floor tiles:
    //for (int x = 2; x < 20; x+=2) { //Make 20 more 4-piece floor panels
    //tiles.add(new MapTile(fTL, x, 0, 0));
    //tiles.add(new MapTile(fTR, x + 1, 0, 0));
    //tiles.add(new MapTile(fBL, x, 1, 0));
    //tiles.add(new MapTile(fBR, x + 1, 1, 0));
    //}

    //A third method of adding tiles, using a "tile map" or 2D array

    ArrayList<Sprite> tileTypes = new ArrayList<Sprite>(); //We need to create the list of tiles for the function to use

    tileTypes.add(fTL);
    tileTypes.add(fTR);
    tileTypes.add(fBL);
    tileTypes.add(fBR);
    tileTypes.add(wall);
    
    //This above works out to be tiles with these tile numbers:
    //0 = floor tile top-left
    //1 = floor tile top-right
    //2 = floor tile bottom-left
    //3 = floor tile bottom-right
    //4 = wall tile

    int[][] myMap = {  
      {
        4, 0, 1, 0, 1, 0, 1
      }
      , 
      {
        4, 2, 3, 2, 3, 2, 3
      }
      , 
      {
        4, 0, 1, 0, 1, 0, 1
      }
      , 
      {
        4, 2, 3, 2, 3, 2, 3
      }
    };

    loadTileMap(myMap, tileTypes); //Pass the level graphics, the collision mask, and the sprites
  }

  if (_l == 2) { //Second level
    p1.setX(100);
    p1.setY(100);
    
    //A third method of adding tiles, using a "tile map" or 2D array

    ArrayList<Sprite> tileTypes = new ArrayList<Sprite>(); //We need to create the list of tiles for the function to use

    tileTypes.add(fTL);
    tileTypes.add(fTR);
    tileTypes.add(fBL);
    tileTypes.add(fBR);
    tileTypes.add(wall);
    
    //This above works out to be tiles with these tile numbers:
    //0 = floor tile top-left
    //1 = floor tile top-right
    //2 = floor tile bottom-left
    //3 = floor tile bottom-right
    //4 = wall tile, this is set as a collision tile below

    int[][] myMap = {  
      {
        4, 0, 1, 0, 1, 0, 1
      }
      , 
      {
        4, 2, 3, 2, 3, 2, 3
      }
      , 
      {
        4, 0, 1, 0, 1, 0, 1
      }
      , 
      {
        4, 2, 3, 2, 3, 2, 3
      }
    }; 

    loadTileMap(myMap, tileTypes); //Pass the level graphics, the collision mask, and the sprites
  }
}

void nextLevel() { //Go to the next level or check for end of game 
  currLevel += 1;

  if (currLevel > numLevels) {
    //Put code here to game over, or start from beginning again, etc! for now, reset to level 1
    currLevel = 1;
    SetupLevel(currLevel); //Prepare that level
  } else {
    SetupLevel(currLevel); //Prepare that level
  }
}

void loadTileMap(int[][] level, ArrayList<Sprite> imgs) {
  for (int i = 0; i < level.length; i++) {
    for (int j = 0; j < level[0].length; j++) {
      int tileType = level[i][j];
      
      int col = 0;
      
      if (tileType == 4) col = 1; //Wall tile
      
      tiles.add(new MapTile(imgs.get(tileType), j, i, col));
    }
  }
}

