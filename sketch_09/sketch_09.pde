Table data;
float[] educationValues, gdpValues;
float eduMin, eduMax, gdpMin, gdpMax;

boolean showLabel = false;

float scaleFactor = 1, translateX = 0;

// DRAW
int margin = 100;

void setup() {
  size(800, 700);
  getData();
}

void draw() {
  background(255);
  
  surface.setTitle(int(frameRate) + " fps - " + frameCount + " frames" );
  if(scaleFactor <= 1) {
    scaleFactor = 1;
  }
  if(translateX >= 0) {
    translateX = 0;
  }
  pushMatrix();
  translate(translateX, 0);
  drawGUI();
  drawData();
  popMatrix();
}

void drawGUI() {
  fill(127);
  stroke(200);
  // ASSI X e Y
  line(margin, margin, margin, height - margin);
  line(margin, height - margin, width - margin, height - margin);
  
  // Linee di riferimento education
  for(int i = round(eduMin); i <= round(eduMax); i++) {
    if(i % 5 == 0) {
      stroke(200, 60);
      float yPos = map(i, eduMin, eduMax, height - margin - 10, margin + 10);
      textAlign(RIGHT, CENTER);
      text(i + "%", margin - 5, yPos - 1);
      line(margin, yPos, width - margin, yPos);
    }
  }
  
  // Linee di riferimento gdp
  for(int i = round(gdpMin); i <= round(gdpMax); i++) {
    if(i % 10000 == 0) {
      float xPos = map(i, gdpMin, gdpMax, margin + 10, width - margin - 10);
      textAlign(CENTER, TOP);
      text(i, xPos, height - margin + 5);
      line(xPos, margin, xPos, height - margin);
    }
  }
  
  // LABELS
  textAlign(RIGHT, CENTER);
  pushMatrix();
  rotate(-HALF_PI);
  text("Education enrollment rate", -margin , margin/3);
  popMatrix();
  text("GDP in $US", width-margin, height - margin + (margin/2));
}

void drawData() {
  color[] palette = {
    #EAC435, // AFRICA
    #345995, // AMERICA
    #E40066, // ASIA
    #03CEA4, // EUROPE
    #FA7921, // OCEANIA
  };
  
  noStroke();

  for(int i = 0; i < data.getRowCount(); i++) {
    float xPos = map(gdpValues[i], gdpMin, gdpMax, margin + 10, (width - margin - 10)*scaleFactor);
    float yPos = map(educationValues[i], eduMin, eduMax, height - margin - 10, margin + 10);
    switch(data.getString(i, 0)) {
      case "Africa":
        fill(palette[0]);
      break;
      case "America":
        fill(palette[1]);
      break;
      case "Asia":
        fill(palette[2]);
      break;
      case "Europe":
        fill(palette[3]);
      break;
      case "Oceania":
        fill(palette[4]);
      break;
    }
    ellipse(xPos, yPos, 10, 10);
    if(showLabel) {
      textAlign(LEFT, CENTER);
      text(data.getString(i, 2), xPos + 10, yPos - 1);
    }
  }
}

void getData() {
  data = loadTable("data.csv", "header");
  // LEGENDA CSV
  // [0]REGION, [1]UN REGION, [2]COUTRY, [3]2006 % EDU, [4]2006 GPD
  // Controllo che i dati siano caricati
  // println(data.getRowCount());
  educationValues = new float[data.getRowCount()];
  gdpValues = new float[data.getRowCount()];
  
  for(int i = 0; i < data.getRowCount(); i++) {
    educationValues[i] = data.getFloat(i, 3);
    gdpValues[i] = data.getFloat(i, 4);
  }
  // Controllo che nell'array ci siano i valori giusti
  // printArray(educationValues);
  
  // Estraggo i valori min/max dagli array
  eduMin = min(educationValues);
  eduMax = max(educationValues);
  gdpMin = min(gdpValues);
  gdpMax = max(gdpValues);
}

void keyPressed() {
  if(key == 'l') {
    showLabel = !showLabel;
  }
  if(key == 'r') {
    scaleFactor = 1;
    translateX = 0;
  }
}

void mouseWheel(MouseEvent event) {
  scaleFactor += event.getCount()*0.1;
  println(scaleFactor);
}

void mouseDragged() {
  translateX += mouseX - pmouseX;
}