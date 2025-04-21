import java.util.*;

String[] cityNames;
ArrayList<City> cities = new ArrayList<>();

boolean usingQuadtree = true;

int N_CITIES = 300;

//int N_CITIES = 100000000;
// Takes about 250ms to do a query

int searchRadius = 100;

QNode quadtree;
int BUCKET_SIZE = 3;

int iters = 0;

void setup() {
  size(640, 480, P2D);
  background(255);
  //frameRate(10);
  quadtree = new QNode(new PVector(0, 0), new PVector(width, height));

  cityNames = loadStrings("list.txt");

  for (int i = 0; i < N_CITIES; i++) {
    City city = new City(cityNames[(int)random(cityNames.length-1)], random(width-1), random(height-1));
    cities.add(city);
    insertQuadtree(quadtree, city);
  }
}

void draw() {
  background(255);

  /*City city = new City(cityNames[(int)random(cityNames.length-1)], random(width-1), random(height-1));
   cities.add(city);
   insertQuadtree(quadtree, city);*/

  for (City c : cities) {
    c.render();
  }

  drawQuadtree(quadtree);

  iters = 0;
  queryCitiesInRadius(new PVector(mouseX, mouseY), searchRadius);
  println("Iters made to search: " + iters);
}

void queryCitiesInRadius(PVector pos, float radius) {
  fill(0, 255, 0, 50);
  circle(pos.x, pos.y, radius*2);

  if (usingQuadtree) treeImpl(quadtree, pos, radius);
  else linearImpl(pos, radius);
}

void linearImpl(PVector pos, float radius) {
  for (City c : cities) {
    if (PVector.dist(pos, c.pos) <= radius) {
      c.renderFound();
    }
    iters++;
  }
}

boolean intersectsCircle(PVector circlePos, float radius, PVector rectPos, PVector rectSize) {
  float distX = abs(circlePos.x - (rectPos.x + rectSize.x/2));
  float distY = abs(circlePos.y - (rectPos.y + rectSize.y/2));

  if (distX > rectSize.x/2 + radius) return false;
  if (distY > rectSize.y/2 + radius) return false;

  if (distX <= rectSize.x/2) return true;
  if (distY <= rectSize.y/2) return true;

  float cornerDistSq = pow(distX - rectSize.x/2, 2) + pow(distY - rectSize.y/2, 2);

  return cornerDistSq <= pow(radius, 2);
}

void treeImpl(QNode root, PVector pos, float radius) {
  // First we find the square that fits the given circle
  /*PVector start = new PVector(pos.x - radius, pos.y - radius);
   float size = 2 * radius;
   
   square(start.x, start.y, size);*/

  if (root.isLeaf()) {
    PVector start = root.start;
    PVector size = root.size;

    if (intersectsCircle(pos, radius, start, size))
    {
      // Leaf quad intersects with query circle
      // Paint it as green to show
      fill(0, 255, 0, 50);
      rect(start.x, start.y, size.x, size.y);
      
      for (City c : root.cities) {
        if (PVector.dist(pos, c.pos) <= radius) {
          c.renderFound();
        }
        iters++;
      }
    }
  } else {
    // If not leaf traverse tree until we reach the corresponding one
    treeImpl(root.q1, pos, radius);
    treeImpl(root.q2, pos, radius);
    treeImpl(root.q3, pos, radius);
    treeImpl(root.q4, pos, radius);
  }
}

void insertQuadtree(QNode root, City city) {
  if (root.isLeaf()) {
    if (root.cities.size() < BUCKET_SIZE) {
      root.cities.add(city);
    } else {
      PVector start = root.start;
      PVector size = root.size;
      PVector newSize = PVector.div(size, 2);

      // Create new leaf nodes
      root.q1 = new QNode(start, newSize);
      root.q2 = new QNode(new PVector(start.x + newSize.x, start.y), newSize);
      root.q3 = new QNode(new PVector(start.x, start.y + newSize.y), newSize);
      root.q4 = new QNode(new PVector(start.x + newSize.x, start.y + newSize.y), newSize);

      // Decompose leaf into new leaves
      for (City c : root.cities) {
        insertQuadtree(root, c);
      }

      // Retry addingthe original city (now the bucket shouldn't be full)
      insertQuadtree(root, city);
    }
  } else {
    // If not leaf traverse tree until we reach the corresponding one
    if (root.q1.doesCityBelong(city)) insertQuadtree(root.q1, city);
    else if (root.q2.doesCityBelong(city)) insertQuadtree(root.q2, city);
    else if (root.q3.doesCityBelong(city)) insertQuadtree(root.q3, city);
    else if (root.q4.doesCityBelong(city)) insertQuadtree(root.q4, city);
  }
}

void drawQuadtree(QNode root) {

  if (!root.isLeaf()) {
    // If not leaf traverse tree until we reach the corresponding one
    drawQuadtree(root.q1);
    drawQuadtree(root.q2);
    drawQuadtree(root.q3);
    drawQuadtree(root.q4);
  } else root.draw();
}
