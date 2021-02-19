class Body {
  PVector d;
  PVector v;
  float m;
  color c1;
  boolean isStatic;
  Body(PVector d1, PVector v1, float m1, boolean y, color c) {
    this.c1 = c;
    this.d = d1;
    this.v = v1;
    this.m = m1;
    this.isStatic = y;}
  void iterate(Body body) {
    PVector lorentz = calcE(body);
    v = PVector.add(v,lorentz);}
  void move(float iterator) {
    d = PVector.add(d, PVector.mult(v,iterator));}
  void sketch() {
    strokeWeight(1);
    //noStroke();
    colorMode(RGB);
    fill(c1);
    ellipse(d.x,d.y,10,10);
    //point(d.x,d.y);
  }
  boolean returnStatic() {return this.isStatic;}
  float calcV(Body center) {
    return center.getM()/epsilon0/PVector.sub(center.getD(),this.getD()).mag();}
  PVector calcE(Body center) {
    PVector g = PVector.sub(center.getD(),this.getD());
    PVector r = PVector.mult(g.normalize(),center.getM()/epsilon0/PVector.sub(center.getD(),this.getD()).magSq());
    return r.limit(300);}
  PVector calcB(Body center) {
    //println(center.getV());
    if (center.getV().x==0.0) {
      return new PVector(0,0);}
    else {
      PVector g = PVector.sub(center.getD(),this.getD());
      PVector r = PVector.mult(PVector.mult(center.getV(),center.getM()).cross(g.normalize()),mu0/PVector.sub(center.getD(),this.getD()).magSq());
      return r;}
    }
  PVector getD() {return d;}
  PVector getV() {return v;}
  float getM() {return this.m;}
  void setD(PVector d1) {d = d1;}
  void setV(PVector v1) {v = v1;}
}
