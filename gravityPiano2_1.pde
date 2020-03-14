/****
by erazedfx
*/

import themidibus.*;

String midiOut = "Nord";
float dampLow = 0.65;
float dampHigh = 0.9;
float wallDamp = 0.99;

int maxVel = 100;
int maxGroundTime = 300;
int[] scale = {0, 2, 3, 7, 14, 15 }; 
int[][] chord =  {{0, 2, 3, 7, 14, 15 }, {3, 5, 7, 10, 15, 19 },{0, 2, 4, 6, 8, 10 }};
//int[][] chord =  {{0, 3, 7,10 }, {3, 7, 10 },{5,8,12}};
int scaleOct = 4;
float windLevelH = 4;
float windLevelV = 0.2 * 1.3;

boolean applyWind = true; 


MidiBus myBus;
PVector gravity, wind, acc;
color c;

float t = 0;
int chordIndex = 0;


ArrayList<Ball> balls;
void setup() {
  scale = chord[chordIndex];
  frameRate(60);
  println("frame rate: " + frameRate);
  size(600, 1000);

  gravity = new PVector(0, 0.2);
  wind = new PVector(random(-0.1, 0.1), 0);
  println("wind level: " + wind.x);

  balls = new ArrayList<Ball>();
  myBus = new MidiBus(this, 0, midiOut);
}

void draw() {
  background(255);

  //if (random(0, 1) < (0.1 / frameRate)) changeChord();

  float noiseX = map(noise(t * 0.5), 0, 1, -windLevelH, windLevelH);
  float noiseY = map(noise(t + 1), 0, 1, -windLevelV, windLevelV);
  wind = new PVector(noiseX, noiseY);
  pushMatrix();

  colorMode(HSB);
  fill(150, 180, 180, map(abs(noiseX), 0, windLevelH, 0, 180));
  noStroke();
  rect(width/2, 20, map(wind.x, -windLevelH, windLevelH, -width / 2, width / 2), 10);
  fill(150, 180, 180, map(abs(noiseY), -windLevelV, windLevelV, 0, 180));
  rect(20, height /2, 10, map(wind.y, -windLevelV, windLevelV, -height / 2, height / 2));

  popMatrix();
  if (balls.size() > 0) {
    for (int i = 0; i < balls.size(); i++) {

      Ball ball = balls.get(i);
      ball.applyForce(gravity);
      if (applyWind)
        ball.applyForceWeighted(wind);

      if (ball.update()) {
        ball.show();
      } else {
        balls.remove(i);
        i = 1 - 1;
        println("ball removed, total " + balls.size());
      }
    }
  }
  t += 0.01 * 0.5;
}

void mousePressed() {
  balls.add(new Ball());
  println("ball added, total " + balls.size());
}

void keyPressed() {
  if (key == ' ') {
    changeChord();
  }
}
