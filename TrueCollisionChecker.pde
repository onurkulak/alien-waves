class TrueCollisionManager{
  
  private boolean inb (float x, float y, float z){
    return (x<=y && x>=z) || (x>=y && x<=z);
  }
  float sqr ( float x ) { return x*x; } 
  public boolean checkCollison(AlienShape a, Bullet b){
    int type = a.kind + 3*b.type;
    switch(type){
      case 0:
        return polygonPointCollision(a,b);
      case 1:
        return ellipsePointCollision(a,b);
      case 2:
        return capsulePointCollision(a,b);
      
      case 3:
        return polygonLineCollision(a,b);
      case 4:
        return ellipseLineCollision(a,b);
      case 5:
        return capsuleLineCollision(a,b);
      
      case 6:
        return polygonCircleCollision(a,b);
      case 7:
        return ellipseCircleCollision(a,b);
      case 8:
        return capsuleCircleCollision(a,b);
      default:
        throw new RuntimeException("False Collision Code");
    }
  }
  
  private PVector[] getPolygonVertices(float[] data){
    PVector[] v = new PVector[data.length/2];
    for(int i = 0; i < v.length; ++i){
      v[i] = new PVector(data[2*i], data[2*i+1]);
    }
    return v;
  }
  
  private boolean polygonPointCollision(AlienShape a, Bullet b){
    // check two axis rays for crossing number method
    PVector p = b.pos;
    PVector[] v = getPolygonVertices(a.data);
    int cntr = 0;
    for(int i = 0; i < v.length; ++i){
      PVector p1 = v[i];
      PVector p2 = v[(i+1)%v.length];
      PVector e = PVector.sub(p1,p2);
      float m = e.y/e.x;
      float n = p1.y - m * p1.x;
      float ix = (p.y - n) / m;
      if(ix<p.x && ((ix < p2.x && ix >= p1.x) ||(ix > p2.x && ix <= p1.x)))
        ++cntr;
    }
    return cntr%2==1;
  }

  private boolean ellipsePointCollision(AlienShape a, Bullet b){
    if(a.data.length==3){
      return a.data[2]>=PVector.sub(b.pos, new PVector(a.data[0], a.data[1])).mag();
    }
    else{
      return a.data[4]>=PVector.sub(b.pos, new PVector(a.data[0], a.data[1])).mag()+PVector.sub(b.pos, new PVector(a.data[2], a.data[3])).mag();
    }
  }
  
  private boolean capsulePointCollision(AlienShape a, Bullet b){
    if(a.data[4]>=PVector.sub(b.pos, new PVector(a.data[0], a.data[1])).mag() || a.data[4]>=PVector.sub(b.pos, new PVector(a.data[2], a.data[3])).mag())
      return true;
    else 
      {
        PVector p1 = new PVector(a.data[0],a.data[1]);
        PVector p2 = new PVector(a.data[2],a.data[3]);
        PVector ls = PVector.sub(p1,p2);
        float m1 = ls.y/ls.x;
        float m2 = 1/m1;
        float n1 = p1.y - m1 * p1.x;
        float n2 = b.pos.y - m2 * b.pos.x;
        float ix = (n1-n2)/(m2-m1);
        float iy = ix*m1+n1;
        boolean f1 = (p1.x<ix && ix < p2.x) || (p1.x>ix && ix > p2.x);
        boolean f2 = PVector.sub(new PVector(ix,iy), b.pos).mag() <= a.data[4];
        return f1 && f2;
      }
  }
  
  private boolean polygonLineCollision(AlienShape a, Bullet b){
    PVector b0 = b.pos;
    PVector b1 = b.pos2;
    
    PVector[] v = getPolygonVertices(a.data);
    
    for(int i = 0; i < v.length; ++i){
      PVector p1 = v[i];
      PVector p2 = v[(i+1)%v.length];
      PVector e = PVector.sub(p1,p2);
      float m2 = e.y/e.x;
      float n2 = p1.y - m2 * p1.x;
      float iy = m2 * b0.x + n2;
    
      // exists in both line segments
      if( ((iy <= b1.y && iy >= b0.y)) && ((iy < p2.y && iy >= p1.y) ||(iy > p2.y && iy <= p1.y)))
        return true;
    }
    return false;
  }
  
  private boolean ellipseLineCollision(AlienShape a, Bullet b){
    if(a.data.length==3){
      if(sqr(a.data[2])-sqr(b.pos.x-a.data[0]) < 0)
        return false;
      float delta = sqrt(sqr(a.data[2])-sqr(b.pos.x-a.data[0]));
      if(inb(a.data[1]-delta,b.pos.y, b.pos2.y))
        return true;
      if(inb(a.data[1]+delta,b.pos.y, b.pos2.y))
        return true;
      return false;
    }
    else{
      PVector p0 = new PVector (a.data[0], a.data[1]);
      PVector p1 = new PVector (a.data[2], a.data[3]);
      float c0 = sqr(p0.x) + sqr(p0.y)- 2*(p0.x*b.pos.x);
      float c1 = sqr(p1.x) + sqr(p1.y)- 2*(p1.x*b.pos.x);
      float miny = (c0-c1)/(2*(p0.y-p1.y));
      float y2bechecked;
      if(inb(miny, b.pos.y, b.pos2.y)){
        y2bechecked = miny;
      }
      else if(max(b.pos.y, b.pos2.y)<=miny)
        y2bechecked = max(b.pos.y, b.pos2.y);
      else{
        y2bechecked = min(b.pos.y, b.pos2.y);
      }
      return ellipsePointCollision(a, new Bullet(b.pos.x, y2bechecked,0,0));
    }
  }
  
  private boolean capsuleLineCollision(AlienShape a, Bullet b){
    // check collisions with circle parts
    AlienShape tempA0 = new AlienShape();
    tempA0.data = new float[]{a.data[0],a.data[1],a.data[4]};
    if(ellipseLineCollision(tempA0,b))
      return true;
    tempA0.data[0] = a.data[2];
    tempA0.data[1] = a.data[3];
    if(ellipseLineCollision(tempA0,b))
      return true;
      
    // check intersections between lines
    tempA0.data = new float[4];
    PVector p0 = new PVector(a.data[0],a.data[1]);
    PVector p1 = new PVector(a.data[2],a.data[3]);
    PVector diff = PVector.sub(p0,p1);
    PVector shift = diff.rotate(HALF_PI).normalize().mult(a.data[4]);
    PVector shiftedP0 = PVector.add(p0,shift);
    PVector shiftedP1 = PVector.add(p1,shift);
    tempA0.data[0] = shiftedP0.x;
    tempA0.data[1] = shiftedP0.y;
    tempA0.data[2] = shiftedP1.x;
    tempA0.data[3] = shiftedP1.y;
    if(polygonLineCollision(tempA0,b))
      return true;
      
    shiftedP0 = PVector.sub(p0,shift);
    shiftedP1 = PVector.sub(p1,shift);
    tempA0.data[0] = shiftedP0.x;
    tempA0.data[1] = shiftedP0.y;
    tempA0.data[2] = shiftedP1.x;
    tempA0.data[3] = shiftedP1.y;
    if(polygonLineCollision(tempA0,b))
      return true;
    return false;
  }
  
  private boolean polygonCircleCollision(AlienShape a, Bullet b){
    if(polygonPointCollision(a,b))
      return true;
    else{
      AlienShape t = new AlienShape();
      t.data = new float[5];
      t.data[4] = b.radius;
      for(int i = 0; i < a.data.length/2; ++i){
        t.data[0] = a.data[2*i];
        t.data[1] = a.data[2*i+1];
        t.data[2] = a.data[(2*i)%a.data.length];
        t.data[3] = a.data[(2*i+1)%a.data.length];
        if(capsulePointCollision(t,b))
        return true;
      }
    }
    return false;
  }
  
  private boolean ellipseCircleCollision(AlienShape a, Bullet b){
    int radind = a.data.length-1;
    
    a.data[radind] += 2*b.radius;
    boolean r = ellipsePointCollision(a,b);
    a.data[radind] -= 2*b.radius;
    return r;
  }
  
  private boolean capsuleCircleCollision(AlienShape a, Bullet b){
    a.data[4] += b.radius;
    boolean r = capsulePointCollision(a,b);
    a.data[4] -= b.radius;
    return r;
  }
}
