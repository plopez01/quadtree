// This quadtree could be implemented using an array to help avoid cache misses caused by pointer dereferences
// Here I will implement this using objects to keep it simple, but this could prove inefficent: https://www.youtube.com/watch?v=zuWvrqcZwuU

class QNode {
    QNode q1 = null;
    QNode q2 = null;
    QNode q3 = null;
    QNode q4 = null;
    
    PVector start;
    PVector size;
    
    // We could instantiate this in a lazy manner
    ArrayList<City> cities = new ArrayList<City>();
    
    
    QNode(PVector start, PVector size) {
      this.start = start;
      this.size = size;
    }
    
    boolean doesCityBelong(City city) {
      return city.pos.x >= start.x && city.pos.x < start.x + size.x
            && city.pos.y >= start.y && city.pos.y < start.y + size.y;
    }
    
    boolean isLeaf() {
      return q1 == null
             && q2 == null
             && q3 == null
             && q4 == null;
    }
    
    void draw() {
      noFill();
      rect(start.x, start.y, size.x, size.y);
    }
}
