class City {
  PVector pos;
  String name;
  
  City(String name, float x, float y) {
    pos = new PVector(x, y);
    this.name = name;
  }
  
  void render() {
    fill(255, 0, 0);
    circle(pos.x, pos.y, 10);
    
    fill(0);
    text(name, pos.x, pos.y);
  }
  
  void renderFound() {
    fill(0, 255, 0);
    circle(pos.x, pos.y, 10);
    
    fill(0);
    text(name, pos.x, pos.y);
  }
}
