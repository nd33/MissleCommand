final int NO_PARTICLES = 20 ;
final int OBJECT_SIZE = 10 ;

ArrayList<Particle> meteors;

ArrayList<Missle> missles;

ArrayList<Explosion> explosions;

ArrayList<Pyramid> pyramids;

MissleLauncher gun;

int xStart, yStart, xEnd, yEnd ;

enum GameState {
  MAIN_MENU,
  STARTED,
  GAME_OVER
}

GameState state;

color buttonHighlight;

float buttonA_x = 103.8;
int buttonA_y = 35;
int buttonA_width = 120;
int buttonA_height = 85;
int buttonA_colorR = 0x25;
int buttonA_colorG = 0x25;
int buttonA_colorB = 0x25;

float buttonB_x = 103.8;
int buttonB_y = 130;
int buttonB_width = 120;
int buttonB_height = 85;
int buttonB_colorR = 0x25;
int buttonB_colorG = 0x25;
int buttonB_colorB = 0x25;

boolean buttonA_clicked = false;
boolean buttonB_clicked = false;

//// A force generator that applies a force specified by the user.
//UserForce userForce ;

// Holds all the force generators and the particles they apply to
ForceRegistry forceRegistry ;

// initialise screen and particle array
void setup() {
  size(displayWidth, displayHeight) ;
  state = GameState.MAIN_MENU;
  buttonHighlight = color(51);
  meteors = new ArrayList<Particle>();
  missles = new ArrayList<Missle>();
  explosions = new ArrayList<Explosion>();
  pyramids = new ArrayList<Pyramid>();

  //Create a gravitational force
  Gravity gravity = new Gravity(new PVector(0f, .1f)) ;
  
  //Create a drag force
  //NB Increase k1, k2 to see an effect 
  Drag drag = new Drag(10, 10) ;
  
  ////Create the user force
  //userForce = new UserForce(new PVector(0f, 0f)) ;
  
  //Create the ForceRegistry
  forceRegistry = new ForceRegistry() ;  
  
  // Create particles, register gravity's 
  for (int i = 0; i < NO_PARTICLES; i++) {
    meteors.add(new Particle((int)random(0,displayWidth),
                                0,
                                random(-.1f,.5f),
                                random(-.5f,.5f),
                                random(0.001f,0.005f)));
    forceRegistry.add(meteors.get(i), gravity) ;
    forceRegistry.add(meteors.get(i), drag) ;
    //forceRegistry.add(particles[i], userForce) ;
  }
  
  pyramids.add(new Pyramid(displayWidth/4, 20, OBJECT_SIZE));
  pyramids.add(new Pyramid(displayWidth/2 + displayWidth/6, 20, OBJECT_SIZE));
  gun = new MissleLauncher(displayWidth/2, displayHeight, displayHeight * 90 / 100);
}

// update particles, render.
void draw() {
  
  if (state == GameState.STARTED) {
    noCursor();
    background(128) ;    
    drawAim();    
    forceRegistry.updateForces() ;    
    drawMeteors();
    drawPyramids();    
    drawMissleLauncher();   
    drawFlyingMissles();    
    checkForCollisions();    
    drawExplosions();
  } else if (state == GameState.MAIN_MENU) {
    drawMainMenu();
  } else {
      textSize(50);
      text("GAME OVER", displayWidth/2, displayHeight/2);
  } //<>// //<>// //<>//
  
}

// When mouse is pressed, store x, y coords
void mousePressed() {
  xStart = mouseX ;
  yStart = mouseY ;
  
  missles.add(gun.shoot(mouseX,mouseY));
}

// When mouse is released create new vector relative to stored x, y coords
void mouseReleased() {
  xEnd = mouseX ;
  yEnd = mouseY ;
  //userForce.set(xEnd - xStart, yEnd - yStart) ;
}

void drawAim() {
  line(mouseX - 8, mouseY, mouseX + 8, mouseY) ;
  line(mouseX, mouseY + 8, mouseX, mouseY - 8) ;
  fill(255,0,0,63);
  circle(mouseX, mouseY, 16) ;
}

void drawPyramids() {
  for(Pyramid pyramid : pyramids) {
    for(int i = 0 ; i < pyramid.getBuildingBlocks().size(); i++) {
      PVector position = pyramid.getBuildingBlocks().get(i).position;
      fill(255, 204, 0);
      noStroke();
      rect(position.x, position.y,OBJECT_SIZE,OBJECT_SIZE);
      stroke(0);
    }
  }
}

