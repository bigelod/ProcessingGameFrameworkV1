//This class is where you define your custom classes for game objects that rely on parts of the engine
class Camera {
  //Where the camera scrolls to
  float x, y; //X, Y
  
  Camera(float _x, float _y) {
    x = _x;
    y = _y;
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
}

class Player {
  AnimationController ac; //The ac object controls all of the player animations
  float x, y, colW, colH, xSpd, ySpd, maxXS, maxYS, jumpStr; //X position, Y position, collision box width and height, x and y speed components, max x and y speeds, jump strength
  int colFromSprite = 0; //Whether or not to load collision boundaries from the current sprite frame width and height, 0 for false, 1 for true
  int onGround = 1; //If on ground or not
  int lastDir = 0; //Left  = 0 or right = 1
  float floorFriction = 0.25; //How much friction on the floor when sliding? between 0 and 1 (0% and 100%), set in the ground blocks!
  float movSpd = 0.1; //How fast to move when accelerating
  float fallSpd = 0.1; //How fast to fall / gravity
  int onJumpThroughPlat = 0; //If we are on a jumpThrough platform
  float barkRecharge = 0; //Countdown before next bark

  Player() { //Since there is only one player object, we will load the graphics for them here instead of in the game code
    prepController();
    x = 0;
    y = 0;
    colW = 58;
    colH = 36;
    xSpd = 0;
    ySpd = 0;
    maxXS = 4;
    maxYS = 5;
    jumpStr = 0.5;
  }

  Player(float _x, float _y) { //Same as above but set X and Y
    prepController();
    x = _x;
    y = _y;
    colW = 58;
    colH = 36;
    xSpd = 0;
    ySpd = 0;
    maxXS = 4;
    maxYS = 5;
    jumpStr = 0.5;
  }

  void prepController() { //It would also be possible to program something like this that loads from a text file CSV, perhaps in FrameworkV2 !
    //First we will load the sprites
    Sprite bark1L = new Sprite("Shepherd_bark_1L.png", 0);
    Sprite bark2L = new Sprite("Shepherd_bark_2L.png", 0);
    Sprite bark3L = new Sprite("Shepherd_bark_3L.png", 0);
    Sprite idleL = new Sprite("Shepherd_defaultL.png", 0);
    Sprite walk1L = new Sprite("Shepherd_walk_1L.png", 0);
    Sprite walk2L = new Sprite("Shepherd_walk_2L.png", 0);
    Sprite walk3L = new Sprite("Shepherd_walk_3L.png", 0);
    Sprite walk4L = new Sprite("Shepherd_walk_4L.png", 0);
    Sprite walk5L = new Sprite("Shepherd_walk_5L.png", 0);
    Sprite walk6L = new Sprite("Shepherd_walk_6L.png", 0);
    Sprite jumpL = new Sprite("Shepherd_jumpL.png", 0);
    Sprite fallL = new Sprite("Shepherd_fallL.png", 0);

    Sprite idleR = new Sprite("Shepherd_defaultR.png", 0);
    Sprite jumpR = new Sprite("Shepherd_jumpR.png", 0);
    Sprite fallR = new Sprite("Shepherd_fallR.png", 0);

    //Create lists of sprites
    ArrayList<Sprite> barkL = new ArrayList<Sprite>();
    ArrayList<Sprite> barkR = new ArrayList<Sprite>();
    ArrayList<Sprite> walkL = new ArrayList<Sprite>();
    ArrayList<Sprite> walkR = new ArrayList<Sprite>();

    //Add the sprites to the list, the Right sprites are added using a condensed code method that saves on sprite definitions above!
    barkL.add(bark1L);
    barkL.add(bark2L);
    barkL.add(bark3L);

    barkR.add(new Sprite("Shepherd_bark_1R.png", 0));
    barkR.add(new Sprite("Shepherd_bark_2R.png", 0));
    barkR.add(new Sprite("Shepherd_bark_3R.png", 0));

    walkL.add(walk1L);
    walkL.add(walk2L);
    walkL.add(walk3L);
    walkL.add(walk4L);
    walkL.add(walk5L);
    walkL.add(walk6L);

    walkR.add(new Sprite("Shepherd_walk_1R.png", 0));
    walkR.add(new Sprite("Shepherd_walk_2R.png", 0));
    walkR.add(new Sprite("Shepherd_walk_3R.png", 0));
    walkR.add(new Sprite("Shepherd_walk_4R.png", 0));
    walkR.add(new Sprite("Shepherd_walk_5R.png", 0));
    walkR.add(new Sprite("Shepherd_walk_6R.png", 0));

    ArrayList<Animation> a = new ArrayList<Animation>(); //Prepare a list of animations to pass to the controller

    //Now we add animations by adding list of sprites and naming the animations
    //NAME, sprite or sprite arraylist, animation speed, loopval (0 or 1 or 2), loopFrame (to loop from), repeats (if not looping)
    //Animation speed is how many frames (eg: 60 frames per second) to show a frame for
    //Loopval is 0 for not looping, 1 or 2 for looping (2 is ping-pong, eg: 1,2,3,4,4,3,2,1...)
    //loopFrame is the frame to loop from if in regular loop or repeat mode (eg: 2 restarts from frame 2 at end of loop)
    //repeats is number of times to repeat if not looping before saying the animation has finished

    a.add(new Animation("BARKLEFT", barkL, 15, 0, 0, 0)); //Bark left, sprite list, not looped
    a.add(new Animation("BARKRIGHT", barkR, 15, 0, 0, 0)); //Bark right, sprite list, not looped
    a.add(new Animation("IDLELEFT", idleL, 10, 1, 0, 0)); //Idle left, single frame, looped
    a.add(new Animation("IDLERIGHT", idleR, 10, 1, 0, 0)); //Idle right, single frame, looped
    a.add(new Animation("WALKLEFT", walkL, 10, 1, 0, 0)); //Walk left, sprite list, looped
    a.add(new Animation("WALKRIGHT", walkR, 10, 1, 0, 0)); //Walk right, sprite list, looped
    a.add(new Animation("JUMPLEFT", jumpL, 10, 0, 0, 1)); //Jump left, single frame, not looped, repeats once due to lack of extra frames for timing
    a.add(new Animation("JUMPRIGHT", jumpR, 10, 0, 0, 1)); //Jump right, single frame, not looped, repeats once due to lack of extra frames for timing
    a.add(new Animation("FALLLEFT", fallL, 10, 1, 0, 0)); //Fall left, single frame, looped
    a.add(new Animation("FALLRIGHT", fallR, 10, 1, 0, 0)); //Fall right, single frame, looped

    ac = new AnimationController(a); //Finally we add the list of animations to the controller
    ac.setAnimation("IDLELEFT"); //Set the starting animation
  }

