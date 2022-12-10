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
  float x, y, colW, colH, xSpd, ySpd, targX, targY; //X position, Y position, collision box width and height, target X and target Y
  int colFromSprite = 0; //Whether or not to load collision boundaries from the current sprite frame width and height, 0 for false, 1 for true
  float movSpd = 0.02; //How fast to move when accelerating, a decimal between 0 and 1 (becomes a % between 0% and 100%)
  int hp = 100; //Player health
  float angle; //Player angle, 0 is right

  Player() { //Since there is only one player object, we will load the graphics for them here instead of in the game code
    prepController();
    x = 0;
    y = 0;
    colW = 32;
    colH = 56;
    targX = 0;
    targY = 0;
    angle = 0;
  }

  Player(float _x, float _y) { //Same as above but set X and Y
    prepController();
    x = _x;
    y = _y;
    colW = 32;
    colH = 56;
    targX = _x;
    targY = _y;
    angle = 0;
  }

  void prepController() { //It would also be possible to program something like this that loads from a text file CSV, perhaps in FrameworkV2 !

    //Walk sprite
    Sprite idle = new Sprite("p_walk_1.png", 0);

    //Create list of sprites
    ArrayList<Sprite> walk = new ArrayList<Sprite>();

    //Add the sprites to the list, the Right sprites are added using a condensed code method that saves on sprite definitions above!
    walk.add(new Sprite("p_walk_2.png", 0));
    walk.add(new Sprite("p_walk_3.png", 0));
    walk.add(new Sprite("p_walk_4.png", 0));
    walk.add(new Sprite("p_walk_5.png", 0));
    walk.add(new Sprite("p_walk_6.png", 0));
    walk.add(new Sprite("p_walk_7.png", 0));
    walk.add(new Sprite("p_walk_8.png", 0));
    walk.add(new Sprite("p_walk_1.png", 0)); //This frame goes last because we already start from it when we use it for idle frame

    ArrayList<Animation> a = new ArrayList<Animation>(); //Prepare a list of animations to pass to the controller

    //Now we add animations by adding list of sprites and naming the animations
    //NAME, sprite or sprite arraylist, animation speed, loopval (0 or 1 or 2), loopFrame (to loop from), repeats (if not looping)
    //Animation speed is how many frames (eg: 60 frames per second) to show a frame for
    //Loopval is 0 for not looping, 1 or 2 for looping (2 is ping-pong, eg: 1,2,3,4,4,3,2,1...)
    //loopFrame is the frame to loop from if in regular loop or repeat mode (eg: 2 restarts from frame 2 at end of loop)
    //repeats is number of times to repeat if not looping before saying the animation has finished

    a.add(new Animation("WALK", walk, 10, 1, 0, 0)); //Walk, sprite list, looped
    a.add(new Animation("IDLE", idle, 10, 1, 0, 0)); //Idle, single frame, looped

    ac = new AnimationController(a); //Finally we add the list of animations to the controller
    ac.setAnimation("IDLE"); //Set the starting animation
  }

  void Update() { //Call this to make the player update logic

    if (actionKeyPress == true) {
      if (scrollingGame == 1) {
        targX = mouseX + x - (width/2);
        targY = mouseY + y - (height/2);
      } else {
        targX = mouseX + scrollX;
        targY = mouseY + scrollY;
      }
    } else {
      if (pointInRect(x, y, targX, targY, 20, 20) == true ) { //If not clicking but close to target, stop where we are instead
        targX = x;
        targY = y;
      }
    }

    //Check logic for next frame
    if (pointInRect(x, y, targX, targY, 5, 5) == false) { //Simple animation check using detection of player within a certain amount of pixels from target
      if (ac.getCurrAnim() != "WALK") ac.setAnimation("WALK");
    } else { //Stop moving
      ac.setAnimation("IDLE");
      targX = x;
      targY = y;
    }

    //Now update movement
    x = lerp(x, targX, movSpd); //Move from current position to target position at a % of the distance between the two
    y = lerp(y, targY, movSpd); //Move from current position to target position at a % of the distance between the two

    if (ac.getCurrAnim() == "WALK") angle = angleToPoint(x, targX, y, targY); //Angle towards our target position if moving

    //Update animations to match angle
    ac.setAngle(angle);
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

      rotate(radians(angle));

      rect(0, 0, colW, colH);
    }

    popMatrix(); //Restore the camera
  }

  float getX() {
    return x;
  }

  void setX(float _x) {
    x = _x;
    targX = _x;
  }

  float getY() {
    return y;
  }

  void setY(float _y) {
    y = _y;
    targY = _y;
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

  float getTargX() {
    return targX;
  }

  void setTargX(float _x) {
    targX = _x;
  }

  float getTargY() {
    return targY;
  }

  void setTargY(float _y) {
    targY = _y;
  }

  float getMovSpd() {
    return movSpd;
  }

  void setMovSpd(float _mS) {
    movSpd = _mS;
  }

  int getHP() {
    return hp;
  }

  void setHP(int _h) {
    hp = _h;
  }
}

