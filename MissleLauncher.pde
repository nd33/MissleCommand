// a representation of a Missle Launcher
final class MissleLauncher {
  
  // Vector to accumulate forces prior to integration
  private PVector forceAccumulator;
  
  private ArrayList<Particle> buildingBlocks;
  
  private int x;
  
  private int y;
  
  // create a single missle launcher
  MissleLauncher(int xStart, int yStart, int yEnd) {
    this.x = xStart;
    this.y = yEnd;
    buildingBlocks = new ArrayList<Particle>();
      for(int y = yStart ; y > yEnd ; y-=5) {
        buildingBlocks.add(new Particle(xStart,y,0,0,0));
      } 
    // add extra configuration to Missle Launcher ?
  }
  
  // Add a force to the accumulator
  void addForce(PVector force) {
    forceAccumulator.add(force) ;
  }
  
  ArrayList<Particle> getBuildingBlocks() {
    return buildingBlocks;
  }
  
  Missle shoot(int mX, int mY) {
    //line(this.x + 3, this.y, x, y);
    // point particle towards x and y end coordinates
    //PVector mousePosition = new PVector(x,y);
    //PVector movement = mousePosition.sub(missleLaunchPosition);
    //PVector missleDirection = movement.normalize();
    //PVector acceleration = new PVector((x - missleLaunchPosition.x)/1000f, (y - missleLaunchPosition.y)/1000f) ;
    Missle missle = new Missle(this.x, this.y, mX, mY);
    //missle.velocity.normalize();
    return missle;
  }
}
