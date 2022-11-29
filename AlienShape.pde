class AlienShape{
  /* kind is either 0, 1, 2
  
  0: polygon case, data array has 2n floats where n is the number of vertices in the polygon. 
  Index 0 points to the X of first vertex, 1 points to the Y of the first vertex, 2 points to the X of the second vertex and so on.
  
  1: Ellipse-like case, shape is either a circle or an ellipse
  if data has 3 elements it's a circle If it has 5 it's an ellipse.
  
  If it's a circle first 2 floats show the centre and 3rd float is the radius
  
  If it's an ellipse 1st and 2nd floats are the first focus, 3rd and 4th floats are the second focus, 5th float is the length of the major axis (size of the wide axis)
  
  2: Capsule, first to fourth floats show the end points of the line segment, 5th float is the radius
  */
  public int kind;
  public float[] data;

}