  void Update() { //Call this to make the player update logic

    //Check logic for next frame
    if (barkRecharge > 0) {
      barkRecharge -= 2.0 / targetFPS; //Try to recover 2 per second (frames per second)
    } else {
      barkRecharge = 0;
    }
    
    if (leftKeyPress == false && rightKeyPress == false && actionKeyPress == false && onGround == 1) {
      //On the ground, set animation to idle
      if (lastDir == 0) {
        ac.setAnimation("IDLELEFT");
      } else {
        ac.setAnimation("IDLERIGHT");
      }

      xSpd = lerp(xSpd, 0, floorFriction);
    }

    if (leftKeyPress == true && rightKeyPress == false && actionKeyPress == false && ac.getCurrAnim() != "BARKLEFT" && ac.getCurrAnim() != "BARKRIGHT") {
      //Move left
      if (ac.getCurrAnim() != "WALKLEFT" && onGround == 1) ac.setAnimation("WALKLEFT");
      lastDir = 0;
      if (xSpd > -1 * maxXS) xSpd -= movSpd;
    }

    if (leftKeyPress == false && rightKeyPress == true && actionKeyPress == false && ac.getCurrAnim() != "BARKLEFT" && ac.getCurrAnim() != "BARKRIGHT") {
      //Move right
      if (ac.getCurrAnim() != "WALKRIGHT" && onGround == 1) ac.setAnimation("WALKRIGHT");
      lastDir = 1;
      if (xSpd < maxXS) xSpd += movSpd;
    }

    if (actionKeyPress == true && ac.getCurrAnim() != "BARKLEFT" && ac.getCurrAnim() != "BARKRIGHT" && ac.getCurrAnim() != "JUMPLEFT" && ac.getCurrAnim() != "JUMPRIGHT" && barkRecharge == 0) {
      if (lastDir == 0) {
        ac.setAnimation("BARKLEFT");
        
        if (onGround == 1) {
          ac.setNextAnimation("IDLELEFT");
        } else {
          ac.setNextAnimation("FALLLEFT");
        }
        
        barkz.add(new BarkBubble(x - (colW/2) - 16, y - 2));
      } else {
        ac.setAnimation("BARKRIGHT");
        
        if (onGround == 1) {
          ac.setNextAnimation("IDLERIGHT");
        } else {
          ac.setNextAnimation("FALLRIGHT");
        }
        
        barkz.add(new BarkBubble(x + (colW/2) + 16, y - 2));
      }
      
      barkRecharge = 1;

      tryBark();

      if (onGround == 1) xSpd = lerp(xSpd, 0, floorFriction * 2); //More stopping power
    }

    if (jumpKeyPress == true && actionKeyPress == false && ac.getCurrAnim() != "BARKLEFT" && ac.getCurrAnim() != "BARKRIGHT" && onGround == 1) {
      if (downKeyPress == true) { //The player is trying to jump down through a platform
        if (onJumpThroughPlat == 1) {
          //We can fall through here
          if (lastDir == 0) {
            ac.setAnimation("FALLLEFT");
          } else {
            ac.setAnimation("FALLRIGHT");
          }

          y += 5; //Escape the check
          ySpd += 0.3; //Increase speed
          onJumpThroughPlat = 0; //Assume the next platform can not be jumped through

          onGround = 0;
        }
      } else {
        if (lastDir == 0) {
          ac.setAnimation("JUMPLEFT");
        } else {
          ac.setAnimation("JUMPRIGHT");
        }

        onJumpThroughPlat = 0; //Assume the next platform can not be jumped through

        onGround = 0;
      }
    }

    if (ac.getCurrAnim() == "JUMPLEFT" || ac.getCurrAnim() == "JUMPRIGHT") {
      if (lastDir == 0) {
        ac.setNextAnimation("FALLLEFT");
      } else {
        ac.setNextAnimation("FALLRIGHT");
      }
    }

    if (ac.getCurrAnim() != "JUMPLEFT" && ac.getCurrAnim() != "JUMPRIGHT" && ac.getCurrAnim() != "FALLLEFT" && ac.getCurrAnim() != "FALLRIGHT" && ac.getCurrAnim() != "BARKLEFT" && ac.getCurrAnim() != "BARKRIGHT" && onGround == 0) {
      if (lastDir == 0) {
        ac.setAnimation("FALLLEFT");
      } else {
        ac.setAnimation("FALLRIGHT");
      }
    }

    if (ac.getCurrAnim() == "FALLLEFT" || ac.getCurrAnim() == "FALLRIGHT") {
      if (leftKeyPress == true && rightKeyPress == false && onGround == 0) {
        ac.setAnimation("FALLLEFT");
        lastDir = 0;
      }

      if (leftKeyPress == false && rightKeyPress == true && onGround == 0) {
        ac.setAnimation("FALLRIGHT");
        lastDir = 1;
      }
    }

    if (onGround == 1) { //If we are on the ground
      if (ac.getCurrAnim() == "FALLLEFT" || ac.getCurrAnim() == "FALLRIGHT") {
        if (lastDir == 0) {
          ac.setAnimation("IDLELEFT");
        } else {
          ac.setAnimation("IDLERIGHT");
        }
      }
      ySpd = 0;
    } else { //Otherwise, if we are falling
      if (ac.getCurrAnim() == "JUMPLEFT" || ac.getCurrAnim() == "JUMPRIGHT") {
        if (ySpd > -1 * maxYS) ySpd -= jumpStr; //Keep jumping
      }
      if (ySpd < maxYS) ySpd += fallSpd;
    }

    //Now update movement
    x += xSpd;
    y += ySpd;

    //Quick check to see if we are above maximums, which we sometimes do to escape checks
    if (xSpd > maxXS) xSpd = maxXS;
    if (xSpd < -1 * maxXS) xSpd = -1 * maxXS;
    if (ySpd > maxYS) ySpd = maxYS;
    if (ySpd < -1 * maxYS) ySpd = -1 * maxYS;

    if (debugMode == 1 && y > 1600) { //Safety switch in debug mode
      y = 20;
      ySpd = 0;
    }
  }

