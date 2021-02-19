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
    PVector lorentz = PVector.add(calcE(body),v.cross(calcB(body)));
    v = PVector.add(v,lorentz);}
  void move(float iterator) {
    d = PVector.add(d, PVector.mult(v,iterator));}
  void sketch() {
    colorMode(RGB);
    stroke(c1);
    pushMatrix();
    translate(d.x,d.y,d.z);
    sphere(10);
    popMatrix();}
  boolean returnStatic() {return this.isStatic;}
  PVector calcE(Body center) {
    PVector g = PVector.sub(center.getD(),this.getD());
    PVector r = PVector.mult(g.normalize(),1/epsilon0*center.getM()/4/PI/PVector.sub(center.getD(),this.getD()).magSq());
    //return r.limit(190);}
    return r;}
  PVector calcB(Body center) {
    if (center.getV().mag()==0.0) {
      return new PVector(0,0);}
    else {
      PVector g = PVector.sub(center.getD(),this.getD());
      PVector r = PVector.mult(center.getV().cross(g.normalize()),center.getM()*it*mu0/PVector.sub(center.getD(),this.getD()).magSq());
      return r;}
    }
  PVector getD() {return d;}
  PVector getV() {return v;}
  float getM() {return this.m;}
  void setD(PVector d1) {d = d1;}
  void setV(PVector v1) {v = v1;}
  void setColor(color c) {c1 = c;}
}
