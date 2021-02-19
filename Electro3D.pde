ArrayList<Body> bodies;
float t = 0;
import peasy.*; //from a libary called PeasyCam so that we can move the camera
PeasyCam p;
PVector testV;
PVector testD;
boolean e, b, fE, fB, showFlux, showFlux1;
int chargeNum = 30;
final static float mu0 = 400;
final static float epsilon0 = .0005;
final static float it = .01; //time step, maybe dont mess with this either
void setup() {
  e = false;
  b = false;
  fE = false;
  fB = false;
  showFlux = false;
  bodies = new ArrayList<Body>();
  size(800, 800, P3D);
  p = new PeasyCam(this,400,400,400,400);
  //current
  //for (int i = 0; i < chargeNum; i++) {
  //  bodies.add(new Body(new PVector(0,0,-5+i*10), new PVector(0,0,4),50,true,color(255,0,255)));}
  //random charges
  stdCharges(1);
  //wall of charges
  //for (int i = 0; i < 400; i++) {
  //  bodies.add(new Body(new PVector(-400+2*i,200),new PVector(0,0),1*fD,true,color(255,0,0)));}
  //moving particels 0,0,400
  //200,200,600
  testV = PVector.mult(PVector.random3D(),15);
  testD = new PVector(100,100,500);
  bodies.add(new Body(new PVector(500,500,500), testV, 10, false,color(0,0,255)));
  //bodies.add(new Body(new PVector(-100,-100,300), testV[1], 10, false,color(0,0,255)));
  //bodies.add(new Body(new PVector(100,-10,0), PVector.mult(PVector.random3D(),30), 10, false,color(0,0,255)));
}
void draw() {
  background(0);
  translate(width/2, height/2);
   //single body motion, full calc
   for (int i = chargeNum; i < bodies.size(); i++) { //only influencible charges
     for (int j = 0; j < bodies.size(); j++) { //all charges
       if (i != j) {
         bodies.get(i).iterate(bodies.get(j));}}
     bodies.get(i).move(it);}
   //current and true all body motion
   //for (int i = 0; i < bodies.size(); i++) {
   //  for (int j = 0; j < bodies.size(); j++) {
   //     if (i != j && !bodies.get(i).returnStatic()) {
   //       bodies.get(i).iterate(bodies.get(j));}}
   //   bodies.get(i).move(it);}
   //all body motion with absolute fixed
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
   if (e) {drawEField();}
   if (b) {drawBField();}
   if (fB) {calcFluxB(0,0,400,1);}
   if (fE) {calcFluxE(0,0,400,200);}
   t+= it;
   //reset moving charges in current and in general
   if (bodies.get(0).returnStatic() && bodies.get(0).getV().mag() != 0.0) {
     for (int i = 0; i < chargeNum; i++) {
       if (bodies.get(i).getD().z > height) {
         bodies.get(i).setD(new PVector(0,0,-5));}}}
   for (int i = chargeNum; i < bodies.size(); i++) {
     if (bodies.get(i).getD().x < -width/2 || bodies.get(i).getD().x > width/2 ||bodies.get(i).getD().y > height/2 || bodies.get(i).getD().y < -height/2 || bodies.get(i).getD().z > height || bodies.get(i).getD().z < 0) {
     bodies.get(i).setD(testD);
     bodies.get(i).setV(testV);}}
 }
void drawEField() {
  int fieldDensity = 60;
  Body s = new Body(new PVector(0,0),new PVector(0,0),1,false,color(255,255,255));
  for (int x = -width/2; x < width/2; x+= fieldDensity) {
    for (int y = -height/2; y < height/2; y+= fieldDensity) {
      for (int z = 0; z < height; z+=fieldDensity) {
      s.setD(new PVector(x,y,z));
      PVector h = new PVector(0,0);
      for (int i = 0; i < bodies.size()-1; i++) {
        h = PVector.add(h, s.calcE(bodies.get(i)));
      }
      colorMode(HSB);
      drawMiniArrow(x,y,z,h,fieldDensity,true);
      }}}
  }
