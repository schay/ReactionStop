

class Butterfly {
  private String butterflyImageNames[] = {"ageha.png", "aosuji.png", "jakouageha.png", "monki.png", "monshiro.png"};
  private PVector stopFacePosition = new PVector();
  private PVector size = new PVector();
  private PVector position = new PVector(random(width), random(height));
  private PVector vector = new PVector(0, 0);
  private String policy = "hidden";
  private PImage image = loadImage("data/" + butterflyImageNames[int(random(butterflyImageNames.length))]);
  private float coolTime = random(5, 30);
  private float time = Utils.getTime();
  private float escapeThreshold = random(5, 30);
  private boolean flapIsOpen = false;
  private int flapP = 0;
  private int faceID = -1;
  private float flappingSpeed = random(3,5);
  private boolean isHidden = true;
  private int hideTime = int(random(5, 30));
  
  Butterfly() {
    int xSize = int(random(50, 100));
    
    image.resize(xSize, int(xSize*image.height/image.width));
    size.x = image.width;
    size.y = image.height;
    
    
  }
  
  public void subDraw() {
    //println(policy);
    switch(policy)  {
      case "flying":
        flying();
        break;
      case "chase":
        chase();
        break;
      case "stoped":
        stoped();
        break;
      case "escape":
        escape();
        break;
      case "hidden":
        hidden();
        break;
      default:
         println("error");
    }
    position.add(vector);
    
    
    if(!isHidden) {
      PImage tmp_image = image.get();
      
      tmp_image.resize(int(size.x*(flapP/10.0)), int(size.y));
      imageMode(CENTER);
      image(tmp_image, position.x, position.y);
      imageMode(CORNER);
    }
  }
  
  private void flying(){
    move();
    flapping();  
      
    if(faceList.size() != 0) {
      faceID = faceList.get(int(random(faceList.size()))).id;
      policy = "chase";
    }
    if(position.x < -width || position.x > width*2 || position.y < -height || position.y > height*2) {
      policy = "hidden";
      time = Utils.getTime();
    }
  }
  
  private void chase() {
    move();
    flapping();  
    boolean isExistFace = false;
    for (Face f : faceList) {
      if(f.id == faceID) {
        isExistFace = true;
        //float distance = dist(position.x, position.y, f.r.x + f.r.width/2.0, f.r.y + f.r.height/2.0);
        if(position.x > f.r.x && position.x < f.r.x + f.r.width
          && position.y > f.r.y && position.y < f.r.y + f.r.height) {
          //if(distance < escapeThreshold) {
          stopFacePosition.x = f.r.x;
          stopFacePosition.y = f.r.y;
          policy = "stoped";
          time = Utils.getTime();
        }
      }
    }
    if(!isExistFace) {
      policy = "flying";
    }
  }
  
  private void stoped() {
    flapP = 0;
    vector.x = 0;
    vector.y = 0;
    boolean isStopFace = false;
    for (Face f : faceList) {
      if(f.id == faceID) {
        float distance = dist(stopFacePosition.x, stopFacePosition.y, f.r.x, f.r.y);
        if(distance < escapeThreshold) {
          isStopFace = true;
        }
      }
    }
    if(!isStopFace) {
      policy = "escape";
    }
  }
  
  private void escape() {
    move();
    flapping();
    if(Utils.getTime() - time > coolTime) {
      policy = "flying";
    }
  }
  
  private void hidden() {
    isHidden = true;
    if(Utils.getTime() - time > hideTime) {
      policy = "flying";
      isHidden = false;
    }
  }
  
  private void move() {
    int xMin = -10, xMax = 10;
    int yMin = -10, yMax = 10;
    if(policy == "chase") {
      for (Face f : faceList) {
        if(f.id == faceID) {
          if(f.r.x > position.x) {
            xMin = 0;
            xMax = xMax/2;
          }else {
            xMax = 0;
          }
          if(f.r.y > position.y) {
            yMin = 0;
          }else {
            yMax = 0;
          }
        }
      }
    }
    if(policy == "escape") {
      for (Face f : faceList) {
        if(f.id == faceID) {
          if(f.r.x < position.x) {
            xMin = 0;
          }else {
            xMax = 0;
          }
          if(f.r.y < position.y) {
            yMin = 0;
          }else {
            yMax = 0;
          }
        }
      }
    }
    vector.x = int(random(xMin, xMax))*2;
    vector.y = int(random(yMin, yMax))*2;
  }
  
  private void flapping() {
    float minPropotion = 2;
    float maxPropotion = 10;
    float speed = flappingSpeed;
    
    if(flapP <= minPropotion) {
      flapIsOpen = true;
    }
    if(flapP >= maxPropotion) {
      flapIsOpen = false;
    }
    if(flapIsOpen) {
      flapP += speed;
    }
    else {
      flapP -= speed;
    }
  }
}
