final class Explosion {
  final int MAX_RADIUS = 100 ;
  
  int currRadius;
  
  PVector position;
  
  Explosion(PVector position) {
    this.position = new PVector(position.x, position.y);
    currRadius = 1;
  }
  
  void propagate() {
    if (!hasExpired()) {
      fill(255);
      noStroke();
      circle(position.x, position.y, currRadius++);
      stroke(0);
    }
  }
  
  boolean hasExpired() {
    return currRadius >= MAX_RADIUS;
  }
}
