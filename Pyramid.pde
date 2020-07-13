// a representation of a pyramid
final class Pyramid {
  
  private ArrayList<Particle> buildingBlocks;
  
  // create a single pyramid
  Pyramid(int pyramidX, int size, int particleSize) {
    buildingBlocks = new ArrayList<Particle>();
    int pyramidY = displayHeight;
    int by, bx;
    int blocksPerRow = size;
    
    // add particles in pyramid shape
    for (int row = 0 ; row < size ; row++, blocksPerRow -= 2) {
      by = pyramidY - row * particleSize;
      bx = pyramidX + row * particleSize;
      for (int block = 0 ; block < blocksPerRow ; block++) {
        buildingBlocks.add(new Particle(bx, by, 0, 0, 0));
        bx += particleSize;
      }
    }
  }
  
  ArrayList<Particle> getBuildingBlocks() {
    return buildingBlocks;
  }
}
