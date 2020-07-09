// a representation of a city
final class Pyramid {
  
  // Vector to accumulate forces prior to integration
  private PVector forceAccumulator ;
  
  private ArrayList<Particle> buildingBlocks;
  
  // create a single city
  Pyramid(int pyramidX, int size, int particleSize) {
    buildingBlocks = new ArrayList<Particle>();
    int pyramidY = displayHeight;
    int by, bx;
    
    //for (int row = 0 ; row < n ; row++) {
    //  by = pyramidY - row * particleSize;
    //  bx = pyramidX + (row + 1) * particleSize/2;
    //}
    
    int blocksPerRow = size;
    for (int row = 0 ; row < size ; row++, blocksPerRow -= 2) {
      by = pyramidY - row * particleSize;
      bx = pyramidX + row * particleSize;
      for (int block = 0 ; block < blocksPerRow ; block++) {
        buildingBlocks.add(new Particle(bx, by, 0, 0, 0));
        bx += particleSize;
      }
    }
    //for( int storeCounter = 0; storeCounter < stores ; xStart += particleSize, storeCounter++) {
    //  int store = 0;
    //  for( ; store <= storeCounter ; y -= particleSize, store++) {
    //    buildingBlocks.add(new Particle(xStart,y,0,0,0));
    //  }
    //  y = displayHeight;
    //}
    // builld other half of city here ??
    
  }
  
  // Add a force to the accumulator
  void addForce(PVector force) {
    forceAccumulator.add(force) ;
  }
  
  ArrayList<Particle> getBuildingBlocks() {
    return buildingBlocks;
  }
}
