//https://discourse.processing.org/t/water-simulation-updating-asymetrically/10885

int num_of_springs = 101;
Spring[] springs = new Spring[num_of_springs];

void setup() {
  size(1200, 640);
  fill(255, 126);

  for (int i = 0; i<=springs.length-1; i++) {
    springs[i] = new Spring(i*width/num_of_springs+20, height/2, 0, 80, .99, 0.99); //(xpos, ypos, gravity, mass, damping, spring_constant)
  }
}

void draw() {
  background(0);
  line(0, height/2, width, height/2);

  for (int i = 0; i<=springs.length-1; i++) {
    if (i==0) {
      springs[0].update(springs[0].x, springs[1].y);
      springs[0].update(springs[0].x, height/2);
    } else if (i==springs.length-1) {
      springs[springs.length-1].update(springs[springs.length-1].x, springs[springs.length-2].y);
      springs[springs.length-1].update(springs[springs.length-1].x, height/2);
    } else {
      springs[i].update(springs[i-1].x, springs[i-1].y);
      springs[i].update(springs[i+1].x, springs[i+1].y);
      springs[i].update(springs[i].x, height/2);
    }
    springs[i].display();
  }

  if (keyPressed) {
    if (key == ' ') {            
      springs[springs.length/2].vy = 10;
    }
  }
}


class Spring {
  float vx, vy; 
  float x, y; 
  float gravity = 0;
  float mass = 0;
  float spring_constant = 0;
  float damping = 0;
  float target_x;
  float target_y;

  Spring(float xpos, float ypos, float gravity, float mass, float damping, float spring_constant) {
    x = xpos;
    y = ypos;
    this.gravity = gravity;
    this.mass = mass;
    this.spring_constant = spring_constant;
    this.damping = damping;
  }

  void update(float target_x, float target_y) { 

    line(x, y, target_x, target_y);
    this.target_x=target_x;
    this.target_y=target_y;

    float forceX = (target_x - x) * spring_constant;
    float ax = forceX / mass;
    vx = damping * (vx + ax);
    x += vx;

    float forceY = (target_y - y) * spring_constant;
    forceY += gravity;
    float ay = forceY / mass;
    vy = damping * (vy + ay);
    y += vy;

    if (abs(vy) < 0.01) {
      vy = 0.0;
    }
    if (abs(vx) < 0.01) {
      vx = 0.0;
    }
  }

  void display() {
    fill(255, 100);
    stroke(255);
    line(x, y, target_x, target_y);
    ellipse(x, y, 10, 10 );
    noFill();
  }
}
