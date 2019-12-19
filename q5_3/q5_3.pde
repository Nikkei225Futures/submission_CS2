void setup(){
  size(500, 500);
  background(0);
}

void draw(){
  noStroke();
  fill(int(random(255)),
       int(random(255)),
       int(random(255))
       );
  
  ellipse(random(width),
          random(height),
          5, 5);
}
