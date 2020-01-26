/*@pjs preload="./askOpens.txt, ./askHighs.txt, ./askLows.txt, ./askCloses.txt, ./bidOpens.txt, ./bidHighs.txt, ./bidLows.txt, ./bidCloses.txt";*/

final String dataDirectory = "./";
String[] Aopens, Ahighs, Alows, Acloses, Bopens, Bhighs, Blows, Bcloses, times;
int numCandles;

//for stats
float[] margins = {0, 0, 0, 0, 0, 0};
float[] float_profits = {0, 0, 0, 0, 0, 0};
float[] lots = {0, 0, 0, 0, 0, 0};
float[] in_price = {0, 0, 0, 0, 0, 0};
int[] BoS = {0, 0, 0, 0, 0, 0};  //1 = sell, 2 = buy
int num_order = 0;
Float equity;
//

//for draw chart
float price_per_px, center;


final int delay_time = 1000;
String server_stat;
float bid, ask, spread, ltp;
float balance = 1000000;
String time;
float lot;
int lot_size = 100000;
int leverage = 100;
int second, minute;
int nowCandle = 90;
void setup() {
  size(1900, 1010);
  getCandles();
  drawLayout();
}

void getCandles() {
  Aopens  = loadStrings(dataDirectory + "askOpens.txt");
  Ahighs  = loadStrings(dataDirectory + "askHighs.txt");
  Alows   = loadStrings(dataDirectory + "askLows.txt");
  Acloses = loadStrings(dataDirectory + "askCloses.txt");
  Bopens  = loadStrings(dataDirectory + "bidOpens.txt");
  Bhighs  = loadStrings(dataDirectory + "bidHighs.txt");
  Blows   = loadStrings(dataDirectory + "bidLows.txt");
  Bcloses = loadStrings(dataDirectory + "bidCloses.txt");
  times   = loadStrings(dataDirectory + "times.txt");
  numCandles = Aopens.length;
}

void draw() {
  getMarketData();
  drawLayout();
  drawMarketData();
  delay(delay_time);
  if (nowCandle == Aopens.length - 1) {
    return;
  }
  nowCandle ++;
}

void getMarketData() {
  bid = float(Bcloses[nowCandle]);
  ask = float(Acloses[nowCandle]);
  ltp = (bid + ask) / 2;
  spread = ask - bid;
}

void drawLayout() {
  background(30, 30, 30);
  fill(50, 50, 50);
  stroke(220, 220, 220);
  line(0, 160, 1600, 160);
  line(250, 0, 250, 160);
  line(500, 0, 500, 160);
  line(1600, 0, 1600, 800);
  line(0, 800, 1901, 800);
  line(1500, 160, 1500, 800);
  //rect(1400, 160, 100, 30);    //+,-
  //line(1450, 160, 1450, 190);
  rect(-1, 800, 1901, 30);     //stats
  for (int y = 860; y <= height; y += 30) {
    line(-1, y, 1901, y);
  }
  rect(150, 0, 200, 40);       //lot
  line(650, 0, 650, 160);
  rect(500, 0, 150, 40);
  line(575, 40, 575, 160);
  line(500, 80, 650, 80);
  line(500, 120, 650, 120);
  line(1600, 40, 1900, 40);
  textAlign(CENTER, CENTER);
  fill(255, 255, 255);
  textSize(30);
  text("bid", 75, 20);
  text("ask", 425, 20);
  text("Trade History", 1750, 20);
  textSize(22);
  text("+1", 535, 60);
  text("+0.1", 535, 100);
  text("+0.01", 537, 140);
  text("-1", 610, 60);
  text("-0.1", 610, 100);
  text("-0.01", 610, 140);
  textSize(20);
  //text("+", 1425, 175);
  //text("-", 1475, 175);
  textAlign(LEFT, CENTER);
  text("spread:", 170, 20);
  text("lot:", 520, 20);
  text("positions", 10, 845);
  textAlign(CENTER, CENTER);
  text("push to close", 1800, 845);
  line(1700, 830, 1700, height);
}


void drawMarketData() {
  drawHistory();
  drawBidAskSpreadEtc();
  drawStats();
  drawChart();
}

void drawHistory() {
  textSize(20);
  int txheight = 50;
  //draw
  for (int i = nowCandle; i > nowCandle - 37; i--) {
    textAlign(RIGHT, TOP);
    text(times[i].substring(11, 19), 1880, txheight);
    textAlign(LEFT, TOP);
    text(Bcloses[i], 1620, txheight);
    txheight += 20;
  }
  txheight = 50;
}

void drawBidAskSpreadEtc() {
  String server = "tradeable";
  textSize(30);
  textAlign(CENTER, TOP);
  text(bid, 125, 80);
  text(ask, 375, 80);
  textSize(20);
  textAlign(RIGHT, CENTER);
  text(spread, 320, 20);
  textAlign(RIGHT, TOP);
  text("server time(UTC): " + times[nowCandle], 1590, 0);
  text("server stat: " + server, 1590, 30);
  textAlign(LEFT, CENTER);
  text(nf(lot, 2, 2), 570, 20);
}


