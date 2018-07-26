

class Tree {
  
}

class Flower {
  String flowerImageNames[] = {"symbol_y12.png", "symbol_y03.png", "symbol_y14.png", "symbol_y16.png", "symbol_y07.png"};
  PImage image = loadImage("data/" + flowerImageNames[int(random(flowerImageNames.length))]);
  String policy = "hidden";
  int faceID = -1;
  float time = Utils.getTime();
  ArrayList<PVector> branches = new ArrayList<PVector>();
  int growLength = 15;
  float lastLength;
  PVector stopFacePosition = new PVector();
  float escapeThreshold = random(20, 50);
  boolean isHidden = true;
  boolean isBloom = false;
  float thick;
  float size;
  
  float hideTime = random(10, 100);
  
  PVector position = new PVector();
  PVector bloomPosition = new PVector();
  
  public Flower() {
    
  }
  
  public void subDraw() {
    println(policy);
    switch(policy)  {
      case "hidden":
        hidden();
        break;
      case "growing":
        growing();
        break;
      case "die":
        die();
        break;
      case "bloom":
        bloom();
        break;
      default:
         println("error");
    }
    
    if(!isHidden) {
      PVector prePoint = new PVector();
      prePoint.x = position.x;
      prePoint.y = position.y;
      
      for(PVector b : branches) {
        strokeWeight(thick);
        line(prePoint.x, prePoint.y, prePoint.x + b.x, prePoint.y + b.y);
        prePoint.x = prePoint.x + b.x;
        prePoint.y = prePoint.y + b.y;
      }
      
      if(isBloom) {
        bloomPosition.x = prePoint.x;
        bloomPosition.y = prePoint.y;
        image.resize(int(size), int(size*image.height/image.width));
        imageMode(CENTER);
        image(image, prePoint.x, prePoint.y);
        imageMode(CORNER);
      }
    }
  }
  
  private void hidden() {
    isHidden = true;
    if(Utils.getTime() - time > hideTime) {
      if(faceList.size() != 0) {
        faceID = faceList.get(int(random(faceList.size()))).id;
        for (Face f : faceList) {
          if(f.id == faceID) {
              position.x = random(f.r.x, f.r.x + f.r.width);
              position.y = random(f.r.y, f.r.y + f.r.height);
              stopFacePosition.x = f.r.x;
              stopFacePosition.y = f.r.y;
              size = random(f.r.width/3, f.r.width/5);
              thick = f.r.width/40;
              lastLength = f.r.width/4;
              time = Utils.getTime();
              isHidden = false;
              policy = "growing";
          }
        }
      }
    }
  }
  
  private void growing() {
    //for(PVector b:branch)
    boolean isStopFace = false;
    if(faceList.size() != 0) {
      faceID = faceList.get(int(random(faceList.size()))).id;
      for (Face f : faceList) {
        if(f.id == faceID) {
          float distance = dist(stopFacePosition.x, stopFacePosition.y, f.r.x, f.r.y);
          if(distance < escapeThreshold) {
            isStopFace = true;
          }
        }
      }
    }
    if(growLength > branches.size()) {
      PVector nextPoint = new PVector();
      nextPoint.x = random(-2, 2);
      nextPoint.y = -lastLength/2.0;
      lastLength = dist(0, 0, nextPoint.x, nextPoint.y);
      branches.add(nextPoint);
    }else {
      policy = "bloom";
    }
    if(!isStopFace) {
      policy = "die";
    }
  }
  
  private void bloom() {
    isBloom = true;
    policy = "growing";
  }
  
  private void die() {
    isBloom = false;
    isHidden = true;
    policy = "hidden";
  }
}
