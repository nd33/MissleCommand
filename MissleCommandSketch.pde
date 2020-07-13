int NO_PARTICLES = 0 ;
final int OBJECT_SIZE = 10 ;

ArrayList<Particle> meteors;

ArrayList<Missle> missles;

ArrayList<Explosion> explosions;

ArrayList<Pyramid> pyramids;

MissleLauncher gun;

enum GameState {
  MAIN_MENU,
  STARTED,
  GAME_OVER
}

GameState state;

color buttonHighlight;

int buttonA_y = 35;
int buttonA_width = 120;
int buttonA_height = 85;

int buttonB_y = 130;
int buttonB_width = 120;
int buttonB_height = 85;

boolean buttonA_over = false;
boolean buttonB_over = false;

// Holds all the force generators and the particles they apply to
ForceRegistry forceRegistry ;

// initialise screen and particle array
void setup() {
  size(displayWidth, displayHeight) ;
  resetGame();
}

// update particles, render.
void draw() {
  if (state == GameState.STARTED) {
    if(meteors.isEmpty()) {
      proceedToNextLevel();
    }
    noCursor();
    background(128) ;    
    drawAim();    
    forceRegistry.updateForces() ;       
    checkForCollisions();    
    drawExplosions();
    drawPyramids();    
    drawMissleLauncher();   
    drawFlyingMissles(); 
    drawMeteors();
    if (isGameOver()) {
      resetGame();
    }
  } else if (state == GameState.MAIN_MENU) {
    cursor();
    updateMainMenu();
    drawMainMenu();
  } else {
      exit();
  }
}

// When mouse is pressed, store x, y coords
void mousePressed() {
  if(buttonA_over) {
    state = GameState.STARTED;
    buttonA_over = false;
  } else if (buttonB_over) {
    buttonB_over = false;
    exit();
  } else {
    missles.add(gun.shoot(mouseX,mouseY));
  }
  
}

void drawAim() {
  line(mouseX - 8, mouseY, mouseX + 8, mouseY) ;
  line(mouseX, mouseY + 8, mouseX, mouseY - 8) ;
  fill(255,0,0,63);
  circle(mouseX, mouseY, 16) ;
}

void drawPyramids() {
  for(Pyramid pyramid : pyramids) {
    //draw pyramid's building blocks
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
    //check if meteor is in explosion range
    for (int explosion = 0 ; explosion < explosions.size() ; explosion++) {
      if (isMeteorInExplosionRange(meteors.get(i), explosions.get(explosion))) {
        meteors.remove(i);
      }
    }
    //check for collisions with pyramids
    for(int pyramid = 0 ; pyramid < pyramids.size() ; pyramid++) {
      if (isMeteorInPyramidRange(meteors.get(i), pyramids.get(pyramid))) {
        explosions.add(new Explosion(meteors.get(i).position));
        meteors.remove(i);
        pyramids.remove(pyramid);
      }
    }
    float invMass = meteors.get(i).invMass ;
    if (invMass <= 0.002f) fill(0) ;
    else if (invMass <= 0.003f) fill(100) ;
    else if (invMass <= 0.004f) fill(200) ;
    else fill(255);
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

boolean isMeteorInPyramidRange(Particle meteor, Pyramid pyramid) {
  // Collision?
  for(Particle buildingBlock : pyramid.buildingBlocks) {
      PVector distance = meteor.position.get();
      distance.sub(buildingBlock.position);
      if (distance.mag() < OBJECT_SIZE) {
        return true; //<>// //<>//
    }
  }
  return false;
}

void drawMainMenu() {
  
  if (buttonA_over) {
    fill(buttonHighlight);
  } else {
    fill(0);
  }
  rect(displayWidth/2, buttonA_y, buttonA_width, buttonA_height);

   if (buttonB_over) {
    fill(buttonHighlight);
  } else {
    fill(0);
  }
  rect(displayWidth/2, buttonB_y, buttonB_width, buttonB_height);
  
  fill(255); 

  fill(0, 0, 0);
  text("DEFEND THE PYRAMIDS", displayWidth/2, 20);

  textAlign(CENTER, CENTER); 
  fill(255);
  text("START GAME", 
    displayWidth/2+buttonA_width/2, buttonA_y+buttonA_height/2);

  fill(255); 
  text("QUIT", 
    displayWidth/2+buttonB_width/2, buttonB_y+buttonB_height/2);

  // reset alignment
  textAlign(LEFT);
}

void updateMainMenu() {
  if (overRect(displayWidth/2, buttonA_y, buttonA_width, buttonA_height)) {
    buttonA_over = true;
    buttonB_over = false;
  } else if (overRect(displayWidth/2, buttonB_y, buttonB_width, buttonB_height)) {
    buttonA_over = false;
    buttonB_over = true;
  } else {
    buttonA_over = buttonB_over = false;
  }
}

boolean overRect(float x, float y, int width, int height)  {
  if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}

boolean isGameOver() {
  return pyramids.isEmpty();
}

void resetGame() {
  NO_PARTICLES = 0;
  state = GameState.MAIN_MENU;
  buttonHighlight = color(51);
  meteors = new ArrayList<Particle>();
  missles = new ArrayList<Missle>();
  explosions = new ArrayList<Explosion>();
  pyramids = new ArrayList<Pyramid>();
  
  //Create the ForceRegistry
  forceRegistry = new ForceRegistry() ;  
}

void proceedToNextLevel() {
  pyramids = new ArrayList<Pyramid>();
  NO_PARTICLES += 10;
    //Create a gravitational force
  Gravity gravity = new Gravity(new PVector(0f, .1f)) ;
  
  //Create a drag force
  //NB Increase k1, k2 to see an effect 
  Drag drag = new Drag(10, 10) ;
  
  // Create meteors, register gravity's 
  for (int i = 0; i < NO_PARTICLES; i++) {
    meteors.add(new Particle((int)random(0,displayWidth),
                                0,
                                random(-.1f,.5f),
                                random(-.5f,.5f),
                                random(0.001f,0.005f)));
    forceRegistry.add(meteors.get(i), gravity) ;
    forceRegistry.add(meteors.get(i), drag) ;
  }
  
  pyramids.add(new Pyramid(displayWidth/4, 20, OBJECT_SIZE));
  pyramids.add(new Pyramid(displayWidth/2 + displayWidth/6, 20, OBJECT_SIZE));
  gun = new MissleLauncher(displayWidth/2, displayHeight, displayHeight * 90 / 100);
}
