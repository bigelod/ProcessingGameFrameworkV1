//This is where you will put your code for game logic!
//EXCEPT for renaming or deleting the engine functions titleSetup(), titleDraw(), gameSetup(), and gameDraw(), and displayObjects() you can completely change how this page works
//Otherwise, feel free to add your own functions, variables, etc here and the other user-edited tabs listed in the main engine tab
//----------------------------------------------------------------------------------------------------------------------------------
//Put your game related global variables in here!
String gameTitle = "FrameworkV1 - German Shephard";
int targetFPS = 60; //Used for frames per second

Camera cam;
Player p1;
ArrayList<GroundCollider> map; //An arraylist of the collision boxes in the level (invisible unless in debug mode)
ArrayList<Backdrop> backs; //An arraylist of the depth background objects in the level (in this case, clouds)
ArrayList<LevelGraphic> levelgfx; //An arraylist of the levelgraphics (actual platform images)
ArrayList<ScoreItem> pointOrbs; //An array list of the pointOrbs that float
ArrayList<BarkBubble> barkz; //An array list of the bark attack bubbles
ArrayList<GunBullet> enemyBulls; //An array list of enemy bullets
ArrayList<GunEnemy> enemyz; //An array list of enemies

int currLevel = 1;
int numLevels = 2; //How many levels? edit this manually!
float levelWidth; //Max width of level
float levelHeight; //Max height of level

float playerScreenXRatio = 2; //Where from left to right side of screen to place player? (eg: 2 = 1/2 the screen)
float playerScreenYRatio = 1.6; //Where from top to bottom side of screen to place player (eg: 2 = 1/2 the screen)

