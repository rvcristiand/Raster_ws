import frames.timing.*;
import frames.primitives.*;
import frames.processing.*;

// 1. Frames' objects
Scene scene;
Frame frame;
Vector v1, v2, v3;
// timing
TimingTask spinningTask;
boolean yDirection;
// scaling is a power of 2
int n = 2;
// 2^nn divisiones del pixel
int nn = 1;

// 2. Hints
boolean triangleHint = true;
boolean gridHint = true;
boolean debug = true;

// 3. Use FX2D, JAVA2D, P2D or P3D
String renderer = P3D;

void setup() {
  //use 2^n to change the dimensions
  size(600, 400, renderer);
  scene = new Scene(this);
  if (scene.is3D())
    scene.setType(Scene.Type.ORTHOGRAPHIC);
  scene.setRadius(width/2);
  scene.fitBallInterpolation();

  // not really needed here but create a spinning task
  // just to illustrate some frames.timing features. For
  // example, to see how 3D spinning from the horizon
  // (no bias from above nor from below) induces movement
  // on the frame instance (the one used to represent
  // onscreen pixels): upwards or backwards (or to the left
  // vs to the right)?
  // Press ' ' to play it :)
  // Press 'y' to change the spinning axes defined in the
  // world system.
  spinningTask = new TimingTask() {
    public void execute() {
      spin();
    }
  };
  scene.registerTask(spinningTask);

  frame = new Frame();
  frame.setScaling(width/pow(2, n));

  // init the triangle that's gonna be rasterized
  randomizeTriangle();
}

void draw() {
  background(0);
  stroke(0, 255, 0);
  if (gridHint)
    scene.drawGrid(scene.radius(), (int)pow(2, n));
  if (triangleHint)
    drawTriangleHint();
  pushMatrix();
  pushStyle();
  scene.applyTransformation(frame);
  triangleRaster();
  popStyle();
  popMatrix();
}

// Implement this function to rasterize the triangle.
// Coordinates are given in the frame system which has a dimension of 2^n
void triangleRaster() {
  // frame.coordinatesOf converts from world to frame
  // here we convert v1 to illustrate the idea
  
  // count
  int count;
  
  // Vector de cada punto de la malla
  Vector p;
  // Vector de cada subpunto de la malla
  Vector pp;

  // Valores de la función de frontera del punto de la malla
  float e12;
  float e23;
  float e31;
  
  // Valores de la función de frontera del subpunto de la malla
  float ee12;
  float ee23;
  float ee31;
  
  //Colores
  float clrRed;
  float clrGreen;
  float clrBlue;

  for (float i = -pow(2, n-1); i <= pow(2, n-1); i++) {
    for (float j = -pow(2, n-1); j <= pow(2, n-1); j++) {
      count = 0;
      for (float ii = -pow(2, nn - 1); ii <= pow(2, nn - 1); ii++) {
        for (float jj = -pow(2, nn - 1); jj <= pow(2, nn - 1); jj++) {
          if (!(ii == 0.0) && !(jj == 0.0)) {
            
            pp = new Vector(i + ii/pow(2, nn), j + jj/pow(2, nn));
      
            ee12 = edgeFunction(frame.coordinatesOf(v1), frame.coordinatesOf(v2), pp);
            ee23 = edgeFunction(frame.coordinatesOf(v2), frame.coordinatesOf(v3), pp);
            ee31 = edgeFunction(frame.coordinatesOf(v3), frame.coordinatesOf(v1), pp);
            
            if ((!(ee12 < 0) == !(ee23 < 0)) && (!(ee23 < 0) == !(ee31 < 0))) {
              count += 1;
            }
          }
        }
      }
      
      float clrAlpha = count / pow(2, 2 * nn);
      if (clrAlpha != 0.0) {
          p = new Vector(i, j);
          
          e12 = edgeFunction(frame.coordinatesOf(v1), frame.coordinatesOf(v2), p);
          e23 = edgeFunction(frame.coordinatesOf(v2), frame.coordinatesOf(v3), p);
          e31 = edgeFunction(frame.coordinatesOf(v3), frame.coordinatesOf(v1), p);
          
          clrRed   = e12 / (e12 + e23 + e31);
          clrGreen = e23 / (e12 + e23 + e31);
          clrBlue  = e31 / (e12 + e23 + e31);
        
          pushStyle();
          stroke(255*clrRed, 255*clrGreen, 255*clrBlue, 255*clrAlpha);
          point(p.x(), p.y());
          popStyle();
      }
    }
  }
}

float edgeFunction (Vector v0, Vector v1, Vector p) {
  return (v0.y() - v1.y()) * p.x() + (v1.x() - v0.x()) * p.y() + (v0.x()*v1.y() - v0.y()*v1.x());
}

void randomizeTriangle() {
  int low = -width/2;
  int high = width/2;
  v1 = new Vector(random(low, high), random(low, high));
  v2 = new Vector(random(low, high), random(low, high));
  v3 = new Vector(random(low, high), random(low, high));
  //v1 = new Vector(low, low);
  //v2 = new Vector(low, high);
  //v3 = new Vector(high, low);
}

void drawTriangleHint() {
  pushStyle();
  noFill();
  strokeWeight(2);
  stroke(255, 0, 0);
  triangle(v1.x(), v1.y(), v2.x(), v2.y(), v3.x(), v3.y());
  strokeWeight(5);
  stroke(0, 255, 255);
  point(v1.x(), v1.y());
  point(v2.x(), v2.y());
  point(v3.x(), v3.y());
  popStyle();
}

void spin() {
  if (scene.is2D())
    scene.eye().rotate(new Quaternion(new Vector(0, 0, 1), PI / 100), scene.anchor());
  else
    scene.eye().rotate(new Quaternion(yDirection ? new Vector(0, 1, 0) : new Vector(1, 0, 0), PI / 100), scene.anchor());
}

void keyPressed() {
  if (key == 'g')
    gridHint = !gridHint;
  if (key == 't')
    triangleHint = !triangleHint;
  if (key == 'd')
    debug = !debug;
  if (key == '+') {
    n = n < 10 ? n+1 : 2;
    frame.setScaling(width/pow( 2, n));
  }
  if (key == '-') {
    n = n >2 ? n-1 : 10;
    frame.setScaling(width/pow( 2, n));
  }
  if (key == 'r')
    randomizeTriangle();
  if (key == ' ')
    if (spinningTask.isActive())
      spinningTask.stop();
    else
      spinningTask.run(20);
  if (key == 'y')
    yDirection = !yDirection;
  if (keyCode == UP) {
    nn = nn < 3 ? nn + 1 : 1;
  }
  if (keyCode == DOWN) {
    nn = nn > 1 ? nn - 1 : 3;
  }
}
