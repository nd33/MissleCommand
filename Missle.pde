final class Missle {
  
  PVector direction;
  
  float speed = 1.2f;
  
  PVector position;
  
  Missle(int startX, int startY, int endX, int endY) {
    //line(this.x + 3, this.y, x, y);
    // point particle towards x and y end coordinates
    position = new PVector(startX,startY);
    PVector mousePosition = new PVector(endX,endY);
    direction = mousePosition.sub(position);
    if (direction.mag() != 0) {
      direction.normalize();
    }
    //PVector acceleration = new PVector((x - missleLaunchPosition.x)/1000f, (y - missleLaunchPosition.y)/1000f) ;
    //Particle missle = new Particle(this.x + 3, this.y, acceleration.x,acceleration.y, 0.005f);
    //missle.velocity.normalize();
  }
  
  void integrate() {
     direction.mult(speed);
     position.add(direction);
  }
  
  void explode() {
  }
}
