//For installing the SimpleOpenNI library see: https://code.google.com/p/simple-openni/wiki/Installation

//This tab has everything related to Xbox 360 Kinect input! Technically you should be able to copy this file
//(plus the KinectSetup() and KinectDraw() events inside of GameSetup() and GameDraw() ) into any version of the framework to add basic Kinect input
//Also set TargetFPS to 30 on the GameLogic tab if using Kinect, it can't output data faster than that

//This method compares raw pixel values, might be able to speed up in future if other methods are quicker (but this probably is the fastest method using Kinect?)

//----------------------------------------------------------
//These settings are adjustable for performance, the look and feel on the screen, and for exactly how the controls work
float kinectPreviewScale = 0.25; //How big to scale the Kinect preview window?
float kinectPreviewX = 650; //Where to position preview window on screen X?
float kinectPreviewY = 10; //Where to position preview window on screen Y?

//Adjust these values based on the performance demands of your game, 30FPS is max when using Kinect!
int kinectFrameLogicSkip = 12; //How many frames before checking logic again? Increases latency feeling for player, but anything greater than 1 is an FPS speedhack
int kinectPixelCheckSkip = 14; //How many extra pixels to jump by when checking for button presses? Makes them less accurate but faster (speedhack)! Only used if checkEdgesOnly = 0
int checkEdgesOnly = 1; //Whether or not to only check edges of the buttons (since you have to pass through an edge to touch anyway), speedhack! Also only checks for input from closest edges to center
int edgePixelCheck = 1; //How many rows in from the outside edge to check? speedhack
int edgeCheat = 5; //How many pixels to shave off the corners of an edge? speedhack
int edgeHalfOnly = 1; //Just check against the closest half to center? speedhack
int maxButtonsDown = 2; //Another speedhack, once this many buttons are detected in a single logic check it will stop looking at other buttons

ArrayList<TouchRect> kinectButtons; //An arraylist of buttons, this should not be renamed!

//Finally, add your button boxes of where the person should touch in X,Y co-ordinates on the screen and what button to press
void addKinectButtons() { //Add your code here for placing buttons relative to the full size Kinect view (640x480)
  //Buttons available: UP, DOWN, LEFT, RIGHT, ACTION, JUMP, START
  //Keep these within the bounds of the Kinect image (640x480) or it will crash!
  kinectButtons.add(new TouchRect(40, 80, 60, 100, "LEFT"));//X, Y, W, H, button name
  kinectButtons.add(new TouchRect(590, 80, 60, 100, "RIGHT"));
  kinectButtons.add(new TouchRect(320, 80, 60, 60, "JUMP"));
  kinectButtons.add(new TouchRect(40, 400, 60, 100, "DOWN"));
  kinectButtons.add(new TouchRect(580, 400, 80, 80, "ACTION"));
}

//------------------------------------------------------------------------------------------------------------
//Please do not change any code below here so that the engine runs the same for all!
//Now actual code for Kinect stuff, bottom is the TouchRect class
//------------------------------------------------------------------------------------------------------------

int kinectWidth = 640;
int kinectHeight = 480;

boolean kinectRunning = false; //Only set it up once

import processing.opengl.*; 
import SimpleOpenNI.*;

SimpleOpenNI kinect;

//based on Greg's Book Making things see / https://github.com/ITPNYU/Comperas/blob/master/KinectBackgroundRemoval/KinectBackgroundRemoval.pde
boolean tracking = false; 
int userID; 
int[] userMap; 
// Store result image
PImage resultImage;

void KinectSetup() {
  kinectButtons = new ArrayList<TouchRect>();

  addKinectButtons();

  if (kinectRunning == false) {

    kinect = new SimpleOpenNI(this);
    if (kinect.isInit() == false)
    {
      println("Can't init SimpleOpenNI, maybe the camera is not connected!"); 
      exit();
      return;
    }

    // enable depthMap generation 
    kinect.enableDepth();

    // enable skeleton generation for all joints
    kinect.enableUser();
    // enable color image from the Kinect
    kinect.enableRGB();
    //enable the finding of users but dont' worry about skeletons

    // turn on depth/color alignment
    kinect.alternativeViewPointDepthToImage();
    
    kinectRunning = true;
  }
  //create a buffer image to work with instead of using sketch pixels
  resultImage = new PImage(kinectWidth, kinectHeight, RGB);
}

