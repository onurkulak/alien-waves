class Player {
  
  public int hitCount = 0;
  public int health = 3;
  public int state = 0;
  public final int stateCnt=3;
  public final int reqEnemies=15;
  private int lastShootTime;
  private final static int shootPeriod = 25;
  float currPos;
  Player() {
    lastShootTime = 0;
    currPos = mouseX;
    fill(#000000);
  }
  
  void display () {
   currPos = lerp(currPos, mouseX, 0.05);
   state = hitCount / reqEnemies;
   lastShootTime--;
   switch(state){
     case 0:
       fill(#000000);
       rect(currPos-15,height-50,30,30);
       break;
     case 1: 
       fill(#990000);
       triangle(currPos,height-50, currPos-15, height-20, currPos+15, height-20);
       break;
     default:
       fill(#990099);
       ellipse(currPos,height-30, 50, 40);
       break;
   }
    
  }
  public Bullet shoot() {
    if(lastShootTime<0){ 
      lastShootTime = shootPeriod;
      switch(state){
        case 0: 
          return new Bullet(currPos,height-50,0,-5);
        case 1:
          return new Bullet(currPos,height-120, currPos,height-50, 0,-5);
        default:
          return new Bullet(currPos,height-50, 30, 0,-5);
      }
        
    }
    else
      return null;
  }
}
