//Math functions useful for the game, like QARP

float Qarp (float Start, float Mid, float End, float T) { //A curved version of a LERP (linear interpolation) function
    float Ans;
    
    //Don't go past target!
    if (T > 1.0) T = 1.0;
    
    Ans = (Start + (Mid - Start) * T) + ((Mid + (End - Mid) * T) - (Start + (Mid - Start) * T)) * T;
    
    return Ans;
}

float chkDist(float x1, float y1, float x2, float y2) { //Return distance between two points
  float distance = sqrt(sq((x1 - x2)) + sq(y1 - y2)); //Distance between the two points

  return distance;
}

//Based on code from: http://gamedev.stackexchange.com/questions/86755/how-to-calculate-corner-marks-of-a-rotated-rectangle
PVector getRotatedPoint(float x, float y, float cx, float cy, float angle) { //X and Y of point, center X, center Y, rotation angle
  PVector result;

  float tempX = x - cx;
  float tempY = y - cy;

  float rotatedX = tempX*cos(angle) - tempY*sin(angle);
  float rotatedY = tempX*sin(angle) + tempY*cos(angle);

  result = new PVector(rotatedX + cx, rotatedY + cy);

  return result;
}

//Calculate our angle, based on http://www.gamefromscratch.com/post/2012/11/18/GameDev-math-recipes-Rotating-to-face-a-point.aspx
float angleToPoint(float startX, float endX, float startY, float endY) {
    float radAngle = atan2(endY - startY, endX - startX ); //The angle in radians
    float degAngle = radAngle * (180/PI); //Convert to degrees
    //Convert range from -180 to +180 degrees to 0-360 degrees
    if (degAngle < 0) {
      degAngle = 360 - (-degAngle);
    }
    
    return degAngle;
}
