      
public class BulletList {
  
  
  LinkedList<Bullet> bsList = new LinkedList<Bullet>();
 
  public BulletList(int n) {
   // for (int i=0;i<n;i++){ }
     //  ps.add(new Alien(random(width),10,0,random(1,2)));
   }
   
   public void update() {
     ListIterator<Bullet> bs = bsList.listIterator();
     while (bs.hasNext()) {
       Bullet b = bs.next();
       b.update();
       if (b.offScreen()) {
         bs.remove();
       }
     }  
   }
   
   public void display() {
     ListIterator<Bullet> bs = bsList.listIterator();
     while (bs.hasNext())
       bs.next().drawit();
   }
  
  public void hit(AlienList al, Player pl) {
      ListIterator<Bullet> bs = bsList.listIterator();
     while (bs.hasNext()) {
        Bullet b = bs.next();
        ListIterator<Alien> iter = al.ps.listIterator(0);
        while (iter.hasNext()){ 
           Alien a = iter.next();
           if (b.collide(a)){
               //a.setcolor();
               println("hit");
               pl.hitCount++;
               iter.remove();
               bs.remove();
               break;
           }
        }
       }
     }  
  
}
