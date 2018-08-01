

class Butterfly {
  
  private String butterflyImageNames[] = {"ageha.png", "aosuji.png", "jakouageha.png", "monki.png", "monshiro.png"};
  private PVector stopFacePosition = new PVector();
  private PVector size = new PVector();
  private PVector position = new PVector(random(width), random(height));
  private PVector vector = new PVector(0, 0);
  private String policy = "hidden";
  private PImage image = loadImage("data/" + butterflyImageNames[int(random(butterflyImageNames.length))]);
  private float coolTime = random(10, 30);
  private float time = Utils.getTime();
  private float escapeThreshold = random(5, 30);
  private boolean flapIsOpen = false;
  private int flapP = 0;
  private float flappingSpeed = random(3,5);
  private boolean isHidden = true;
  private int hideTime = int(random(5, 30));
  private int flowerID = -1;
  private PVector inertia = new PVector(random(-5, 5), random(-5, 5));
  
  Butterfly() {
    int xSize = int(random(25, 40));
    
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
      
    if(flowers.size() != 0) {
      flowerID = int(random(flowers.size()));
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
    boolean isExistFlower = false;
    Flower f = flowers.get(flowerID);
    if(f.isBloom) {
      isExistFlower = true;
      //float distance = dist(position.x, position.y, f.r.x + f.r.width/2.0, f.r.y + f.r.height/2.0);
      if(position.x > f.bloomPosition.x && position.x < f.bloomPosition.x + f.size
        && position.y > f.bloomPosition.y && position.y < f.bloomPosition.y + f.size) {
        //if(distance < escapeThreshold) {
        stopFacePosition.x = f.bloomPosition.x;
        stopFacePosition.y = f.bloomPosition.y;
        policy = "stoped";
        time = Utils.getTime();
      }
    }
    if(!isExistFlower) {
      policy = "flying";
    }
  }
  
  private void stoped() {
    flapP = 0;
    vector.x = 0;
    vector.y = 0;
    boolean isStopFlower = false;
    Flower f = flowers.get(flowerID);
    if(f.isBloom) {
      float distance = dist(stopFacePosition.x, stopFacePosition.y, f.bloomPosition.x, f.bloomPosition.y);
      if(distance < escapeThreshold) {
        isStopFlower = true;
        position.x = f.bloomPosition.x;
        position.y = f.bloomPosition.y;
      }
    }
    if(!isStopFlower) {
      policy = "escape";
    }
  }
  
  private void escape() {
    move();
    flapping();
    if(position.x < -width || position.x > width*2 || position.y < -height || position.y > height*2) {
      policy = "hidden";
      time = Utils.getTime();
    }
    /*
    if(Utils.getTime() - time > coolTime) {
      policy = "flying";
    }
    */
  }
  
  private void hidden() {
    if(!isHidden) {
      isHidden = true;
      time = Utils.getTime();
    }
    if(Utils.getTime() - time > hideTime) {
      policy = "flying";
      isHidden = false;
    }
  }
  
  private void move() {
    float xMin = -10 + inertia.x, xMax = 10 + inertia.x;
    float yMin = -10 + inertia.y, yMax = 10 + inertia.y;
    if(policy == "chase") {
      Flower f = flowers.get(flowerID);
      if(f.isBloom) {
        if(f.bloomPosition.x > position.x) {
          xMin = 0;
          xMax = xMax/2;
        }else {
          xMax = 0;
        }
        if(f.bloomPosition.y > position.y) {
          yMin = 0;
        }else {
          yMax = 0;
        }
      }
    }
    if(policy == "escape") {
      Flower f = flowers.get(flowerID);
      if(f.isBloom) {
        if(f.bloomPosition.x < position.x) {
          xMin = 0;
        }else {
          xMax = 0;
        }
        if(f.bloomPosition.y < position.y) {
          yMin = 0;
        }else {
          yMax = 0;
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