  void Display() { //Call this to draw the player object
    pushMatrix(); //Store the camera
    
    translate(x, y);

    ac.playAnimation(); //Draw the frame

    if (colFromSprite == 1) { //Grab the current sprite object dimensions
      Animation a = ac.getAnim(ac.getCurrAnim());

      Sprite s = a.getSprite();

      colW = s.getWidth();
      colH = s.getHeight();
    }

    if (debugMode == 1) {
      //Draw the collision box
      rectMode(CENTER);
      ellipseMode(CENTER);
      imageMode(CENTER);

      fill(255, 255, 0, 100);
      stroke(255);

      rect(0, 0, colW, colH);
    }

    popMatrix(); //Restore the camera
  }

  void forceFall() { //Call this to force the player to fall eg: if they hit a ceiling 
    if (ac.getCurrAnim() == "JUMPLEFT" || ac.getCurrAnim() == "JUMPRIGHT") {
      if (lastDir == 0) {
        ac.setAnimation("FALLLEFT");
      } else {
        ac.setAnimation("FALLRIGHT");
      }

      ySpd = fallSpd; //Back to falling
    }
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

  float getColW() {
    return colW;
  }

  void setColW(float _cW) {
    colW = _cW;
  }

  float getColH() {
    return colH;
  }

  void setColH(float _cH) {
    colH = _cH;
  }

  float getXSpd() {
    return xSpd;
  }

  void setXSpd(float _xS) {
    xSpd = _xS;
  }

  float getYSpd() {
    return ySpd;
  }

  void setYSpd(float _yS) {
    ySpd = _yS;
  }

  float getMaxXSpd() {
    return maxXS;
  }

  void setMaxXSpd(float _mXS) {
    maxXS = _mXS;
  }

  float getMaxYSpd() {
    return maxYS;
  }

  void setMaxYSpd(float _mYS) {
    maxYS = _mYS;
  }

  boolean isOnGround() {

    if (onGround == 1) {
      return true;
    } else {
      return false;
    }
  }

  void setOnGround(int _oG) {
    onGround = _oG;
  }

  float getFloorF() {
    return floorFriction;
  }

  void setFloorF(float _fF) {
    floorFriction = _fF;
  }

  float getMovSpd() {
    return movSpd;
  }

  void setMovSpd(float _mS) {
    movSpd = _mS;
  }

  float getFallSpd() {
    return fallSpd;
  }

  void setFallSpd(float _fS) {
    fallSpd = _fS;
  }

  boolean isOnJumpThroughPlat() {
    if (onJumpThroughPlat == 1) {
      return true;
    } else {
      return false;
    }
  }

  void setJumpThroughPlat(int _jP) {
    onJumpThroughPlat = _jP;
  }

  boolean isJumping() {
    if (ac.getCurrAnim() == "JUMPLEFT" || ac.getCurrAnim() == "JUMPRIGHT") {
      return true;
    } else {
      return false;
    }
  }

  boolean isFalling() {
    if (ac.getCurrAnim() != "JUMPLEFT" && ac.getCurrAnim() != "JUMPRIGHT" && onGround == 0) {
      return true;
    } else {
      return false;
    }
  }
}

//Classes used for collisions
class GroundCollider { //This is an invisible object that would be used over top of ground image objects of different types to stop the player falling/moving
  float x, y, w, h; //X and Y pos, width and height of collider
  int jumpThrough = 0; //Allow the player to jump through it if 1 or stop player from jumping through it if 0
  float friction = 0.25; //The friction of the ground object

