class Sprite { //A sprite class, NO NEED TO CHANGE THIS!
  PImage raster;
  PShape vector;
  int isVector = 0; //Whether or not to act as a vector (SVG) or raster (PNG) file
  int mirrored; //Whether the image is mirrored horizontally (0 or 1), set in setImg()
  int flipped; //Whether the image is flipped vertically (0 or 1), set in setImg()
  float w, h, sX, sY; //X pos, Y pos, Z pos, Width, Height, Scale X, Scale Y, set in setImg()
  float angle; //The angle in DEGREES (0 - 360), 0 is facing right. REMEMBER: THIS DOESN'T CHANGE COLLISION BOXES/ANGLES!, set in setImg()

  Sprite(String _f, int _i) {
    setImg(_f, _i);
  }

  void imgPGraphic(PGraphics _pg) { //For setting sprite contents from draw commands like rect();
    //See https://processing.org/reference/PGraphics.html for more information on using this method in your GameLogic sheet (not in this sheet!)
    raster = _pg.get();
    w = raster.width;
    h = raster.height;
    isVector = 0;
  }

  void render() {
    pushMatrix();

    rectMode(CENTER);
    ellipseMode(CENTER);
    imageMode(CENTER);

    //We already have some code for scaling the sprites, so we use the flipped and mirrored variable just to invert directions
    if (mirrored == 1 && flipped == 0) {
      scale(-1, 1);
    }

    if (flipped == 1 && mirrored == 0) {
      scale(1, -1);
    }

    if (mirrored == 1 && flipped == 1) {
      scale(-1, -1);
    }
    
    rotate(radians(angle));

    //Finally, draw the image
    if (isVector == 0) {
      image(raster, 0, 0, w * sX, h * sY);
    } else {
      shape(vector, 0, 0, w * sX, h * sY);
    }

    popMatrix();
  }

  void setScale(float _s) {
    sX = _s;
    sY = _s;
  }

  void setScaleX(float _sX) {
    sX = _sX;
  }

  void setScaleY(float _sY) {
    sY = _sY;
  }

  void setImg(String filename, int _iV) {
    isVector = _iV;

    if (_iV == 0) {
      raster = loadImage(filename);
      w = raster.width;
      h = raster.height;
    } else {
      vector = loadShape(filename);
      w = vector.width;
      h = vector.height;
    }
    
    mirrored = 0; //Not mirrored
    flipped = 0; //Not flipped
    angle = 0; //Default angle

    sX = 1.0;
    sY = 1.0;
  }

  float getScaleX() {
    return sX;
  }

  float getScaleY() {
    return sY;
  }

  float getWidth() {
    return w * sX;
  }

  float getHeight() {
    return h * sY;
  }

  boolean isFlipped() {
    if (flipped == 1) {
      return true;
    } else {
      return false;
    }
  }

  void setFlipped(int _f) {
    flipped = _f;
  }

  boolean isMirrored() {
    if (mirrored == 1) {
      return true;
    } else {
      return false;
    }
  }
  
  void setMirrored(int _m) {
    mirrored = _m;
  }
  
  float getAngle() {
    return angle;
  }
  
  void setAngle(float _a) {
    angle = _a;
  }
}

//A class used for sprites that scroll in the background (eg: sense of depth, 2.5D)
class Backdrop {
  float x, y, parax, paray; //X and Y pos, and parallax X ratio and parallax Y ratio (eg: 0 = no movement when screen scrolls, 1.0 = normal movement)
  Sprite img; //The background image

  Backdrop(float _x, float _y, float _px, float _py, Sprite _s) {
    x = _x;
    y = _y;
    parax = _px;
    paray = _py;
    img = _s;
  }

  Sprite getSprite() {
    return img;
  }

  void setSprite(Sprite _s) {
    img = _s;
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
    return img.getWidth();
  }

  float getHeight() {
    return img.getHeight();
  }

  void Display() {
    boolean offScreen = false; //Check if we are offscreen

    pushMatrix(); //Store matrix

      if (parax < 0) parax = 0; //Looks silly when negative
    if (paray < 0) paray = 0; //Looks silly when negative

    if (parax <= 0 || paray <= 0) {
      if (parax <= 0 && paray > 0) {
        //Only scroll on Y axis
        translate(x, y + (scrollY * paray));

        if (y + (scrollY * paray) > height + img.getHeight() || y + (scrollY * paray) < 0 - img.getHeight()) {
          offScreen = true;
        }
      } else if (paray <= 0) {
        //Only scroll on X axis
        translate(x + (scrollX * parax), y);
        if (x + (scrollX * parax) > width + img.getWidth() || x + (scrollX * parax) < 0 - img.getWidth()) {
          offScreen = true;
        }
      } else {
        //Both are zero, static backdrop no translate needed
        if (x > width + img.getWidth() || x < 0 - img.getWidth() || y > height + img.getHeight() || y < 0 - img.getHeight()) {
          offScreen = true;
        }
      }
    } else {
      //Scroll on both axis      
      translate(x + (scrollX * parax), y + (scrollY * paray));

      if (x + (scrollX * parax) > width + img.getWidth() || x + (scrollX * parax) < 0 - img.getWidth() || y + (scrollY * paray) > height + img.getHeight() || y + (scrollY * paray) < 0 - img.getHeight()) {
        offScreen = true;
      }
    }

    if (offScreen == false) img.render(); //Finally, if we are onscreen, draw!

    popMatrix(); //Restore matrix
  }
}

//A class for sprites that scroll on-screen (in the foreground)
class Foreground {
  float x, y; //X and Y pos
  Sprite img; //The foreground image

  Foreground(float _x, float _y, Sprite _s) {
    x = _x;
    y = _y;
    img = _s;
  }

  Sprite getSprite() {
    return img;
  }

  void setSprite(Sprite _s) {
    img = _s;
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
    return img.getWidth();
  }

  float getHeight() {
    return img.getHeight();
  }

  void Display() {
    boolean offScreen = false; //Check if we are offscreen

    pushMatrix(); //Store matrix

      //Scroll on both axis      
    translate(x, y);

    if (x + scrollX > width + img.getWidth() || x + scrollX < 0 - img.getWidth() || y + scrollY > height + img.getHeight() || y + scrollY < 0 - img.getHeight()) {
      offScreen = true;
    }

    if (offScreen == false) img.render(); //Finally, if we are onscreen, draw!

    popMatrix(); //Restore matrix
  }
}
