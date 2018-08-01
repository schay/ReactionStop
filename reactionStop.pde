import processing.video.*;
import java.awt.*;
import gab.opencv.*;

OpenCV opencv;
Capture video;

reactionStop thisInstance = this;

// List of my Face objects (persistent)
ArrayList<Face> faceList;
// Number of faces detected over all time. Used to set IDs.
int faceCount = 0;
// List of detected faces (every frame)
Rectangle[] faces;

ArrayList<Butterfly> butterflies;
int butterflyNum = 20;
ArrayList<Flower> flowers;
int flowerNum = 15;

float scale = 1;

void setup() {
  surface.setSize(int(640*scale), int(480*scale));
  width = int(width/scale);
  height = int(height/scale);
  video = new Capture(this, width, height);
  opencv = new OpenCV(this, width, height);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);
  
  faceList = new ArrayList<Face>();
  Rectangle[] faces;

  video.start();
  
    
  flowers = new ArrayList<Flower>();
  for(int i = 0; i < flowerNum; i++) {
    flowers.add(new Flower());
  }
  
  butterflies = new ArrayList<Butterfly>();
  for(int i = 0; i < butterflyNum; i++) {
    butterflies.add(new Butterfly());
  }

    
}

void draw() {
  scale(scale);
  background(0);
  opencv.loadImage(video);
  opencv.flip(1);
  
  scale(-1, 1);
  image(video, -width, 0);
  scale(-1, 1);
  
  /*
  opencv.calculateOpticalFlow();
  stroke(255,0,0);
  opencv.drawOpticalFlow();
  PVector aveFlow = opencv.getAverageFlow();
  int flowScale = 50;
  stroke(255);
  strokeWeight(2);
  line(video.width/2, video.height/2, video.width/2 + aveFlow.x*flowScale, video.height/2 + aveFlow.y*flowScale);
  */
  detectFaces();
  
  // Draw all the faces
  /*
  for (int i = 0; i < faces.length; i++) {
    noFill();
    strokeWeight(5);
    stroke(255,0,0);
    //rect(faces[i].x*scl,faces[i].y*scl,faces[i].width*scl,faces[i].height*scl);
    rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
  }
  */
  
  for (Face f : faceList) {
    strokeWeight(2);
    //f.display();
  }

  noFill();
  stroke(0, 255, 0);

  for(Flower f : flowers) {
    f.subDraw();
  }
  for(Butterfly b : butterflies){
    b.subDraw();
  }
}

void detectFaces() {
  
  // Faces detected in this frame
  faces = opencv.detect();
  
  // Check if the detected faces already exist are new or some has disappeared. 
  
  // SCENARIO 1 
  // faceList is empty
  if (faceList.isEmpty()) {
    // Just make a Face object for every face Rectangle
    for (int i = 0; i < faces.length; i++) {
      println("+++ New face detected with ID: " + faceCount);
      faceList.add(new Face(faceCount, faces[i].x,faces[i].y,faces[i].width,faces[i].height));
      faceCount++;
    }
  
  // SCENARIO 2 
  // We have fewer Face objects than face Rectangles found from OPENCV
  } else if (faceList.size() <= faces.length) {
    boolean[] used = new boolean[faces.length];
    // Match existing Face objects with a Rectangle
    for (Face f : faceList) {
       // Find faces[index] that is closest to face f
       // set used[index] to true so that it can't be used twice
       float record = 50000;
       int index = -1;
       for (int i = 0; i < faces.length; i++) {
         float d = dist(faces[i].x,faces[i].y,f.r.x,f.r.y);
         if (d < record && !used[i]) {
           record = d;
           index = i;
         } 
       }
       // Update Face object location
       used[index] = true;
       f.update(faces[index]);
    }
    // Add any unused faces
    for (int i = 0; i < faces.length; i++) {
      if (!used[i]) {
        println("+++ New face detected with ID: " + faceCount);
        faceList.add(new Face(faceCount, faces[i].x,faces[i].y,faces[i].width,faces[i].height));
        faceCount++;
      }
    }
  
  // SCENARIO 3 
  // We have more Face objects than face Rectangles found
  } else {
    // All Face objects start out as available
    for (Face f : faceList) {
      f.available = true;
    } 
    // Match Rectangle with a Face object
    for (int i = 0; i < faces.length; i++) {
      // Find face object closest to faces[i] Rectangle
      // set available to false
       float record = 50000;
       int index = -1;
       for (int j = 0; j < faceList.size(); j++) {
         Face f = faceList.get(j);
         float d = dist(faces[i].x,faces[i].y,f.r.x,f.r.y);
         if (d < record && f.available) {
           record = d;
           index = j;
         } 
       }
       // Update Face object location
       Face f = faceList.get(index);
       f.available = false;
       f.update(faces[i]);
    } 
    // Start to kill any left over Face objects
    for (Face f : faceList) {
      if (f.available) {
        f.countDown();
        if (f.dead()) {
          f.delete = true;
        } 
      }
    } 
  }
  
  // Delete any that should be deleted
  for (int i = faceList.size()-1; i >= 0; i--) {
    Face f = faceList.get(i);
    if (f.delete) {
      faceList.remove(i);
    } 
  }
}

/* タブキー動作
void keyPressed() {
  if (key == TAB) {
    butterfly.add(new Butterfly());
  }
}
*/

void captureEvent(Capture c) {
  c.read();
}