  GroundCollider(int _jT) { //If this will be attached to a level object then there's no need to pass x,y,w,h
    jumpThrough = _jT;
  }

  GroundCollider(int _jT, float _fric) { //Create one with ground friction
    jumpThrough = _jT;
    friction = _fric;
  }

  GroundCollider(float _x, float _y, float _w, float _h, int _jT) {
    x = _x;
    y = _y;
    w = _w;
    h = _h;
    jumpThrough = _jT;
  }

  GroundCollider(float _x, float _y, float _w, float _h, int _jT, float _fric) {
    x = _x;
    y = _y;
    w = _w;
    h = _h;
    jumpThrough = _jT;
    friction = _fric;
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

  float getFriction() {
    return friction;
  }

  void setFriction(float _fric) {
    friction = _fric;
  }

  int getJumpThrough() {
    return jumpThrough;
  }

  void setJumpThrough(int _jT) {
    jumpThrough = _jT;
  }

  void debugDisplay() { //Draw the colliders, use color to identify type
    if (jumpThrough == 0) {
      fill(0, 255, 0, 100);
      stroke(255);
    } else {
      fill(0, 255, 100, 100);
      stroke(255);
    }

    if (x + scrollX > width + w || x + scrollX < 0 - w || y + scrollY > height + h || y + scrollY < 0 - h) {
      //Offscreen!
    } else {

      rectMode(CENTER);
      ellipseMode(CENTER);
      imageMode(CENTER);

      rect(x, y, w, h);
    }
  }
}

//Classes for the level design

class LevelGraphic { //A class that merges the foreground object and an (optional) groundcollider
  Foreground fG;
  GroundCollider gC; //If attached, the groundCollider is positioned and sized to fit the foreground object
  int hasGC = 0; //If we have a GroundCollider attached

  LevelGraphic(Foreground _fG) {
    fG = _fG;
  }

  void attachGroundCollider(GroundCollider _gC) {
    gC = _gC;
    hasGC = 1;
  }

  void Update() {

    if (hasGC == 1) {
      gC.setX(fG.getX());
      gC.setY(fG.getY());

      gC.setWidth(fG.getWidth());
      gC.setHeight(fG.getHeight());

      if (gC.getJumpThrough() == 1) {
        tint(180, 180, 180); //Tint slightly darker
      } else {
        noTint(); //Don't draw slightly darker
      }
    }

    fG.Display();
  }

  //Pass data too and from the foreground object directly
  void setX(float _x) {
    fG.setX(_x);
  }

  void setY(float _y) {
    fG.setY(_y);
  }

  float getWidth() {
    return fG.getWidth();
  }

  float getHeight() {
    return fG.getHeight();
  }

  Sprite getSprite() {
    return fG.getSprite();
  }

  void setSprite(Sprite _s) {
    fG.setSprite(_s);
  }

  GroundCollider getGroundCollider() {
    return gC;
  }
}

//Classes used for items and abiliies

class ScoreItem {
  Sprite img;
  float x, y, w, h, fH, fS; //X, Y, Width, Height, floatHeight how far to float up and down, floatSpeed

  ScoreItem(float _x, float _y) {
    img = new Sprite("point_orb_32x32.png", 0);
    x = _x;
    y = _y;
    w = img.getWidth();
    h = img.getHeight();
    fH = 4; //Float up to this amount above and below Y position
    fS = 5; //How fast to float? Use number less than 1 to float faster, don't use zero!
  }

