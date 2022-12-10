class Timer { //A timer is a handy object for countdowns and other features
  float startTime;
  float time;
  
  Timer(float _s) { //Constructor
    setTime(_s);
  }
  
  void setTime(float _sT) { //Set the timer and restart it
    startTime = _sT;
    time = _sT;
  }
  
  float getTime() { //Get the current time remaining
    return time;
  }
  
  int getSeconds() { //Get the whole seconds of time remaining
    return int(time);  
  }
  
  boolean isDone() { //Check if the timer is done
    if (time <= 0) {
      return true;
    } else {
      return false;
    }
  }
  
  void resetTime() {
    time = startTime; //Reset the timer
  }
  
  void timeTick() {
    if (frameCount % int(float(targetFPS)/10) == 0) time -= 0.1; //Every 10th of a second
    
    if (time <= 0) time = 0;
  }
}
