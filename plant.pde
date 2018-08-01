

class Tree {
  
}

class Flower {
  String flowerImageNames[] = {"gerbera003.png", "margaret001.png", "margaret002.png", "himawariA001.png", "himawariB001.png"};
  PImage image = loadImage("data/" + flowerImageNames[int(random(flowerImageNames.length))]);
  String policy = "hidden";
  int faceID = -1;
  float keepTime = Utils.getTime();
  ArrayList<PVector> branches = new ArrayList<PVector>();
  float growStepTime = random(1, 2);
  int growLength = 10;
  float lastLength;
  PVector stopFacePosition = new PVector();
  float escapeThreshold = random(5, 30);
  boolean isHidden = true;
  boolean isBloom = false;
  float thick;
  float size;
  
  float hideTime = random(10, 100);
  
  PVector relatedPosition = new PVector();
  PVector position = new PVector();
  PVector bloomPosition = new PVector();
  
  public Flower() {
    
  }
  
  public void subDraw() {
    //println(policy);
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
      case "keep":
        keep();
        break;
      default:
         println("error");
    }
    
    if(!isHidden) {
      if(faceList.size() != 0) {
        for (Face f : faceList) {
          if(f.id == faceID) {
            position.x = f.r.x + relatedPosition.x;
            position.y = f.r.y + relatedPosition.y;
            
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
      }
    }
  }
  
  private void hidden() {
    isHidden = true;
    if(Utils.getTime() - keepTime > hideTime) {
      if(faceList.size() != 0) {
        faceID = faceList.get(int(random(faceList.size()))).id;
        for (Face f : faceList) {
          if(f.id == faceID) {
              relatedPosition.x = random(30, f.r.width - 30);
              relatedPosition.y = random(-f.r.height/4, f.r.height/4);
              stopFacePosition.x = f.r.x;
              stopFacePosition.y = f.r.y;
              size = random(f.r.width/3, f.r.width/5);
              thick = f.r.width/40;
              lastLength = f.r.width/4;
              keepTime = Utils.getTime();
              isHidden = false;
              policy = "growing";
          }
        }
      }else {
        keepTime = Utils.getTime();
      }
    }
  }
  
  private void growing() {
    //for(PVector b:branch)
    boolean isStopFace = false;
    if(faceList.size() != 0) {
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
      if(Utils.getTime() - keepTime > growStepTime) {
        PVector nextPoint = new PVector();
        nextPoint.x = random(-2, 2);
        nextPoint.y = -lastLength/1.8;
        lastLength = dist(0, 0, nextPoint.x, nextPoint.y);
        branches.add(nextPoint);
        keepTime = Utils.getTime();
      }
    }else {
      policy = "bloom";
    }
    if(!isStopFace) {
      policy = "die";
    }
  }
  
  private void bloom() {
    isBloom = true;
    policy = "keep";
  }
  
  private void keep() {
    policy = "die";
    if(faceList.size() != 0) {
      for (Face f : faceList) {
        if(f.id == faceID) {
          policy = "keep";
        }
      }
    }
  }
  
  private void die() {
    isBloom = false;
    isHidden = true;
    keepTime = Utils.getTime();
    policy = "hidden";
  }
}
