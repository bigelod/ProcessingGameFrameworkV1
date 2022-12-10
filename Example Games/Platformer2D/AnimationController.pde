class AnimationController { //This class is used to swap between animations, you might want to make your own if it doesn't fit your needs
  ArrayList<Animation> anims = new ArrayList<Animation>(); //A list of animations 
  String lastAnim = ""; //
  String currAnim = "IDLE"; //The current animation name
  String nextAnim = "IDLE"; //What animation to play next?
  int flipController = 0; //Flip all animations?
  int mirrorController = 0; //Mirror all animations?
  float angle = 0; //The angle of animations? try not to combine this with mirror and flip!
  
  AnimationController() { //Build a controller with no animations
    currAnim = "IDLE";
  }
  
  AnimationController(Animation _an) { //Build a controller with a single animation
    currAnim = "IDLE";
    addAnim(_an);
  }
  
  AnimationController(ArrayList<Animation> _a) { //Build a controller with a list of animations
    currAnim = "IDLE";
    addAnims(_a);
  }
  
  String getCurrAnim() {
    return currAnim;
  }
  
  String getNextAnim() {
    return nextAnim;
  }
  
  void setAnimation(String animName) { //Set the animation right away
    currAnim = animName;
    
    Animation anim = getAnim(currAnim);
    anim.startAnim(); //Prepare the animation for rendering
  }
  
  void setNextAnimation(String animName) { //Set the next animation to play
    nextAnim = animName;
  }
  
  float getAngle() {
    return angle;
  }
  
  void setAngle(float _a) {
    angle = _a;
  }
  
  void playAnimation() { //Called every frame to animate, sometimes called again if animation should change
    
    if (chkAnimation() == true) { //If we have an animation to play
    
      Animation anim = getAnim(currAnim);
      
      anim.setAngle(angle);
      anim.setMirrored(mirrorController);
      anim.setFlipped(flipController);
      
      anim.Animate(); // Play it
    
    }
    
  }
  
  boolean chkAnimation() { //Check if we should change the animation
    Animation anim = getAnim(currAnim); //Grab the current animation
    
    if (anim.animName() != "NONAME") { //If the animation exists, we try to animate or switch if the animation has ended
    
      if (anim.animationEnded() == false) { //If the animation hasn't ended, animate it
        return true;
      } else { //Otherwise, change to next animation and try again
        Animation a = getAnim(nextAnim); //Get ahold of the animation
        
        a.startAnim(); //Prepare the animation for rendering
        
        currAnim = nextAnim;
        return true;
      }
      
      
    } else { //Otherwise, switch to IDLE and don't animate this time
      currAnim = "IDLE";
      return false;
    }
  }
  
  Animation getAnim(String animName) { //Get the animation
    for (int i = anims.size() - 1; i >= 0; i--) {
      Animation a = anims.get(i);
      
      if (a.animName() == animName) {
        //This is our animation!
        return a;
      }
    }
    
    Animation noAnim = new Animation("NONAME");
    return noAnim;
  }
  
  void addAnims(ArrayList<Animation> _an) { //Add multiple animations to the controller
   for (int i = 0; i < _an.size(); i++) { //Order doesn't matter in this case
      Animation a = _an.get(i);
      
      addAnim(a);
    }
  }
  
  void addAnim(Animation a) { //Add a single animation to the controller at the end
    a.startAnim(); //Reset the animation
    anims.add(a); //Add it to the pile
  }
  
  boolean isFlipped() {
    if (flipController == 1) {
      return true;
    } else {
      return false;
    }
  }
  
  void setFlipped(int _f) {
    flipController = _f;
  }
  
  boolean isMirrored() {
    if (mirrorController == 1) {
      return true;
    } else {
      return false;
    }
  }
  
  void setMirrored(int _m) {
    mirrorController = _m;
  }
}
