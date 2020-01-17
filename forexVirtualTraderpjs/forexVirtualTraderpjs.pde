/*be careful of limits of calling rest api. 
 if over 120 request per 1 second from same ip address,
 using api will be restricted or banned.
 api data is served as json.
 leverage = 100x
 order is available up to 5
 1 lot = 100,000USD
 */
//for getting datas from rest api
final String api_key = "48db3546e09e037c829ce0507b4da944-0e75d408b9e2bb35a1e98a3409506871";
final String accID = "101-001-12970645-001";
String currency_pair = "GBP_JPY";
String granularity = "M1";
String num_candles = "90";
//

//for shell func
StringList strout = new StringList();
StringList strerr = new StringList();
//for shell func

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
double[] candle_sticks   = new double[90];
ArrayList<Float> opens  = new ArrayList();
ArrayList<Float> highs  = new ArrayList();
ArrayList<Float> lows   = new ArrayList();
ArrayList<Float> closes = new ArrayList();
float price_per_px, center;

final int delay_time = 10;
boolean server_stat;
float bid, ask, spread, ltp, balance = 1000000;
ArrayList<Float> price_history = new ArrayList();
ArrayList<String> time_history = new ArrayList<String>();
String time;
float lot;
int lot_size = 100000;
int leverage = 100;
int second, minute;

void setup() {
  size(1900, 1010);
  //getBalance();
  getCandles();
  drawLayout();
}


void getCandles() {
  int i, j;
  String urls = "curl -H \"Authorization: Bearer " + api_key + "\" \"" + "https://api-fxpractice.oanda.com/v3/accounts/" + accID + "/instruments/" + currency_pair + "/candles?granularity=" + granularity + "&count=" + num_candles + "\"";
  String outFile = " > /home/scinfo23/230373g/local_html/web-export/ohlc.json";
  String ohlc_data = "/home/scinfo23/230373g/local_html/web-export/ohlc.json";
  String getOHLC = urls + outFile;
  JsonObject candle_datas = new JsonObject();
  JsonObject mid = new JsonObject();
  JsonObject tmp = new JsonObject();
  JsonArray candles = new JsonArray();
  float open = 0, high = 0, low = 0, close = 0;

  shell(strout, strerr, getOHLC);

  candle_datas.Load(ohlc_data);


  candles = candle_datas.GetJsonArray("candles");

  for (i = candles.Size() - 1, j = 0; i >= 0; i--, j++) {
    tmp = candles.GetJsonObject(i);
    mid = tmp.GetJsonObject("mid");
    open = mid.GetFloat("o", open);
    high = mid.GetFloat("h", high);
    low = mid.GetFloat("l", low);
    close = mid.GetFloat("c", close);
    //apiのOHLCは古い順から格納
    opens.add(j, open);
    highs.add(j, high);
    lows.add(j, low);
    closes.add(j, close);
  }
}

