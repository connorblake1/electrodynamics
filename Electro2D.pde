ArrayList<Body> bodies;
float t = 0;
int maxQ = 900;
int chargeNum =100;
boolean e, b, v1, v2, v3;
PVector testV;
final static float mu0 = 40;
final static float epsilon0 = .025;//gravitational constant epsilon0 (changing the fundamental constants of the universe, while fun, will make trying to find interesting orbital systems annoying)
final static float it = .01; //time step, maybe dont mess with this either
void setup() {
  e = false;
  b = false;
  v1 = false;
  v2 = false;
  v3 = false;
  bodies = new ArrayList<Body>(); //extremely disgusting ArrayList of ArrayLists
  size(800, 800);
  //random charges
  //for (int i = 0; i < chargeNum; i++) {
  //  float q = random(-50, 50);
  //  bodies.add(new Body(new PVector(random(-width/2, width/2), random(-height/2, height/2)), new PVector(0, 0), 10*q, true, color((q+20)*12, (q+20)*12, (q+20)*12)));
  //}
  //inner charge
  //float q = 25;
  //bodies.add(new Body(new PVector(0, 0), new PVector(0, 0), 10*q, true, color((q+20)*12, (q+20)*12, (q+20)*12)));
  //float r = 200;
  //for (int i = 0; i < chargeNum-1; i++) {
  //  bodies.add(new Body(new PVector(r*sin(i*TWO_PI/(chargeNum-1)), r*cos(i*TWO_PI/(chargeNum-1))), new PVector(0, 0), -10*q/(chargeNum-1), true, color((q+20)*12, (q+20)*12, (q+20)*12)));}
  //////two charges
  //float q = 25;
  //bodies.add(new Body(new PVector(-75, 0), new PVector(0, 0), 10*q, true, color((q+20)*12, (q+20)*12, (q+20)*12)));
  //q = -25;
  //bodies.add(new Body(new PVector(75, 0), new PVector(0, 0), 10*q, true, color((q+20)*12, (q+20)*12, (q+20)*12)));
  //bodies.add(new Body(new PVector(150, 0), new PVector(0, 0), 10*q, true, color((q+20)*12, (q+20)*12, (q+20)*12)));
  //many charges
  //float q = 50;
  //bodies.add(new Body(new PVector(75, -75), new PVector(0, 0), 10*q, true, color((q+20)*12, (q+20)*12, (q+20)*12)));
  //bodies.add(new Body(new PVector(-75, 75), new PVector(0, 0), 10*q, true, color((q+20)*12, (q+20)*12, (q+20)*12)));
  //q = -25;
  //bodies.add(new Body(new PVector(75, 75), new PVector(0, 0), 10*q, true, color((q+20)*12, (q+20)*12, (q+20)*12)));
  //bodies.add(new Body(new PVector(-75, -75), new PVector(0, 0), 10*q, true, color((q+20)*12, (q+20)*12, (q+20)*12)));
  ////two lines
  for (int i = 0; i < chargeNum/2; i++) {
    float q = 1000/chargeNum;
   bodies.add(new Body(new PVector(-150,-height+i*4*height/chargeNum), new PVector(0, 0), 10*q, true, color((q+20)*12, (q+20)*12, (q+20)*12)));
 }
  for (int i = 0; i < chargeNum/2; i++) {
    float q = -1000/chargeNum;
   bodies.add(new Body(new PVector(150,-height+i*4*height/chargeNum), new PVector(0, 0), 10*q, true, color((q+20)*12, (q+20)*12, (q+20)*12)));
}
  //wall of charges
  //for (int i = 0; i < chargeNum; i++) {
  //  bodies.add(new Body(new PVector(-chargeNum+2*i,200),new PVector(0,0),100,true,color(255,0,0)));}
  testV = PVector.mult(PVector.random2D(), 40);
  bodies.add(new Body(new PVector(0, 0), testV, 10, false, color(0, 0, 0)));
}
void draw() {
  background(0);
  translate(width/2, height/2);
  //single body motion, full calc
  for (int i = chargeNum; i < bodies.size(); i++) { //only moving charges
    for (int j = 0; j < bodies.size(); j++) { //all charges
      if (i != j) {
        bodies.get(i).iterate(bodies.get(j));
      }
    }
    bodies.get(i).move(it);
  }
  //for (int j = 0; j < chargeNum; j++) {
  //  bodies.get(bodies.size()-1).iterate(bodies.get(j));}
  //   bodies.get(bodies.size()-1).move(it);
  //all body motion
  //for (int i = 0; i < bodies.size(); i++) {
  //  for (int j = 0; j < bodies.size(); j++) {
  //    if (i != j && !bodies.get(i).returnStatic()) {
  //      bodies.get(i).iterate(bodies.get(j));
  //      }}
  //  bodies.get(i).move(it);
  //  }
  for (int i = 0; i < bodies.size(); i++) {
    bodies.get(i).sketch();
  }
  if (e) {
    drawEField();
  }
  if (b) {
    drawBField();
  }
  if (v1) {
    drawVField();
  }
  if (v2) {
    drawVLines();
  }
  if (v3) {
    drawImageCompress();}
  t+= it;
  if (bodies.get(bodies.size()-1).getD().x < -width/2 || bodies.get(bodies.size()-1).getD().x > width/2 ||bodies.get(bodies.size()-1).getD().y > height/2 || bodies.get(bodies.size()-1).getD().y < -height/2) {
    bodies.get(bodies.size()-1).setD(new PVector(0, 0));
    bodies.get(bodies.size()-1).setV(testV);
  }
}
void drawEField() {
  int fieldDensity = 30;
  float [][] eqL = new float[width/fieldDensity][height/fieldDensity];
  Body s = new Body(new PVector(0, 0), new PVector(0, 0), 1, false, color(255, 255, 255));
  for (int x = -width/2; x < width/2; x+= fieldDensity) {
    for (int y = -height/2; y < height/2; y+= fieldDensity) {
      s.setD(new PVector(x, y));
      PVector h = new PVector(0, 0);
      for (int i = 0; i < bodies.size()-1; i++) {
        h = PVector.add(h, s.calcE(bodies.get(i)));
      }
      colorMode(HSB);
      //eqL[(x+width/2)/fieldDensity][(y+height/2)/fieldDensity] = h.mag();
      drawMiniArrow(x, y, h, fieldDensity, true);
    }
  }
  //drawV(eqL,fieldDensity);
}
void drawVField() {
  colorMode(HSB);
  strokeWeight(5);
  int fieldDensity = 10;
  Body s = new Body(new PVector(0, 0), new PVector(0, 0), 1, false, color(255, 255, 255));
  for (int x = -width/2; x < width/2; x+= fieldDensity) {
    for (int y = -height/2; y < height/2; y+= fieldDensity) {
      s.setD(new PVector(x, y));
      float h =0;
      for (int i = 0; i < bodies.size()-1; i++) {
        h+=s.calcV(bodies.get(i));
      }
      stroke(customMap1(h), 255, 255);
      point(x, y);
    }
  }
}

