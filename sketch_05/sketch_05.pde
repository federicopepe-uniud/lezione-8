Table data;
float[] educationValues, gdpValues;
float eduMin, eduMax, gdpMin, gdpMax;

// DRAW
int margin = 100;

void setup() {
  size(800, 700);
  background(255);
  getData();
  drawGUI();
  drawData();
}

void draw() {
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
    float xPos = map(gdpValues[i], gdpMin, gdpMax, margin + 10, width - margin - 10);
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