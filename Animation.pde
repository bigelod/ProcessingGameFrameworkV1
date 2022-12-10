class Animation { //An animation class, NO NEED TO CHANGE THIS!
  ArrayList<Sprite> sprites = new ArrayList<Sprite>();
  String name = "";
  int animSpeed = 10; //How many frames to wait before changing frame
  int loop = 1; //Whether or not to loop (0 for no loop, 1 for loop from loopFrame, 2 for ping-pong loop in forward-backward style)
  int currFrame = 0; //The current frame of an animation
  int loopFrame = 0; //When looping or repeating, set frame to restart the loop from, default 0 to replay whole animation
  int repeats = 0; //If loop = 0, then how many times should the animation play before it has ended?
  int numRepeat = 0; //How many times it has repeated
  int lastFrameCount = 0; //How many frames since last animate?
  int mirrorAnimation = 0; //Whether or not to mirror the whole animation
  int flipAnimation = 0; //Whether or not to flip the whole animation
  
  Animation(String _n) { //Build an animation without any sprites
    name = _n;
  }
  
  Animation(String _n, Sprite _s) { //Build an animation with a single sprite
    name = _n;
    addSprite(_s);
  }
  
  Animation(String _n, ArrayList<Sprite> _s) { //Build an animation with a list of sprites
    name = _n;
    addSprites(_s);
  }
  
  Animation(String _n, int _aS, int _l, int _lF, int _r) { //Build an animation without any sprites, but set its configurations
    name = _n;
    animSpeed = _aS;
    loop = _l;
    loopFrame = _lF;
    repeats = _r;
  }
  
  Animation(String _n, Sprite _s, int _aS, int _l, int _lF, int _r) { //Build an animation with a single sprite, but set its configurations
    name = _n;
    addSprite(_s);
    animSpeed = _aS;
    loop = _l;
    loopFrame = _lF;
    repeats = _r;
  }
  
  Animation(String _n, ArrayList<Sprite> _s, int _aS, int _l, int _lF, int _r) { //Build an animation with a list of sprites, but set its configurations
    name = _n;
    addSprites(_s);
    animSpeed = _aS;
    loop = _l;
    loopFrame = _lF;
    repeats = _r;
  }
  
  String animName() { //Get the name of the animation
    return name;
  }
  
  void startAnim() { //Start the animation or restart it
    currFrame = 0;
    numRepeat = 0;
    lastFrameCount = frameCount;
  }
  
  void Animate() {
    
    //Now we get the frame and draw it!
    Sprite currSprite = sprites.get(abs(currFrame)); //Get the current frame as a positive number, since negative is for ping-pong
    
    currSprite.setMirrored(mirrorAnimation); //Before rendering, check if animation is mirrored
    currSprite.setFlipped(flipAnimation); //Before rendering, check if animation is flipped
    
    currSprite.render(); //Render the frame
    
    if (frameCount - lastFrameCount >= animSpeed) { //If the number of frames passed is equal or more than the animspeed then we change frame      
      
      if (currFrame < sprites.size() - 1) { //Still frames left to play
        currFrame += 1; //Get ready for next time
      } else { //Otherwise, get ready to deal with loops and repeats

        //GOTTA MAKE THIS PART OF CODE DO PROPER LOOP, REPEAT, ETC
        if (loop == 1) { //Loop
          currFrame = loopFrame;
        }
        
        if (loop == 2) { //Ping-pong loop
          currFrame = -1 * (sprites.size() - 1); //Set to negative, this has the effect of counting backward for a forward-backward loop!
        }
        
        if (loop == 0) { //Catch-all, no looping!
          if (numRepeat < repeats) { //If there are repeats left to do
            currFrame = loopFrame; //Go back to loop frame
            numRepeat += 1;
          }
          
          //Otherwise, we just keep on the current frame!
        }
        
      }
    
      lastFrameCount = frameCount; //Update last frameCount
    }
  }
  
  Sprite getSprite() { //Send back the current sprite object
    return sprites.get(abs(currFrame));
  }
  
  void addSprites(ArrayList<Sprite> _spr) { //Add multiple sprites to the animation
   for (int i = 0; i < _spr.size(); i++) { //Unlike a normal object sort, we go from 0 and up so that the first frame in is the first one in the animation!
      Sprite s = _spr.get(i);
      
      addSprite(s);
    }
  }
  
  void addSprite(Sprite spr) { //Add a single sprite to the animation at the end
    sprites.add(spr);
  }
  
  boolean animationEnded() {
    if (loop == 0 && currFrame == sprites.size() - 1 && numRepeat == repeats) {
      return true;
    } else {
      return false;
    }
  }
  
  int getAnimSpeed() {
    return animSpeed;
  }
  
  void setAnimSpeed(int _aS) {
    animSpeed = _aS;
  }
  
  int loopType() {
    return loop;
  }
  
  void setLoop(int _l) {
    loop = _l;
  }
  
  int getLoopFrame() {
    return loopFrame;
  }
  
  void setLoopFrame(int _lf) {
    loopFrame = _lf;
  }
  
  int totalRepeats() {
    return repeats;
  }
  
  void setRepeats(int _r) {
    repeats = _r;
  }
  
  int getNumRepeats() {
    return numRepeat;
  }
  
  boolean isFlipped() {
    if (flipAnimation == 1) {
      return true;
    } else {
      return false;
    }
  }
  
  void setFlipped(int _f) {
    flipAnimation = _f;
  }
  
  boolean isMirrored() {
    if (mirrorAnimation == 1) {
      return true;
    } else {
      return false;
    }
  }
  
  void setMirrored(int _m) {
    mirrorAnimation = _m;
  }
}
