// a representation of a point mass
class Particle {
  
  // Vectors to hold pos, vel
  public PVector position, velocity ;
  
  // Vector to accumulate forces prior to integration
  private PVector forceAccumulator ; 
  
  // Store inverse mass to allow simulation of infinite mass
  private float invMass ;
  
  // If you do need the mass, here it is:
  public float getMass() {return 1/invMass ;}
  
  Particle(int x, int y, float xVel, float yVel, float invM) {
    position = new PVector(x, y) ;
    velocity = new PVector(xVel, yVel) ;
    forceAccumulator = new PVector(0, 0) ;
    invMass = invM ;    
  }
  
  // Add a force to the accumulator
  void addForce(PVector force) {
    forceAccumulator.add(force) ;
  }
  
  // update position and velocity
  void integrate() {
    // If infinite mass, we don't integrate
    if (invMass <= 0f) return ;
    
    // update position
    position.add(velocity) ;
    
    // NB If you have a constant acceleration (e.g. gravity) start with
    //    that then add the accumulated force / mass to that.
    PVector resultingAcceleration = forceAccumulator.get() ;
    resultingAcceleration.mult(invMass) ;
    
    // update velocity
    velocity.add(resultingAcceleration) ;
    // Apply an impulse to bounce off the edge of the screen
    //if ((position.x < 0) || (position.x > width)) velocity.x = -velocity.x ;
    //if ((position.y < 0) || (position.y > height)) velocity.y = -velocity.y ; 

    // Clear accumulator
    forceAccumulator.x = 0 ;
    forceAccumulator.y = 0 ;    
  }
}
