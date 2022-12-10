boolean pointInCircle(float x, float y, float circlex, float circley, float circleradius) { //Return true or false if a point is within a circle
  if (chkCollideCircles(x, y, 0.1, circlex, circley, circleradius) > 0) {
    return true;
  } else {
    return false;
  }
}

int chkCollideCircles(float x1, float y1, float rad1, float x2, float y2, float rad2) { //Return an integer to check if two circles collide
  float distance = sqrt(sq((x1 - x2)) + sq(y1 - y2)); //Distance between the two circles

  if (distance < rad1 + rad2) {
    return 1;//Intersection
  } else if (distance == rad1 + rad2) {
    return 2; //Touching only
  }

  return 0; //No collide
}

boolean pointInRect(float x1, float y1, float x2, float y2, float recWidth, float recHeight) { //If the object is within a rectangle centered at X and Y
  if (x1 >= x2 - (recWidth/2) & y1 >= y2 - (recHeight/2) & x1 <= x2 + (recWidth/2) & y1 <= y2 + (recHeight/2)) { //Check conditions for being within the rectangle
    return true; //Point is within rectangle
  }

  return false; //No collide
}

boolean rectOverlap(float x1, float y1, float w1, float h1, float x2, float y2, float w2, float h2) { //If one rectangle overlaps another
  float obj1Top = y1 - (h1/2);
  float obj1Bottom = y1 + (h1/2);
  float obj1Left = x1 - (w1/2);
  float obj1Right = x1 + (w1/2);

  float obj2Top = y2 - (h2/2);
  float obj2Bottom = y2 + (h2/2);
  float obj2Left = x2 - (w2/2);
  float obj2Right = x2 + (w2/2);

  if (obj1Bottom >= obj2Top && obj1Right >= obj2Left && obj1Top <= obj2Bottom && obj1Left <= obj2Right) { 
    return true;
  } else {
    return false; //Nope
  }
}

boolean angleRectOverlap(float x1, float y1, float w1, float h1, float angle1, float x2, float y2, float w2, float h2, float angle2) { //Check if two rectangles overlap
  //This code could be copied and modified to support other polygons for overlap detection, but unless we have an explicit need for that we'll stick to rectangles
  ArrayList<PVector> rect1Points = new ArrayList<PVector>();
  ArrayList<PVector> rect2Points = new ArrayList<PVector>();
  
  //Add the vertices in a clockwise order!
  rect1Points.add(getRotatedPoint(x1 - (w1/2), y1 - (h1/2), x1, y1, angle1)); //Top left corner
  rect1Points.add(getRotatedPoint(x1 + (w1/2), y1 - (h1/2), x1, y1, angle1)); //Top right corner
  rect1Points.add(getRotatedPoint(x1 + (w1/2), y1 + (h1/2), x1, y1, angle1)); //Bottom right corner
  rect1Points.add(getRotatedPoint(x1 - (w1/2), y1 + (h1/2), x1, y1, angle1)); //Bottom left corner

  rect2Points.add(getRotatedPoint(x2 - (w2/2), y2 - (h2/2), x2, y2, angle2)); //Top left corner
  rect2Points.add(getRotatedPoint(x2 + (w2/2), y2 - (h2/2), x2, y2, angle2)); //Top right corner
  rect2Points.add(getRotatedPoint(x2 + (w2/2), y2 + (h2/2), x2, y2, angle2)); //Bottom right corner
  rect2Points.add(getRotatedPoint(x2 - (w2/2), y2 + (h2/2), x2, y2, angle2)); //Bottom left corner

  boolean foundOverlap = false;

  //Now loop through and check for overlap, first by checking points inside rectangle 1 to be inside rectangle 2
  for (int i = rect1Points.size () - 1; i >= 0; i--) {
    PVector p = rect1Points.get(i);

    foundOverlap = pointInPolygon(rect2Points, p.x, p.y);

    if (foundOverlap == true) return true;
  }

  //Check for points of rectangle 2 inside rectangle 1
  for (int i = rect2Points.size () - 1; i >= 0; i--) {
    PVector p = rect2Points.get(i);

    foundOverlap = pointInPolygon(rect1Points, p.x, p.y);

    if (foundOverlap == true) return true;
  }

  return false;
}

//Based on code from: https://forum.processing.org/one/topic/how-do-i-find-if-a-point-is-inside-a-complex-polygon.html
boolean pointInPolygon(ArrayList<PVector> vertices, float _x, float _y) { //Points of shape, x and y to test
  int j=vertices.size()-1;
  int sides = vertices.size();
  boolean oddNodes = false;
  for (int i=0; i<sides; i++) {
    PVector vert = vertices.get(i);
    PVector vert2 = vertices.get(j);      
    if ((vert.y < _y && vert2.y >= _y || vert2.y < _y && vert.y >= _y) && (vert.x <= _x || vert2.x <= _x)) {
      oddNodes^=(vert.x + (_y-vert.y)/(vert2.y - vert.y)*(vert2.x-vert.x)<_x);
    }
    j=i;
  }
  return oddNodes;
}

//Alternative (unused) way of doing the above from same page - Both seem to work?
boolean pointInPoly(ArrayList<PVector> verts, float _x, float _y) {
  int i, j;
  boolean c=false;
  int sides = verts.size();
  for (i=0, j=sides-1; i<sides; j=i++) {
    PVector vert1 = verts.get(i);
    PVector vert2 = verts.get(j);
    if (( ((vert1.y <= _y) && (_y < vert2.y)) || ((vert2.y <= _y) && (_y < vert1.y))) &&
      (_x < (vert2.x - vert1.x) * (_y - vert1.y) / (vert2.y - vert1.y) + vert1.x)) {
      c = !c;
    }
  }
  return c;
}


//This code is unused, but here if you want to take advantage of it (put the pixels of two objects at a time into it, works only for RASTER PNG gfx)
//Based on per-pixel collision code from https://forum.processing.org/two/discussion/4657/per-pixel-collision-detection
boolean intersectPixels(int X1, int Y1, int w1, int h1, color[] data1, int X2, int Y2, int w2, int h2, color[] data2) {

  int top = max(Y1, Y2);
  int bottom = min(Y1+h1, Y2+h2);
  int left = max(X1, X2);
  int right = min(X1+w1, X2+w2);

  for (int y = top; y < bottom; y++) {

    for (int x = left; x < right; x++) {

      color color1 = data1[(x - X1) + (y - Y1) * w1];
      color color2 = data2[(x - X2) + (y - Y2) * w2];

      if (alpha(color1) != 0 && alpha(color2) != 0) {
        return true;
      }
    }
  }
  return false;
}