float margin_level;
//draw and calc stats and each position stat
void drawStats() {
  float margin_sum = 0;
  float float_profit_sum = 0;
  float free_margin, margin_level;
  int loss_cut_rate = 30;
  String currency_pair = "GBP/JPY";
  //calc some stats
  calcFloatProfit();
  for (int i = 0; i <= margins.length - 1; i++) {
    margin_sum += margins[i];
    float_profit_sum += float_profits[i];
  }
  equity = balance + float_profit_sum;
  free_margin = equity - margin_sum;

  //draw stats
  if (margin_sum == 0) {
    textAlign(LEFT, CENTER);
    text("Balance: " + balance +
      "              Equity: "       + equity +
      "              Margin: "       + margin_sum +
      "              Free margin: "  + free_margin +
      "              Margin level: ", 
      10, 815);
  } else {
    margin_level = equity / margin_sum * 100;
    //loss cut 
    if (margin_level < loss_cut_rate) {
      balance += float_profit_sum;
      equity = balance;
      for (int i = 0; i <= margins.length - 1; i++) {
        margins[i] = 0;
        float_profits[i] = 0;
        lots[i] = 0;
        in_price[i] = 0;
        num_order = 0;
        textAlign(LEFT, BOTTOM);
        noStroke();
        fill(230, 0, 0);
        text("YOUR POSITIONS ARE LOSSCUTED FOR PROTECTING FROM TOO MUCH MINUS BALANCE", 200, 860);
        fill(255);
      }
    }

    textAlign(LEFT, CENTER);
    if (margin_level < 150) {
      fill(255, 240, 0);
    }
    if (margin_level < 100) {
      fill(230, 0, 0);
    } 
    text("Balance: " + balance +
      "              Equity: "       + equity +
      "              Margin: "       + margin_sum +
      "              Free margin: "  + free_margin +
      "              Margin level: " + margin_level + "%", 
      10, 815);
    fill(255);
  }

  //draw position stats
  int y = 860;
  String space = "          ";
  for (int i = 0; i < num_order; i++) {
    String BS = "0";
    if (BoS[i] == 1) {
      BS = "sell";
    } else if (BoS[i] == 2) {
      BS = "buy";
    }
    textAlign(LEFT, TOP);
    text(currency_pair + space + BS + space + "at" + space + in_price[i] + space + "x" + space + lots[i] + space + "profit: " + float_profits[i], 10, y);
    textAlign(CENTER, TOP);    
    text("CLOSE", 1800, y);
    y += 30;
  }
}

void calcFloatProfit() {
  for (int i = 0; i < num_order; i++) {
    if (BoS[i] == 1) {                                        //when sell position
      float_profits[i] = (in_price[i] - ask) * lots[i] * lot_size;
    } else if (BoS[i] == 2) {                                 //when buy position
      float_profits[i] = (bid - in_price[i]) * lots[i] * lot_size;
    }
  }
}

float lowest = 10000;
float highest = 0;

void drawChart() {
  int offset = 185;
  float nowX = 1390;
  float oY, hY, lY, cY;  //distance from height(px)
  //search highest and lowest price in a chart
  lowest = 10000;
  highest = 0;
  for (int i = nowCandle; i > nowCandle - 90; i--) {
    if (float(Bhighs[i]) >= highest) {
      highest = float(Bhighs[i]);
    }
    if (float(Blows[i]) <= lowest) {
      lowest = float(Blows[i]);
    }
  }  
  getPriceHeightPerPx();
  float bidY = ((highest - bid) / price_per_px) + offset;
  float askY = ((highest - ask) / price_per_px) + offset;
  float highestY = ((highest - highest) / price_per_px) + offset;
  float lowestY = ((highest - lowest) / price_per_px) + offset;
  stroke(230);
  line(0, highestY, 1500, highestY);
  line(0, lowestY, 1500, lowestY);
  stroke(30, 30, 30);
  fill(255);
  textAlign(LEFT, CENTER);
  text(highest, 1502, highestY);
  text(lowest, 1502, lowestY);  
  rectMode(CENTER);
  //when askY bigger than 165, draw ask line and price
  if (askY > offset + 5) {
    fill(230, 0, 0);
    noStroke();
    rect(1552, askY, 95, 23);
    fill(0);
    text(ask, 1502, askY);
    stroke(200, 0, 0);
    line(0, askY, 1500, askY);
  }
  noStroke();
  fill(150, 150, 150);
  rect(1552, bidY, 95, 23);
  fill(0);
  text(bid, 1502, bidY);
  stroke(128);
  line(0, bidY, 1500, bidY);

  for (int i = nowCandle; i > nowCandle - 90; i--) {
    //get distance(px) from Y = 0(each candle)
    oY = ((highest - float(Bopens[i]))  / price_per_px) + offset;
    hY = ((highest - float(Bhighs[i]))  / price_per_px) + offset;
    lY = ((highest - float(Blows[i]))   / price_per_px) + offset;
    cY = ((highest - float(Bcloses[i])) / price_per_px) + offset;
    if (float(Bopens[i]) > float(Bcloses[i])) {
      fill(255);
    } else {
      fill(30, 30, 30);
    }

    rectMode(CORNERS);
    stroke(31, 255, 32);
    line(nowX + 5.55, hY, nowX + 5.55, lY);
    rect(nowX, oY, nowX + 10, cY);
    nowX -= 15;
  }
  textAlign(LEFT, CENTER);
  rectMode(CORNER);
}