void drawBField(){
  int fieldDensity = 40;
  Body s = new Body(new PVector(0,0), new PVector(0,0),1,false,color(255,255,255));
  for (int x = -width/2; x < width/2; x+= fieldDensity) {
    for (int y = -height/2; y < height/2; y+= fieldDensity) {
      for (int z = 0; z < height; z+= fieldDensity) {
      s.setD(new PVector(x,y,z));
      PVector h = new PVector(0,0);
      for (int i = 0; i < bodies.size(); i++) {
        h = PVector.add(h, s.calcB(bodies.get(i)));
      }
      colorMode(HSB);
      drawMiniArrow(x,y,z,h,fieldDensity,false);
      }}}
  }
void drawMiniArrow(float x, float y, float z,PVector h, int fD, boolean e) {
  if (e) {
    if (h.mag()>.3) {
      stroke(map(h.mag(),0,14,125,255),255,255);
    pushMatrix();
      translate(x,y,z);
      float phi = atan2(h.z,sqrt(sq(h.x)+sq(h.y)));
      float theta =atan2(h.y,h.x);
      rotateZ(PI/2+theta);
      rotateX(PI-phi);
      //rotateY(-phi*cos(theta));
      line(0,fD*.7,0,0);
      noFill();
      triangle(0,fD*.7,fD*.05,fD*.5,-fD*.05,fD*.5);
    popMatrix();}}
  else {
    if (h.mag()>.3) {
      stroke(map(h.mag(),.3,15,0,125),255,255);
    pushMatrix();
      translate(x,y,z);
      float phi = atan2(h.z,sqrt(sq(h.x)+sq(h.y)));
      float theta =atan2(h.y,h.x);
      rotateZ(PI/2+theta);
      rotateX(PI-phi);
      //rotateY(-phi*cos(theta));
      line(0,fD*.7,0,0);
      noFill();
      triangle(0,fD*.7,fD*.05,fD*.5,-fD*.05,fD*.5);
    popMatrix();}}}
    
void drawP(int x,int y,int z) {
  colorMode(HSB);
  stroke(map(z,-50,50,125,255),255,255);
  beginShape();
    vertex(0,0,0);
    vertex(x,0,0);
    vertex(x,y,0);
    vertex(0,y,0);
    vertex(0,0,0);
    
    vertex(0,0,0);
    vertex(0,y,0);
    vertex(0,y,z);
    vertex(0,0,z);
    vertex(0,0,0);
    
    vertex(0,0,0);
    vertex(x,0,0);
    vertex(x,0,z);
    vertex(0,0,z);
    vertex(0,0,0);
    
    vertex(x,0,0);
    vertex(x,y,0);
    
    vertex(x,y,z);
    vertex(x,0,z);
    vertex(x,y,z);
    vertex(0,y,z);
    vertex(x,y,z);
    
    vertex(x,y,z);
    vertex(x,y,0);
    vertex(x,y,z);
    vertex(x,0,z);
    vertex(x,y,z);
    
    vertex(x,y,z);
    vertex(x,y,0);
    vertex(x,y,z);
    vertex(0,y,z);
    vertex(x,y,z);
  endShape();}    
    
