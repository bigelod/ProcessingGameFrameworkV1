//-----------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------
//TRY NOT TO CHANGE THE STUFF BELOW! IT IS MEANT TO BE SHARED BETWEEN EVERYONES GAMES!
//-----------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------

boolean upKeyPress = false; //if they up key is pressed down
boolean downKeyPress = false; //if they down key is pressed down
boolean leftKeyPress = false; //if they left key is pressed down
boolean rightKeyPress = false; //if they right key is pressed down
boolean actionKeyPress = false; //if they action key is pressed down
boolean jumpKeyPress = false; //if they jump key is pressed down
boolean startKeyPress = false; //if the start key is pressed down

boolean anyKeyPress = false; //If there are any keys being held down
boolean noKeyPress = false; //if there are no keys being held down HINT: COULD ALSO BE USED AS A GAME IDEA! :D

//When a key is pressed

void keyPressed() {
  if (key == CODED && useArrows == true) {
    if (keyCode == UP) {
      upKeyPress = true;
    }
    
    if (keyCode == DOWN) {
      downKeyPress = true;
    }
    
    if (keyCode == LEFT) {
      leftKeyPress = true;
    }
    
    if (keyCode == RIGHT) {
      rightKeyPress = true;
    }
    
  } else {
    
    if (useArrows == false) {
      if (key == upKey) {
        upKeyPress = true;
      }
      
      if (key == downKey) {
        downKeyPress = true;
      }
      
      if (key == leftKey) {
        leftKeyPress = true;
      }
      
      if (key == rightKey) {
        rightKeyPress = true;
      }
    }
    
    if (key == actionKey) {
      actionKeyPress = true;
    }
    
    if (key == jumpKey) {
      jumpKeyPress = true;
    }
     
  }
  
  if (int(key) == 10 || int(key) == 13) { //Line Feed or Carriage Return
    startKeyPress = true;
  }
  
  checkKeysDown();
  
  if (startKeyPress == true && gameState == "GAME") inMenu = 1 - inMenu; //Toggle the menu
}

//When a key is released

void keyReleased() {
  if (key == CODED && useArrows == true) {
    if (keyCode == UP) {
      upKeyPress = false;
    }
    
    if (keyCode == DOWN) {
      downKeyPress = false;
    }
    
    if (keyCode == LEFT) {
      leftKeyPress = false;
    }
    
    if (keyCode == RIGHT) {
      rightKeyPress = false;
    }
  } else {
    if (useArrows == false) {
      if (key == upKey) {
        upKeyPress = false;
      }
      
      if (key == downKey) {
        downKeyPress = false;
      }
      
      if (key == leftKey) {
        leftKeyPress = false;
      }
      
      if (key == rightKey) {
        rightKeyPress = false;
      }
    }
    
    if (key == actionKey) {
      actionKeyPress = false;
    }
    
    if (key == jumpKey) {
      jumpKeyPress = false;
    }
  }
  
  if (int(key) == 10 || int(key) == 13) { //Line Feed or Carriage Return
    startKeyPress = false;
  }
  
  checkKeysDown();
}

//When a mouse button is pressed

void mousePressed() {
  if (useMouse == true) {
    if (mouseButton == LEFT) {
      if (mouseLB == "UP") {
        upKeyPress = true;
      }
      
      if (mouseLB == "DOWN") {
        downKeyPress = true;
      }
      
      if (mouseLB == "LEFT") {
        leftKeyPress = true;
      }
      
      if (mouseLB == "RIGHT") {
        rightKeyPress = true;
      }
      
      if (mouseLB == "ACTION") {
        actionKeyPress = true;
      }
      
      if (mouseLB == "JUMP") {
        jumpKeyPress = true;
      }
      
      if (mouseLB == "START") {
        startKeyPress = true;
      }
    }
    
    if (mouseButton == RIGHT) {
      if (mouseRB == "UP") {
        upKeyPress = true;
      }
      
      if (mouseRB == "DOWN") {
        downKeyPress = true;
      }
      
      if (mouseRB == "LEFT") {
        leftKeyPress = true;
      }
      
      if (mouseRB == "RIGHT") {
        rightKeyPress = true;
      }
      
      if (mouseRB == "ACTION") {
        actionKeyPress = true;
      }
      
      if (mouseRB == "JUMP") {
        jumpKeyPress = true;
      }
      
      if (mouseRB == "START") {
        startKeyPress = true;
      }
    }
  }
  
  checkKeysDown();
  
  if (startKeyPress == true && gameState == "GAME") inMenu = 1 - inMenu; //Toggle the menu
}