//Classes for the level design

class MapTile { //A class that merges the foreground object and an (optional) groundcollider
  Sprite tilegfx; //The graphic for this tile piece
  int xGrid = 0; //X of tile
  int yGrid = 0; //Y of tile
  int isSolid = 0; //Whether or not this tile is solid
  int doTint = 0; //Whether or not to tint this tile
  float tintR = 0; //Red tint
  float tintG = 0; //Green tint
  float tintB = 0; //Blue tint
  float tintA = 0; //Alpha tint (opacity)

  MapTile(Sprite _tgfx, int _x, int _y, int _isSolid) { //Just create tile, no tint
    tilegfx = _tgfx;

    xGrid = _x;
    yGrid = _y;
    isSolid = _isSolid;
    doTint = 0;
  }

  MapTile(Sprite _tgfx, int _x, int _y, int _isSolid, float _tR, float _tG, float _tB, float _tA) { //Create tile with tint
    tilegfx = _tgfx;

    xGrid = _x;
    yGrid = _y;
    isSolid = _isSolid;

    setTint(_tR, _tG, _tB, _tA);
  }

  void Display() {
    boolean offScreen = false; //Check if we are offscreen
    float x = float(xGrid * tileWidth);
    float y = float(yGrid * tileHeight);

    pushMatrix(); //Store matrix

      //Scroll on both axis      
    translate(x, y);

    if (x + scrollX > width + tileWidth || x + scrollX < 0 - tileWidth || y + scrollY > height + tileHeight || y + scrollY < 0 - tileHeight) {
      offScreen = true;
    }

    if (offScreen == false) {
      if (doTint == 1) tint(tintR, tintG, tintB, tintA); //Tint

      tilegfx.render(); //Finally, if we are onscreen, draw!

      noTint(); //Get rid of tint again
    }

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

      rect(0, 0, tileWidth, tileHeight);

      popMatrix();
    }
  }

  void setTint(float _r, float _g, float _b, float _a) {
    doTint = 1;
    tintR = _r;
    tintG = _g;
    tintB = _b;
    tintA = _a;
  }

  void removeTint() {
    doTint = 0;
  }

  int getGridX() {
    return xGrid; //Tile X
  }

  float getX() {
    return float(xGrid * tileWidth); //Return actual X
  }

  void setGridX(int _x) {
    xGrid = _x; //Set grid X
  }

  int getGridY() {
    return yGrid; //Tile Y
  }

  float getY() {
    return float(yGrid * tileHeight); //Return actual Y
  }

  void setGridY(int _y) {
    yGrid = _y; //Set grid Y
  }

  Sprite getSprite() {
    return tilegfx;
  }

  void setSprite(Sprite _s) {
    tilegfx = _s;
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