void calcFluxE(float x1, float y1, float z1, int w) {

  strokeWeight(1);
  stroke(255);
  noFill();
  pushMatrix();
  translate(x1+w/2,y1+w/2,z1+w/2);
  box(w,w,w);
  popMatrix();
  //if (random(1) < .01) {
  float step = 10; //total area is 6*w^2
  float f = 0;
  int fluxD = 10;
  int fluxV = 1;
  Body s = new Body(new PVector(0,0,0), new PVector(0,0,0), 1, false,color(255,255,255));
  PVector [] NV = new PVector[] {new PVector(1,0,0),new PVector(-1,0,0),new PVector(0,1,0),new PVector(0,-1,0),new PVector(0,0,1),new PVector(0,0,-1)};
  //right left
  int PVI = 0;
  for (float y = y1; y < y1+w; y+=step) {
    for (float z = z1; z < z1+w; z+=step) {
      s.setD(new PVector(x1+w,y,z));
      PVector h = new PVector(0,0,0);
      for (int i = 0; i < bodies.size();i++) {
        h = PVector.add(h,s.calcE(bodies.get(i)));}
      if (showFlux) {
        drawMiniArrow(s.getD().x,s.getD().y,s.getD().z,NV[PVI],fluxD,false);
        specificE(s.getD(),fluxD);
      }        if (showFlux1){
        pushMatrix();
          translate(s.getD().x+fluxD,s.getD().y,s.getD().z+fluxD);
          //rotateX(PI/2*(NV[PVI].x-1));
          rotateY(PI/2);
          //rotateZ(PI/2*NV[PVI].z);
 
          drawP(fluxD,fluxD,int(fluxV*PVector.dot(NV[PVI],h)));
        popMatrix();}
      f += PVector.dot(NV[PVI],h)*sq(step);}}
  PVI++;
  for (float y = y1; y < y1+w; y+=step) {
    for (float z = z1; z < z1+w; z+=step) {
      s.setD(new PVector(x1,y,z));
      PVector h = new PVector(0,0,0);
      for (int i = 0; i < bodies.size();i++) {
        h = PVector.add(h,s.calcE(bodies.get(i)));}
      //println(h);
      if (showFlux) {
        drawMiniArrow(s.getD().x,s.getD().y,s.getD().z,NV[PVI],fluxD,false);
        specificE(s.getD(),fluxD);}        if (showFlux1){
        pushMatrix();
          translate(s.getD().x-fluxD,s.getD().y,s.getD().z);
          //rotateX(PI/2*(NV[PVI].x-1));
          rotateY(-PI/2);
          //rotateZ(PI/2*NV[PVI].z);
 
          drawP(fluxD,fluxD,int(fluxV*PVector.dot(NV[PVI],h)));
        popMatrix();}
      f += PVector.dot(NV[PVI],h)*sq(step);}}
  PVI++;
  //front back
  for (float x = x1; x < x1+w; x+=step) {
    for (float z = z1; z < z1+w; z+=step) {
      s.setD(new PVector(x,y1+w,z));
      PVector h = new PVector(0,0,0);
      for (int i = 0; i < bodies.size();i++) {
        h = PVector.add(h,s.calcE(bodies.get(i)));}
      if (showFlux) {
        drawMiniArrow(s.getD().x,s.getD().y,s.getD().z,NV[PVI],fluxD,false);
        specificE(s.getD(),fluxD);}        if (showFlux1){
        pushMatrix();
          translate(s.getD().x,s.getD().y+fluxD,s.getD().z+fluxD);
          rotateX(-PI/2);
          //rotateY(PI/2);
          //rotateZ(PI/2);
 
          drawP(fluxD,fluxD,int(fluxV*PVector.dot(NV[PVI],h)));
        popMatrix();}
      f += PVector.dot(NV[PVI],h)*sq(step);}}
  PVI++;
  for (float x = x1; x < x1+w; x+=step) {
    for (float z = z1; z < z1+w; z+=step) {
      s.setD(new PVector(x,y1,z));
      PVector h = new PVector(0,0,0);
      for (int i = 0; i < bodies.size();i++) {
        h = PVector.add(h,s.calcE(bodies.get(i)));}
      if (showFlux) {
        drawMiniArrow(s.getD().x,s.getD().y,s.getD().z,NV[PVI],fluxD,false);
        specificE(s.getD(),fluxD);}        if (showFlux1){
        pushMatrix();
          translate(s.getD().x,s.getD().y-fluxD,s.getD().z);
          rotateX(PI/2);
          //rotateY(PI/2);
          //rotateZ(PI/2);
 
          drawP(fluxD,fluxD,int(fluxV*PVector.dot(NV[PVI],h)));
        popMatrix();}
      f += PVector.dot(NV[PVI],h)*sq(step);}}
  PVI++;
  //top bottom
  for (float x = x1; x < x1+w; x+=step) {
    for (float y = y1; y < y1+w; y+=step) {
      s.setD(new PVector(x,y,z1+w));
      PVector h = new PVector(0,0,0);
      for (int i = 0; i < bodies.size();i++) {
        h = PVector.add(h,s.calcE(bodies.get(i)));}
      if (showFlux) {
        drawMiniArrow(s.getD().x,s.getD().y,s.getD().z,NV[PVI],fluxD,false);
        specificE(s.getD(),fluxD);}        if (showFlux1){
        pushMatrix();
          translate(s.getD().x,s.getD().y,s.getD().z+fluxD);
          //rotateX(PI/2);
          //rotateY(PI/2);
          //rotateZ(PI/2);
 
          drawP(fluxD,fluxD,int(fluxV*PVector.dot(NV[PVI],h)));
        popMatrix();}
      f += PVector.dot(NV[PVI],h)*sq(step);}} 
  PVI++;
  for (float x = x1; x < x1+w; x+=step) {
    for (float y = y1; y < y1+w; y+=step) {
      s.setD(new PVector(x,y,z1));
      PVector h = new PVector(0,0,0);
      for (int i = 0; i < bodies.size();i++) {
        h = PVector.add(h,s.calcE(bodies.get(i)));}
      if (showFlux) {
        drawMiniArrow(s.getD().x,s.getD().y,s.getD().z,NV[PVI],fluxD,false);
        specificE(s.getD(),fluxD);}        if (showFlux1){
        pushMatrix();
          translate(s.getD().x+fluxD,s.getD().y,s.getD().z-fluxD);
          //rotateX(PI/2);
          rotateY(PI);
          //rotateZ(PI/2);
 
       drawP(fluxD,fluxD,int(fluxV*PVector.dot(NV[PVI],h)));
        popMatrix();}
      f += PVector.dot(NV[PVI],h)*sq(step);}} 

    println("The total flux is " + f + "   This implies the total charge enclosed is " + (float)(-1*f*epsilon0));
  //}
  }
  void specificE(PVector d, int fD) {
    Body s = new Body(new PVector(0,0),new PVector(0,0),1,false,color(255,255,255));
    s.setD(d);
    PVector h = new PVector(0,0);
    for (int i = 0; i < bodies.size()-1; i++) {
      h = PVector.add(h, s.calcE(bodies.get(i)));}
    colorMode(HSB);
    drawMiniArrow(d.x,d.y,d.z,h,fD,true);}