//When a mouse button is released

void mouseReleased() {
  if (useMouse == true) {
    if (mouseButton == LEFT) {
      if (mouseLB == "UP") {
        upKeyPress = false;
      }
      
      if (mouseLB == "DOWN") {
        downKeyPress = false;
      }
      
      if (mouseLB == "LEFT") {
        leftKeyPress = false;
      }
      
      if (mouseLB == "RIGHT") {
        rightKeyPress = false;
      }
      
      if (mouseLB == "ACTION") {
        actionKeyPress = false;
      }
      
      if (mouseLB == "JUMP") {
        jumpKeyPress = false;
      }
      
      if (mouseLB == "START") {
        startKeyPress = false;
      }
    }
    
    if (mouseButton == RIGHT) {
      if (mouseRB == "UP") {
        upKeyPress = false;
      }
      
      if (mouseRB == "DOWN") {
        downKeyPress = false;
      }
      
      if (mouseRB == "LEFT") {
        leftKeyPress = false;
      }
      
      if (mouseRB == "RIGHT") {
        rightKeyPress = false;
      }
      
      if (mouseRB == "ACTION") {
        actionKeyPress = false;
      }
      
      if (mouseRB == "JUMP") {
        jumpKeyPress = false;
      }
      
      if (mouseRB == "START") {
        startKeyPress = false;
      }
    }
  }
  
  checkKeysDown();
}

boolean checkKeyIsDown(String _key) { //Check if a specific key is down, you can call this from your code!!
  //Options are UP, DOWN, LEFT, RIGHT, ACTION, JUMP, START
  
  if (_key == "UP" && upKeyPress == true) return true;
  if (_key == "DOWN" && downKeyPress == true) return true;
  if (_key == "LEFT" && leftKeyPress == true) return true;
  if (_key == "RIGHT" && rightKeyPress == true) return true;
  if (_key == "ACTION" && actionKeyPress == true) return true;
  if (_key == "JUMP" && jumpKeyPress == true) return true;
  if (_key == "START" && startKeyPress == true) return true;
  
  return false;
}

void checkKeysDown() { //Runs every time keys change to check if no inputs are being pressed at all DONT CALL THIS DIRECTLY FROM YOUR CODE! Instead check value of noKeyPress == true or == false
  if (upKeyPress == false && downKeyPress == false && leftKeyPress == false && rightKeyPress == false && actionKeyPress == false && jumpKeyPress == false) {
    anyKeyPress = false;
    noKeyPress = true;
  } else {
    anyKeyPress = true;
    noKeyPress = false;
  }
}

void debugPrintInput() { //Print to console what keys are down
  if (upKeyPress == true) println("UP KEY IS PRESSED");
  if (downKeyPress == true) println("DOWN KEY IS PRESSED");
  if (leftKeyPress == true) println("LEFT KEY IS PRESSED");
  if (rightKeyPress == true) println("RIGHT KEY IS PRESSED");
  if (actionKeyPress == true) println("ACTION KEY IS PRESSED");
  if (jumpKeyPress == true) println("JUMP KEY IS PRESSED");
  if (startKeyPress == true) println("START KEY IS PRESSED");
  println("");
}