void drawVLines() {
  int scanDensity = 10;
  for (int v = -maxQ; v< maxQ; v+=50) {
    ArrayList<PVector> EL = new ArrayList<PVector>();
    //get v points and put loop for equipotential lines
    Body s1 = new Body(new PVector(0, 0), new PVector(0, 0), 1, false, color(255, 255, 255));
    for (int x = -width/2; x < width/2; x+= scanDensity) {
      for (int y = -height/2; y < height/2; y+= scanDensity) {
        s1.setD(new PVector(x, y));
        float h =0;
        for (int i = 0; i < bodies.size()-1; i++) {
          h+=s1.calcV(bodies.get(i));
        }
        if (10*int(h/10) == v) {
          EL.add(new PVector(x, y));
        }
      }
    }
    println(EL.size());
    //drawNetwork(EL,100);
    int i = 0;
    float t = .25;
    float t2 = 10;
    final float b = .5;
    Body s2 = new Body(new PVector(0, 0), new PVector(0, 0), 1, false, color(255, 255, 255));
    while (i < EL.size()) { //goes through all marked points
      ArrayList<PVector> dots = new ArrayList<PVector>();
      PVector p1 = EL.get(i);
      PVector p2 = EL.get(i);
      boolean o = true;
      int breaker = 0;
      while ((!((p1.x < t + EL.get(i).x && p1.x > EL.get(i).x-t && p1.y < t + EL.get(i).y && p1.y > EL.get(i).y-t)||(p2.x < t + EL.get(i).x && p2.x > EL.get(i).x-t && p2.y < t + EL.get(i).y && p2.y > EL.get(i).y-t)) || o ) && breaker < 200) {
        if (o) {
          o = false;
        }


        for (int j = i; j < EL.size(); j++) {
          if (i!=j) {
            if (p1.x < t2 + EL.get(j).x && p1.x > EL.get(j).x-t2 && p1.y < t2 + EL.get(j).y && p1.y > EL.get(j).y-t2 && p2.x < t2 + EL.get(j).x && p2.x > EL.get(j).x-t2 && p2.y < t2 + EL.get(j).y && p2.y > EL.get(j).y-t2) {
              EL.remove(j);
              j--;
            }
          }
        } 

        s1.setD(p1);
        s2.setD(p2);
        PVector r1 = PVector.mult(PVector.fromAngle(PI/2+fullE(bodies, s1)), b);
        PVector r2 = PVector.mult(PVector.fromAngle(-PI/2+fullE(bodies, s2)), b);//mult(PVector.add(PVector.fromAngle(PI/2),fullE(bodies,s).normalize()),b);
        //println(r);
        p1 = PVector.add(p1, r1);
        p2 = PVector.add(p2, r2);
        dots.add(p1);
        dots.add(0, p2);
        //println(dots);
        breaker++;
      }
      drawNetwork(dots, v);
      i++;
    }
    //PVector
  }
}
void drawImageCompress() {
  int scanDensity = 5;
  for (int x = -width/2; x < width/2; x+= scanDensity) {
      for (int y = -height/2; y < height/2; y+= scanDensity) {
        
      }
    }
  }