void KinectDraw() {
  kinect.update();

  PImage rgbImage = kinect.rgbImage();

  if (frameCount % kinectFrameLogicSkip == 0) { //If we aren't skipping this frame

    for (int n = kinectButtons.size () - 1; n >= 0; n--) {
      TouchRect kB = kinectButtons.get(n);

      kB.prepButton(); //Prepare the buttons for checking
    }

    if (tracking) {

      //ask kinect for bitmap of user pixels, that is pixels which are not the background
      loadPixels();
      userMap = kinect.userMap();

      //For old SLOW method see commented code at very bottom!
      //Otherwise, here we check the pixels for each X and Y within each button to see if it exists in the usermap

        int buttonsDetected = 0; //How many buttons are pressed?

      for (int n = kinectButtons.size () - 1; n >= 0; n--) { //Loop through each button
        TouchRect kB = kinectButtons.get(n);


        if (checkEdgesOnly == 0) { //Brute force our way through the entire rectangle, use pixel skip to decrease amount of checks
          for (int y = int (kB.getY () - (kB.getHeight()/2)); y <= int(kB.getY() + (kB.getHeight()/2)); y++) {
            for (int x = int (kB.getX () - (kB.getWidth()/2)); x <= int(kB.getX() + (kB.getWidth()/2)); x++ ) {
              if (userMap[y * kinect.userWidth() + x] != 0) { //We have a pixel at this 1D array position of X,Y on the usermap!
                //We know that this is within the button too so no extra checks needed!
                kB.pushButtonDown();
                buttonsDetected += 1;
                break; //Done with X loop, get out
              }
              x+=kinectPixelCheckSkip; //Try to increment x by a number of pixels (since we are already adding 1 in for loop above) as a speedhack
            }

            if (kB.isPressed() == true) break; //Get out of the Y loop too so we can check next button

            y+=kinectPixelCheckSkip; //Again try the speedhack here too
          }
        } else { //Otherwise use corner checks
          int chkTopEdge = 0;
          int chkBottomEdge = 0;
          int chkLeftEdge = 0;
          int chkRightEdge = 0;

          if (kB.getX() <= kinectWidth/2) chkRightEdge = 1;
          if (kB.getY() <= kinectHeight/2) chkBottomEdge = 1;
          if (kB.getX() > kinectWidth/2) chkLeftEdge = 1;
          if (kB.getY() > kinectHeight/2) chkTopEdge = 1;

          //Check left or right edge first, since most controls will not be directly above or below the person probably

          int startX = 0;
          int endX = 0;
          int startY = 0;
          int endY = 0;

          if (chkLeftEdge == 1 || chkRightEdge == 1) {

            startY = int(kB.getY() - (kB.getHeight()/2));
            endY = startY + int(kB.getHeight());
            if (edgeHalfOnly == 1) {
              if (chkBottomEdge == 1) {
                endY += edgeCheat - int(kB.getHeight()/2); //We only need half of this edge actually, but counteract the edgeCheat happening below
              } else {
                startY += int(kB.getHeight()/2) - edgeCheat; //We only need half of this edge actually, but counteract the edgeCheat happening below
              }
            }

            if (chkRightEdge == 1) {
              startX = int(kB.getX() + (kB.getWidth()/2)) - edgePixelCheck;
              endX = startX + edgePixelCheck;
            }

            if (chkLeftEdge == 1) {
              startX = int(kB.getX() - (kB.getWidth()/2));
              endX = startX + edgePixelCheck;
            }

            for (int y = startY + edgeCheat; y <= endY - edgeCheat; y++) {
              for (int x = startX; x <= endX; x++ ) {
                if (userMap[y * kinect.userWidth() + x] != 0) { //We have a pixel at this 1D array position of X,Y on the usermap!
                  //We know that this is within the button too so no extra checks needed!
                  kB.pushButtonDown();
                  buttonsDetected += 1;
                  break; //Done with X loop, get out
                }
              }

              if (kB.isPressed() == true) break; //Get out of the Y loop too so we can check next button
            }
          }

          if (kB.isPressed() == false) { //Still here? check for the top or bottom edge now
            if (chkTopEdge == 1 || chkBottomEdge == 1) {
              startX = int(kB.getX() - (kB.getWidth()/2));
              endX = startX + int(kB.getWidth());
              if (edgeHalfOnly == 1) {
                if (chkLeftEdge == 1) {
                  endX += edgeCheat - int(kB.getWidth()/2); //We only need half of this edge actually, but counteract the edgeCheat happening below
                } else {
                  startX += int(kB.getWidth()/2) - edgeCheat; //We only need half of this edge actually, but counteract the edgeCheat happening below
                }
              }

              if (chkBottomEdge == 1) {
                startY = int(kB.getY() + (kB.getHeight()/2)) - edgePixelCheck;
                endY = startY + edgePixelCheck;
              }

              if (chkTopEdge == 1) {
                startY = int(kB.getY() - (kB.getHeight()/2));
                endY = startY + edgePixelCheck;
              }

              for (int y = startY; y <= endY; y++) {
                for (int x = startX + edgeCheat; x <= endX - edgeCheat; x++ ) {
                  if (userMap[y * kinect.userWidth() + x] != 0) { //We have a pixel at this 1D array position of X,Y on the usermap!
                    //We know that this is within the button too so no extra checks needed!
                    kB.pushButtonDown();
                    buttonsDetected += 1;
                    break; //Done with X loop, get out
                  }
                }

                if (kB.isPressed() == true) break; //Get out of the Y loop too so we can check next button
              }
            }
          }
        }

        if (buttonsDetected >= maxButtonsDown) break; //Get out of the loop, we have two buttons confirmed
      }

      //update the pixel from the inner array to image
      resultImage.updatePixels();
    }
  }

  imageMode(CORNER);

  image(rgbImage, kinectPreviewX, kinectPreviewY, kinectWidth * kinectPreviewScale, kinectHeight * kinectPreviewScale); //Shrink the image down to show what's going on

  if (debugMode == 1) {
    //View the output of the depth image too, left of main image
    image(kinect.depthImage(), kinectPreviewX - (kinectWidth * kinectPreviewScale), kinectPreviewY - (kinectHeight * kinectPreviewScale), kinectWidth * kinectPreviewScale, kinectHeight * kinectPreviewScale);
  }

  for (int n = kinectButtons.size () - 1; n >= 0; n--) {
    TouchRect kB = kinectButtons.get(n);

    kB.drawRect(); //Draw the buttons on the RGB image
  }

  println("FPS: " + str(frameRate));
}


