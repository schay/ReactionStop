

class Tree {
  
}

class Flower {
  String policy = "hidden";
  private int faceID = -1;
  ArrayList<PVector> branch = new ArrayList<PVector>();
  
  private PVector position = new PVector();
  
  public Flower() {
    
  }
  
  public void subDraw() {
    //println(policy);
    switch(policy)  {
      case "hidden":
        hidden();
        break;
      case "grow":
        grow();
        break;
      default:
         println("error");
    }
  }
  
  private void hidden() {
    if(faceList.size() != 0) {
      faceID = faceList.get(int(random(faceList.size()))).id;
      for (Face f : faceList) {
      if(f.id == faceID) {
          position.x = random(f.r.x, f.r.x + f.r.width);
          position.y = random(f.r.y, f.r.y + f.r.height);
          branch.add(position);
          policy = "grow";
      }
    }
    }
  }
  
  private void grow() {
    //for(PVector:p)
  }
}
