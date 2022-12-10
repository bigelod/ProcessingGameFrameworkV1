//We don't use these by default! BUT THEY ARE HERE FOR YOUR NEEDS :)

int isCollideSphere(float x1, float y1, float z1, float rad1, float x2, float y2, float z2, float rad2) { //Return an integer to check if two circles collide
  float distance = sqrt(sq((x1 - x2)) + sq(y1 - y2) + sq(z1 - z2)); //Distance between the two spheres

  if (distance < rad1 + rad2) {
    return 1;//Intersection
  } 
  else if (distance == rad1 + rad2) {
    return 2; //Touching only
  }

  return 0; //No collide
}

float chk3Dist(float x1, float y1, float z1, float x2, float y2, float z2) { //Return distance between two 3D points
  float distance = sqrt(sq(x1 - x2) + sq(y1 - y2) + sq(z1 - z2));

  return distance;
}

boolean isInBox(float x1, float y1, float z1, float x2, float y2, float z2, float recWidth, float recHeight, float recDepth) { //If the object is within a box
  if (x1 >= x2 & y1 >= y2 & z1 >= z2 & x1 <= x2 + recWidth & y1 <= y2 + recHeight & z1 <= z2 + recDepth) { //Check conditions for being within the box
    return true;
  }

  return false;
}

//Based on the example Texture Cube by Dave Bollinger
//https://processing.org/examples/texturecube.html
void texturedBox(float x, float y, float z, float rx, float ry, float rz, float w, float h, float d, PImage tex, PImage tex2, PImage tex3, PImage tex4, PImage tex5, PImage tex6) {

  pushMatrix();

  noStroke();

  translate(x, y, z);

  rotateX(rx);
  rotateY(ry);
  rotateZ(rz); 

  textureMode(NORMAL);

  // +Z "front" face
  beginShape(QUADS);
  texture(tex);

  //X, Y, Z, U, V

  vertex(0, 0, d, 0, 0);
  vertex( w, 0, d, 1, 0);
  vertex( w, h, d, 1, 1);
  vertex(0, h, d, 0, 1);

  endShape();

  // -Z "back" face
  beginShape(QUADS);
  texture(tex2);

  vertex( w, 0, 0, 0, 0);
  vertex(0, 0, 0, 1, 0);
  vertex(0, h, 0, 1, 1);
  vertex( w, h, 0, 0, 1);

  endShape();

  // +Y "bottom" face
  beginShape(QUADS);
  texture(tex3);

  vertex(0, h, d, 0, 0);
  vertex( w, h, d, 1, 0);
  vertex( w, h, 0, 1, 1);
  vertex(0, h, 0, 0, 1);

  endShape();

  // -Y "top" face
  beginShape(QUADS);
  texture(tex4);

  vertex(0, 0, 0, 0, 0);
  vertex( w, 0, 0, 1, 0);
  vertex( w, 0, d, 1, 1);
  vertex(0, 0, d, 0, 1);

  endShape();

  // +X "right" face
  beginShape(QUADS);
  texture(tex5);

  vertex( w, 0, d, 0, 0);
  vertex( w, 0, 0, 1, 0);
  vertex( w, h, 0, 1, 1);
  vertex( w, h, d, 0, 1);

  endShape();

  // -X "left" face
  beginShape(QUADS);
  texture(tex6);

  vertex(0, 0, 0, 0, 0);
  vertex(0, 0, d, 1, 0);
  vertex(0, h, d, 1, 1);
  vertex(0, h, 0, 0, 1);

  endShape();

  textureMode(IMAGE);

  popMatrix();
}

//Draw a "skybox" outside of the environment
void drawSkyBox(float x, float y, float z, float rx, float ry, float rz, float w, float h, float d, PImage tex, PImage tex2, PImage tex3, PImage tex4, PImage tex5, PImage tex6) {

  pushMatrix();

  noStroke();

  rotateX(rx);
  rotateY(ry);
  rotateZ(rz); 

  translate(x, y, z);



  textureMode(NORMAL);

  // +Z "front" face
  beginShape(QUADS);
  texture(tex);

  //X, Y, Z, U, V
  vertex(0, 0, d, 0, 0);
  vertex( w, 0, d, 1, 0);
  vertex( w, h, d, 1, 1);
  vertex(0, h, d, 0, 1);

  endShape();

  // -Z "back" face
  beginShape(QUADS);
  texture(tex2);

  vertex( w, 0, 0, 0, 0);
  vertex(0, 0, 0, 1, 0);
  vertex(0, h, 0, 1, 1);
  vertex( w, h, 0, 0, 1);

  endShape();

  // +Y "bottom" face
  beginShape(QUADS);
  texture(tex3);

  vertex(0, h, d, 0, 0);
  vertex( w, h, d, 1, 0);
  vertex( w, h, 0, 1, 1);
  vertex(0, h, 0, 0, 1);

  endShape();

  // -Y "top" face
  beginShape(QUADS);
  texture(tex4);

  vertex(0, 0, 0, 0, 0);
  vertex( w, 0, 0, 1, 0);
  vertex( w, 0, d, 1, 1);
  vertex(0, 0, d, 0, 1);

  endShape();

  // +X "right" face
  beginShape(QUADS);
  texture(tex5);

  vertex( w, 0, d, 0, 0);
  vertex( w, 0, 0, 1, 0);
  vertex( w, h, 0, 1, 1);
  vertex( w, h, d, 0, 1);

  endShape();

  // -X "left" face
  beginShape(QUADS);
  texture(tex6);

  vertex(0, 0, 0, 0, 0);
  vertex(0, 0, d, 1, 0);
  vertex(0, h, d, 1, 1);
  vertex(0, h, 0, 0, 1);

  endShape();

  textureMode(IMAGE);

  popMatrix();
}
