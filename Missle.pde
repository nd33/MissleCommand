final class Missle {
  
  PVector direction;
  
  float speed = 1.2f;
  
  PVector position;
  
  Missle(int startX, int startY, int endX, int endY) {
    // point missle towards x and y end coordinates
    position = new PVector(startX,startY);
    PVector mousePosition = new PVector(endX,endY);
    direction = mousePosition.sub(position);
    if (direction.mag() != 0) {
      direction.normalize();
    }
  }
  
  void integrate() {
     direction.mult(speed);
     position.add(direction);
  }
  
  void explode() {
  }
}
