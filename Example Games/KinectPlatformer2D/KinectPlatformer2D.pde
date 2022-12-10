//Welcome to the MacGDA Multimedia Team Processing Game Framework (V1.0) [KINECT EDITION!]
//This is the 2D platformer with extra code to support using a Kinect to send input, it only works on Processing 2.2.x though
//Read more on how to use Kinect in your games in the KinectInput tab!
//Tested in Processing 2.2.1 on Windows and MacOSX. If you have any issues, e-mail bigelod@mcmaster.ca

//=================
//Use these tabs to make your game the way you like:
//=================
//Audio -- Use this one to add your sound and music code in!
//GameLogic -- Use this one to add your game specific code in!
//GameObjs -- Use this one to add your object classes like players, enemies, items, etc
//HUDs -- Use this one to add a heads-up-display (HUD) for things like showing player health-points (HP) or the quit menu
//InputConfig -- Use this one for customising the controls of your game!
//Functions - Add your math functions here! try not to remove any you started with

//=================
//But try not to change these tabs, they are part of the engine/shared between the other projects and will be needed to merge the games into one compilation:
//=================
//THIS TAB! The only line you might be okay to change in this file is size(), where you can change Width, Height, and rendering engine (P2D or P3D, remove this part for old machines)
//Animation -- This is used to store a list of sprites an animate through them
//AnimationController -- This is used to store a list of animations and choose the right one
//Collisions -- This has useful code for detecting collisions which you can use in your GameLogic
//Input -- This controls the handling of input from keyboard and mouse
//Sprite -- This is a class for a sprite, or graphic image in games, including Backdrop (background) and Foreground (in-game) sprites
//Tools -- This contains useful functions and classes you can use in your game logic and objects!
//KinectInput - Read the tab for instructions on editing the button boxes, but other than that, don't change this tab!

//=================
//These are unused tabs / extra code you can use and hack around with and use how you like
//=================
//Functions3D -- This has some 3D functions from my "The Baby Is Coming" game on GameJolt

//=============================================================
//THIS CODE BELOW IS THE ENTIRE GAME ENGINE SETUP AND DRAW CODE! TRY TO KEEP THIS THE SAME SINCE WE SHARE IT BETWEEN ALL GAMES!!!
//=============================================================


//Library imports, eg: sound engine minim (go to Sketch > Import Library > Add Libraries to install "minim" on Procession 3.0)
//=============================================================
import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

//Global variables
//=============================================================
int gameTimer = 0; //Used for timing the whole game in whole seconds
String gameState = "TITLE"; //The state of the game, can be TITLE or GAME
int changeState = 0; //Whether or not to change the game state between TITLE and GAME
int inMenu = 0; //If in-game, check if we are inside the game menu
float scrollX = 0; //The X position to scroll to
float scrollY = 0; //The Y position to scroll to
int scrollingGame = 1; //Whether or not the game should have a scrolling camera
int debugMode = 0; //Set to 1 to turn debug features on, 0 to turn them off

//Global sound engine, loads once!
Minim minim;

//Void setup, every program needs this! Happens once at start
//=============================================================
void setup() {
  size(800, 600, P2D); //Set X and Y size of window and use P2D for OpenGL accelerated 2D graphics (use P3D for 3D graphics)
  
  frame.setTitle(gameTitle);
  
  frameRate(targetFPS); //Set the FPS
  
  minim = new Minim(this); //Start up the audio engine
  
  loadAudio(); //Load the audio files
  
  titleSetup(); //Prepare the title screen
}


//Void draw, every program needs this! Happens every frame
//=============================================================
void draw() {
  if (frameCount % targetFPS == 0) gameTimer += 1; //Add 1 to gameTimer (every second if at 60FPS)
  
  pushMatrix(); //Store the camera state at default
  
  if (gameState == "TITLE") {
    inMenu = 0; //No menus at title, at least not quit-menus!
    titleDraw(); //Now run the title logic
    if (changeState == 1) { //If we are changing state
      gameState = "GAME"; //Switch to game
      gameSetup(); //Prepare the game
      changeState = 0; //Done the swap
    }
  } else {
        
    gameDraw(); //Now run the game logic
    if (changeState == 1) { //If we are changing state
      gameState = "TITLE"; //Switch back to title
      titleSetup(); //Prepare the title
      changeState = 0; //Done the swap
    }
    
  }
  
  popMatrix(); //Load the camera state
  
  if (debugMode == 1) {
    debugPrintInput();
    
    println("FPS: " + str(frameRate));
  }
}
