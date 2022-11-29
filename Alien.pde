
class Alien {
  PShape alienShape;
  PVector vel = new PVector();
  PVector center = new PVector();
  float angle;
  float rvel;
  color c = #000000;
  ShapeBuilder mShapeBuilder = new ShapeBuilder();
  float sqr ( float x ) { return x*x; } 
  private int kind;
  
  void setcolor() { c = #FFFFFF; }
  
  public Alien (Player pl) {
    //((int)random(width/50))*50,10,0,random(1,2))
    vel.x = randomGaussian()/2; vel.y = random(1,4+pl.state);
    rvel = random(PI/4) - PI/8;
    angle = random(PI*2);
   
    center.x = (int)random(width/50)*50;
    center.y = 10;//(int)random(4)
    switch((int)random(4)){
      // simple 3-4 vertice shape
      case 0:
        switch((int)random(2)){
          case 0:
            alienShape = mShapeBuilder.getRandomQuad();
            break;
          case 1:
            alienShape = mShapeBuilder.getRandomTriangle();
            break;
        }
        kind = 0;
        break;
       // ellipse + circle
      case 1:
        if(random(1)<0.5){
          alienShape = mShapeBuilder.getRandomEllipse();
        }
        else{
          alienShape = mShapeBuilder.getRandomCircle();
        }
        kind = 1;
        break;
        // capsule
      case 2:
        alienShape = mShapeBuilder.getRandomCapsule();
        kind = 2;
        break;
      case 3:
        alienShape = mShapeBuilder.getRandomPolygon();
        kind = 3;
        break;
    }
    alienShape.translate(center.x,center.y);
    alienShape.rotate(angle);
  }
  public void update ( ) {
    
    alienShape.rotate(-angle);
    alienShape.translate(vel.x,vel.y);
    center.add(vel);
    angle+=rvel;
    alienShape.rotate(angle);
    //if (pos.x >= width)  { pos.x = width;  vel.x *= -1;}
    //if (pos.x <= 0)      { pos.x = 0;      vel.x *= -1;}
    //if (pos.y >= height) { pos.y = height; vel.y *= -1;}
    //if (pos.y <= 0)      { pos.y = 0;      vel.y *= -1;}
  }
  
  public boolean offScreen(Player pl) {
    if ((center.x >= width)||(center.x <= 0)||
        (center.y <= 0)) return true;
    else if((center.y >= height)){
      pl.health--;
      return true;
    }
    else return false;
  }
  public void drawit () {
    alienShape.setFill(#000000);
    shape(alienShape);
  }
  
  public void preventCollision(Alien s ){
    PVector diff = PVector.sub(s.center, center);
    if(diff.mag()<60){
      diff = diff.normalize().div(diff.mag()).mult(5);
      s.vel.add(diff);
      vel.sub(diff);
    }
  }
  
  public AlienShape getShapeParams(){
    AlienShape as = new AlienShape();
    as.kind = kind%3;
    float[] data = null;
    switch(kind){
      case 0:
        if(alienShape.getKind()==TRIANGLE){
          data = new float[6];
          for(int i = 0; i < 3; i++){
            PVector r = rt(alienShape.getParam(2*i), alienShape.getParam(2*i+1));
            data[2*i] = r.x;
            data[2*i+1] = r.y;
          }
        }
        else{
          data = new float[8];
          for(int i = 0; i < 4; i++){
            PVector r = rt(alienShape.getParam(2*i), alienShape.getParam(2*i+1));
            data[2*i] = r.x;
            data[2*i+1] = r.y;
          }
        }
        break;
        
        case 1:
        //circle
          if(alienShape.getParam(2)==alienShape.getParam(3)){
            data = new float[3];
            PVector r = rt(alienShape.getParam(0), alienShape.getParam(1));
            data[0] = r.x;
            data[1] = r.y;
            data[2] = alienShape.getParam(2)/2;
          }
          //ellipse
          else {
            PVector p1, p2;
            data = new float[5];
            float c = sqr(alienShape.getParam(2)) - sqr(alienShape.getParam(3));
            c /= 4;
            if(c>0){
              c = sqrt(c);
              p1 = rt(c,0);
              p2 = rt(-c,0);
            }
            else{
              c = sqrt(-c);
              p1 = rt(0,c);
              p2 = rt(0,-c);
            }
            
            data[0] = p1.x;
            data[1] = p1.y;
            data[2] = p2.x;
            data[3] = p2.y;
            data[4] = max(alienShape.getParam(2),alienShape.getParam(3));
          }
          break;
          
        case 2:
          data = new float[5];
          PShape rectangle = alienShape.getChild(0);
          data[4] = rectangle.getParam(3)/2;
          PVector leftCenter = rt(rectangle.getParam(0), rectangle.getParam(1) + rectangle.getParam(3)/2);
          PVector rightCenter = rt(rectangle.getParam(0) + rectangle.getParam(2), rectangle.getParam(1) + rectangle.getParam(3)/2);
          data[0] = leftCenter.x;
          data[1] = leftCenter.y;
          data[2] = rightCenter.x;
          data[3] = rightCenter.y;
          break;
        case 3:
          data = new float[alienShape.getVertexCount()*2];
          for(int i = 0; i < alienShape.getVertexCount(); i++){
            PVector rt = rt(alienShape.getVertexX(i),alienShape.getVertexY(i));
            data[2*i] = rt.x;
            data[2*i+1] = rt.y;
          }
          break;
    }
    as.data = data;
    return as;
  }
  
  // rotate and translate
  private PVector rt(float x, float y){
    PVector r = new PVector(x, y);
    r.rotate(angle);
    r.add(center);
    return r;
  }
}