//main function
void draw() {
  minute = minute();
  getMarketData();
  drawLayout();
  drawMarketData();
  delay(delay_time);
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

//get bid, ask, ltp, timestamp from rest api(oanda.com)
void getMarketData() {
  JsonObject market_data = new JsonObject();
  JsonArray prices = new JsonArray();
  JsonObject tmp = new JsonObject();
  JsonArray bids = new JsonArray();
  JsonArray asks = new JsonArray();
  JsonObject bidsary = new JsonObject(); 
  JsonObject asksary = new JsonObject();
  String urls = "curl -H \"Authorization: Bearer " + api_key + "\" \"" + "https://api-fxpractice.oanda.com/v3/accounts/" + accID + "/pricing?instruments=" + currency_pair + "\"";
  String outFile = " > /home/scinfo23/230373g/local_html/web-export/ticker.json" ;
  String getPrice = urls + outFile;
  String ticker = "/home/scinfo23/230373g/local_html/web-export/ticker.json";  // file name of ticker data
  shell(strout, strerr, getPrice);
  market_data.Load(ticker);
  prices = market_data.GetJsonArray("prices");

  //get  time, bid, ask, server stat from json file
  for (int i = 0; i < prices.Size(); i++) {

    tmp = prices.GetJsonObject(i);
    time= tmp.GetString("time", time);
    asks = tmp.GetJsonArray("asks");
    bids = tmp.GetJsonArray("bids");

    //get bid, ask
    for (int j = 0; j < bids.Size(); j++) {

      bidsary = bids.GetJsonObject(j);
      asksary = asks.GetJsonObject(j);
      bidsary.GetFloat("price", bid);
      asksary.GetFloat("price", ask);
    }

    tmp.GetBoolean("tradeable", server_stat);
  }

  ltp = (bid + ask) / 2;
  spread = ask - bid;

  opens.set(0, closes.get(1));
  closes.set(0, bid);

  if (highs.get(0) <= bid) {
    highs.set(0, bid);
  }
  if (lows.get(0) >= bid) {
    lows.set(0, bid);
  }

  //create new candle stick when minute changed
  if (minute != minute()) {
    opens.add(0, 0.0);
    closes.add(0, bid);
    opens.set(0, closes.get(1));
    highs.add(0, 0.0);
    lows.add(0, 1000.0);

    if (highs.get(0) <= bid) {
      highs.set(0, bid);
    }
    if (lows.get(0) >= bid) {
      lows.set(0, bid);
    }

    //remove oldest candle stick
    opens.remove(90);
    highs.remove(90);
    lows.remove(90);
    closes.remove(90);
  }

  price_history.add(0, ltp);
  //time_history.add(0, time.substring(11, 22));
}

void drawMarketData() {
  drawHistory();
  drawBidAskSpreadEtc();
  drawStats();
  drawChart();
}

//draw price history
void drawHistory() {
  textSize(20);
  int txheight = 50;

  //adjust size of price history. 
  if (price_history.size() == 38) {
    price_history.remove(37);
  }
  if (time_history.size() == 38) {
    time_history.remove(37);
  }

  //draw
  for (float price_history : price_history) {
    textAlign(RIGHT, TOP);
    text(price_history, 1880, txheight);
    txheight+=20;
  }
  txheight = 50;
  for (String time_history : time_history) {
    textAlign(LEFT, TOP);
    text(time_history, 1620, txheight);
    txheight+=20;
  }
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
  /*text("server time(UTC): " +
   time.substring(0, 9) +
   "  " +
   time.substring(11, 22), 
   1590, 0);
   */
  //market closed or not
  if (server_stat == false) {
    server = "market closed, no orders available";
  }

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

void drawChart() {
  int offset = 185;
  float nowX = 1390;
  float oY, hY, lY, cY;  //distance from height(px)
  //search highest and lowest price in a chart
  lowest = 10000;
  highest = 0;
  for (int i = 0; i < 90; i++) {
    if (highs.get(i) >= highest) {
      highest = highs.get(i);
    }
    if (lows.get(i) <= lowest) {
      lowest = lows.get(i);
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

  for (int i = 0; i < 90; i++) {
    //get distance(px) from Y = 0(each candle)
    oY = ((highest - opens.get(i)) / price_per_px) + offset;
    hY = ((highest - highs.get(i))/ price_per_px) + offset;
    lY = ((highest - lows.get(i)) / price_per_px) + offset;
    cY = ((highest - closes.get(i) ) / price_per_px) + offset;
    if (opens.get(i) > closes.get(i)) {
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

float highest = 0, lowest = 10000;

void getPriceHeightPerPx() {  
  float price_range;

  for (float high : highs) {
    if ( highest < high ) {
      highest = high;
    }
  }
  for (float low : lows) {
    if ( lowest > low ) {
      lowest = low;
    }
  }

  price_range  = highest - lowest;
  price_range  = float(round(price_range * pow(10, 3))) / pow(10, 3);
  price_per_px = price_range / 680;
  price_per_px *= 1.15;
  center = (highest + lowest) / 2;
}



void printMarketData() {
  println(time.substring(11, 19) + "(UTC)");
  println("bid: " + bid);
  println("ask: " + ask);
  println("spr: " + spread);
  println("ltp: " + ltp);
  println("");
}


//click event
void mousePressed() {
  Float margin_sum = 0.0;
  if (lot > 0 && num_order < 5) {  // when lot > 0 number of orders under 5

    for (int i = 0; i <= margins.length - 1; i++) {
      margin_sum += margins[i];
    }

    if (mouseX >= 0 && mouseX <= 249 && mouseY >= 40 && mouseY <= 160 || mouseX >= 0 && mouseX <= 150 && mouseY >= 0 && mouseY <= 39) {    // when bid is pressed = sell
      //margin is enough or not
      if (equity - (margin_sum + (bid * lot * lot_size / leverage)) < 0) {
        textAlign(LEFT, BOTTOM);
        fill(230, 0, 0);
        noStroke();
        text("WARING: " + "margin isn't enough ", 200, 860);
        fill(255);
        return;
      }

      in_price[num_order] = bid;
      margins[num_order] = bid * lot * lot_size / leverage;
      BoS[num_order] = 1;
      lots[num_order] = lot;
      num_order ++;
      drawLayout();
      drawMarketData();
    } else if (mouseX >= 251 && mouseX <= 449 && mouseY >= 40 && mouseY <= 160 || mouseX >= 0 && mouseX <= 150 && mouseY >= 0 && mouseY <= 39) {  //when ask is pressed = buy

      //margin is enough or not
      if (equity - (margin_sum + (ask * lot *lot_size / leverage)) < 0) {
        textAlign(LEFT, BOTTOM);
        fill(230, 0, 0);
        noStroke();
        text("WARING: " + "margin isn't enough ", 200, 860);
        fill(255);
        return;
      }

      in_price[num_order] = ask;
      margins[num_order] = ask * lot * lot_size / leverage;
      BoS[num_order] = 2;
      lots[num_order] = lot;
      num_order ++;
      drawLayout();
      drawMarketData();
    }
  }

  //when position closed
  if (mouseX >= 1700 && mouseX <= width && mouseY >= 860 && mouseY <= 889) {
    for (int i = 0; i <= 4; i++) {
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
  } else if (mouseX >= 1700 && mouseX <= width && mouseY >= 891 && mouseY <= 919) {
    for (int i = 1; i <= 4; i++) {
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
  } else if (mouseX >= 1700 && mouseX <= width && mouseY >= 921 && mouseY <= 949) {
    for (int i = 2; i <= 4; i++) {
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
  } else if (mouseX >= 1700 && mouseX <= width && mouseY >= 951 && mouseY <= 979) {
    for (int i = 3; i <= 4; i++) {
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
  } else if (mouseX >= 1700 && mouseX <= width && mouseY >= 981 && mouseY <= height) {
    for (int i = 4; i <= 4; i++) {
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
  //when position closed

  //when lot changed
  if (mouseX >= 501 && mouseX <= 574 && mouseY >= 41 && mouseY <= 79) {   //when +1 pressed
    lot += 1;
    lot = float(round(lot * pow(10, 2))) / pow(10, 2);
    drawLayout();
    drawMarketData();
  } else if (mouseX >= 501 && mouseX <= 574 && mouseY >= 81 && mouseY <= 119) {  //when +0.1 pressed
    lot += 0.1;
    lot = float(round(lot * pow(10, 2))) / pow(10, 2);
    drawLayout();
    drawMarketData();
  } else if (mouseX >= 501 && mouseX <= 574 && mouseY >= 121 && mouseY <= 159) {  //when +0.01 pressed
    lot += 0.01;
    lot = float(round(lot * pow(10, 2))) / pow(10, 2);
    drawLayout();
    drawMarketData();
  }

  if (lot > 0) {
    if (mouseX >= 576 && mouseX <= 749 && mouseY >= 41 && mouseY <= 79) {   //when -1 pressed
      lot -= 1;
      lot = float(round(lot * pow(10, 2))) / pow(10, 2);
      drawLayout();
      drawMarketData();
    } else if (mouseX >= 576 && mouseX <= 749 && mouseY >= 81 && mouseY <= 119) {  //when -0.1 pressed
      lot -= 0.1;
      lot = float(round(lot * pow(10, 2))) / pow(10, 2);
      drawLayout();
      drawMarketData();
    } else if (mouseX >= 576 && mouseX <= 749 && mouseY >= 121 && mouseY <= 159) {  //when -0.01 pressed
      lot -= 0.01;
      lot = float(round(lot * pow(10, 2))) / pow(10, 2);
      drawLayout();
      drawMarketData();
    }
  }
  //when lot changed
}



/*
 OriginalJSONUtility
 Author : Gamu2059 (https://github.com/Gamu2059)
 Creation Date : 2018/01/22
 Version : 1.0.0
 */
public final class JsonArray extends JsonUtility {
  private ArrayList<String> _elem;

  public JsonArray() {
    _elem = new ArrayList<String>();
  }

  public JsonArray(String path) {
    this();
    Load(path);
  }

  public boolean IsNull() {
    return _elem == null;
  }

  public boolean IsEmpty() {
    return _elem.isEmpty();
  }

  public String GetString(int index, String defaultValue) {
    if (IsNull()) {
      return defaultValue;
    }

    if (_elem.size()<=index) {
      return defaultValue;
    }
    String obj = _elem.get(index);
    if (obj == null) {
      return defaultValue;
    }

    if (!_IsProper(obj, stringToken, stringToken)) {
      return defaultValue;
    }
    return _RemoveEscape(_RemoveSideString(obj));
  }

  public int GetInt(int index, int defaultValue) {
    if (IsNull()) {
      return defaultValue;
    }

    if (_elem.size()<=index) {
      return defaultValue;
    }
    String obj = _elem.get(index);
    if (obj == null) {
      return defaultValue;
    }
    return int(obj);
  }

  public float GetFloat(int index, float defaultValue) {
    if (IsNull()) {
      return defaultValue;
    }

    if (_elem.size()<=index) {
      return defaultValue;
    }
    String obj = _elem.get(index);
    if (obj == null) {
      return defaultValue;
    }
    return float(obj);
  }

  public boolean GetBoolean(int index, boolean defaultValue) {
    if (IsNull()) {
      return defaultValue;
    }

    if (_elem.size()<=index) {
      return defaultValue;
    }
    String obj = _elem.get(index);
    if (obj == null) {
      return defaultValue;
    }
    return boolean(obj);
  }

  public JsonObject GetJsonObject(int index) {
    if (IsNull()) {
      return null;
    }
    if (_elem.size()<=index) {
      return null;
    }
    String obj = _elem.get(index);
    if (obj == null) {
      return null;
    }
    JsonObject jsonObj = new JsonObject();
    jsonObj.Parse(obj);
    return jsonObj;
  }

  public JsonArray GetJsonArray(int index) {
    if (IsNull()) {
      return null;
    }

    if (_elem.size()<=index) {
      return null;
    }
    String obj = _elem.get(index);
    if (obj == null) {
      return null;
    }
    JsonArray jsonArray = new JsonArray();
    jsonArray.Parse(obj);
    return jsonArray;
  }

  /**
   各パラメーターの追加
   */
  public void AddString(String elem) {
    AddElement(stringToken + elem + stringToken);
  }

  public void AddInt(int elem) {
    AddElement(elem);
  }

  public void AddFloat(float elem) {
    AddElement(elem);
  }

  public void AddBoolean(boolean elem) {
    AddElement(elem);
  }

  public void AddJsonObject(JsonObject elem) {
    AddElement(elem);
  }

  public void AddJsonArray(JsonArray elem) {
    AddElement(elem);
  }

  private void AddElement(Object elem) {
    _elem.add(elem.toString());
  }

  /**
   各パラメーターの設定
   */
  public void SetString(int index, String elem) {
    SetElement(index, stringToken + elem + stringToken);
  }

  public void SetInt(int index, int elem) {
    SetElement(index, elem);
  }

  public void SetFloat(int index, float elem) {
    SetElement(index, elem);
  }

  public void SetBoolean(int index, boolean elem) {
    SetElement(index, elem);
  }

  public void SetJsonObject(int index, JsonObject elem) {
    SetElement(index, elem);
  }

  public void SetJsonArray(int index, JsonArray elem) {
    SetElement(index, elem);
  }

  private void SetElement(int index, Object elem) {
    int elemSize=Size();
    if (index < 0) {
      println("IndexOutOfBoundsException : " + index);
    } else {
      if (elemSize <= index) {
        for (int i=index-elemSize; 0<=i; i--) {
          _elem.add(null);
        }
      }
      _elem.set(index, elem.toString());
    }
  }

  public void RemoveElement(int index) {
    _elem.remove(index);
  }

  public void ClearElements() {
    _elem.clear();
  }

  public int Size() {
    return _elem.size();
  }

  /**
   指定した文字列からデータを生成し、それを自身に格納する。
   */
  public void Parse(String jsonContents) {
    if (jsonContents == null) return;

    // 最初が '[' 最後が ']' でなければ生成しない
    if (!_IsProper(jsonContents, beginArrayToken, endArrayToken)) return;

    _elem = _Split(trim(_RemoveSideString(jsonContents)));
  }

  /**
   Json文字列を ',' で区切ってリストで返す。
   */
  protected ArrayList<String> _Split(String jsonContents) {
    ArrayList<String> jsonPair = new ArrayList<String>();
    boolean isLiteral = false;
    int arrayDepth = 0, objectDepth = 0;
    char temp;
    int lastSplitIdx = 0;

    if (jsonContents.length()!=0) {
      for (int i=0; i<jsonContents.length(); i++) {
        temp = jsonContents.charAt(i);

        if (temp == stringToken) {
          if (i == 0 || jsonContents.charAt(i - 1) != escapeToken) {
            isLiteral = !isLiteral;
          }
        }
        if (!isLiteral) {
          if (temp == beginArrayToken) {
            arrayDepth++;
          } else if (temp == endArrayToken) {
            arrayDepth--;
          } else if (temp == beginObjectToken) {
            objectDepth++;
          } else if (temp == endObjectToken) {
            objectDepth--;
          }
        }

        if (temp == commaToken && !isLiteral && arrayDepth==0 && objectDepth == 0) {
          String elem=trim(jsonContents.substring(lastSplitIdx, i));
          if (elem.equals("null")) {
            elem=null;
          }
          jsonPair.add(elem);
          lastSplitIdx = i + 1;
        }
      }
      jsonPair.add(trim(jsonContents.substring(lastSplitIdx)));
    }
    return jsonPair;
  }

  public String toString() {
    try {
      String elem;
      String[] product = new String[_elem.size()];
      for (int i=0; i<_elem.size(); i++) {
        elem = _elem.get(i);
        if (elem == null) {
          continue;
        }
        product[i] = elem;
      }
      return beginArrayToken + newLineToken + join(product, ",\n") + newLineToken + endArrayToken;
    } 
    catch(Exception e) {
      println(e);
      println("JsonArray can not express oneself!");
      return null;
    }
  }
}
public final class JsonObject extends JsonUtility {
  private HashMap<String, String> _elem;
  private ArrayList<String> _names;

  public JsonObject() {
    _elem = new HashMap<String, String>();
    _names = new ArrayList<String>();
  }

  public JsonObject(String path) {
    this();
    Load(path);
  }

  public boolean IsNull() {
    return _elem == null;
  }

  public boolean IsEmpty() {
    return _elem.isEmpty();
  }

  public boolean HasKey(String name) {
    return _elem.containsKey(name);
  }

  public String GetString(String name, String defaultValue) {
    if (IsNull()) {
      return defaultValue;
    }

    String obj = _elem.get(name);
    if (obj == null) {
      return defaultValue;
    }

    if (!_IsProper(obj, stringToken, stringToken)) {
      return defaultValue;
    }
    return _RemoveEscape(_RemoveSideString(obj));
  }

  public int GetInt(String name, int defaultValue) {
    if (IsNull()) {
      return defaultValue;
    }

    String obj = _elem.get(name);
    if (obj == null) {
      return defaultValue;
    }
    return int(obj);
  }

  public float GetFloat(String name, float defaultValue) {
    if (IsNull()) {
      return defaultValue;
    }

    String obj = _elem.get(name);
    if (obj == null) {
      return defaultValue;
    }
    return float(obj);
  }

  public boolean GetBoolean(String name, boolean defaultValue) {
    if (IsNull()) {
      return defaultValue;
    }

    String obj = _elem.get(name);
    if (obj == null) {
      return defaultValue;
    }
    return boolean(obj);
  }

  public JsonObject GetJsonObject(String name) {
    if (IsNull()) {
      return null;
    }

    String obj = _elem.get(name);
    if (obj == null) {
      return null;
    }
    JsonObject jsonObj = new JsonObject();
    jsonObj.Parse(obj);
    return jsonObj;
  }

  public JsonArray GetJsonArray(String name) {
    if (IsNull()) {
      return null;
    }

    String obj = _elem.get(name);
    if (obj == null) {
      return null;
    }
    JsonArray jsonArray = new JsonArray();
    jsonArray.Parse(obj);
    return jsonArray;
  }

  public void SetString(String name, String elem) {
    SetElement(name, stringToken + elem + stringToken);
  }

  public void SetInt(String name, int elem) {
    SetElement(name, elem);
  }

  public void SetFloat(String name, float elem) {
    SetElement(name, elem);
  }

  public void SetBoolean(String name, boolean elem) {
    SetElement(name, elem);
  }

  public void SetJsonObject(String name, JsonObject elem) {
    SetElement(name, elem);
  }

  public void SetJsonArray(String name, JsonArray elem) {
    SetElement(name, elem);
  }

  private void SetElement(String name, Object elem) {
    if (!HasKey(name)) {
      _names.add(name);
    }
    _elem.put(name, elem.toString());
  }

  /**
   指定した文字列からデータを生成し、それを自身に格納する。
   */
  public void Parse(String jsonContents) {
    if (jsonContents == null) return;

    // 最初が '{' 最後が '}' でなければ生成しない
    if (!_IsProper(jsonContents, beginObjectToken, endObjectToken)) {
      return;
    }

    _elem.clear();
    _names.clear();

    ArrayList<String> jsonPair = _Split(_RemoveSideString(jsonContents));
    String[] pair = new String[2];
    char temp;

    for (int i=0, end=jsonPair.size(); i<end; i++) {
      String jsonElem = jsonPair.get(i);

      for (int j=0, end2=jsonElem.length(); j<end2; j++) {
        temp = jsonElem.charAt(j);

        if (temp == colonToken) {
          pair[0] = trim(jsonElem.substring(0, j));
          pair[1] = trim(jsonElem.substring(j+1));


          if (_IsProper(pair[0], stringToken, stringToken)) {
            pair[0] = _RemoveSideString(pair[0]);
          } else {
            println("Inappropriate name. There in no \"");
            continue;
          }
          if (pair[1].equals("null")) {
            pair[1]=null;
          }
          SetElement(pair[0], pair[1]);
          break;
        }
      }
    }
  }

  /**
   Json文字列を ',' で区切ってリストで返す。
   */
  protected ArrayList<String> _Split(String jsonContents) {
    ArrayList<String> jsonPair = new ArrayList<String>();
    boolean isLiteral = false;
    int arrayDepth=0, objectDepth=0;
    char temp;
    int lastSplitIdx = 0;
    for (int i=0; i<jsonContents.length(); i++) {
      temp = jsonContents.charAt(i);

      if (temp == stringToken) {
        if (i == 0 || jsonContents.charAt(i - 1) != escapeToken) {
          isLiteral = !isLiteral;
        }
      }
      if (!isLiteral) {
        if (temp == beginArrayToken) {
          arrayDepth++;
        } else if (temp == endArrayToken) {
          arrayDepth--;
        } else if (temp == beginObjectToken) {
          objectDepth++;
        } else if (temp == endObjectToken) {
          objectDepth--;
        }
      }

      if (temp == commaToken && !isLiteral && arrayDepth==0&&objectDepth==0) {
        jsonPair.add(trim(jsonContents.substring(lastSplitIdx, i)));
        lastSplitIdx = i + 1;
      }
    }
    jsonPair.add(trim(jsonContents.substring(lastSplitIdx)));

    return jsonPair;
  }

  public String toString() {
    try {
      String name, elem;
      String[] product = new String[_names.size()];
      for (int i=0, end=_names.size(); i<end; i++) {
        name = _names.get(i);
        elem = _elem.get(name);
        if (elem == null) {
          continue;
        }
        product[i] = stringToken + _InsertEscape(name) + stringToken + " : " + elem;
      }
      return beginObjectToken + newLineToken + join(product, ",\n") + newLineToken + endObjectToken;
    } 
    catch(Exception e) {
      println(e);
      println("JsonObject can not express oneself!");
      return null;
    }
  }
}
public abstract class JsonUtility {
  // pjsでなぜかchar型と直接的な比較を行うと失敗するので、このような冗長な定義をしています。
  public final char beginObjectToken = "{".charAt(0);
  public final char endObjectToken = "}".charAt(0);
  public final char beginArrayToken = "[".charAt(0);
  public final char endArrayToken = "]".charAt(0);
  public final char stringToken = "\"".charAt(0);
  public final char escapeToken = "\\".charAt(0);
  public final char commaToken = ",".charAt(0);
  public final char colonToken = ":".charAt(0);
  public final String newLineToken = "\n";

  public void Load(String path) {
    try {
      String[] jsonText = loadStrings(path);
      String json = join(trim(jsonText), "");
      Parse(json);
    } 
    catch (Exception e) {
      println(e);
    }
  }

  public void Save(String path) {
    try {
      saveStrings(path, new String[]{this.toString()});
    } 
    catch(Exception e) {
      println(e);
    }
  }

  public abstract void Parse(String content);
  protected abstract ArrayList<String> _Split(String content);

  protected boolean _IsProper(String content, char beginToken, char endToken) {
    if (content.length()==0) {
      return false;
    }
    return content.charAt(0) == beginToken && content.charAt(content.length() - 1) == endToken;
  }

  protected String _InsertEscape(String content) {
    if (content == null) return null;

    ArrayList<String> product = new ArrayList<String>();
    int lastSplitIndex = 0;
    char temp;
    for (int i=0; i<content.length(); i++) {
      temp = content.charAt(i);

      if (temp == escapeToken || temp == stringToken) {
        product.add(content.substring(lastSplitIndex, i) + escapeToken);
        lastSplitIndex = i;
      }
    }
    product.add(content.substring(lastSplitIndex, content.length()));
    String[] proArray = new String[product.size()];
    for (int i=0; i< proArray.length; i++) {
      proArray[i] = product.get(i);
    }

    return join(proArray, "");
  }

  protected String _RemoveEscape(String content) {
    if (content == null) return null;

    ArrayList<String> product = new ArrayList<String>();
    int lastSplitIndex = 0;
    char temp, temp2;
    for (int i=0; i<content.length(); i++) {
      temp = content.charAt(i);

      if (temp == escapeToken && i < content.length() - 1) {
        temp2 = content.charAt(i + 1);
        if (temp2 == escapeToken || temp2 == stringToken) {
          product.add(content.substring(lastSplitIndex, i));
          lastSplitIndex = i + 1;
        }
      }
    }
    product.add(content.substring(lastSplitIndex, content.length()));
    String[] proArray = new String[product.size()];
    for (int i=0; i< proArray.length; i++) {
      proArray[i] = product.get(i);
    }
    return join(proArray, "");
  }

  protected String _RemoveSideString(String content) {
    if (content == null) return null;
    return content.substring(1, content.length() - 1);
  }
}
