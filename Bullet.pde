 public class Bullet {
   
  TrueCollisionManager cm = new TrueCollisionManager();
  public PVector pos = new PVector();
  PVector vel = new PVector();
  public PVector pos2 = new PVector();
  public float radius = 10;
  color c = #FF0000;
  public int type;
  
  float sqr ( float x ) { return x*x; } 
  
  void setcolor() { c = #FF0000; }
  
  public Bullet ( float x, float y, float vx, float vy) {
    pos.x = x;  pos.y = y;
    vel.x = vx; vel.y = vy;
    type = 0;
  }
  
  public Bullet ( float x0, float y0, float x1, float y1,float vx, float vy) {
    pos.x = x0;  pos.y = y0;
    vel.x = vx; vel.y = vy;
    pos2.x = x1; pos2.y = y1;
    type = 1;
  }
  
  public Bullet ( float x, float y, float r,float vx, float vy) {
    pos.x = x;  pos.y = y;
    vel.x = vx; vel.y = vy;
    radius = r;
    type = 2;
  }
  
  public void update ( ) {
    pos.add(vel);
    if(type == 1){
      pos2.add(vel);
    }
    //if (pos.x >= width)  { pos.x = width;  vel.x *= -1;}
    //if (pos.x <= 0)      { pos.x = 0;      vel.x *= -1;}
    //if (pos.y >= height) { pos.y = height; vel.y *= -1;}
    //if (pos.y <= 0)      { pos.y = 0;      vel.y *= -1;}
  }
  
  public boolean offScreen() {
    if ((pos.x >= width)||(pos.x <= 0)||
        (pos.y >= height)||(pos.y <= 0)) return true;
    else return false;
  }
  public void drawit () {
    //fill(c);
    if(type != 1){
      ellipse(pos.x,pos.y,radius,radius);
    }
    else {
      rect(pos.x-1, pos.y, 3, pos.y-pos2.y);
    }
    
  }
  
  public boolean collide ( Alien s ) {
    return cm.checkCollison(s.getShapeParams(), this);
  }
}
