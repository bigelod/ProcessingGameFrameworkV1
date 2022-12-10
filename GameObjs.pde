//This class is where you define your custom classes for game objects that rely on parts of the engine
//Some useful code is here to start, but you are free to remove anything and everything you want from this tab!
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