  void Display() {
    boolean offScreen = false; //Check if we are offscreen

    pushMatrix(); //Store matrix

      //Scroll on both axis      
    translate(x, y + sin(frameCount / fS) * fH); //Float up and down

    if (x + scrollX > width + img.getWidth() || x + scrollX < 0 - img.getWidth() || y + scrollY > height + img.getHeight() || y + scrollY < 0 - img.getHeight()) {
      offScreen = true;
    }

    if (offScreen == false) img.render(); //Finally, if we are onscreen, draw!

    popMatrix(); //Restore matrix

      if (debugMode == 1 && offScreen == false) {
      pushMatrix();

      translate(x, y); //Move to actual position

      //Draw the collision box

      rectMode(CENTER);
      ellipseMode(CENTER);
      imageMode(CENTER);

      fill(255, 255, 0, 100);
      stroke(255);

      rect(0, 0, w, h);

      popMatrix();
    }
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

  float getHeight() {
    return h;
  }

  float getFloatHeight() {
    return fH;
  }

  void setFloatHeight(float _fH) {
    fH = _fH;
  }

  float getFloatSpeed() {
    return fS;
  }

  void setFloatSpeed(float _fS) {
    fS = _fS;
  }
}

class BarkBubble {
  AnimationController ac;
  Timer t;
  float x, y, w, h; //X, Y, Width, Height

  BarkBubble(float _x, float _y) {
    prepController();
    x = _x;
    y = _y;
    w = 64;
    h = 64;
    t = new Timer(0.25);
  }

  void prepController() { //It would also be possible to program something like this that loads from a text file CSV, perhaps in FrameworkV2 !
    //First we will load the sprites
    Sprite bark1B = new Sprite("bark_48x48.png", 0);
    Sprite bark2B = new Sprite("bark_64x64.png", 0);

    //Create lists of sprites
    ArrayList<Sprite> barkB = new ArrayList<Sprite>();

    //Add the sprites to the list, the Right sprites are added using a condensed code method that saves on sprite definitions above!
    barkB.add(bark1B);
    barkB.add(bark2B);

    //animSpeed = frames per sprite, loop = 0/1/2, loopFrame = frame to repeat from, repeats = how many times to play
    Animation a = new Animation("BARK", barkB, 5, 2, 0, 0); //Bark bubble

    ac = new AnimationController(a); //Finally we add the list of animations to the controller
    ac.setAnimation("BARK"); //Set the starting animation
  }

  void Display() {
    boolean offScreen = false; //Check if we are offscreen

    pushMatrix(); //Store matrix

      //Scroll on both axis      
    translate(x, y);

    if (x + scrollX > width + w || x + scrollX < 0 - w || y + scrollY > height + h || y + scrollY < 0 - h) {
      offScreen = true;
    }

    if (offScreen == false) ac.playAnimation(); //Finally, if we are onscreen, draw!

    if (debugMode == 1 && offScreen == false) {
      //Draw the collision box

      rectMode(CENTER);
      ellipseMode(CENTER);
      imageMode(CENTER);

      fill(255, 255, 0, 100);
      stroke(255);

      rect(0, 0, w, h);
    }

    popMatrix(); //Restore matrix
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

  float getHeight() {
    return h;
  }

  boolean timerDone() {
    t.timeTick(); //Countdown the timer

    if (t.isDone()) {
      return true;
    } else {
      return false;
    }
  }
}

//Classes used for enemies

class GunBullet {
  Sprite img;
  float x, y, w, h, spd; //X, Y, Width, Height, bullet speed
  int dir; //Direction of shot

  GunBullet(float _x, float _y, int _dir) {
    img = new Sprite("enemybullet.png", 0);
    img.setScale(1.5);
    x = _x;
    y = _y;
    w = 16;
    h = 12;
    spd = 3; //Pixels per frame
    dir = _dir;
  }

  void Display() {
    boolean offScreen = false; //Check if we are offscreen

    pushMatrix(); //Store matrix

      //Scroll on both axis      
    translate(x, y);

    if (x + scrollX > width + w || x + scrollX < 0 - w || y + scrollY > height + h || y + scrollY < 0 - h) {
      offScreen = true;
    }

    if (offScreen == false) img.render(); //Finally, if we are onscreen, draw!

    if (debugMode == 1 && offScreen == false) {
      //Draw the collision box

      rectMode(CENTER);
      ellipseMode(CENTER);
      imageMode(CENTER);

      fill(255, 255, 0, 100);
      stroke(255);

      rect(0, 0, w, h);
    }

    popMatrix(); //Restore matrix

      x = x + spd*dir;
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

  float getHeight() {
    return h;
  }
}

class GunEnemy {
  AnimationController ac; //The ac object controls all of the enemy animations
  float x, y, colW, colH, xSpd, ySpd, maxXS, maxYS, jumpStr; //X position, Y position, collision box width and height, x and y speed components, max x and y speeds, jump strength
  int colFromSprite = 0; //Whether or not to load collision boundaries from the current sprite frame width and height, 0 for false, 1 for true
  int onGround = 1; //If on ground or not
  int lastDir = 0; //Left  = 0 or right = 1
  float floorFriction = 0.25; //How much friction on the floor when sliding? between 0 and 1 (0% and 100%), set in the ground blocks!
  float movSpd = 0.08; //How fast to move when accelerating
  float fallSpd = 0.11; //How fast to fall / gravity
  int onJumpThroughPlat = 0; //If we are on a jumpThrough platform
  float minChaseDist = 300; //How close to start to chase the player
  float minShootDist = 200; //How close to shoot at player
  float minJumpDist = 60; //Minimum Y distance between the two that is acceptable 
  float maxJumpDist = 120; //How far apart on a Y axis to try jumping
  int chasePlayer = 0; //Whether or not to chase the player
  int shootPlayer = 0; //Whether or not to shoot the player
  int jumpToPlayer = 0; //Whether or not to jump up or down to player (-1 for down, 1 for up, 0 for no jump)

