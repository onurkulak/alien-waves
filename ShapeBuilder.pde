class ShapeBuilder{

  ShapeBuilder(){}
  
  private final static int R = 100;
  private float getWindowedGaussian(float abs){
    float r = randomGaussian();
    if (r>abs(abs))
      return  getWindowedGaussian(abs);
    else return r;
  }
  
  private float getWindowedGaussian(){
    return  getWindowedGaussian(2);
  }
  
  private int randomInt(int high){
    return (int)random(high);
  }
  
  private int randomInt(int low, int high){
    return (int)random(low,high);
  }
  
  public PShape getRandomQuad(){
    PShape s = createShape(QUAD, randomInt(-R,0), randomInt(-R,0), randomInt(-R,0),randomInt(0,R),randomInt(0,R),randomInt(0,R),randomInt(0,R),randomInt(-R,0));
    return s;
  }

  public PShape getRandomRect(){
    int x = randomInt(-R,0);
    int y = randomInt(-R,0);
    PShape s = createShape(RECT,  x,y,randomInt(R/2,R-x),randomInt(R/2,R-y));
    return s;
  }
  
  public PShape getRandomTriangle(){
    PShape s = createShape(TRIANGLE, (getWindowedGaussian()+2)*R/4,(getWindowedGaussian()+2)*R/4,(getWindowedGaussian()-2)*R/4,(getWindowedGaussian()+2)*R/4,getWindowedGaussian()*R/4,(getWindowedGaussian()-2)*R/4);
    return s;
  }
  
  public PShape getRandomEllipse(){
    PShape s = createShape(ELLIPSE, 0,0,getWindowedGaussian()*R/2+R,getWindowedGaussian()*R/2+R);
    return s;
  }
  
  public PShape getRandomCircle(){
    int diameter = randomInt(R,2*R);
    PShape s = createShape(ELLIPSE, getWindowedGaussian()*3,getWindowedGaussian()*3,diameter, diameter);
    return s;
  }
  
  public PShape getRandomCapsule(){
    PShape s = createShape(GROUP);
    PShape rect = getRandomRect();
    s.addChild(rect);
    PVector midp0 = new PVector(rect.getParam(0), rect.getParam(1)+rect.getParam(3)/2); 
    PVector midp1 = PVector.add(midp0, new PVector(rect.getParam(2),0)); 
    float arcDiameter = rect.getParam(3);
    PShape arc1 = createShape(ARC, midp0.x, midp0.y, arcDiameter, arcDiameter, HALF_PI, HALF_PI+PI);
    PShape arc2 = createShape(ARC, midp1.x, midp1.y, arcDiameter, arcDiameter, -HALF_PI, HALF_PI);
    s.addChild(arc1);
    s.addChild(arc2);
    return s;
  }
  
  public PShape getRandomPolygon(){
    int cornerc = randomInt(5,15);
    PShape ps = createShape();
    ps.beginShape();
    float sliceSize = 2*PI/cornerc;
    for(int i = 0; i < cornerc; i++){
      float randomAngle = random(sliceSize*i, sliceSize*(i+1));
      float randomLength = random(R/4, R);
      ps.vertex(cos(randomAngle)*randomLength, sin(randomAngle)*randomLength);
    }
    ps.endShape();
    return ps;
  }
  

}