void getPriceHeightPerPx() {  
  float price_range;

  float highest = 0, lowest = 10000;
  for (int i = nowCandle; i > nowCandle - 90; i--) {
    if (highest < float(Bhighs[i])) {
      highest = float(Bhighs[i]);
    }
    if (lowest > float(Blows[i])) {
      lowest = float(Blows[i]);
    }
  }
  price_range  = highest - lowest;
  price_range  = float(round(price_range * pow(10, 3))) / pow(10, 3);
  price_per_px = price_range / 680;
  price_per_px *= 1.15;
  center = (highest + lowest) / 2;
}


//click event
void mousePressed() {
  if (lot > 0 && num_order < 5) {  // when lot > 0 number of orders under 5
    if (mouseX >= 0 && mouseX <= 249 && mouseY >= 40 && mouseY <= 160 || mouseX >= 0 && mouseX <= 150 && mouseY >= 0 && mouseY <= 39) {    // when bid is pressed = sell
      openOrder(1);
    } else if (mouseX >= 251 && mouseX <= 449 && mouseY >= 40 && mouseY <= 160 || mouseX >= 0 && mouseX <= 150 && mouseY >= 0 && mouseY <= 39) {  //when ask is pressed = buy
      openOrder(2);
    }
  }

  //when position closed
  if (mouseX >= 1700 && mouseX <= width && mouseY >= 860 && mouseY <= 889) {
    closeOrder(0);
  } else if (mouseX >= 1700 && mouseX <= width && mouseY >= 891 && mouseY <= 919) {
    closeOrder(1);
  } else if (mouseX >= 1700 && mouseX <= width && mouseY >= 921 && mouseY <= 949) {
    closeOrder(2);
  } else if (mouseX >= 1700 && mouseX <= width && mouseY >= 951 && mouseY <= 979) {
    closeOrder(3);
  } else if (mouseX >= 1700 && mouseX <= width && mouseY >= 981 && mouseY <= height) {
    closeOrder(4);
  }
  //when position closed

  //when lot changed
  if (mouseX >= 501 && mouseX <= 574 && mouseY >= 41 && mouseY <= 79) {             //when +1 pressed
    changeLot(1);
  } else if (mouseX >= 501 && mouseX <= 574 && mouseY >= 81 && mouseY <= 119) {     //when +0.1 pressed
    changeLot(0.1);
  } else if (mouseX >= 501 && mouseX <= 574 && mouseY >= 121 && mouseY <= 159) {    //when +0.01 pressed
    changeLot(0.01);
  }

  if (lot > 0) {
    if (mouseX >= 576 && mouseX <= 749 && mouseY >= 41 && mouseY <= 79) {             //when -1 pressed
      changeLot(-1);
    } else if (mouseX >= 576 && mouseX <= 749 && mouseY >= 81 && mouseY <= 119) {     //when -0.1 pressed
      changeLot(-0.1);
    } else if (mouseX >= 576 && mouseX <= 749 && mouseY >= 121 && mouseY <= 159) {    //when -0.01 pressed
      changeLot(-0.01);
    }
  }
  //when lot changed
}


void openOrder(int orderType) { //orderType = buy or sell, 1 = sell, 2 = buy
  float margin_sum = 0;
  float neededMargin = 0;

  if (orderType == 1) {
    neededMargin = bid * lot * lot_size / leverage;
  } else if (orderType == 2) {
    neededMargin = ask * lot * lot_size / leverage;
  }

  for (int i = 0; i <= margins.length - 1; i++) {
    margin_sum += margins[i];
  }

  //margin is enough or not
  if (equity - (margin_sum + neededMargin) < 0) {
    textAlign(LEFT, BOTTOM);
    fill(230, 0, 0);
    noStroke();
    text("WARING: " + "margin isn't enough ", 200, 860);
    fill(255);
    return;
  }

  if (orderType == 1) {
    in_price[num_order] = bid;
    BoS[num_order] = 1;
  } else if (orderType == 2) {
    in_price[num_order] = ask;
    BoS[num_order] = 2;
  }

  margins[num_order] = neededMargin;
  lots[num_order] = lot;
  num_order ++;
  drawLayout();
  drawMarketData();
}

void closeOrder(int idx) {
  for (int i = idx; i <= 4; i++) {
    balance    += float_profits[i];
    in_price[i] = in_price[i + 1];
    margins[i]  = margins[i + 1];
    BoS[i]      = BoS[i + 1];
    lots[i]     = lots[i + 1];
    float_profits[i] = 0;
  }
  num_order --;
  drawLayout();
  drawMarketData();
}

void changeLot(float change) {
  lot = lot + change;
  lot = float(round(lot * pow(10, 2))) / pow(10, 2);
  drawLayout();
  drawMarketData();
}