  GunEnemy() { //Load the enemy graphics
    prepController();
    x = 0;
    y = 0;
    colW = 22;
    colH = 45;
    xSpd = 0;
    ySpd = 0;
    maxXS = 1;
    maxYS = 5;
    jumpStr = 0.5;
  }

  GunEnemy(float _x, float _y) { //Same as above but set X and Y
    prepController();
    x = _x;
    y = _y;
    colW = 22;
    colH = 45;
    xSpd = 0;
    ySpd = 0;
    maxXS = 1;
    maxYS = 5;
    jumpStr = 0.5;
  }

  void prepController() { //It would also be possible to program something like this that loads from a text file CSV, perhaps in FrameworkV2 !
    //First we will load the sprites
    Sprite idle = new Sprite("enemy_idle.png", 0);
    Sprite fall = new Sprite("enemy_fall.png", 0);
    Sprite hurt = new Sprite("enemy_hurt.png", 0);

    //Create lists of sprites
    ArrayList<Sprite> walk = new ArrayList<Sprite>();

    //Add the sprites to the list
    walk.add(new Sprite("enemy_walk1.png", 0));
    walk.add(new Sprite("enemy_walk2.png", 0));
    walk.add(new Sprite("enemy_walk3.png", 0));
    walk.add(new Sprite("enemy_walk4.png", 0));
    walk.add(new Sprite("enemy_walk5.png", 0));
    walk.add(new Sprite("enemy_walk6.png", 0));
    walk.add(new Sprite("enemy_walk7.png", 0));
    walk.add(new Sprite("enemy_walk8.png", 0));

    ArrayList<Animation> a = new ArrayList<Animation>(); //Prepare a list of animations to pass to the controller

    //Now we add animations by adding list of sprites and naming the animations
    //NAME, sprite or sprite arraylist, animation speed, loopval (0 or 1 or 2), loopFrame (to loop from), repeats (if not looping)
    //Animation speed is how many frames (eg: 60 frames per second) to show a frame for
    //Loopval is 0 for not looping, 1 or 2 for looping (2 is ping-pong, eg: 1,2,3,4,4,3,2,1...)
    //loopFrame is the frame to loop from if in regular loop or repeat mode (eg: 2 restarts from frame 2 at end of loop)
    //repeats is number of times to repeat if not looping before saying the animation has finished

    a.add(new Animation("IDLE", idle, 10, 1, 0, 0)); //Idle, single frame, looped
    a.add(new Animation("WALK", walk, 10, 1, 0, 0)); //Walk, sprite list, looped
    a.add(new Animation("JUMP", fall, 10, 0, 0, 1)); //Jump, uses same sprite list as walk, one repeated frame
    a.add(new Animation("FALL", fall, 10, 1, 0, 0)); //Fall, single frame, looped
    a.add(new Animation("HURT", hurt, 10, 1, 0, 0)); //Hurt/dead, single frame, looped

    ac = new AnimationController(a); //Finally we add the list of animations to the controller
    ac.setAnimation("IDLE"); //Set the starting animation
  }