int playerLives = 3; //How many lives does the player have?
int playerScore = 0; //Players score
int numOrbs = 0; //Number of orbs in the level

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

      if (p1.getY() > levelHeight) { //If we are out of the map, kill the player and subtract one from lives
        playerLives -= 1;
        SetupLevel(currLevel);
      }

      if (playerLives < 0) gameOver = 1; //Set game over screen to active

      if (pointOrbs.size() <= 0) nextLevel(); //Beat the level

        background(63, 157, 219); //Game background color

      displayBackgrounds(); //Display parallax backgrounds

        UpdateCollisions(); //Check for collisions

        p1.Update(); //Update the player 

      for (int i = enemyz.size () - 1; i >= 0; i--) {
        GunEnemy e = enemyz.get(i);

        if (scrollZeldaStyle == 1) { //If zelda style, only activate enemy when on screen
          if (e.getX() > cam.getX() && e.getX() < cam.getX() + width && e.getY() > cam.getY() && e.getY() < cam.getY() + height) {
            e.Update();
          }
        } else {
          e.Update();
        }
        
      }

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
      
      if (scrollZeldaStyle == 1) {
        cam.setX(int(p1.getX() / width) * width);
        cam.setY(int(p1.getY() / height) * height);
        
        //Scroll has a negative value
        scrollX = -1 * cam.getX();
        scrollY = -1 * cam.getY();
      }

      if (scrollingGame == 1) { //If we have scrolling in this game, adjust screen before drawing the rest of the objects
        pushMatrix();

        translate(scrollX, scrollY);

        //Now draw the objects
        displayObjects();
        
        p1.Display(); //Draw the player

        popMatrix();
      } else {
        //Otherwise just call your draw commands on the objects like normal
        displayObjects();
        
        p1.Display(); //Draw the player
      }

      if (scrollingGame == 1) { //Render effects over top of the player
        pushMatrix();

        translate(scrollX, scrollY);

        displayEffects(); //Things above the player

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
void displayObjects() { //A call to tell objects to draw, handled as a separate function to reduce code in the main game draw loop

  for (int i = levelgfx.size () - 1; i >= 0; i--) {
    LevelGraphic lG = levelgfx.get(i);

    lG.Update();
  }

  for (int i = enemyz.size () - 1; i >= 0; i--) {
    GunEnemy e = enemyz.get(i);

    e.Display();
  }

  for (int i = pointOrbs.size () - 1; i >= 0; i--) {
    ScoreItem pO = pointOrbs.get(i);

    pO.Display();
  }


  if (debugMode == 1) { //Things to draw if in debug mode
    fill(0);
    noStroke();
    rect(p1.getX() - (width/2), 1600, width, 500);  //Add a killzone, other code in player object to reset them if in this zone during debug

    for (int i = map.size () - 1; i >= 0; i--) {
      GroundCollider gC = map.get(i);

      gC.debugDisplay();
    }
  }
}

void displayEffects() { //Things in front of the player

  for (int i = enemyBulls.size () - 1; i >= 0; i--) {
    GunBullet b = enemyBulls.get(i);

    b.Display();

    if (b.getX() < p1.getX() - width || b.getX() > p1.getX() + width) { //Destroy offscreen
      enemyBulls.remove(i);
    }
  }

  for (int i = barkz.size () - 1; i >= 0; i--) {
    BarkBubble b = barkz.get(i);

    b.Display();

    if (b.timerDone() == true) barkz.remove(i);
  }
}

void displayBackgrounds() { //Display all background objects

    for (int i = backs.size () - 1; i >= 0; i--) {
    Backdrop b = backs.get(i);

    b.Display();

    //A smooth movement of the clouds
    b.setX(b.getX() - 0.01);

    if (b.getX() < - 200) {
      b.setX(levelWidth);
    }
  }
}

void UpdateCollisions() { //Check for objects colliding
  for (int i = pointOrbs.size () - 1; i >= 0; i--) {
    ScoreItem pO = pointOrbs.get(i);

    if (pointInRect(p1.getX(), p1.getY(), pO.getX(), pO.getY(), pO.getWidth(), pO.getHeight()) == true) {
      playerScore += 1;

      pointOrbs.remove(i);
    }
  }

  for (int i = enemyBulls.size () - 1; i >= 0; i--) {
    GunBullet b = enemyBulls.get(i);

    if (rectOverlap(p1.getX(), p1.getY(), p1.getColW(), p1.getColH(), b.getX(), b.getY(), b.getWidth(), b.getHeight()) == true) {
      playerLives -= 1;
      SetupLevel(currLevel);
    }
  } 

  boolean p1OnGround = false;

  float playerTop = p1.getY() - (p1.getColH()/2);
  float playerBottom = p1.getY() + (p1.getColH()/2);
  float playerLeft = p1.getX() - (p1.getColW()/2);
  float playerRight = p1.getX() + (p1.getColW()/2);

  for (int i = map.size () - 1; i >= 0; i--) {
    GroundCollider gC = map.get(i);

    float platformTop = gC.getY() - (gC.getHeight()/2);
    float platformBottom = gC.getY() + (gC.getHeight()/2);
    float platformLeft = gC.getX() - (gC.getWidth()/2);
    float platformRight = gC.getX() + (gC.getWidth()/2);

    //Now we can do some basic checks for pushing out of solid objects
    if (playerBottom > platformTop && gC.getJumpThrough() == 0) { //If we are not in a platform we can jump through, and are below the top, push out
      float pushOut = 0; //How many pixels to push out?

      boolean skipChk = false; //Skip check if we changed Y this time, so that bumping the roof doesn't cause the player to teleport to the sides

      if (p1.getY() > gC.getY() && playerTop < platformBottom && p1.getX() > platformLeft && p1.getX() < platformRight && p1.isOnGround() == false) {
        p1.setY(platformBottom + (p1.getColH()/2) + pushOut);
        p1.forceFall();
        skipChk = true;
      }

      if (p1.getY() > platformTop && skipChk == false) { //Below the top
        if (playerRight > platformLeft && playerLeft < platformLeft) { //Caught in the left side 
          p1.setX(platformLeft - (p1.getColW()/2) - pushOut);
          p1.setXSpd(0);
        }

        if (playerLeft < platformRight && playerRight > platformRight) { //Caught in the right side
          p1.setX(platformRight + (p1.getColW()/2) + pushOut);
          p1.setXSpd(0);
        }
      }

      if (p1.getX() < gC.getX() && playerRight > platformLeft && playerBottom < platformBottom && playerTop > platformTop && skipChk == false) {
        p1.setX(platformLeft - (p1.getColW()/2) - pushOut);
        p1.setXSpd(0);
      }

      if (p1.getX() > gC.getX() && playerLeft < platformRight  && playerBottom < platformBottom && playerTop > platformTop && skipChk == false) {
        p1.setX(platformRight + (p1.getColW()/2) + pushOut);
        p1.setXSpd(0);
      }
    }

    if (p1OnGround == false) { //Only check for another platform if we aren't on ground yet

      if (pointInRect(p1.getX(), playerBottom, gC.getX(), gC.getY(), gC.getWidth(), gC.getHeight()) == true) {
        //We are inside this rectangle, try to check if we are landing on it or being pushed out

        if (playerBottom < platformTop + 6 && p1.getYSpd() >= 0) { //6 pixel tolerance check to see if we are on the top half of the platform and falling
          p1.setY(gC.getY() - (gC.getHeight()/2) - (p1.getColH()/2)); //Fix our position to the top of the platform
          p1.setJumpThroughPlat(gC.getJumpThrough()); //Set if the ground can be jumped through or not
          p1OnGround = true; //We are finally on ground
          p1.setFloorF(gC.getFriction());
        }
      }
    }
  }

  if (p1OnGround == false) {
    p1.setOnGround(0); //We are not on ground
  } else {
    p1.setOnGround(1); //We are on ground
  }

  //Let's do this check too for enemies
  for (int n = enemyz.size () - 1; n >= 0; n--) {
    GunEnemy e = enemyz.get(n);

    //Check if the player is overlapping the enemy (die)
    if (pointInRect(p1.getX(), p1.getY(), e.getX(), e.getY(), e.getColW(), e.getColH()) == true) {
      playerLives -= 1;
      SetupLevel(currLevel);
    }

    boolean eOnGround = false;

    float enemyTop = e.getY() - (e.getColH()/2);
    float enemyBottom = e.getY() + (e.getColH()/2);
    float enemyLeft = e.getX() - (e.getColW()/2);
    float enemyRight = e.getX() + (e.getColW()/2);

    for (int i = map.size () - 1; i >= 0; i--) {
      GroundCollider gC = map.get(i);

      float platformTop = gC.getY() - (gC.getHeight()/2);
      float platformBottom = gC.getY() + (gC.getHeight()/2);
      float platformLeft = gC.getX() - (gC.getWidth()/2);
      float platformRight = gC.getX() + (gC.getWidth()/2);

      //Now we can do some basic checks for pushing out of solid objects
      if (enemyBottom > platformTop && gC.getJumpThrough() == 0) { //If we are not in a platform we can jump through, and are below the top, push out
        float pushOut = 0; //How many pixels to push out?

        boolean skipChk = false; //Skip check if we changed Y this time, so that bumping the roof doesn't cause the enemy to teleport to the sides

        if (e.getY() > gC.getY() && enemyTop < platformBottom && e.getX() > platformLeft && e.getX() < platformRight && e.isOnGround() == false) {
          e.setY(platformBottom + (e.getColH()/2) + pushOut);
          e.forceFall();
          skipChk = true;
        }

        if (e.getY() > platformTop && skipChk == false) { //Below the top
          if (enemyRight > platformLeft && enemyLeft < platformLeft) { //Caught in the left side 
            e.setX(platformLeft - (e.getColW()/2) - pushOut);
            e.setXSpd(0);
          }

          if (enemyLeft < platformRight && enemyRight > platformRight) { //Caught in the right side
            e.setX(platformRight + (e.getColW()/2) + pushOut);
            e.setXSpd(0);
          }
        }

        if (e.getX() < gC.getX() && enemyRight > platformLeft && enemyBottom < platformBottom && enemyTop > platformTop && skipChk == false) {
          e.setX(platformLeft - (e.getColW()/2) - pushOut);
          e.setXSpd(0);
        }

        if (e.getX() > gC.getX() && enemyLeft < platformRight  && enemyBottom < platformBottom && enemyTop > platformTop && skipChk == false) {
          e.setX(platformRight + (e.getColW()/2) + pushOut);
          e.setXSpd(0);
        }
      }

      if (eOnGround == false) { //Only check for another platform if we aren't on ground yet

        if (pointInRect(e.getX(), enemyBottom, gC.getX(), gC.getY(), gC.getWidth(), gC.getHeight()) == true) {
          //We are inside this rectangle, try to check if we are landing on it or being pushed out

          if (enemyBottom < platformTop + 6 && e.getYSpd() >= 0) { //6 pixel tolerance check to see if we are on the top half of the platform and falling
            e.setY(gC.getY() - (gC.getHeight()/2) - (e.getColH()/2)); //Fix our position to the top of the platform
            e.setJumpThroughPlat(gC.getJumpThrough()); //Set if the ground can be jumped through or not
            eOnGround = true; //We are finally on ground
            e.setFloorF(gC.getFriction());
          }
        }
      }
    }

    if (eOnGround == false) {
      e.setOnGround(0); //We are not on ground
    } else {
      e.setOnGround(1); //We are on ground
    }

    //Check if this enemy should die
    for (int i = barkz.size () - 1; i >= 0; i--) {
      BarkBubble b = barkz.get(i);

      if (e.getY() > levelHeight || rectOverlap(e.getX(), e.getY(), e.getColW(), e.getColH(), b.getX(), b.getY(), b.getWidth(), b.getHeight()) == true) {
        enemyz.remove(n);
      }
    }
  }
}

//Start of game-specific functions
void SetupLevel(int _l) { //Prepare the level and start it
  //Load some sprites
  Sprite gB1 = new Sprite("groundblock_1024x64.png", 0); //Load the ground object textures
  Sprite gB2 = new Sprite("groundblock_256x256.png", 0); //Load second ground
  Sprite iB1 = new Sprite("iceblock_256x256.png", 0); //Load the ice block texture
  Sprite iB2 = new Sprite("iceblock2_256x256.png", 0); //Load the second ice block texture

  //You can also pre-apply stretching to the textures, uniformly, in the X or Y axis, using these commands: (this applies to all objects using the Sprite!)
  //gB1.setScale(1.5);
  //gB1.setScaleX(1.5);
  gB1.setScaleY(1.5);

  //Clear the objects for p1, map, backs, and levelgfx to (re)load data into them
  p1 = new Player(100, 100);
  map = new ArrayList<GroundCollider>();
  backs = new ArrayList<Backdrop>();
  levelgfx = new ArrayList<LevelGraphic>();
  pointOrbs = new ArrayList<ScoreItem>();
  barkz = new ArrayList<BarkBubble>();
  enemyBulls = new ArrayList<GunBullet>();
  enemyz = new ArrayList<GunEnemy>();

  if (_l == 1) { //First level
    p1.setX(94);
    p1.setY(100);

    //First in the list is last drawn / on top!
    addLevelGraphic(896, 350, gB2, 1, 0, 0.25); //X pos, Y pos, sprite, if it has a collider, and 0 or 1 for solid or jump-through, friction on ground
    addLevelGraphic(-128, 350, gB2, 1, 0, 0.25);
    addLevelGraphic(384, 432, gB1, 1, 0, 0.25);
    addLevelGraphic(384, 350, gB1, 1, 1, 0.25);

    pointOrbs.add(new ScoreItem(74, 260));
    pointOrbs.add(new ScoreItem(358, 360));
    pointOrbs.add(new ScoreItem(634, 272));
    pointOrbs.add(new ScoreItem(924, 204));

    enemyz.add(new GunEnemy(534, 200));

    levelHeight = 800;
    levelWidth = 1152;
  }

  if (_l == 2) { //Second level
    p1.setX(100);
    p1.setY(100);

    addLevelGraphic(-128, 180, gB2, 1, 0, 0.25);
    addLevelGraphic(3520, 380, gB2, 1, 0, 0.25);
    addLevelGraphic(0, 350, gB2, 1, 0, 0.25);
    addLevelGraphic(256, 350, gB2, 1, 0, 0.25);
    addLevelGraphic(512, 350, gB2, 1, 0, 0.25);
    addLevelGraphic(768, 350, iB1, 1, 0, 0);
    addLevelGraphic(1024, 450, iB2, 1, 0, 0);
    addLevelGraphic(1280, 572, iB1, 1, 0, 0);
    addLevelGraphic(1792, 632, gB1, 1, 0, 0.25);
    addLevelGraphic(2816, 550, gB2, 1, 0, 0.25);
    addLevelGraphic(3072, 600, gB2, 1, 0, 0.25);
    addLevelGraphic(2304, 632, gB1, 1, 0, 0.25);
    addLevelGraphic(2588, 550, gB1, 1, 1, 0.25);
    addLevelGraphic(3392, 550, gB2, 1, 0, 0.25);

    pointOrbs.add(new ScoreItem(240, 180));
    pointOrbs.add(new ScoreItem(790, 180));
    pointOrbs.add(new ScoreItem(1280, 260));
    pointOrbs.add(new ScoreItem(2200, 540));
    pointOrbs.add(new ScoreItem(2460, 464));
    pointOrbs.add(new ScoreItem(3080, 272));
    pointOrbs.add(new ScoreItem(3332, 260));

    enemyz.add(new GunEnemy(1024, 292));
    enemyz.add(new GunEnemy(2500, 550));
    enemyz.add(new GunEnemy(3077, 440));

    levelHeight = 1024;
    levelWidth = 3392;
  }

  numOrbs = pointOrbs.size();

  //Load the cloud object for the background parallax objects
  Sprite s = new Sprite("parabak.png", 0);

  for (int i = 0; i < 20; i++) { //Create these all along the level
    backs.add(new Backdrop(random(width * 8) - 80, random(150) + 25, random(0.2) + 0.05, 0.05, s));
  }
}

void addLevelGraphic(float _x, float _y, Sprite _s, int _hasGC, int _gC, float _friction) { //Create all the objects needed for this level in a simple one line command
  levelgfx.add(new LevelGraphic(new Foreground(_x, _y, _s)));

  if (_hasGC == 1) {
    LevelGraphic l = levelgfx.get(levelgfx.size() - 1);
    l.attachGroundCollider(new GroundCollider(_gC, _friction));
    map.add(l.getGroundCollider());
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