//Debug code
void onNewUser(SimpleOpenNI curContext, int userId)
{
  userID = userId;
  tracking = true;
  if (debugMode == 1) println("tracking");
  //curContext.startTrackingSkeleton(userId); //Optional code
}

void onLostUser(SimpleOpenNI curContext, int userId)
{
  if (debugMode == 1) println("onLostUser - userId: " + userId);
}

void onVisibleUser(SimpleOpenNI curContext, int userId)
{
  if (debugMode == 1) println("onVisibleUser - userId: " + userId);
}


//The rectangle input box detection class and code

class TouchRect {
  float x, y, w, h; //X and Y pos, width, height
  String button; //The button name to press when touched
  boolean wasPressed;

  TouchRect (float _x, float _y, float _w, float _h, String _but) {
    x = _x; //Center X
    y = _y; //Center Y
    w = _w; //Width
    h = _h; //Height
    button = _but;
    wasPressed = false;
  }

  void drawRect() { //Draw the rectangle for input box
    if (wasPressed == true) {
      fill(255, 0, 0, 80);
    } else {
      noFill();
    }

    stroke(255, 0, 0);
    strokeWeight(2);

    rectMode(CENTER);
    rect(kinectPreviewX + (x * kinectPreviewScale), kinectPreviewY + (y * kinectPreviewScale), w * kinectPreviewScale, h * kinectPreviewScale);
  }

  float getX() {
    return x;
  }

  void setX(float _x) {
    x = _x;
  }

  float getY() {
    return y;
  }

  void setY(float _y) {
    y = _y;
  }

  float getWidth() {
    return w;
  }

  void setWidth(float _w) {
    w = _w;
  }

  float getHeight() {
    return h;
  }

  void setHeight(float _h) {
    h = _h;
  }

  String getButton() {
    return button;
  }

  void changeButton(String _but) {
    button = _but;
  }

  void prepButton() {
    wasPressed = false; //Prepare the button for checks ahead

    if (button == "UP") {
      upKeyPress = false;
    }

    if (button == "DOWN") {
      downKeyPress = false;
    }

    if (button == "LEFT") {
      leftKeyPress = false;
    }

    if (button == "RIGHT") {
      rightKeyPress = false;
    }

    if (button == "ACTION") {
      actionKeyPress = false;
    }

    if (button == "JUMP") {
      jumpKeyPress = false;
    }

    if (button == "START") {
      startKeyPress = false;
    }
  }

  boolean isPressed() {
    return wasPressed;
  }

  boolean touchButton(float _x, float _y) {
    if (wasPressed == true) {
      return true; //We already know this button was pressed
    } else {
      if (_x > x - (w/2) && _x < x + (w/2) && _y > y - (h/2) && _y < y + (h/2)) {
        return true;
      } else {
        return false;
      }
    }
  }

  void pushButtonDown() {
    wasPressed = true; //Yep this was pressed

    if (button == "UP") {
      upKeyPress = true;
    }

    if (button == "DOWN") {
      downKeyPress = true;
    }

    if (button == "LEFT") {
      leftKeyPress = true;
    }

    if (button == "RIGHT") {
      rightKeyPress = true;
    }

    if (button == "ACTION") {
      actionKeyPress = true;
    }

    if (button == "JUMP") {
      jumpKeyPress = true;
    }

    if (button == "START") {
      startKeyPress = true;
    }
  }
}

//OLD SLOW CODE for brute force checking every pixel
//for (int i =0; i < userMap.length; i++) {
//  // if the pixel is part of the user
//  if (userMap[i] != 0) {
//    // set the pixel to the color pixel
//    resultImage.pixels[i] = rgbImage.pixels[i];
//
//    int x = i % kinect.userWidth();
//    int y = int(i / kinect.userWidth());
//
//    for (int n = kinectButtons.size () - 1; n >= 0; n--) {
//      TouchRect kB = kinectButtons.get(n);
//
//     Boolean pixelHit = kB.touchButton(x, y);
//
//      if (pixelHit == true) kB.pushButtonDown(); //Set the button to true
//    }
//  }
//}