  void Update() { //Call this to make the player update logic
      
    //Check logic for next frame
    if (chkDist(p1.getX(), p1.getY(), x, y) <= minShootDist && onGround == 1 && enemyBulls.size() < 1) { //Within X pixels of player? try shoot
      shootPlayer = 1;
    } else {
      shootPlayer = 0;
    }
    
    if (chkDist(p1.getX(), 0, x, 0) <= minChaseDist   && chkDist(0, p1.getY(), 0, y) <= height) { //If we are on screen with the player
      chasePlayer = 1;
      
      //Also check if we want to jump to player
      if (chkDist(0, p1.getY(), 0, y) >= minJumpDist && chkDist(0, p1.getY(), 0, y) <= maxJumpDist) {
        if (p1.getY() < y) {
          jumpToPlayer = 1;
        } else {
          jumpToPlayer = -1;
        }
      } else {
        jumpToPlayer = 0;
      }
      
    } else {
      chasePlayer = 0;
      jumpToPlayer = 0;
    }
    
    if (chasePlayer == 0 && onGround == 1) {
      //On the ground, set animation to idle
      ac.setAnimation("IDLE");
      
      if (p1.getX() > x) lastDir = 0;
      if (p1.getX() < x) lastDir = 1;
      
      xSpd = lerp(xSpd, 0, floorFriction);
    }

    if (p1.getX() > x && chasePlayer == 1 && shootPlayer == 0) {
      //Move left
      if (ac.getCurrAnim() != "WALK" && onGround == 1) ac.setAnimation("WALK");
      lastDir = 0;
      if (lastDir == 0 && xSpd > -1 * maxXS) xSpd += movSpd;
    }

    if (p1.getX() < x && chasePlayer == 1 && shootPlayer == 0) {
      //Move right
      if (ac.getCurrAnim() != "WALK" && onGround == 1) ac.setAnimation("WALK");
      lastDir = 1;
      if (xSpd < maxXS) xSpd -= movSpd;
    }

    if (shootPlayer == 1 && onGround == 1) {
      if (lastDir == 0) {
        enemyBulls.add(new GunBullet(x - (colW/2) + 16, y - 2, 1));
      } else {
        enemyBulls.add(new GunBullet(x + (colW/2) - 16, y - 2, -1));
      }

      tryLaser();

      xSpd = lerp(xSpd, 0, floorFriction * 2); //More stopping power
    }

    if (jumpToPlayer != 0 && onGround == 1) {
      if (jumpToPlayer == -1) { //The player is trying to jump down through a platform
        if (onJumpThroughPlat == 1) {
          //We can fall through here
          ac.setAnimation("FALL");

          y += 5; //Escape the check
          ySpd += 0.3; //Increase speed
          onJumpThroughPlat = 0; //Assume the next platform can not be jumped through

          onGround = 0;
        }
      } else {
        ac.setAnimation("JUMP");

        onJumpThroughPlat = 0; //Assume the next platform can not be jumped through

        onGround = 0;
      }
    }

    if (ac.getCurrAnim() == "JUMP") {
      ac.setNextAnimation("FALL");
    }

    if (ac.getCurrAnim() != "JUMP" && ac.getCurrAnim() != "FALL" && onGround == 0) {
      ac.setAnimation("FALL");
    }

    if (ac.getCurrAnim() == "FALL") {
      if (p1.getX() < x && onGround == 0) {
        ac.setAnimation("FALL");
        lastDir = 1;
      }

      if (p1.getX() > x && onGround == 0) {
        ac.setAnimation("FALL");
        lastDir = 0;
      }
    }

    if (onGround == 1) { //If we are on the ground
      if (ac.getCurrAnim() == "FALL") ac.setAnimation("IDLE");

      ySpd = 0;
    } else { //Otherwise, if we are falling
      if (ac.getCurrAnim() == "JUMP") {
        if (ySpd > -1 * maxYS) ySpd -= jumpStr; //Keep jumping
      }
      if (ySpd < maxYS) ySpd += fallSpd;
    }

    //Now update movement
    x += xSpd;
    y += ySpd;

    //Quick check to see if we are above maximums, which we sometimes do to escape checks
    if (xSpd > maxXS) xSpd = maxXS;
    if (xSpd < -1 * maxXS) xSpd = -1 * maxXS;
    if (ySpd > maxYS) ySpd = maxYS;
    if (ySpd < -1 * maxYS) ySpd = -1 * maxYS;
  }

  void Display() { //Call this to draw the player object
    pushMatrix(); //Store the camera

    translate(x, y);

    ac.setMirrored(lastDir); //Update whether the enemy should be mirrored or not based on its direction

    ac.playAnimation(); //Draw the frame

    if (colFromSprite == 1) { //Grab the current sprite object dimensions
      Animation a = ac.getAnim(ac.getCurrAnim());

      Sprite s = a.getSprite();

      colW = s.getWidth();
      colH = s.getHeight();
    }

    if (debugMode == 1) {
      //Draw the collision box
      rectMode(CENTER);
      ellipseMode(CENTER);
      imageMode(CENTER);

      fill(255, 255, 0, 100);
      stroke(255);

      rect(0, 0, colW, colH);
    }

    popMatrix(); //Restore the camera
  }

  void forceFall() { //Call this to force the enemy to fall eg: if they hit a ceiling 
    if (ySpd < 0) {
      ac.setAnimation("FALL");

      ySpd = fallSpd; //Back to falling
    }
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

  float getColW() {
    return colW;
  }

  void setColW(float _cW) {
    colW = _cW;
  }

  float getColH() {
    return colH;
  }

  void setColH(float _cH) {
    colH = _cH;
  }

  float getXSpd() {
    return xSpd;
  }

  void setXSpd(float _xS) {
    xSpd = _xS;
  }

  float getYSpd() {
    return ySpd;
  }

  void setYSpd(float _yS) {
    ySpd = _yS;
  }

  float getMaxXSpd() {
    return maxXS;
  }

  void setMaxXSpd(float _mXS) {
    maxXS = _mXS;
  }

  float getMaxYSpd() {
    return maxYS;
  }

  void setMaxYSpd(float _mYS) {
    maxYS = _mYS;
  }

  boolean isOnGround() {

    if (onGround == 1) {
      return true;
    } else {
      return false;
    }
  }

  void setOnGround(int _oG) {
    onGround = _oG;
    if (_oG == 1 && ac.getCurrAnim() == "FALL") { //Reset speed to stop sliding
      xSpd *= 0.1;
    }
  }

  float getFloorF() {
    return floorFriction;
  }

  void setFloorF(float _fF) {
    floorFriction = _fF;
  }

  float getMovSpd() {
    return movSpd;
  }

  void setMovSpd(float _mS) {
    movSpd = _mS;
  }

  float getFallSpd() {
    return fallSpd;
  }

  void setFallSpd(float _fS) {
    fallSpd = _fS;
  }

  boolean isOnJumpThroughPlat() {
    if (onJumpThroughPlat == 1) {
      return true;
    } else {
      return false;
    }
  }

  void setJumpThroughPlat(int _jP) {
    onJumpThroughPlat = _jP;
  }

  boolean isJumping() {
    if (ac.getCurrAnim() == "JUMP") {
      return true;
    } else {
      return false;
    }
  }

  boolean isFalling() {
    if (ac.getCurrAnim() == "FALL") {
      return true;
    } else {
      return false;
    }
  }
}

//All classes used by particles and emitters, usually these are part of another graphic or object, not just on their own.

class Particle { //A class for particles, emitted from a particle emitter
  Sprite img; //The image to draw
  Timer t; //Timer, if used will destroy object
  float x, y, xSpd, ySpd, acc; //X and Y position, X speed, Y speed, acceleration

