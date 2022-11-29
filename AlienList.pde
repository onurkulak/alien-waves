import java.util.LinkedList;
import java.util.ListIterator;
class AlienList {
  
  public LinkedList<Alien> ps = new LinkedList<Alien>();
 
  public AlienList(int n) {
    for (int i=0;i<n;i++){ }
     //  ps.add(new Alien(random(width),10,0,random(1,2)));
   }
   
   public void update(Player pl) {
     ListIterator<Alien> psi = ps.listIterator(0);
     while(psi.hasNext()){
       Alien alien = psi.next();
       alien.update();
       if (alien.offScreen(pl)) {
         psi.remove();
       }
       //for (int j = 0; j < i; j++) 
        //if (ps.get(i).collide(ps.get(j)))
         //ps.get(j).setcolor();
     }  
   }
   
   public void display() {
     ListIterator<Alien> psi = ps.listIterator(0);
     while(psi.hasNext()){
       psi.next().drawit();
     }
   }
}
