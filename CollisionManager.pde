class CollisionManager{


  public boolean checkCollison(AlienShape a, Bullet b){
    // temporary method
    PVector t = new PVector(a.data[0], a.data[1]);
    return t.sub(b.pos).mag()<15;
  }

}
