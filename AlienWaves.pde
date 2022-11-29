
   AlienList p;
   Player pl;
   BulletList b;

   public void setup() {
     size(1500,1500);
     p = new AlienList(100);
     pl = new Player();
     b = new BulletList(10);
     noStroke();
     println(width);
     
   }
   
    
   public void draw() {
     background(255);
     if(pl.health<=0){
      textSize(100);
      textAlign(CENTER);
      text("YOU LOST", width/2, height/2);
     }
     else if (pl.state >= pl.stateCnt){
      textSize(100);
      textAlign(CENTER);
      text("YOU WON", width/2, height/2);
     }
     else{
       textSize(32);
       text("hit count:\t" + pl.hitCount, 10, 30);
       text("goal:\t" + pl.reqEnemies*pl.stateCnt, 10, 60);
       text("health:\t" + pl.health, 10, 90); 
       p.update(pl);
       p.display();
       pl.display();
       b.update();
       b.display();
       b.hit(p,pl);
       //println(frameRate);
       if (frameCount % 100 == 0) 
       p.ps.add(new Alien(pl));
       if (mousePressed){
         Bullet bullet = pl.shoot();
         if(bullet!= null){
           b.bsList.add(bullet);
         }
       }
     }
     }