  Particle(float _x, float _y, float _xSpd, float _ySpd, float _acc, float _t) {
    x = _x;
    y = _y;
    xSpd = _xSpd;
    ySpd = _ySpd;
    acc = _acc;
    t = new Timer(_t);
  }

  void Display() { //If on-screen is handled by the emitter
    pushMatrix();

    translate(x, y);

    img.render();

    popMatrix();

    x += xSpd;
    y += ySpd;

    xSpd += acc;
    ySpd += acc;
  }

  boolean timerDone() {
    t.timeTick(); //Countdown the timer

    if (t.isDone()) {
      return true;
    } else {
      return false;
    }
  }
}

class ParticleEmitter { //A class for controlling particles emitted
  ArrayList<Particle> particles; //A list of particles
  Sprite img; //The image to emit
  float x, y, minAngle, maxAngle; // X and Y of emitter, and min and max angle to shoot particles towards
  float minSpd, maxSpd; //Speed of particles will be random between minimum and maximum
  float minLife, maxLife; //The minimum lifetime of a particle and the maximum lifetime
  float minAcc, maxAcc; //Minimum acceleration and maximum accleration
  int maxParticles; //How many particles to make?
  int emitting; //Whether or not to emit at start

  ParticleEmitter(float _x, float _y, Sprite _img) { //Omni direcitonal particle emitter
    x = _x;
    y = _y;
    img = _img;
    minAngle = 0;
    maxAngle = 360;
    minSpd = 1;
    maxSpd = 10;
    minLife = 0.25;
    maxLife = 5;
    maxParticles = 10;
    emitting = 1;
    minAcc = -10;
    maxAcc = 0;
  }

  ParticleEmitter(float _x, float _y, Sprite _img, float _minA, float _maxA, float _minS, float _maxS, float _minL, float _maxL, float _minAc, float _maxAc, int _maxP, int _e) { //Custom particle emitter
    x = _x;
    y = _y;
    img = _img;
    minAngle = _minA;
    maxAngle = _maxA;
    minSpd = _minS;
    maxSpd = _maxS;
    minLife = _minL;
    maxLife = _maxL;
    minAcc = _minAc;
    maxAcc = _maxAc;
    maxParticles = _maxP;
    emitting = _e;
  }

  void Update() {
    boolean offScreen = false; //Check if we are offscreen

    if (x + scrollX > width + (width/2) || x + scrollX < -1 * (width/2) || y + scrollY > height + (height/2) || y + scrollY < -1 * (height/2)) { //Keep particles going for at least a screen width each side
      offScreen = true;
    }

    if (offScreen == false) {

      for (int i = particles.size () - 1; i >= 0; i--) {
        Particle p = particles.get(i);

        p.Display();

        if (p.timerDone() == true) {
          particles.remove(i);
        }
      }

      if (particles.size() < maxParticles && emitting == 1) { //Create another particle
        float pAngle = random(maxAngle + 1) + minAngle;
        float pSpeed = random(maxSpd + 1) + minSpd;
        float pXSpd = sin(radians(pAngle)) * pSpeed;
        float pYSpd = cos(radians(pAngle)) * pSpeed;

        float pAcc = random(maxAcc + 1) + minAcc;

        float pLife = random(maxLife + 1) + minLife;

        particles.add(new Particle(x, y, pXSpd, pYSpd, pAcc, pLife));
      }
    } else {
      if (particles.size() > 0) particles = new ArrayList<Particle>(); //Wipe the list of particles
    }
  }

  float getX() {
    return x;
  }

  float getY() {
    return y;
  }

  void setPosition(float _x, float _y) {
    x = _x;
    y = _y;
  }

  void setImg(Sprite _img) {
    img = _img;
  }

  void setConeAngle(float _minA, float _maxA) {
    minAngle = _minA;
    maxAngle = _maxA;
  }

  void setSpawnSpeed(float _minS, float _maxS) {
    minSpd = _minS;
    maxSpd = _maxS;
  }

  void setSpawnLife(float _minL, float _maxL) {
    minLife = _minL;
    maxLife = _maxL;
  }

  boolean isEmitting() {
    if (emitting == 1) {
      return true;
    } else {
      return false;
    }
  }

  void setEmitting(int _e) {
    emitting = _e;
  }

  void setMaxParticles(int _maxP) {
    maxParticles = _maxP;
  }
}