void drawBField() {
  int fieldDensity = 30;
  Body s = new Body(new PVector(0, 0), new PVector(0, 0), 1, false, color(255, 255, 255));
  for (int x = -width/2; x < width/2; x+= fieldDensity) {
    for (int y = -height/2; y < height/2; y+= fieldDensity) {
      s.setD(new PVector(x, y));
      PVector h = new PVector(0, 0);
      for (int i = 0; i < bodies.size(); i++) {
        h = PVector.add(h, s.calcB(bodies.get(i)));
      }
      colorMode(HSB);
      if (h.mag() > 5) {
        strokeWeight(6);
        stroke(map(h.mag(), 5, 15, 0, 125), 255, 255);
        point(x, y);
        strokeWeight(1);
      }
      stroke(255);
      //drawMiniArrow(x,y,h,fieldDensity,false);
    }
  }
}
void drawMiniArrow(float x, float y, PVector h, int fD, boolean e) {
  strokeWeight(1);
  if (e) {
    stroke(map(h.mag(), 0, 10, 125, 255), 255, 255);
    pushMatrix();
    translate(x, y);
    rotate(-PI/2+h.heading());
    triangle(0, fD*.7, fD*.1, fD*.5, -fD*.1, fD*.5);
    line(0, 0, 0, fD*.7);
    popMatrix();
  } else {
    stroke(map(h.mag(), -15, 15, 0, 125), 255, 255);
    pushMatrix();
    translate(x, y);
    PVector p = new PVector(h.x, h.y);
    println(p);
    rotate(-PI/2+p.heading());
    triangle(0, fD*.7, fD*.1, fD*.5, -fD*.1, fD*.5);
    line(0, 0, 0, fD*.7);
    popMatrix();
  }
  stroke(255);
}

void keyPressed() {
  if (key == '1') {
    if (!e) {
      e = true;
    } else {
      e = false;
    }
  } else if (key == '2') {
    if (!b) {
      b = true;
    } else {
      b = false;
    }
  } else if (key == '3') {
    if (!v1) {
      v1 = true;
    } else {
      v1 = false;
    }
  } else if (key == '4') {
    if (!v2) {
      v2 = true;
    } else {
      v2 = false;
    }
  } else if (key == '5') {
    if (!v3) {
      v3 = true;
    } else {
      v3 = false;
    }
  } else if (key == '6') {
    testV = PVector.mult(PVector.random2D(), 40);
  }
}

void drawV(float [][] l, int f) {
  int a = l.length;
  int b = l[0].length;
  colorMode(HSB);
  //for (int x = -width/2; x < width/2; x++) {
  //  for (int y = -height/2; y <height/2; y++) {
  //    point();}}
  for (int x =0; x<a; x++) {
    for (int y = 0; y < b; y++) {
      for (int i =-1; i <= 1; i++) {
        for (int j = -1; j <= 1; j++) {
          if (i+x > 0 && i+x < a && j+y > 0 && j+y < b) {
            if (sq(l[x][y]-l[x+i][y+j]) < .01) {
              stroke(map(l[x][y], 0, 20, 0, 255), 255, 255);
              line(-width/2+f*x, -height/2+f*y, -width/2+f*(x+i), -height/2+f*(y+j));
            }
          }
        }
      }
    }
  }
}
int customMap1(float in) {
  return int(map(in, -maxQ, maxQ, 0, 255));
}

float fullE(ArrayList<Body> l, Body b) {
  PVector r = new PVector(0, 0);
  for (int i = 0; i < l.size()-1; i++) {
    r = PVector.add(r, b.calcE(l.get(i)));
  }
  return r.heading();
}
void drawNetwork(ArrayList<PVector> l, int m) {
  strokeWeight(1);
  colorMode(HSB);
  stroke(customMap1(m), 255, 255);
  //for (int i = 0; i < l.size()-1; i++) {
  //  line(l.get(i).x, l.get(i).y, l.get(i+1).x, l.get(i+1).y);
  //}
  for (int i = 0; i < l.size(); i++) {
    point(l.get(i).x, l.get(i).y);
  }
}
