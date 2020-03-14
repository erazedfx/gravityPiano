
class Ball {
  PVector location;
  PVector velocity;
  color col;
  int note;
  int vel;
  float mass;
  //boolean isGrounded = false;
  int groundTime = 0;
  Ball() {
    location = new PVector(mouseX, mouseY);
    mass = map(mouseY, height, 0 + 40, 0, random(0.95, 1));
    velocity = new PVector(random(-2, 2), random(0, 1) * 1);
    note = mapNote(map(location.x, 0, width, 0, 1));
    vel = floor(map(abs(velocity.y), 0, 10, 0, maxVel));
    colorMode(HSB);
    //int alpha = round(map(velocity.y,0,2,0,255));
    col = color(random(255), 255, 255, 255);
  }
  void applyForce(PVector force) {
    velocity.add(force);
  }
  void applyForceWeighted(PVector force) {
   
    velocity.add(PVector.mult(force,1 - mass));
  }
  boolean update() {


    location.add(velocity);


    if (location.x < 0 ) {
      velocity.x = velocity.x * -1 * wallDamp;
      location.x = 0;
      // println("turn");
    }
    if (location.x > width ) {
      velocity.x = velocity.x *  -1 * wallDamp;
      location.x = width;
      //  println("turn");
    }

    if (location.y < 0) {
      velocity.y = velocity.y * -1 * wallDamp;
      location.y = 0;
    }
    if (location.y >= height) bounce();
    //  println(location.x);

    if (velocity.y < 0.5 && location.y >= height) {
      groundTime++;
    }

    if (groundTime > maxGroundTime) return false;
    else return true;
  }
  void bounce() {

    //  println(velocity.y);
    // velocity.mult(-1 * 0.8);
    velocity.y *=  -0.99 * map(location.x, 0, width, dampLow, dampHigh);

    if (abs(velocity.y) >= 0.4) {
      note = mapNote(map(location.x, 0, width, 0, 1));
      vel = floor(map(abs(velocity.y), 0, 10, 0, maxVel));

      colorMode(HSB);
      int alpha = round(map(vel, 0, maxVel, 0, 255));
      col = color(hue(col), saturation(col), brightness(col), alpha);
      myBus.sendNoteOn(0, note, vel );
    } else
    {
      //   myBus.sendNoteOff(0,note,vel);
    }
    location.y = height;
  }
  void show() { 
    fill(col);
    noStroke();
    int size = floor(map(mass, 0, 1, 10, 40));
    ellipse(location.x, location.y, size, size);
  }
}


int mapNote(float in) {
  int root = 36;
  //int[] scale = {0, 2, 3, 7, 8}; //jp

  int noteCount = scale.length * scaleOct;

  in = constrain(in, 0, 1);
  int x = round(map(in, 0, 1, 0, noteCount));

  int i = x % scale.length;
  int iOct = x / scale.length;
  int note = scale[i] + 12 * iOct + root;
  return note;
}

void changeChord() {
  if (chordIndex >= (chord.length - 1)) chordIndex = 0;
  else chordIndex++;
  scale = chord[chordIndex];
  println("change chord: " + chordIndex);
}