void drawMissleLauncher() {
  for(int i = 0 ; i < gun.getBuildingBlocks().size(); i++) {
    PVector position = gun.getBuildingBlocks().get(i).position;
    fill(100, 0, 0);
    noStroke();
    rect(position.x, position.y,OBJECT_SIZE,OBJECT_SIZE);
    stroke(0);
  }
}

void drawFlyingMissles() {
  for (int i = 0; i < missles.size(); i++) {
    missles.get(i).integrate() ;
    PVector position = missles.get(i).position ;
    if (position.x > displayWidth || position.x < 0 || position.y > displayHeight || position.y < 0) {
      missles.remove(i);
      continue;
    }
    fill(204, 102, 0);
    ellipse(position.x, position.y, OBJECT_SIZE, OBJECT_SIZE) ; 
  }
}

//very slow O^2 ( faster will be to have Collision Pairs between all meteors and missles) : O^1
void checkForCollisions() {
  for (int missle = 0; missle < missles.size(); missle++) {
    for (int meteor = 0; meteor < meteors.size(); meteor++) {
      if (detectCollision(meteors.get(meteor), missles.get(missle))) {
        meteors.remove(meteor);
        explosions.add(new Explosion(missles.get(missle).position)); // create new explosion
        missles.remove(missle);
        break;
      }
    }
  }
}

// Check if the given meteor and missle are colliding.
// Generate a Contact if necessary
boolean detectCollision(Particle meteor, Missle missle) {
  PVector distance = meteor.position.get() ;
  distance.sub(missle.position) ;
  
  // Collision?
  if (distance.mag() < OBJECT_SIZE) {
    return true;
  }
  return false;
}

void drawExplosions() {
  for (int explosion = 0 ; explosion < explosions.size() ; explosion++) {
    if (explosions.get(explosion).hasExpired()) {
      explosions.remove(explosion);
    } else {
      explosions.get(explosion).propagate();
    }
  }
}

void drawMeteors() {
  for (int i = 0; i  < meteors.size(); i++) {
    meteors.get(i).integrate() ;
    PVector position = meteors.get(i).position ;
    if (position.x > displayWidth || position.x < 0 || position.y > displayHeight || position.y < 0) {
      meteors.remove(i);
      continue;
    }
    for (int explosion = 0 ; explosion < explosions.size() ; explosion++) {
      if (isMeteorInExplosionRange(meteors.get(i), explosions.get(explosion))) {
        meteors.remove(i);
      }
    }
    float invMass = meteors.get(i).invMass ;
    if (invMass <= 0.002f) fill(0) ;
    else if (invMass <= 0.003f) fill(100) ;
    else if (invMass <= 0.004f) fill(200) ;
    else fill(255) ;
    ellipse(position.x, position.y, OBJECT_SIZE, OBJECT_SIZE) ; 
  }
}

boolean isMeteorInExplosionRange(Particle meteor, Explosion explosion) {
  PVector distance = meteor.position.get();
  distance.sub(explosion.position);
  
  // Collision?
  if (distance.mag() < explosion.currRadius) {
    return true;
  }
  return false;
}

void drawMainMenu() {
  
    fill(buttonA_colorR, buttonA_colorG, buttonA_colorB);
  rect(buttonA_x, buttonA_y, buttonA_width, buttonA_height);

  fill(buttonB_colorR, buttonB_colorG, buttonA_colorB);
  rect(buttonB_x, buttonB_y, buttonB_width, buttonB_height);
  
  fill(255); 

  fill(0, 0, 0);
  text("LED CONTROL", 119, 20);

  //fill(0, 0, 0);
  text("/", 286, 220);

  //fill(0, 0, 0);
  text("/", 296, 220);

int d = day();    // Values from 1 - 31
int m = month();  // Values from 1 - 12
int y = year();
  String s = String.valueOf(d);
  text(s, 272, 220);
  s = String.valueOf(m);
  text(s, 290, 220); 
  s = String.valueOf(y);
  text(s, 300, 220);

  textAlign(CENTER, CENTER); 
  fill(255);
  text("START", 
    buttonA_x+buttonA_width/2, buttonA_y+buttonA_height/2);

  fill(255); 
  text("STOP", 
    buttonB_x+buttonB_width/2, buttonB_y+buttonB_height/2);

  // reset 
  textAlign(LEFT);
}

void updateMainMenu(int x, int y) {
  if (overRect(buttonA_width, buttonA_height, buttonA_width, buttonA_height)) {
    rectOver = true;
    circleOver = false;
  } else {
    circleOver = rectOver = false;
  }
}

boolean overRect(int x, int y, int width, int height)  {
  if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}