void calcFluxB(float x1, float y1, float z1, int w) {
  strokeWeight(2);
  stroke(255);
  noFill();
  pushMatrix();
  translate(x1+w/2,y1+w/2,z1+w/2);
  box(w,w,w);
  popMatrix();
  float step = .1; //total area is 6*w^2
  float f = 0;
  Body s = new Body(new PVector(0,0,0), new PVector(0,0,0), 1, false,color(255,255,255));
  PVector [] NV = new PVector[] {new PVector(1,0,0),new PVector(-1,0,0),new PVector(0,1,0),new PVector(0,-1,0),new PVector(0,0,1),new PVector(0,0,-1)};
  //right left
  int PVI = 0;
  for (float y = y1; y < y1+w; y+=step) {
    for (float z = z1; z < z1+w; z+=step) {
      s.setD(new PVector(x1+w,y,z));
      PVector h = new PVector(0,0,0);
      for (int i = 0; i < bodies.size();i++) {
        h = PVector.add(h,s.calcB(bodies.get(i)));}
      f += PVector.dot(NV[PVI],h)*sq(step);}} 
  PVI++;
  for (float y = y1; y < y1+w; y+=step) {
    for (float z = z1; z < z1+w; z+=step) {
      s.setD(new PVector(x1,y,z));
      PVector h = new PVector(0,0,0);
      for (int i = 0; i < bodies.size();i++) {
        h = PVector.add(h,s.calcB(bodies.get(i)));}
      //println(h);
      f += PVector.dot(NV[PVI],h)*sq(step);}}
  PVI++;
  //front back
  for (float x = x1; x < x1+w; x+=step) {
    for (float z = z1; z < z1+w; z+=step) {
      s.setD(new PVector(x,y1+w,z));
      PVector h = new PVector(0,0,0);
      for (int i = 0; i < bodies.size();i++) {
        h = PVector.add(h,s.calcB(bodies.get(i)));}
      f += PVector.dot(NV[PVI],h)*sq(step);}} 
  PVI++;
  for (float x = x1; x < x1+w; x+=step) {
    for (float z = z1; z < z1+w; z+=step) {
      s.setD(new PVector(x,y1,z));
      PVector h = new PVector(0,0,0);
      for (int i = 0; i < bodies.size();i++) {
        h = PVector.add(h,s.calcB(bodies.get(i)));}
      f += PVector.dot(NV[PVI],h)*sq(step);}}
  PVI++;
  //top bottom
  for (float x = x1; x < x1+w; x+=step) {
    for (float y = y1; y < y1+w; y+=step) {
      s.setD(new PVector(x,y,z1+w));
      PVector h = new PVector(0,0,0);
      for (int i = 0; i < bodies.size();i++) {
        h = PVector.add(h,s.calcB(bodies.get(i)));}
      f += PVector.dot(NV[PVI],h)*sq(step);}}
  PVI++;
  for (float x = x1; x < x1+w; x+=step) {
    for (float y = y1; y < y1+w; y+=step) {
      s.setD(new PVector(x,y,z1));
      PVector h = new PVector(0,0,0);
      for (int i = 0; i < bodies.size();i++) {
        h = PVector.add(h,s.calcB(bodies.get(i)));}
      f += PVector.dot(NV[PVI],h)*sq(step);}} 
  if (random(1) < .01) {
    println("The total flux is " + f);
  }
  }
  
  void stdCharges(int in) {
  bodies.clear();
  if (in ==1) {
    for (int i = 0; i < chargeNum; i++) {
      float q = random(-50,50);
      bodies.add(new Body(new PVector(random(-height/2+110,height/2-110),random(-height/2+110,height/2-110),random(110,height-110)),new PVector(0,0,0),10*q,true,color((q+20)*12,(q+20)*12,(q+20)*12)));}
    for (int i = 0; i < chargeNum; i++) { if (bodies.get(i).getD().x > 0 && bodies.get(i).getD().x < 200 && bodies.get(i).getD().y < 200 && bodies.get(i).getD().y > 0 && bodies.get(i).getD().z < 600 && bodies.get(i).getD().z > 400){
      println("Location: " + bodies.get(i).getD() + "  Charge: " + bodies.get(i).getM());
      bodies.get(i).setColor(color(0,255,0));}
    }}
  else if (in == 2) {
    float q = random(-50,50);
    bodies.add(new Body(new PVector(random(-height/2+110,height/2-110),random(-height/2+110,height/2-110),random(110,height-110)),new PVector(0,0,0),10*q,true,color((q+20)*12,(q+20)*12,(q+20)*12)));}
  else if (in == 3) {
    int d = 40;
    chargeNum = int(sq(width/d)*2);
    for (int x = -width/2; x < width/2; x+=d) {
      for (int y = -height/2; y <height/2; y+=d) {
        float q = 10;
        bodies.add(new Body(new PVector(x,y,150),new PVector(0,0,0),10*q,true,color((q+20)*12,(q+20)*12,(q+20)*12)));
      }}
    for (int x = -width/2; x < width/2; x+=d) {
      for (int y = -height/2; y <height/2; y+=d) {
        float q = 10;
        bodies.add(new Body(new PVector(x,y,-150),new PVector(0,0,0),10*q,true,color((q+20)*12,(q+20)*12,(q+20)*12)));
      }}
    
  }
  }
  void keyPressed() {
    if (key == '1') {
      if (!e) {e = true;}
      else {e = false;}}
    else if (key == '2') {
      if (!b) {b = true;}
      else {b = false;}}
    else if (key == '3') {
      if (!fE) {fE = true;}
      else {fE = false;}}
    else if (key == '4') {
      if (!fB) {fB = true;}
      else {fB = false;}}
    else if (key == '5') {
      testV = PVector.mult(PVector.random3D(),15);}
    else if (key == '6') {
      if (!showFlux) {showFlux = true;}
      else {showFlux = false;}}
    else if (key == '7') {
      if (!showFlux1) {showFlux1 = true;}
      else {showFlux1 = false;}}}
